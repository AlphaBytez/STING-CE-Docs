---
title: "Passkey Management Guide"
linkTitle: "Passkey Management"
weight: 10
description: >
  Configure and manage passkey authentication in STING.
---

# Passkey Management Guide

Passkeys provide secure, passwordless authentication for your STING account. This guide explains how to register and manage passkeys.

## What are Passkeys?

Passkeys use WebAuthn technology to provide:
- Passwordless authentication
- Phishing-resistant security
- Biometric or hardware key authentication
- Cross-device synchronization (browser-dependent)

## Registering a Passkey

### Prerequisites

- A modern browser with WebAuthn support (Chrome, Firefox, Safari, Edge)
- An active STING session
- A compatible authentication device (built-in biometric, USB security key, or mobile device)

### Registration Steps

1. Log in to your STING account
2. Navigate to **Security Settings**
3. Select **Register New Passkey**
4. Enter a descriptive name for your passkey (e.g., "MacBook Pro TouchID" or "YubiKey 5")
5. Follow your browser's prompts to complete registration

Your browser will guide you through the authentication ceremony, which may involve:
- Touching a fingerprint sensor
- Using face recognition
- Entering a PIN
- Tapping a hardware security key

## Managing Passkeys

### Viewing Registered Passkeys

Access your Security Settings to view all registered passkeys. Each entry displays:
- Passkey name
- Registration date
- Last used date

### Removing a Passkey

To remove a passkey:

1. Navigate to Security Settings
2. Locate the passkey in your registered devices
3. Select **Remove** or **Delete**
4. Confirm the removal

## Security Considerations

### Domain Binding

Passkeys are cryptographically bound to the domain where they were created. A passkey registered on `app.example.com` will not work on `example.com` or other domains.

### Browser Support

Not all browsers support WebAuthn. Ensure you're using a current version of:
- Chrome/Edge 87+
- Firefox 84+
- Safari 14+

### Backup Authentication

Always maintain at least one backup authentication method (password, additional passkey, or recovery codes) in case your primary passkey becomes unavailable.

## Troubleshooting

### Registration Fails

If passkey registration fails:

1. Verify your browser supports WebAuthn
2. Ensure you're accessing STING over HTTPS
3. Check that browser extensions aren't blocking authentication
4. Clear browser cache and try again

### Cross-Origin Issues

For deployments with strict Content Security Policies, ensure WebAuthn requests are allowed in your CSP configuration.

### Device Compatibility

Some authentication devices may not be compatible with all browsers or operating systems. Consult your device manufacturer's documentation for compatibility information.

## Best Practices

1. **Use Descriptive Names**: Name passkeys clearly to identify which device they're associated with
2. **Register Multiple Passkeys**: Register passkeys on multiple devices for redundancy
3. **Remove Unused Passkeys**: Periodically review and remove passkeys for devices you no longer use
4. **Test After Registration**: After registering a passkey, log out and test authentication to ensure it works correctly

## Technical Details

STING implements passkey authentication using:
- Ory Kratos identity management
- W3C WebAuthn standard
- Browser-native credential management

For advanced configuration options, see the [WebAuthn Configuration Guide](/docs/authentication/kratos-webauthn-configuration/).

## Additional Resources

- [Passwordless Authentication Overview](/docs/authentication/passwordless-authentication/)
- [Passkey Implementation Guide](/docs/authentication/passkey-implementation-guide/)
- [WebAuthn Cross-Machine Guide](/docs/authentication/webauthn-cross-machine/)

For persistent issues, consult the [troubleshooting guide](/docs/troubleshooting/) or contact your system administrator.
