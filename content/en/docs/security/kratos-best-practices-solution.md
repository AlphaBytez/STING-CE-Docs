---
title: "Kratos Best Practices Solution"
linkTitle: "Kratos Best Practices Solution"
weight: 10
description: >
  Alignment of STING authentication architecture with Kratos best practices.
---

# STING Authentication Architecture Alignment with Kratos Best Practices

## Overview

STING's authentication architecture follows industry best practices for integrating with Ory Kratos, ensuring reliable session management, secure cookie handling, and proper separation of concerns between frontend and backend components.

## Architecture Principles

### 1. Native Kratos Flow Integration

STING leverages Kratos's native self-service flows rather than implementing custom middleware. This approach uses Kratos's built-in "Settings Flow" with webhook integration:

```yaml
# kratos.yml
selfservice:
  flows:
    settings:
      required_aal: aal1
      after:
        password:
          hooks:
            - hook: web_hook
              config:
                url: http://app:5050/api/kratos/hooks/password-changed
                method: POST
```

### 2. Webhook-Based State Synchronization

Kratos webhooks provide real-time notification of authentication events to the application backend:

```python
@kratos_hooks_bp.route('/password-changed', methods=['POST'])
def kratos_password_changed():
    """Webhook endpoint called by Kratos after successful password change"""
    data = request.json
    identity_id = data['identity']['id']

    # Update application state
    settings = UserSettings.query.filter_by(user_id=identity_id).first()
    if settings:
        settings.force_password_change = False
        settings.password_changed_at = datetime.utcnow()
        db.session.commit()

    return jsonify({"success": True})
```

### 3. Kratos Admin API Integration

The backend uses Kratos's Admin API for session management and enforcement:

```python
def require_password_change(identity_id):
    """Enforces password change requirement through Kratos"""
    requests.post(
        f"{KRATOS_ADMIN_URL}/admin/identities/{identity_id}/sessions",
        json={
            "active": False  # Invalidate all sessions
        }
    )
```

### 4. Frontend Flow Handling

The frontend integrates directly with Kratos self-service flows:

```javascript
// Session validation with required action handling
const checkRequiredActions = async () => {
  try {
    const { data } = await kratos.toSession();

    if (data.active && !window.location.pathname.includes('/settings')) {
      navigate('/dashboard');
    }
  } catch (error) {
    if (error.response?.status === 403) {
      // Redirect to Kratos settings flow
      window.location.href = `${KRATOS_BROWSER_URL}/self-service/settings/browser`;
    }
  }
};
```

## Configuration Best Practices

### Cookie Configuration

STING configures Kratos cookies for proper cross-origin operation:

```yaml
# kratos.yml
serve:
  public:
    cors:
      enabled: true
      allowed_origins:
        - https://localhost:8443
        - https://localhost:3000
session:
  cookie:
    domain: ""  # No domain restriction for local development
    same_site: "Lax"
    secure: true
    http_only: true
```

### API Gateway Pattern

The architecture follows an API gateway pattern:

- Frontend communicates directly with Kratos for authentication operations
- Frontend sends session tokens to backend API
- Backend validates sessions through Kratos
- Clear separation between authentication (Kratos) and authorization (application)

### Kratos SDK Usage

STING uses the official Kratos client SDK for reliable integration:

```javascript
import { FrontendApi, Configuration } from '@ory/kratos-client'

const kratos = new FrontendApi(
  new Configuration({
    basePath: process.env.REACT_APP_KRATOS_PUBLIC_URL,
    baseOptions: {
      withCredentials: true
    }
  })
)
```

## Key Implementation Details

### Single Source of Truth

- Kratos serves as the authoritative source for authentication state
- Application database stores only application-specific user preferences
- Kratos webhooks maintain synchronization between systems

### Session Management

- Sessions are created and managed exclusively by Kratos
- Backend validates sessions through Kratos Admin API
- Frontend includes credentials with all Kratos API calls

### Self-Service Flows

All user-facing authentication operations use Kratos self-service flows:

- Login flow for user authentication
- Registration flow for new user creation
- Settings flow for profile and credential updates
- Recovery flow for account recovery
- Verification flow for email/phone verification

This architecture ensures STING maintains security best practices while providing a seamless user experience across all authentication scenarios.
