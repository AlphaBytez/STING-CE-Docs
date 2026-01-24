---
title: "Security"
linkTitle: "Security"
weight: 90
description: >
  Authentication, authorization, and security best practices
---

# Security Documentation

STING implements industry-leading security practices with passwordless authentication, WebAuthn, and advanced access controls.

## 🔑 Encryption & Key Management

{{% pageinfo color="warning" %}}
**New in v1.0**: [Encryption Key Management](/docs/security/encryption-key-management/) - Critical documentation for protecting user data. Always backup your encryption keys before upgrades!
{{% /pageinfo %}}

### Data Encryption
- **At-Rest Encryption**: All user files encrypted with AES-256-GCM
- **Key Hierarchy**: Master key → User keys → File keys
- **Vault Storage**: Keys secured in HashiCorp Vault

### Key Management Commands
```bash
msting encryption-keys status   # Check key status
msting encryption-keys backup   # Backup before upgrades
msting encryption-keys restore  # Restore from backup
```

## Authentication

### Passwordless Authentication
STING prioritizes passwordless authentication methods:
- **Passkeys**: FIDO2/WebAuthn-based passkeys.
- **Biometric**: Face ID, Touch ID, Windows Hello.
- **Platform authenticators**: Built-in device security.

### Multi-Factor Authentication
- TOTP (Time-based One-Time Passwords).
- SMS verification (optional).
- Email verification.
- Backup codes.

## Kratos Integration

STING uses [Ory Kratos](https://www.ory.sh/kratos/) for identity management:
- Self-service registration and login.
- Account recovery.
- Email verification.
- Profile management.
- Session management.

## WebAuthn Implementation

### Features
- Cross-platform passkey support.
- Resident keys.
- User verification.
- Attestation.
- Device management.

### Configuration
- RP ID setup.
- Origin configuration.
- Authenticator selection.
- Credential management.

## Security Architecture

### Biometric-First Architecture
Prioritize biometric authentication while maintaining security:
- AAL2 (Authentication Assurance Level 2).
- Step-up authentication.
- Conditional MFA.

### Recommended AAL Architecture
Best practices for authentication assurance levels in enterprise deployments.

## Access Control

### Role-Based Access Control (RBAC)
- User roles and permissions.
- Resource-level permissions.
- Honey Jar access controls.

### Attribute-Based Access Control (ABAC)
Fine-grained access controls based on attributes (enterprise feature).

## Security Best Practices

- Regular security audits.
- Credential rotation.
- Session timeout configuration.
- HTTPS enforcement.
- CORS configuration.
- CSP headers.
- **Encryption key backups** (see [Key Management](/docs/security/encryption-key-management/))

## Vulnerability Reporting

Found a security issue? Please report it responsibly:
- Email: security@alphabytez.dev.
- Do not open public issues for security vulnerabilities.
- We aim to respond within 48 hours.
