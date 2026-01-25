---
title: "Backup & Restore"
linkTitle: "Backup & Restore"
weight: 15
description: >
  Complete guide to backing up and restoring your STING installation, including the new automated backup system.
---

# Backup & Restore Guide

This guide covers all aspects of backing up and restoring your STING installation, including the automated backup system with monitoring and retention policies.

## New Backup System Overview

STING now includes a comprehensive backup system with:
- **Unified backup wrapper** - Single script for all backup operations
- **Automated scheduling** - Cron-based backup with configurable retention
- **Health monitoring** - Alerts for stale or corrupted backups
- **Remote sync** - Optional offsite backup to S3 or rsync
- **Vault integration** - Separate Vault snapshot backups

## Quick Start

```bash
# Run a backup manually
/opt/sting-ce/scripts/backup/backup-wrapper.sh backup

# Check backup status
/opt/sting-ce/scripts/backup/backup-wrapper.sh status

# Install automated backups
sudo /opt/sting-ce/scripts/backup/setup-backup-cron.sh install

# Monitor backup health
/opt/sting-ce/scripts/backup/backup-monitor.sh check
```

## Backup Components

### What Gets Backed Up

| Component | Description | Included In |
|-----------|-------------|-------------|
| PostgreSQL Database | All application data | Main backup |
| Configuration Files | YAML configs, env files | Main backup |
| SSL Certificates | TLS certificates and keys | Main backup |
| Environment Files | Docker environment variables | Main backup |
| Docker Volumes | config_data, vault_data, logs | Main backup |
| Vault Secrets | HashiCorp Vault data | Separate Vault backup |

### Backup Locations

- **Main Backups**: `/opt/sting-backups/` (configurable)
- **Vault Snapshots**: `/vault/backups/`
- **Logs**: `/opt/sting-ce/logs/backup/`

## Configuration

Edit `/opt/sting-ce/conf/config.yml` to customize backup settings:

```yaml
backup:
  enabled: true
  default_directory: /opt/sting-backups
  compression_level: 5

  # Retention policy - both count and age are enforced
  retention:
    count: 5              # Keep last N backups
    max_age_days: 30      # Maximum age in days (0 = no limit)

  # Files to exclude from backup
  exclude_patterns:
    - "*.tmp"
    - "*.log"
    - "node_modules"
    - ".git"
    - "models"

  # Encryption settings
  encryption:
    enabled: false        # Enable AES-256-CBC encryption
    keychain: true        # Store key in system keychain

  # Remote/offsite backup configuration
  remote:
    enabled: false        # Enable offsite sync
    type: s3              # s3, rsync, ftp, sftp
    destination: s3://my-bucket/sting-backups
    user: backup_user     # SSH user for rsync
    port: 22              # SSH port for rsync

  # Vault backup settings
  vault:
    backup_enabled: true
    directory: /vault/backups
    retention_days: 7

  # Notification settings
  notifications:
    enabled: false
    webhook_url: ""       # Webhook for alerts
    email: ""             # Email for alerts
```

## Backup Commands

### Using the Unified Backup Wrapper

```bash
# Standard backup
./scripts/backup/backup-wrapper.sh backup

# Encrypted backup (recommended for offsite)
./scripts/backup/backup-wrapper.sh backup --encrypt

# Backup with custom retention
./scripts/backup/backup-wrapper.sh backup --retention 10 --days 14

# Sync to remote after backup
./scripts/backup/backup-wrapper.sh backup --remote s3

# Verify backup integrity
./scripts/backup/backup-wrapper.sh verify

# Show backup status and statistics
./scripts/backup/backup-wrapper.sh status

# Rotate old backups manually
./scripts/backup/backup-wrapper.sh rotate

# Backup Vault only
./scripts/backup/backup-wrapper.sh vault
```

### Using the Legacy msting Command

```bash
# Standard backup
msting backup

# Encrypted backup
msting backup --encrypt

# Restore from backup
msting restore /path/to/backup.tar.gz
```

## Automated Backups

### Installing Cron Jobs

```bash
# Install with defaults
sudo /opt/sting-ce/scripts/backup/setup-backup-cron.sh install

# Custom backup directory
sudo /opt/sting-ce/scripts/backup/setup-backup-cron.sh install --backup-dir /data/backups

# View current configuration
/opt/sting-ce/scripts/backup/setup-backup-cron.sh status

# Remove automated backups
sudo /opt/sting-ce/scripts/backup/setup-backup-cron.sh remove
```

### Default Schedule

| Job | Schedule | Description |
|-----|----------|-------------|
| Daily Backup | `30 2 * * *` | Full backup at 2:30 AM |
| Weekly Encrypted | `30 3 * * 0` | Encrypted backup Sunday 3:30 AM |
| Vault Backup | `0 */6 * * *` | Vault snapshot every 6 hours |
| Freshness Check | `0 * * * *` | Hourly backup age check |
| Health Check | `0 6 * * *` | Daily comprehensive check |
| Integrity Check | `0 7 * * 0` | Weekly archive verification |
| Rotation | `0 4 * * *` | Daily cleanup of old backups |

## Monitoring

### Health Check Commands

```bash
# Run all health checks
./scripts/backup/backup-monitor.sh check

# Check only backup freshness
./scripts/backup/backup-monitor.sh freshness

# Verify backup integrity
./scripts/backup/backup-monitor.sh integrity

# Check Vault backup status
./scripts/backup/backup-monitor.sh vault

# Generate JSON report
./scripts/backup/backup-monitor.sh report
```

### Alert Thresholds

Configure via environment or config:

- **Warning**: Backup older than 48 hours (default)
- **Critical**: Backup older than 7 days (168 hours)
- **Size Warning**: Backup smaller than 10 MB

```bash
# Custom thresholds
MAX_BACKUP_AGE_HOURS=24 ./scripts/backup/backup-monitor.sh check
CRITICAL_BACKUP_AGE_HOURS=72 ./scripts/backup/backup-monitor.sh check
```

## Remote/Offsite Backup

### Amazon S3

```yaml
backup:
  remote:
    enabled: true
    type: s3
    destination: s3://my-backup-bucket/sting
```

```bash
# Manual backup with S3 sync
./scripts/backup/backup-wrapper.sh backup --remote s3
```

### rsync

```yaml
backup:
  remote:
    enabled: true
    type: rsync
    destination: backup.server.com
    user: sting
    port: 22
    path: /backups/sting
```

## Encryption Keys (Critical!)

{{% pageinfo color="warning" %}}
**ALWAYS backup encryption keys BEFORE performing system upgrades or migrations.** See [Encryption Key Management](/docs/security/encryption-key-management/) for details.
{{% /pageinfo %}}

```bash

# Restore database
docker exec -i sting-ce-db psql -U sting_user sting_db < backup.sql

# Restart
msting start app
```

## Retention Policy

The backup system enforces both retention policies:

- **Count-based**: Keep last N backups (default: 5)
- **Age-based**: Remove backups older than N days (default: 30)

Older backups are removed first, then excess backups are trimmed to the count limit.

## Disaster Recovery Scenarios

### Scenario: Complete Server Loss

1. Provision new server
2. Retrieve encryption key backup from secure storage
3. Retrieve system backup from offsite storage
4. Follow migration procedure

### Scenario: Database Corruption

```bash
# Stop services
msting stop

# Restore from backup
msting restore /opt/sting-backups/backup-20240124.tar.gz

# Verify encryption keys
msting encryption-keys status

# Start services
msting start
```

### Scenario: Encryption Key Lost

{{% pageinfo color="danger" %}}
If encryption keys are truly lost:
- Encrypted files cannot be recovered
- Users must re-upload profile pictures and files
- Database records remain intact

**Prevention**: Maintain multiple key backups in secure locations.
{{% /pageinfo %}}

## Troubleshooting

### Backup Fails to Create

```bash
# Check Docker is running
docker ps

# Check disk space
df -h /opt/sting-backups

# Check logs
cat /opt/sting-ce/logs/backup/backup_$(date +%Y%m%d).log
```

### Backup Size Too Small

```bash
# List backups with sizes
ls -lh /opt/sting-backups/*.tar.gz

# Verify archive contents
tar -tzf /opt/sting-backups/backup.tar.gz | head -20
```

### Monitoring Alerts

```bash
# Check for alerts
cat /opt/sting-ce/logs/backup/alerts.log

# Verify backup manually
./scripts/backup/backup-wrapper.sh verify
```

## Best Practices

### Recommended Schedule

| Component | Frequency | Retention | Location |
|-----------|-----------|-----------|----------|
| Encryption Keys | Weekly + before upgrades | Forever | Password manager + offline |
| Full Backup | Daily | 7 days | Local + S3 |
| Vault Backup | Every 6 hours | 7 days | Local |
| Health Check | Hourly | N/A | N/A |

### Testing

- **Monthly**: Test restore to staging environment
- **Quarterly**: Full disaster recovery drill
- **Before Upgrades**: Verify all backups are current

### Storage Recommendations

- **Encryption Keys**: Password manager + encrypted USB
- **Daily Backups**: Local storage + S3 (encrypted)
- **Vault Snapshots**: Local + replication

## Related Documentation

- [Encryption Key Management](/docs/security/encryption-key-management/)
- [Upgrade Guide](/docs/guides/upgrade/)
- [Security Architecture](/docs/architecture/security-architecture/)
- [Troubleshooting](/docs/troubleshooting/)
