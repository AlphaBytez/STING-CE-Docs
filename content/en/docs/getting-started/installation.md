---
title: "Installation"
linkTitle: "Installation"
weight: 10
description: >
  Comprehensive installation guide for deploying STING in development and production environments.
---

# STING Platform Installation Guide

Welcome to STING! This guide will walk you through installing STING on your system. The installation is designed to be straightforward and handles most dependencies automatically.

---

## Quick Start: One-Line Installer

{{< alert title="Fastest Way to Install" color="success" >}}
Get STING up and running in minutes with our automated installer! It handles platform detection, dependency installation, and launches an interactive setup wizard.
{{< /alert >}}

<div style="font-size: 1.2em; margin: 1em 0;">

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlphaBytez/STING-CE-Public/main/bootstrap.sh)"
```

</div>

**What this does:**
- ✅ Automatically detects your OS (macOS, WSL2, Debian/Ubuntu)
- ✅ Installs Docker if not present
- ✅ Clones the STING repository
- ✅ Launches the interactive web-based setup wizard
- ✅ Guides you through configuration (domains, email, LLM preferences)
- ✅ Creates your admin account

**After installation, access STING at:**
- **Frontend**: https://sting.local:8443 OR Congigured Domain
- **API**: https://sting.local:5050
- **Mailpit** (dev email): http://sting.local:8025

For additional installation options and detailed configuration, see the [Fresh Installation Guide](/docs/getting-started/fresh-install-guide/).

{{< alert title="Prerequisites" color="info" >}}
Ensure you have **8GB RAM minimum** and **50GB free disk space** before running the installer.
{{< /alert >}}

---

## Quick Start: OVA Virtual Machine

{{< alert title="Fastest Evaluation Option" color="success" >}}
Download a pre-built virtual machine image and be up and running in minutes! No manual installation required.
{{< /alert >}}

**Download the OVA:**
- [STING-CE Quick Start OVA](https://github.com/AlphaBytez/STING-CE-Public/releases/latest) (Latest Release)

**What's included:**
- ✅ Ubuntu 24.04 LTS pre-configured
- ✅ Docker and Docker Compose installed
- ✅ STING repository cloned and ready
- ✅ First-boot installer launches automatically

### OVA System Requirements

```yaml
VM Resources (Pre-configured):
  CPU: 4 cores
  RAM: 8GB
  Disk: 40GB

Host Requirements:
  Hypervisor: VirtualBox 6.1+ or VMware Workstation/Fusion/ESXi
  Host RAM: 12GB+ (8GB for VM + 4GB for host OS)
  Host Disk: 50GB free space
```

### Installation Steps

1. **Download** the `.ova` file from GitHub Releases
2. **Import** into VirtualBox or VMware:
   - VirtualBox: File → Import Appliance → Select OVA
   - VMware: File → Open → Select OVA
3. **Start** the virtual machine
4. **Wait** for the VM to boot and display its IP address
5. **Open** your browser to `https://<VM_IP>:5000`
6. **Complete** the web-based setup wizard
7. **Access** STING at `https://<hostname>:8443`

{{< alert title="First Boot" color="info" >}}
On first boot, the VM will display its IP address and hostname in the console. The web installer starts automatically - just open your browser and follow the wizard.
{{< /alert >}}

{{< alert title="Internet Required" color="warning" >}}
**The VM requires internet access during initial setup.** The installer downloads Docker images for all STING services (~10-15GB). Ensure the VM has network connectivity before starting. After setup, STING runs fully offline (except for optional external AI APIs).
{{< /alert >}}

### OVA vs Manual Installation

| Feature | OVA Quick Start | Manual Installation |
|---------|-----------------|---------------------|
| Setup Time | ~5 minutes | ~30 minutes |
| Best For | Evaluation, demos, quick testing | Production, customization |
| Prerequisites | VirtualBox/VMware only | Docker, Git, shell access |
| Customization | Limited (VM settings) | Full control |
| Updates | Download new OVA | `git pull` + reinstall |

---

## System Requirements

### Minimum Requirements

{{< alert title="Hardware Requirements" color="info" >}}
STING Core requires **8GB RAM minimum** and **30GB free disk space**. Docker Desktop 4.0+ with Docker Compose is required. AI models run via Ollama (separate) or external APIs (no extra resources).
{{< /alert >}}

For optimal performance with larger deployments, see the [Hardware Acceleration Guide](/docs/administration/hardware-acceleration-guide/) and [Performance Admin Guide](/docs/administration/performance-admin-guide/).

#### Check Your System

```bash
# Check OS version
uname -a                    # Linux
sw_vers                     # macOS

# Check available memory
free -h                     # Linux
sysctl hw.memsize          # macOS

# Check available disk space
df -h

# Check Docker installation
docker --version
docker compose version
```

#### STING Core Requirements

```yaml
Operating System:
  - macOS: 11+ (Big Sur or later)
  - Linux: Ubuntu 20.04+ or equivalent
  - Note: Apple Silicon (M1/M2/M3) recommended for macOS

CPU:
  - Minimum: 4 cores
  - Recommended: 6-8 cores for comfortable performance
  - Production: 8+ cores for concurrent users

Memory (STING Core Only):
  - Minimum: 8GB RAM
  - Recommended: 12-16GB RAM
  - Production: 16GB+ RAM for large datasets
  - Docker Allocation: 6-8GB RAM for core services

Storage (STING Core Only):
  - System: 20-30GB for STING services
  - Documents: Scale based on knowledge base size
  - Backups: Additional space for database backups

Network:
  - Initial Setup: Internet required for downloads
  - Operation: Can run offline after setup (except external AI)
  - Speed: 100 Mbps+ recommended

Docker:
  - Version: Docker Desktop 4.0 or later
  - Required: Docker Compose plugin
  - Resources: Allocate 6-8GB RAM to Docker
```

#### AI Model Requirements (Separate)

{{< alert title="AI Models Run Separately" color="info" >}}
STING uses external AI services by default. Resources below are only needed if running Ollama locally.
{{< /alert >}}

```yaml
Option 1: External AI (Recommended for most users):
  Additional RAM: 0GB (runs in cloud)
  Additional Storage: 0GB (no local models)
  Examples: OpenAI, Claude, Gemini

Option 2: Ollama Local (Privacy-focused):
  Additional RAM: +4-8GB depending on model size
  Additional Storage: +10-30GB for model files
  Models:
    - phi3:mini: ~2GB, runs on 4GB RAM
    - llama3:8b: ~5GB, runs on 8GB RAM
    - deepseek-r1: ~8GB, runs on 12GB RAM

Option 3: Legacy In-Process Models (Not recommended):
  Additional RAM: +8-16GB for model loading
  Additional Storage: +20-50GB for model files
  Note: Deprecated in favor of Ollama/External AI
```

#### Tested Configurations

```yaml
Minimum Viable (Tested):
  CPU: 4 cores
  RAM: 8GB total (6GB to Docker)
  Storage: 30GB
  AI: External API or Ollama on separate host
  Use Case: Single user, small datasets (<1000 docs)

Comfortable Development (Tested):
  CPU: 4-6 cores
  RAM: 16GB total (8GB to Docker + 4GB for Ollama)
  Storage: 50GB
  AI: Ollama local with phi3:mini
  Use Case: 1-5 users, moderate datasets (<10k docs)

Production Baseline:
  CPU: 8+ cores
  RAM: 16GB+ total
  Storage: 100GB+
  AI: External API or dedicated Ollama instance
  Use Case: 5-20 users, large datasets (10k+ docs)
```

### Recommended Configurations

<details>
<summary><strong>Small Deployment (1-5 users, <1000 documents)</strong></summary>

```yaml
Profile: Small Team / Development
Users: 1-5 concurrent users
Documents: < 1,000 documents

Hardware:
  CPU: Apple M1/M2/M3 or Intel/AMD 8+ cores
  Memory: 16GB RAM
  Storage: 100GB SSD
  Network: 100 Mbps

Docker Resources:
  Memory Limit: 12GB
  CPU Limit: 6 cores
  Optimized: Resource limits included
```

</details>

<details>
<summary><strong>Medium Deployment (5-20 users, 1000-10000 documents)</strong></summary>

```yaml
Profile: Medium Organization
Users: 5-20 concurrent users
Documents: 1,000 - 10,000 documents

Hardware:
  CPU: Apple M2 Pro/M3 or Intel/AMD 12+ cores
  Memory: 32GB RAM
  Storage: 250GB NVMe SSD
  Network: 1 Gbps

Docker Resources:
  Memory Limit: 24GB
  CPU Limit: 10 cores

Scaling Recommendations:
  - Consider dedicated ChromaDB instance
  - Separate Redis cache server
  - Load balancer for multiple app instances
```

</details>

<details>
<summary><strong>Large Deployment (20+ users, 10000+ documents)</strong></summary>

```yaml
Profile: Enterprise / Production
Users: 20+ concurrent users
Documents: 10,000+ documents

Hardware:
  CPU: Apple M2 Max/M3 Max or Intel/AMD 16+ cores
  Memory: 64GB+ RAM
  Storage: 500GB+ SSD with high IOPS (NVMe recommended)
  Network: 10 Gbps
  GPU: Metal Performance Shaders (macOS) or CUDA-compatible (Linux)

Docker Resources:
  Memory Limit: 48GB
  CPU Limit: 14 cores

Architecture:
  - Redis cluster for caching
  - Separate knowledge processing workers
  - Dedicated ChromaDB with replication
  - Load-balanced application servers
  - Monitoring stack (Prometheus + Grafana)
```

</details>

---

## Quick Start Installation

{{< alert title="Automated Setup" color="success" >}}
STING automatically handles most dependencies including Docker installation, Docker Compose, and system utilities. You only need Git and an internet connection!
{{< /alert >}}

### Step 1: Install Git

{{< tabpane text=true >}}
{{% tab header="**macOS**" %}}
```bash
# Install Xcode Command Line Tools (includes git)
xcode-select --install

# OR install via Homebrew
brew install git
```
{{% /tab %}}
{{% tab header="**Linux**" %}}
```bash
# Update system packages
sudo apt update

# Install git
sudo apt install -y git
```
{{% /tab %}}
{{< /tabpane >}}

### Step 2: Clone Repository

```bash
# Clone STING repository
git clone https://github.com/your-org/sting-platform.git
cd sting-platform

# Verify you're in the correct directory
ls -la  # Should show manage_sting.sh, conf/, frontend/, etc.
```

### Step 3: Run Installation

```bash
# Run the installer (handles all dependencies automatically)
sudo bash install_sting.sh
```

{{< alert title="What Gets Installed" color="info" >}}
The installer automatically:
- Detects and fixes snap Docker installations
- Installs Docker if not present
- Installs required utilities (jq, etc.)
- Creates configuration files
- Builds and starts all services
{{< /alert >}}

**Expected Installation Output:**

```text
✓ Detected snap Docker - automatically replacing with apt version
✓ Docker Engine installed successfully
✓ System dependencies installed
✓ Configuration files generated
✓ Network connectivity confirmed
✓ Disk space sufficient (XX GB available)
```

**Installation Progress:**

```text
[1/8] Validating environment...                ✓
[2/8] Building Docker images...                ✓
[3/8] Initializing databases...                ✓
[4/8] Configuring services...                  ✓
[5/8] Starting core services...                ✓
[6/8] Setting up authentication...             ✓
[7/8] Preparing AI models...                   ✓
[8/8] Final health checks...                   ✓

🎉 STING Platform installed successfully!
```

---

## AI Model Setup

STING supports two AI model options. The setup wizard will guide you through configuration during installation.

### Option 1: Ollama (Recommended for Privacy)

{{< alert title="Recommended for Local Deployment" color="primary" >}}
Ollama provides local AI models with excellent performance and privacy. Run AI models on your own hardware.
{{< /alert >}}

1. **Install Ollama** from [ollama.com](https://ollama.com)
2. **Pull recommended models:**
   ```bash
   ollama pull phi3:mini       # Fast, lightweight model
   ollama pull llama3:8b       # Balanced performance
   ollama pull deepseek-r1     # Advanced reasoning
   ```
3. **Configure in STING:**
   - The setup wizard will detect Ollama automatically
   - Or configure later in Settings → AI Models → Ollama

For detailed model recommendations and configuration, see the [Ollama Model Setup Guide](/docs/bee-features/ollama-model-setup/).

### Option 2: OpenAI and External Providers

Configure API keys for cloud-based AI during setup or in the STING interface:

**Supported Providers:**
- **OpenAI**: GPT-4, GPT-4-Turbo, GPT-3.5-Turbo, o1, o1-mini
- **Anthropic**: Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku
- **Google**: Gemini Pro, Gemini Pro Vision
- **Custom**: Any OpenAI-compatible API endpoint

**Configuration via Settings:**
1. Navigate to Settings → AI Models → External Providers
2. Add your API key for the provider you want to use
3. Select your preferred model
4. Test the connection

**Environment Variables (Optional):**
```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="..."
```

---

## Post-Installation Setup

### Access Verification

{{< alert title="Self-Signed Certificates" color="info" >}}
STING uses self-signed certificates for local development. You'll need to accept the certificate warning in your browser.
{{< /alert >}}

**Test Frontend Access:**

```bash
# Open browser to frontend
open https://sting.local:8443  # Development
```

**Test API Access:**

```bash
# Check API health
curl -k https://sting.local:5050/api/auth/health

# Expected response: {"status": "healthy", "timestamp": "..."}
```

### Create Your First User

1. If default admin was not created during install, you will need to first create admin account:
   ```
   sudo msting create admin [email-here]
   ```
3. Check output for confirmation
4. Enter email (default `admin@sting.local`) 
5. Complete email verification
   - Check Mailpit at `http://sting.local:8025` for the verification email
6. **Log in** to access the dashboard

### Test the Chatbot

1. Navigate to the ** Bee Chat** interface
2. Send a test message: *"Hello, what is STING?"*
3. Verify Bee responds appropriately
4. Check that your selected model is working

---

## Resource Management

### Docker Resource Allocation

STING Core includes optimized Docker resource limits that work on 8GB RAM systems. Scale up for production workloads.

```yaml
Minimal Configuration (8GB RAM System):
  knowledge:
    memory: 2GB
    cpu: 1.0 core
    purpose: Document processing & indexing

  chroma:
    memory: 1GB
    cpu: 0.5 cores
    purpose: Vector search & embeddings

  app:
    memory: 1GB
    cpu: 1.0 core
    purpose: Core API & business logic

  database:
    memory: 768MB
    cpu: 0.5 cores
    purpose: PostgreSQL database

  frontend:
    memory: 512MB
    cpu: 0.5 cores
    purpose: React web interface

  vault:
    memory: 384MB
    cpu: 0.25 cores
    purpose: Secrets management

  redis:
    memory: 384MB
    cpu: 0.25 cores
    purpose: Session & data caching

  messaging:
    memory: 256MB
    cpu: 0.25 cores
    purpose: Message queue & events

Total Allocation (Minimal):
  Max Memory: ~6.3GB (fits in 8GB system)
  Max CPU: ~4.25 cores (works on 4-core system)
  System Buffer: 1.7GB reserved for OS & other processes

---

Recommended Configuration (16GB RAM System):
  knowledge:
    memory: 3GB
    cpu: 1.5 cores

  chroma:
    memory: 2GB
    cpu: 1.0 core

  app:
    memory: 1.5GB
    cpu: 1.0 core

  database:
    memory: 1GB
    cpu: 1.0 core

  frontend:
    memory: 512MB
    cpu: 0.5 cores

  vault:
    memory: 512MB
    cpu: 0.25 cores

  redis:
    memory: 512MB
    cpu: 0.5 cores

  messaging:
    memory: 256MB
    cpu: 0.25 cores

Total Allocation (Recommended):
  Max Memory: ~9.3GB (comfortable on 16GB system)
  Max CPU: ~5.5 cores
  System Buffer: 6.7GB for OS, Ollama, and other processes
```

### Performance Monitoring

```bash
# Monitor all containers
docker stats --no-stream

# Check specific service
docker stats sting-ce-knowledge --no-stream
```

{{< alert title="When to Scale Up" color="warning" >}}
Consider upgrading resources when you notice:
- Container restarts due to memory issues
- Slow search responses (>5 seconds)
- Upload timeouts
- High CPU load consistently above core count
{{< /alert >}}

---

## Advanced Configuration

### AI Model Configuration

Configure AI models through the web interface or environment variables:

**Via Web Interface (Recommended):**
1. Navigate to Settings → AI Models
2. Configure Ollama or External API providers
3. Set your preferred default model
4. Adjust temperature and max tokens as needed

**Via Environment Variables:**
```bash
# Ollama Configuration
export OLLAMA_BASE_URL="http://localhost:11434"
export OLLAMA_DEFAULT_MODEL="llama3:8b"

# External AI Configuration
export OPENAI_API_KEY="sk-..."
export DEFAULT_AI_PROVIDER="openai"
export DEFAULT_AI_MODEL="gpt-4"
```

### Database Access

```bash
# Connect to database directly
psql -h localhost -p 5433 -U postgres -d sting_app

# View database credentials
cat ~/.sting-ce/env/db.env
```

### SSL Certificate Setup

<details>
<summary><strong>Development (Self-Signed)</strong></summary>

```bash
# Certificates are auto-generated during installation
ls -la ~/.sting-ce/certs/
```

</details>

<details>
<summary><strong>Production (Let's Encrypt)</strong></summary>

```bash
# Update configuration for your domain
vim conf/config.yml

# Set your domain and email
application:
  ssl:
    domain: "your-domain.com"
    email: "admin@your-domain.com"

# Restart with new configuration
./manage_sting.sh restart
```

</details>

---

## Troubleshooting

### Common Issues

<details>
<summary><strong>Docker Service Failures</strong></summary>

```bash
# Check Docker status
docker ps -a

# Restart Docker Desktop (macOS)
killall Docker && open -a Docker

# Check Docker logs
docker compose logs [service]
```

</details>

<details>
<summary><strong>Port Conflicts</strong></summary>

```bash
# Check port usage
lsof -i :3010  # Frontend
lsof -i :5050  # API

# Kill conflicting processes
sudo kill -9 [PID]
```

</details>

<details>
<summary><strong>AI Model Connection Issues</strong></summary>

**For Ollama:**
```bash
# Check if Ollama is running
ollama list

# Restart Ollama service
systemctl restart ollama  # Linux
# or restart the Ollama app on macOS

# Test Ollama connection
curl http://localhost:11434/api/tags
```

**For External APIs:**
```bash
# Test OpenAI connection
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# Verify API key in STING Settings → AI Models
```

For comprehensive LLM troubleshooting, see the [LLM Health Check Guide](/docs/troubleshooting/llm-health-check/).

</details>

<details>
<summary><strong>Memory Issues</strong></summary>

```bash
# Check Docker container memory usage
docker stats --no-stream

# For Ollama models using too much RAM (if using an APU):
# Switch to a smaller model (e.g., phi3:mini instead of llama3:70b)
ollama pull phi3:mini

# Update default model in STING Settings → AI Models
```

</details>

### Health Diagnostics

```bash
# Comprehensive health check
./manage_sting.sh health

# Individual service health
curl -k https://sting.local:5050/api/auth/health
curl -k http://sting.local:8086/health
```

### Recovery Procedures

{{< tabpane text=true >}}
{{% tab header="**Soft Reset**" %}}
```bash
# Restart all services
./manage_sting.sh restart

# Regenerate configuration
./manage_sting.sh regenerate-config
```
{{% /tab %}}
{{% tab header="**Full Reset**" %}}
```bash
# Stop services
./manage_sting.sh stop

# Remove containers (preserves data)
docker compose down

# Restart installation
./manage_sting.sh start
```
{{% /tab %}}
{{% tab header="**Complete Uninstall**" %}}
```bash
# Remove all data (DESTRUCTIVE)
./manage_sting.sh uninstall --force

# Remove installation directory
rm -rf ~/.sting-ce
```
{{% /tab %}}
{{< /tabpane >}}

---

## Security Hardening

{{< alert title="Production Security" color="danger" >}}
**Important:** Change default passwords and configure proper SSL certificates before deploying to production!
{{< /alert >}}

### Change Default Passwords

```bash
# Generate new secrets
./manage_sting.sh regenerate-secrets

# Update database password
vim ~/.sting-ce/env/db.env
```

### Firewall Configuration

```bash
# Block unnecessary ports
sudo ufw enable
sudo ufw deny 5433  # PostgreSQL (internal only)
sudo ufw deny 8200  # Vault (admin only)
sudo ufw allow 443  # HTTPS
sudo ufw allow 80   # HTTP (redirect to HTTPS)
```

### Production SSL Certificates

```bash
# Install certbot
sudo apt install certbot

# Generate Let's Encrypt certificate
sudo certbot certonly --standalone -d your-domain.com

# Update STING configuration to point to certificate
vim conf/config.yml
```

---

## Next Steps

{{< alert title="You're Ready!" color="success" >}}
STING is now installed and ready to use! Check out these guides to get started:
{{< /alert >}}

- [Create Your First Honey Jar](/docs/honey-jars/honey-jar-user-guide/) - Learn how to organize and manage your data
- [Authentication Setup](/docs/authentication/passwordless-authentication/) - Configure passwordless login
- [Chat with Bee](/docs/bee-features/bee-conversation-management/) - Explore AI-powered assistance
- [Performance Tuning](/docs/administration/performance-admin-guide/) - Optimize for your workload

Need help? Visit our [Troubleshooting Guide](/docs/troubleshooting/) or reach out to the community!


