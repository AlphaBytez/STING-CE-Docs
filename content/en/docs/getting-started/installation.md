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

## System Requirements

### Minimum Requirements

{{< alert title="Hardware Requirements" color="info" >}}
STING Core requires **8GB RAM minimum** and **30GB free disk space**. Docker Desktop 4.0+ with Docker Compose is required. AI models run via Ollama (separate) or external APIs (no extra resources).
{{< /alert >}}

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

{{< alert title="AI Models Run Separately" color="primary" >}}
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

STING supports multiple AI model options. Choose the one that best fits your needs:

### Option 1: Ollama (Recommended)

{{< alert title="Recommended for Local Deployment" color="primary" >}}
Ollama provides local AI models with excellent performance and privacy. This is the recommended option for most users.
{{< /alert >}}

1. **Install Ollama** from [ollama.com](https://ollama.com)
2. **Pull recommended models:**
   ```bash
   ollama pull phi3:mini
   ollama pull deepseek-r1
   ```

### Option 2: External AI Providers

Configure API keys in the External AI settings for cloud-based AI:

```yaml
Supported Providers:
  OpenAI:
    Models: GPT-4, GPT-4-Turbo, GPT-3.5-Turbo
    Setup: Add API key in Settings → External AI

  Anthropic Claude:
    Models: Claude 3 Opus, Claude 3 Sonnet, Claude 3 Haiku
    Setup: Add API key in Settings → External AI

  Google Gemini:
    Models: Gemini Pro, Gemini Pro Vision
    Setup: Add API key in Settings → External AI

  Custom Providers:
    Support: Any OpenAI-compatible API endpoint
    Config: Custom base URL + API key
```

**Example Configuration:**

```bash
# Set via environment variables (optional)
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="..."
```

### Option 3: Legacy Models (Optional)

{{< alert title="Legacy Support" color="warning" >}}
HuggingFace tokens are only needed for legacy model support (phi3, llama3, zephyr). The modern Ollama/External AI stack does not require HuggingFace tokens.
{{< /alert >}}

If you need legacy models:

```bash
# Interactive token setup
./setup_hf_token.sh

# Token will be securely stored in HashiCorp Vault
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
open https://localhost:3010  # Production
# or
open https://localhost:8443  # Development
```

**Test API Access:**

```bash
# Check API health
curl -k https://localhost:5050/api/auth/health

# Expected response: {"status": "healthy", "timestamp": "..."}
```

### Create Your First User

1. Navigate to `https://localhost:3010`
2. Click **"Register"** to create your first account
3. Enter your email and password
4. Complete email verification
   - Check Mailpit at `http://localhost:8025` for the verification email
5. **Log in** to access the dashboard

### Test the Chatbot

1. Navigate to the **Chat** interface
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

### Custom Model Configuration

Edit the main configuration file to customize model settings:

```bash
vim conf/config.yml
```

**Example Customization:**

```yaml
llm_service:
  default_model: phi3
  models:
    phi3:
      enabled: true
      max_tokens: 4096
    deepseek-1.5b:
      enabled: false  # Disable to save memory
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
<summary><strong>Model Loading Issues</strong></summary>

```bash
# Check model status
./sting-llm status

# Manually download models
./sting-llm download phi3

# Check available disk space
df -h ~/.sting-ce/models
```

</details>

<details>
<summary><strong>Memory Issues</strong></summary>

```bash
# Check memory usage
./sting-llm memory

# Reduce loaded models
vim conf/config.yml
# Set model_lifecycle.max_loaded_models: 1

# Restart LLM service
./sting-llm restart
```

</details>

### Health Diagnostics

```bash
# Comprehensive health check
./manage_sting.sh health

# Individual service health
curl -k https://localhost:5050/api/auth/health
curl -k http://localhost:8086/health
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
