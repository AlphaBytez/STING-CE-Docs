---
title: "Before You Install"
linkTitle: "Before You Install"
weight: 1
description: >
  What you need before installing Nectar - Docker, Ollama setup, and choosing your first AI model.
---

# Before You Install Nectar

Nectar runs STING services in Docker containers and uses **local AI models** so your data never leaves your computer. This page helps you set up everything you need.

{{% alert title="Don't Skip This!" color="warning" %}}
Nectar requires Docker and Ollama. Without these installed, Nectar won't function.
{{% /alert %}}

## Step 1: Install Docker

**Docker** runs the STING services that power Nectar. Install it first:

| System | Download |
|--------|----------|
| **macOS** | [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/) |
| **Windows** | [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) |
| **Linux** | [Docker Engine](https://docs.docker.com/engine/install/) or Docker Desktop |

After installing, make sure Docker is running (look for the Docker icon in your system tray/menu bar).

### Verify Docker is Working

```bash
docker --version
docker compose version
```

You should see version numbers for both. If not, restart Docker Desktop.

---

## Step 2: Install Ollama

**Ollama** is a free tool that runs AI models on your computer. It's like a "runtime" for AI - Nectar talks to it to get AI responses.

### Download Ollama

Go to [ollama.com](https://ollama.com) and download for your system:

| System | Download |
|--------|----------|
| **macOS** | [Download for Mac](https://ollama.com/download/mac) |
| **Windows** | [Download for Windows](https://ollama.com/download/windows) |
| **Linux** | `curl -fsSL https://ollama.com/install.sh | sh` |

### Verify Ollama is Working

After installing, open your terminal (or Command Prompt on Windows) and run:

```bash
ollama --version
```

You should see a version number. If you get an error, restart your computer and try again.

---

## Step 3: Choose Your AI Model

AI models are like different "brains" for the AI. Bigger models are smarter but need more memory.

### Recommended Starting Models

Pick **ONE** model to start with based on your computer's RAM:

| Your RAM | Recommended Model | Command to Install |
|----------|-------------------|-------------------|
| **8GB** | Phi-3 Mini (lightweight) | `ollama pull phi3` |
| **16GB** | Llama 3.3 (best quality) | `ollama pull llama3.3` |
| **32GB+** | Llama 3.3 + DeepSeek Coder | Both commands below |

### Install Your Model

Open terminal and run the command for your chosen model:

```bash
# For most users (16GB+ RAM) - RECOMMENDED
ollama pull llama3.3

# For computers with limited RAM (8GB)
ollama pull phi3

# Optional: For code/programming tasks (needs 16GB+ RAM)
ollama pull deepseek-coder-v2
```

{{% alert title="Model Download Time" color="info" %}}
Models are large (2-8 GB). Download time depends on your internet speed:
- **phi3**: ~2GB (fast download)
- **llama3.3**: ~5GB (medium download)
- **deepseek-coder-v2**: ~16GB (slower download)
{{% /alert %}}

### Verify Your Model is Installed

```bash
ollama list
```

You should see your model(s) listed. Example output:
```
NAME              SIZE
llama3.3:latest   4.7 GB
```

---

## Step 4: Test Ollama (Optional)

Before installing Nectar, you can test that Ollama works:

```bash
ollama run llama3.3 "Hello, what can you help me with?"
```

If you see an AI response, you're ready to install Nectar!

Press `Ctrl+D` (or `Cmd+D` on Mac) to exit.

---

## System Requirements Summary

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **OS** | macOS 11+, Windows 10+, Ubuntu 20.04+ | Latest version |
| **RAM** | 8GB | 16GB+ |
| **Storage** | 10GB free | 20GB+ free |
| **CPU** | Dual-core | Quad-core+ |
| **GPU** | Not required | Helps with speed |

### Apple Silicon Users

If you have an M1/M2/M3 Mac, you're in luck! Ollama automatically uses your GPU for faster responses.

### Windows Users

Make sure WSL2 is enabled if you want the best performance. Ollama will guide you through this during installation.

---

## Troubleshooting

### "ollama: command not found"
- **Mac**: Make sure you dragged Ollama to Applications and ran it once
- **Windows**: Restart your computer after installing
- **Linux**: Run the install script again

### Model download stuck
- Check your internet connection
- Try a smaller model first (phi3)
- Some corporate networks block large downloads

### "Not enough memory"
- Close other applications
- Try a smaller model (phi3 instead of llama3.3)
- Restart your computer to free up memory

---

## Ready?

Once you have:
- ✅ Docker installed and running
- ✅ Ollama installed and running
- ✅ At least one AI model pulled

You're ready to [Install Nectar →](../installation/)
