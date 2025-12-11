---
title: "VirtualBox OVA Guide"
linkTitle: "VirtualBox OVA"
weight: 20
description: >
  Complete guide to importing and configuring the STING-CE Quick Start OVA in VirtualBox for optimal performance.
---

# VirtualBox OVA Installation Guide

This guide covers importing and configuring the STING-CE Quick Start OVA in VirtualBox for optimal performance.

## Prerequisites

{{< alert title="Requirements" color="info" >}}
- VirtualBox 7.0+ (recommended) or 6.1+
- At least 12GB RAM on host system (8GB for VM)
- 50GB free disk space
- Virtualization enabled in BIOS (VT-x/AMD-V)
{{< /alert >}}

## Downloading the OVA

Download the latest OVA from GitHub Releases:

- **AMD64 (Intel/AMD)**: `sting-ce-quickstart-1.0.0-amd64.ova`
- **ARM64 (Apple Silicon)**: `sting-ce-quickstart-1.0.0-arm64.ova` *(requires UTM or Parallels)*

{{< alert title="Architecture Note" color="warning" >}}
VirtualBox on Apple Silicon Macs has limited support. For ARM64 builds on macOS, consider using [UTM](https://mac.getutm.app/) or Parallels instead.
{{< /alert >}}

## Importing the OVA

1. Open VirtualBox
2. Go to **File → Import Appliance**
3. Select the `.ova` file and click **Next**
4. Review settings (see recommended settings below)
5. Click **Import**

---

## Critical Performance Settings

{{< alert title="Performance Warning" color="danger" >}}
**The OVA is pre-configured with optimal settings, but VirtualBox may not preserve all of them during import.** Check these settings before first boot to avoid extremely slow installation times (60+ minutes instead of 15-20 minutes).
{{< /alert >}}

### Host I/O Cache (CRITICAL)

This setting **dramatically affects disk performance**. Without it, database operations and Docker image loading become severely bottlenecked.

1. Select the VM in VirtualBox
2. Click **Settings → Storage**
3. Click on **Controller: SATA** (the controller itself, not the disk)
4. Check **Use Host I/O Cache** ✓
5. Click **OK**

{{< figure src="/images/virtualbox-host-io-cache.png" alt="VirtualBox Host I/O Cache setting" caption="Enable Host I/O Cache on the SATA Controller" >}}

**Impact:**

| Setting | Installation Time | Service Startup |
|---------|------------------|-----------------|
| Host I/O Cache **ON** | ~15-20 minutes | ~30 seconds per service |
| Host I/O Cache **OFF** | 60-90+ minutes | 3-5+ minutes per service |

### Memory (RAM)

{{< alert title="Memory Requirements" color="info" >}}
STING requires sufficient RAM for Docker containers, PostgreSQL, ChromaDB, and AI model loading.
{{< /alert >}}

| Setting | Minimum | Recommended |
|---------|---------|-------------|
| Base Memory | 4096 MB | 8192 MB |

To adjust:
1. **Settings → System → Motherboard**
2. Set **Base Memory** to at least 4096 MB (8192 MB recommended)

### CPU

| Setting | Minimum | Recommended |
|---------|---------|-------------|
| Processors | 2 | 4+ |

To adjust:
1. **Settings → System → Processor**
2. Set **Processor(s)** to at least 2 (4 recommended)
3. Enable **PAE/NX** if available
4. Enable **Nested VT-x/AMD-V** if available (for Docker performance)

### Network Configuration

{{< tabpane text=true >}}
{{% tab header="**Bridged Adapter (Recommended)**" %}}

Bridged networking gives the VM its own IP address on your network:

1. **Settings → Network → Adapter 1**
2. Attached to: **Bridged Adapter**
3. Select your physical network interface (e.g., `en0`, `eth0`, Wi-Fi)

**Benefits:**
- Access from other machines on your network
- mDNS hostname resolution (e.g., `ubuntu-vm.local`)
- WebAuthn/Passkey authentication works properly
- No port forwarding needed

{{% /tab %}}
{{% tab header="**NAT (Local-Only)**" %}}

NAT mode is simpler but requires port forwarding for external access:

1. **Settings → Network → Adapter 1**
2. Attached to: **NAT**
3. Click **Advanced → Port Forwarding**
4. Add rules:

| Name | Host Port | Guest Port |
|------|-----------|------------|
| HTTPS | 8443 | 8443 |
| SSH | 2222 | 22 |
| Wizard | 5000 | 5000 |

**Limitations:**
- Only accessible from host machine
- WebAuthn requires additional setup
- Must use `localhost:8443` instead of hostname

{{% /tab %}}
{{< /tabpane >}}

### Graphics

1. **Settings → Display**
2. Video Memory: **32 MB** or higher
3. Graphics Controller: **VMSVGA** (recommended for Ubuntu)

---

## First Boot

1. **Start** the VM
2. **Wait** for Ubuntu to boot to the login screen
3. **Login** with:
   - Username: `sting`
   - Password: `sting`
4. The STING-CE installation wizard will start automatically
5. **Open** your browser to the URL shown in the console

### Expected Installation Timeline

With proper settings (Host I/O Cache enabled):

| Phase | Duration |
|-------|----------|
| VM boot to login | 1-2 minutes |
| First-boot initialization | 2-3 minutes |
| Service health checks | 10-15 minutes |
| **Total to ready** | **15-20 minutes** |

{{< alert title="First Boot Takes Longer" color="info" >}}
The first boot initializes databases, generates certificates, and starts all services. Subsequent boots are much faster (~2-3 minutes).
{{< /alert >}}

---

## Accessing STING-CE

After installation completes:

### Web Interface

```yaml
From VM Console:
  URL: https://localhost:8443

From Host (Bridged Network):
  URL: https://<vm-hostname>.local:8443
  Example: https://ubuntu-vm.local:8443

From Host (NAT with Port Forwarding):
  URL: https://localhost:8443
```

### SSH Access

```bash
# Bridged networking
ssh sting@<vm-hostname>.local
# Password: sting

# NAT with port forwarding
ssh -p 2222 sting@localhost
```

### Setup Wizard

The web-based setup wizard runs on port 5000 during first boot:
- `http://<vm-ip>:5000` - Initial configuration

---

## Troubleshooting

### Installation Taking Too Long

**Symptoms:**
- Kratos health checks failing repeatedly (retry 10+/60)
- Services taking 5+ minutes each to start
- Installation exceeding 30 minutes

**Solution:**
1. Power off the VM (Machine → ACPI Shutdown or force power off)
2. Verify **Host I/O Cache** is enabled (see above)
3. Ensure at least 4GB RAM allocated
4. Restart the VM

### Network Not Working

**Symptoms:**
- Cannot access STING web interface
- Cannot resolve hostname
- Docker images failing to pull

**Solutions:**

{{< tabpane text=true >}}
{{% tab header="**Check Adapter**" %}}
```yaml
1. Settings → Network → Adapter 1
2. Verify "Cable Connected" is checked
3. Try different adapter type:
   - Bridged: Select different physical interface
   - NAT: Ensure port forwarding is configured
```
{{% /tab %}}
{{% tab header="**Check VM Network**" %}}
```bash
# Inside the VM, check IP address
ip addr show

# Test internet connectivity
ping -c 3 google.com

# Check DNS resolution
nslookup google.com
```
{{% /tab %}}
{{< /tabpane >}}

### VM Won't Start

**Symptoms:**
- VT-x/AMD-V errors
- "Virtualization not available"

**Solutions:**

1. **Enable virtualization in BIOS/UEFI:**
   - Reboot host machine
   - Enter BIOS setup (usually F2, F12, or Del during boot)
   - Find "Virtualization" or "VT-x" option and enable it

2. **On Windows, disable conflicting features:**
   ```powershell
   # Run as Administrator
   bcdedit /set hypervisorlaunchtype off

   # Or disable Hyper-V in Windows Features
   ```

3. **Restart your computer** after making changes

### Poor Console Performance

**Symptoms:**
- Laggy terminal
- Screen tearing
- Slow typing response

**Solutions:**
1. Install VirtualBox Guest Additions (pre-installed in OVA)
2. Increase video memory to 64 MB
3. Try different graphics controller (VBoxVGA vs VMSVGA)
4. Use SSH instead of console for better performance

### Services Keep Restarting

**Symptoms:**
- Containers entering restart loops
- `docker ps` shows services restarting

**Solutions:**
1. Check available memory:
   ```bash
   free -h
   docker stats --no-stream
   ```
2. Increase VM RAM if memory is exhausted
3. Check disk space:
   ```bash
   df -h
   ```

---

## Recommended VirtualBox Settings Summary

```yaml
System:
  Base Memory: 8192 MB (minimum 4096 MB)
  Processors: 4 (minimum 2)
  Enable PAE/NX: Yes
  Enable Nested VT-x/AMD-V: Yes (if available)

Storage:
  Controller: SATA
  Host I/O Cache: ENABLED (critical!)

Display:
  Video Memory: 32 MB+
  Graphics Controller: VMSVGA

Network:
  Attached to: Bridged Adapter (recommended)
  Cable Connected: Yes

Audio:
  Enable Audio: No (not needed, saves resources)
```

---

## VMware Alternative

If you experience issues with VirtualBox, the OVA is also compatible with:

- **VMware Workstation** (Windows/Linux)
- **VMware Fusion** (macOS Intel)
- **VMware Player** (free for personal use)

VMware typically handles I/O caching automatically and may provide better performance out of the box.

---

## Next Steps

After successful installation:

- [Create Your First Honey Jar](/docs/honey-jars/honey-jar-user-guide/) - Organize your knowledge
- [Configure Authentication](/docs/authentication/passwordless-authentication/) - Set up passkeys
- [Connect AI Models](/docs/bee-features/ollama-model-setup/) - Configure Ollama or external AI
- [Admin Setup](/docs/administration/admin-setup/) - Configure your instance

---

## Getting Help

If you continue to experience issues:

1. Check the [Common Errors and Fixes](/docs/troubleshooting/common-errors-and-fixes/)
2. Review VirtualBox logs: **Machine → Show Log**
3. Create an issue at [STING-CE GitHub](https://github.com/AlphaBytez/STING-CE/issues)

Include in your report:
- VirtualBox version
- Host OS and version
- VM settings screenshot
- Console output or error messages
