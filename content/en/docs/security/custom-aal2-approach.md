---
title: "Custom AAL2 Approach"
linkTitle: "Custom AAL2 Approach"
weight: 10
description: >
  Custom AAL2 solution for passwordless WebAuthn authentication with biometric authenticators.
---

# Custom AAL2 Approach for Passwordless WebAuthn

## Overview

STING implements a custom Authenticator Assurance Level 2 (AAL2) solution to properly recognize passwordless WebAuthn authentication with biometric authenticators. This approach extends the standard Kratos AAL handling to account for the security properties of modern biometric authentication methods.

## Technical Background

Standard WebAuthn implementations may not automatically classify passwordless biometric authentication as AAL2-eligible. However, biometric authenticators that perform user verification should qualify for AAL2, as they provide an equivalent level of security to traditional two-factor authentication methods.

## Implementation Architecture

### Backend AAL2 Detection

The backend implements custom logic to analyze WebAuthn authentication sessions and determine AAL2 eligibility based on authenticator characteristics:

```python
# app/utils/enhanced_aal2_check.py

def check_webauthn_aal2_eligibility(session_data):
    """
    Determines if WebAuthn authentication qualifies for AAL2
    based on authenticator characteristics
    """

    # Check if user used WebAuthn with user verification
    webauthn_methods = [m for m in session_data.get('authentication_methods', [])
                       if m.get('method') == 'webauthn']

    for method in webauthn_methods:
        # Check for UV flag or biometric indicators
        if method.get('user_verified') or method.get('biometric_used'):
            return True

    # Check device characteristics
    credentials = session_data.get('identity', {}).get('credentials', {})
    if 'webauthn' in credentials:
        for cred in credentials['webauthn']['credentials']:
            # Platform authenticators (built-in) often support biometrics
            if cred.get('authenticator_attachment') == 'platform':
                return True

            # Check for specific biometric authenticator types
            if cred.get('authenticator_metadata', {}).get('biometric_capable'):
                return True

    return False

def get_effective_aal(kratos_session):
    """
    Determines effective AAL level considering custom WebAuthn AAL2 logic
    """
    base_aal = kratos_session.get('authenticator_assurance_level', 'aal1')

    # If already AAL2, return as-is
    if base_aal == 'aal2':
        return 'aal2'

    # Check if WebAuthn qualifies for AAL2
    if check_webauthn_aal2_eligibility(kratos_session):
        return 'aal2'

    return base_aal
```

### Frontend Integration

The frontend integrates with the custom AAL2 detection through a dedicated API endpoint:

```javascript
// Enhanced auth provider with custom AAL2 logic
const checkEffectiveAAL = async () => {
  const response = await axios.get('/api/auth/effective-aal');
  return response.data.aal; // 'aal1' or 'aal2'
};
```

## Key Features

1. **User Verification Detection**: Analyzes WebAuthn responses for user verification (UV) flags
2. **Biometric Capability Recognition**: Identifies platform authenticators and biometric-capable devices
3. **Kratos Compatibility**: Maintains full compatibility with standard Kratos authentication flows
4. **Transparent Enhancement**: Works alongside existing AAL2 mechanisms without disruption

## Integration Points

The custom AAL2 logic integrates at the following points:

1. Session validation endpoints analyze WebAuthn credentials
2. Protected routes use the enhanced AAL determination
3. Authentication flows maintain standard Kratos behavior
4. AAL2-protected resources correctly recognize biometric authentication

This approach ensures that users authenticating with biometric WebAuthn methods receive appropriate access to AAL2-protected resources while maintaining security standards.
