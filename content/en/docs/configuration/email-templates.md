---
title: "Email Templates"
linkTitle: "Email Templates"
weight: 40
description: >
  Customizing Kratos email templates for login codes, verification, and recovery.
---

# Email Templates

STING-CE uses custom-branded email templates for all authentication flows. These templates are styled to match the STING platform design with a modern dark theme and glass-morphism effects.

## Overview

Ory Kratos sends emails for:
- **Login codes** - Passwordless authentication
- **Registration** - Account verification codes
- **Verification** - Email address confirmation
- **Recovery** - Password reset links

All templates are located in:
```
STING/kratos/courier-templates/
```

## Template Files

| Flow | Body Template | Subject Template |
|------|--------------|------------------|
| **Login Code** | `login_code.body.gotmpl` | `login_code.subject.gotmpl` |
| **Registration** | `registration_code.body.gotmpl` | `registration_code.subject.gotmpl` |
| **Verification** | `verification.valid.email.body.gotmpl` | `verification.valid.email.subject.gotmpl` |
| **Recovery** | `recovery.valid.email.body.gotmpl` | `recovery.valid.email.subject.gotmpl` |

### Additional Templates

| File | Purpose |
|------|---------|
| `*.body.plaintext.gotmpl` | Plain text fallback for HTML emails |
| `*.body.sms.gotmpl` | SMS message templates |
| `*.invalid.*.gotmpl` | Error case templates |

## Configuration

### Enabling Custom Templates

Templates are enabled via two configurations:

**1. Docker Compose Volume Mount** (`docker-compose.yml`):
```yaml
kratos:
  volumes:
    - ${INSTALL_DIR}/kratos/courier-templates:/etc/config/kratos/courier-templates:ro
```

**2. Kratos Configuration** (`kratos.yml`):
```yaml
courier:
  smtp:
    from_address: noreply@your-domain.com
    from_name: STING Platform
  template_override_path: /etc/config/kratos/courier-templates/
```

### SMTP Configuration

Email sending is configured in `env/kratos.env`:

```bash
# SMTP Server
COURIER_SMTP_CONNECTION_URI=smtp://mailpit:1025/?skip_ssl_verify=true

# For production (example with SendGrid):
# COURIER_SMTP_CONNECTION_URI=smtps://apikey:YOUR_KEY@smtp.sendgrid.net:465
```

## Template Syntax

Templates use Go's `text/template` syntax with Kratos-specific variables.

### Available Variables

| Variable | Description |
|----------|-------------|
| `{{ .To }}` | Recipient email address |
| `{{ .RecoveryURL }}` | Password recovery link |
| `{{ .VerificationURL }}` | Email verification link |
| `{{ .RecoveryCode }}` | 6-digit recovery code |
| `{{ .VerificationCode }}` | 6-digit verification code |
| `{{ .LoginCode }}` | 6-digit login code |
| `{{ .RegistrationCode }}` | 6-digit registration code |
| `{{ .Identity }}` | Full identity object |
| `{{ .Identity.traits.name }}` | User's name from traits |

### Example: Login Code Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>🐝 STING Platform - Your Access Code</title>
</head>
<body>
    <div class="glass-card">
        <h1>Your Login Code</h1>
        <div class="code-display">
            {{ .LoginCode }}
        </div>
        <p>This code expires in 15 minutes.</p>
    </div>
</body>
</html>
```

### Example: Subject Template

```
Your STING Login Code: {{ .LoginCode }}
```

## Design Guidelines

STING email templates follow these design principles:

### Color Palette

| Element | Color |
|---------|-------|
| Background | `#0f172a` (slate-900) |
| Card background | `rgba(51, 65, 85, 0.8)` |
| Primary text | `#f1f5f9` (slate-100) |
| Accent (amber) | `#f59e0b` |
| Code background | `#1e293b` |

### Typography

- **Font**: Inter, system fonts fallback
- **Headings**: Bold, larger size
- **Body**: Regular, 1.6 line-height

### Components

- **Glass cards**: Backdrop blur with subtle border
- **Code display**: Monospace, large, amber accent
- **Buttons**: Amber gradient with hover effects

## Testing Emails

### Development Mode

In development, emails are captured by Mailpit:

1. Start with dev profile:
   ```bash
   docker compose --profile dev up -d
   ```

2. Access Mailpit UI:
   ```
   http://localhost:8025
   ```

3. All outgoing emails appear in Mailpit for inspection.

### Testing Templates

To test a specific template:

1. Trigger the flow (login, registration, etc.)
2. Check Mailpit for the email
3. Verify styling renders correctly
4. Check plain text fallback

## Customization

### Changing Branding

To customize for your organization:

1. **Logo**: Replace the SVG in templates or add an `<img>` tag:
   ```html
   <img src="https://your-domain.com/logo.png" alt="Logo" />
   ```

2. **Colors**: Update the CSS variables in the `<style>` block

3. **Text**: Modify copy in the HTML body

4. **Footer**: Update company info and links

### Adding New Templates

1. Create files following naming convention:
   ```
   your_flow.body.gotmpl
   your_flow.subject.gotmpl
   ```

2. Reference in `kratos.yml` if needed

3. Restart Kratos:
   ```bash
   docker compose restart kratos
   ```

## Troubleshooting

### Emails Not Using Custom Templates

**Symptoms**: Emails appear as plain text without styling

**Causes & Fixes**:

1. **Volume not mounted**:
   ```bash
   # Check if templates are visible in container
   docker exec sting-ce-kratos ls /etc/config/kratos/courier-templates/
   ```

2. **Missing template_override_path**:
   Add to `kratos.yml`:
   ```yaml
   courier:
     template_override_path: /etc/config/kratos/courier-templates/
   ```

3. **Container needs restart**:
   ```bash
   docker compose restart kratos
   ```

### Emails Not Sending

1. **Check SMTP configuration**:
   ```bash
   docker exec sting-ce-kratos env | grep SMTP
   ```

2. **Check Kratos logs**:
   ```bash
   docker logs sting-ce-kratos --tail 50 | grep -i mail
   ```

3. **Verify Mailpit is running** (dev mode):
   ```bash
   docker ps | grep mailpit
   ```

### Template Syntax Errors

If emails fail to render:

1. Check Kratos logs for template errors
2. Validate Go template syntax
3. Ensure all variables are spelled correctly
4. Test with minimal template first

## Best Practices

1. **Always provide plaintext fallback** - Some email clients block HTML
2. **Test across email clients** - Gmail, Outlook, Apple Mail render differently  
3. **Keep templates simple** - Complex CSS may not render
4. **Use inline styles** - External CSS often stripped
5. **Version control templates** - Track changes in git
6. **Document customizations** - Note what you changed and why
