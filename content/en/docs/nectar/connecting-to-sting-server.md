---
title: "Connecting to STING Server"
linkTitle: "Connecting to STING Server"
weight: 4
description: >
  How to connect your Nectar installation to a STING Server for team features.
---

# Connecting Nectar to STING Server

Nectar works great standalone, but you can also connect it to a **STING Server** to access team features.

{{% alert title="Optional Feature" color="info" %}}
Connecting to a STING Server is completely optional. Nectar works fully offline without it.
{{% /alert %}}

---

## Why Connect to STING Server?

| Feature | Nectar Standalone | Nectar + STING Server |
|---------|-------------------|---------------|
| Local AI chat | ✅ | ✅ |
| Private Honey Jars | ✅ | ✅ |
| Team Honey Jars | ❌ | ✅ |
| Cloud AI models | ❌ | ✅ (if configured) |
| Shared reports | ❌ | ✅ |
| Cross-device sync | ❌ | ✅ (coming soon) |

---

## What You Need

To connect to a STING Server, you need:

1. **Server URL** - Provided by your IT admin or team lead
2. **Account credentials** - Either:
   - Invitation link from the server admin
   - Existing account on that STING Server

---

## How to Connect

### Step 1: Open Server Settings

1. Go to **Settings** (gear icon)
2. Click **Server Connection**
3. Click **Connect to STING Server**

### Step 2: Enter Server Details

Enter the STING Server URL:
```
https://sting.yourcompany.com
```

Or for self-hosted:
```
https://your-server-ip:8443
```

### Step 3: Authenticate

You'll be redirected to the STING Server login page:
- **New user**: Use your invitation link
- **Existing user**: Login with your credentials (passkey/WebAuthn)

### Step 4: Approve Connection

After login, approve Nectar's access:
- Review requested permissions
- Click **Approve**
- You'll be returned to Nectar

---

## What Changes After Connecting

### New Sidebar Section: Team

You'll see a **Team** section in your sidebar with:
- Shared Honey Jars you have access to
- Team Bee chat (if enabled)
- Reports shared with you

### AI Model Options

If your server admin has configured cloud AI:
- You can choose between local models and cloud models
- Cloud models may be faster but require internet
- Local models keep everything on your machine

### Sync Indicator

Look for the sync icon in the status bar:
- 🟢 **Connected** - Real-time sync active
- 🟡 **Syncing** - Changes being uploaded
- 🔴 **Offline** - Working locally, will sync when online

---

## Privacy Controls

You control what syncs to the server:

### Local-Only Mode

Keep sensitive work local:
1. Go to **Settings → Server → Privacy**
2. Enable **Local-Only Mode**
3. Your personal Honey Jars won't sync

### Per-Conversation Privacy

When chatting with Bee:
- **Local AI** - Stays on your machine
- **Server AI** - Uses server (may be logged)

Look for the AI indicator in the chat:
- 🏠 Local
- ☁️ Server

### Report TTL (Time-to-Live)

When generating reports through the server:
- Set how long reports exist on the server
- After TTL expires, report is deleted from server
- Your local copy remains

---

## Disconnecting

To disconnect from STING Server:

1. Go to **Settings → Server Connection**
2. Click **Disconnect**
3. Confirm

After disconnecting:
- Your personal Honey Jars remain untouched
- Team Honey Jars become unavailable
- Local data is preserved

---

## Troubleshooting

### "Cannot connect to server"

1. Check the URL is correct
2. Verify you have internet access
3. Ask your IT admin if the server is running

### "Authentication failed"

1. Check your invitation link hasn't expired
2. Try logging in directly on the STING Server web interface first
3. Contact your server administrator

### "Permission denied"

You may not have access to certain Honey Jars. Contact your server admin to request access.

### Sync stuck on "Syncing"

1. Check your internet connection
2. Try **Settings → Server → Force Sync**
3. If persistent, disconnect and reconnect

---

## For IT Administrators

If you're setting up STING Server for your team to connect Nectar instances:

1. Ensure your server has external connectivity (or VPN)
2. Configure user accounts/invitations
3. Set up permission groups for shared Honey Jars
4. See [STING Server Administration Guide](/docs/sting-server/administration/) for details

---

## FAQ

**Q: Do I need STING Server to use Nectar?**
A: No. Nectar works fully standalone.

**Q: Can I connect to multiple STING Servers?**
A: Currently, one at a time. Switch in Settings.

**Q: Is my local data uploaded to the server?**
A: Only if you explicitly share it. Personal Honey Jars stay local.

**Q: What if the server goes down?**
A: Nectar continues working locally. Team features pause until reconnection.
