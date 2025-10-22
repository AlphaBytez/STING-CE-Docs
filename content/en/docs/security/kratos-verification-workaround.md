---
title: "Email Verification Troubleshooting"
linkTitle: "Email Verification Troubleshooting"
weight: 10
description: >
  Solutions for email verification issues in STING deployments.
---

# Email Verification Troubleshooting

This guide provides solutions for addressing email verification issues in STING deployments. Select the approach that best matches your environment and requirements.

## Development Environment Solutions

### Disable Email Verification (Development Only)

For local development environments, you can temporarily disable email verification.

**Warning:** This approach should only be used in development environments, never in production.

Edit `/kratos/main.kratos.yml`:

```yaml
selfservice:
  flows:
    registration:
      after:
        password:
          hooks:
            - hook: session
            # Comment out the verification hook
            # - hook: show_verification_ui
```

Restart Kratos to apply changes:
```bash
./manage_sting.sh restart kratos
```

### Access Mailpit Interface

STING uses Mailpit for email testing in development. Access the web interface at `http://localhost:8025` to view verification emails.

If the Mailpit UI is inaccessible, use the API directly:

```bash
# Retrieve all emails
curl http://localhost:8025/api/v1/messages
```

Copy the verification link from the response and access it in your browser.

## Production and Staging Environments

### Manually Verify Identity

For specific cases where automated verification fails, you can manually verify an identity using the Kratos Admin API.

First, obtain the identity ID from your user database or Kratos admin interface. Then execute:

```bash
curl -k -X PATCH https://localhost:4434/admin/identities/IDENTITY_ID \
  -H "Content-Type: application/json" \
  -d '{
    "traits": {
      "email": "user@example.com",
      "name": {
        "first": "First",
        "last": "Last"
      }
    },
    "verifiable_addresses": [{
      "value": "user@example.com",
      "verified": true,
      "via": "email"
    }]
  }'
```

Replace `IDENTITY_ID` and email details with actual values.

### Verify SMTP Configuration

Test your SMTP connection to ensure emails can be sent:

```bash
# Test SMTP connectivity
nc -v your-smtp-host 587
```

For detailed SMTP troubleshooting, see the [Email Testing Guide](/docs/configuration/testing-email-sms/).

### Configure Alternative Email Service

For enhanced reliability, configure an external email testing service.

Example configuration for Mailtrap (development/staging):

```yaml
courier:
  smtp:
    connection_uri: smtps://USERNAME:PASSWORD@smtp.mailtrap.io:2525/?skip_ssl_verify=true
```

For production deployments, configure a production-grade email service such as SendGrid, AWS SES, or Mailgun. See [Email Verification Setup](/docs/troubleshooting/email-verification-setup/) for detailed configuration instructions.

## Diagnostic Steps

If verification emails are not being delivered:

1. **Check Service Status**: Verify Kratos and email services are running
2. **Review Logs**: Examine Kratos logs for SMTP errors
3. **Test Connectivity**: Confirm network access to SMTP server
4. **Validate Configuration**: Verify SMTP credentials and connection settings
5. **Check Spam Filters**: Ensure verification emails aren't being filtered

## Additional Resources

- [Email Verification Setup](/docs/troubleshooting/email-verification-setup/)
- [Testing Email and SMS](/docs/configuration/testing-email-sms/)
- [Kratos Integration Guide](/docs/authentication/kratos-integration-guide/)

For persistent issues, consult the [troubleshooting guide](/docs/troubleshooting/) or review Kratos logs for specific error messages.
