---
title: "Installing Nectar"
linkTitle: "Installation"
weight: 2
description: >
  Step-by-step guide to installing Nectar on your computer.
---

# Installing Nectar

This guide walks you through installing Nectar on your computer.

{{% alert title="Prerequisites" color="warning" %}}
Make sure you've completed [Before You Install](../before-you-install/) first. You need Docker, Ollama, and at least one AI model installed.
{{% /alert %}}

## Quick Install

### macOS

1. Download Nectar from [GitHub Releases](https://github.com/AlphaBytez/Nectar/releases/latest)
2. Open the `.dmg` file
3. Drag **Nectar** to your Applications folder
4. **Important**: Open Terminal and run:
   ```bash
   xattr -cr /Applications/Nectar.app
   ```
5. Launch Nectar from Applications
6. Follow the setup wizard

{{% alert title="Why the Terminal Command?" color="info" %}}
Nectar is currently unsigned. macOS quarantines downloaded apps and blocks them from running. The `xattr -cr` command removes this quarantine flag so the app can launch. This is normal for alpha software—we'll sign future releases.
{{% /alert %}}

### Windows

1. Download Nectar from [GitHub Releases](https://github.com/AlphaBytez/Nectar/releases/latest)
2. Run the `.exe` installer
3. Windows SmartScreen may warn about an unrecognized app—click "More info" → "Run anyway"
4. Follow the installation wizard
5. Launch Nectar from Start Menu

{{% alert title="SmartScreen Warning" color="info" %}}
Nectar is currently unsigned. Windows will show a SmartScreen warning. This is normal for alpha software.
{{% /alert %}}

### Linux

**Debian/Ubuntu (.deb):**
```bash
# Download from GitHub Releases
sudo dpkg -i Nectar.deb
sudo apt-get install -f  # Install dependencies if needed
```

**AppImage:**
```bash
chmod +x Nectar.AppImage
./Nectar.AppImage
```

Download from [GitHub Releases](https://github.com/AlphaBytez/Nectar/releases/latest).

---

## Setup Wizard

When you first launch Nectar, the setup wizard will guide you through:

### 1. Create Your Account

- Choose a username
- Set up passkey authentication (biometrics or security key)
- No passwords to remember!

### 2. Connect to Ollama

Nectar will automatically detect Ollama. If it doesn't:
- Make sure Ollama is running
- Check that you have at least one model installed
- Click "Retry Detection"

### 3. Select Default Model

Choose which AI model Nectar should use by default:
- The wizard will show models you've installed
- You can change this anytime in Settings

### 4. Create Your First Honey Jar

A **Honey Jar** is where your knowledge lives. Start with:
- **Personal Notes** - For general documents
- **Work Projects** - For professional files
- Or skip and create one later

---

## Verify Installation

After setup, verify everything is working:

### Check Services Status

Open Settings → System Status. You should see:
- ✅ Nectar Services: Running
- ✅ Ollama: Connected
- ✅ AI Model: [Your model name]

### Test Bee Chat

1. Click on **Bee** in the sidebar
2. Type: "Hello, can you help me?"
3. You should get an AI response

If you get a response, congratulations! Nectar is working.

---

## What's Installed

Nectar installs the following on your computer:

| Component | Location | Purpose |
|-----------|----------|---------|
| Nectar App | Applications (Mac) / Program Files (Win) | Main application |
| Data Directory | `~/.nectar/` | Your data, configs |
| Database | `~/.nectar/data/` | Local PostgreSQL data |

Your data is stored locally and **never leaves your machine** unless you explicitly connect to a STING Server.

---

## Next Steps

Now that Nectar is installed:

1. **[First Steps Guide](../first-steps/)** - Learn to use Honey Jars and Bee chat
2. **[Import Documents](../importing/)** - Add your existing files
3. **[Connect to STING Server](../connecting-to-sting-server/)** - (Optional) Link to a team server

---

## Troubleshooting

### Nectar won't start

**Mac**:

If right-click → Open doesn't work, run this in Terminal:
```bash
xattr -cr /Applications/Nectar.app
```

If you still have issues, check System Settings → Privacy & Security—there may be an "Open Anyway" button for blocked apps.

**Windows**: Run as Administrator the first time. If SmartScreen blocks it, click "More info" → "Run anyway".

**Linux**: Check Docker is installed and running:
```bash
docker --version
docker compose version
```

### "Cannot connect to Ollama"

1. Make sure Ollama is running: `ollama serve`
2. Verify a model is installed: `ollama list`
3. Restart Nectar

### "No AI models found"

Install a model first:
```bash
ollama pull llama3.3
```

Then restart Nectar.

### Need more help?

- [Full Troubleshooting Guide](../troubleshooting/)
- [GitHub Issues](https://github.com/AlphaBytez/Nectar/issues)
- [Discord](https://discord.gg/alphabytez)
