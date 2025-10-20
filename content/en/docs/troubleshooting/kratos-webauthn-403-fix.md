---
title: "WebAuthn 403 Error"
linkTitle: "WebAuthn 403 Error"
weight: 10
description: >
  Troubleshooting guide for resolving WebAuthn 403 Forbidden errors.
---

# Resolving WebAuthn 403 Error

## Issue Description

After user registration, attempting to add a WebAuthn credential results in a 403 Forbidden error. This occurs because:

1. Kratos requires a "privileged session" to add security credentials
2. A privileged session means the user has authenticated within the `privileged_session_max_age` (15 minutes in our config)
3. The session created after registration might not be considered privileged enough

## Cause

This issue typically occurs in the following sequence:
1. User registers with password → Session created
2. User redirected to add WebAuthn → 403 error
3. Kratos considers the session unprivileged for adding security credentials

## Solutions

### Option 1: Require Re-authentication

Prompt users to re-enter their password before adding WebAuthn credentials:

```javascript
// In the WebAuthn setup component
const setupWebAuthn = async () => {
  try {
    // First, create a settings flow
    const settingsResponse = await fetch(`${kratosUrl}/self-service/settings/browser`, {
      credentials: 'include'
    });
    
    // If we get a 403, user needs to re-authenticate
    if (settingsResponse.status === 403) {
      // Redirect to login with return URL
      const returnTo = encodeURIComponent('/settings/security/passkeys');
      window.location.href = `${kratosUrl}/self-service/login/browser?return_to=${returnTo}`;
      return;
    }
    
    // Continue with WebAuthn setup...
  } catch (error) {
    console.error('WebAuthn setup error:', error);
  }
};
```

### Option 2: Adjust Kratos Configuration
Increase the privileged session duration or disable the requirement:

```yaml
# kratos/kratos.yml
selfservice:
  flows:
    settings:
      privileged_session_max_age: 24h  # Increase from 15m
      # OR
      required_aal: aal1  # Don't require privileged session for settings
```

### Option 3: Custom Registration Flow

Configure the registration flow to enable immediate WebAuthn setup:

```yaml
# kratos/kratos.yml
selfservice:
  flows:
    registration:
      after:
        password:
          hooks:
          - hook: session
            config:
              # Mark session as privileged after registration
              check_session_aal: false
          - hook: web_hook
            config:
              url: https://app:5050/api/kratos/post-registration-webauthn
              method: POST
              # Trigger WebAuthn setup
```

### Option 4: Use Custom WebAuthn Implementation
Since you want to reintroduce your custom passkey UI:

1. Keep Kratos for password authentication
2. Use your custom WebAuthn implementation for passkeys
3. Store passkey credentials in your database
4. Link them to Kratos identities

This gives you full control over the UI and avoids the privileged session issue.

## Implementation Example

Update the PostRegistration component to handle passkey setup:

```jsx
// PostRegistration.jsx
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

const PostRegistration = () => {
  const navigate = useNavigate();
  const [setupPasskey, setSetupPasskey] = useState(false);

  const handlePasskeySetup = () => {
    // Use custom passkey setup that doesn't require Kratos privileged session
    navigate('/setup-passkey-custom');
  };

  const skipPasskeySetup = () => {
    navigate('/dashboard');
  };

  return (
    <div>
      <h2>Welcome to STING!</h2>
      <p>Would you like to set up a passkey for easier login?</p>
      
      <button onClick={handlePasskeySetup}>
        Set up Passkey
      </button>
      
      <button onClick={skipPasskeySetup}>
        Skip for now
      </button>
    </div>
  );
};
```

## Verification Steps

1. Register a new user account
2. On the post-registration page, select "Set up Passkey"
3. Confirm the passkey setup completes without 403 errors
4. Test that passkey login functions correctly

## Additional Considerations

For production deployments, evaluate:
1. Using Kratos OIDC/OAuth2 features for SSO
2. Implementing a custom UI for all authentication flows
3. Using Kratos as a backend service only