---
title: "Backup & Restore"
linkTitle: "Backup & Restore"
weight: 15
description: >
  Complete guide to backing up and restoring your STING installation.
---

# Backup & Restore Guide

This guide covers all aspects of backing up and restoring your STING installation, including the critical encryption keys that protect user data.

{{% pageinfo color="warning" %}}
**Critical**: Always backup encryption keys BEFORE performing system upgrades or migrations. See [Encryption Key Management](/docs/security/encryption-key-management/) for details.
{{% /pageinfo %}}

## Quick Reference

```bash
# Encryption keys (CRITICAL - do first!)
msting encryption-keys backup

# Full system backup
msting backup

# Encrypted backup
msting backup --encrypt
```

## What Gets Backed Up

### Automatically Included

| Component | Location | Backup Command |
|-----------|----------|----------------|
| Database | PostgreSQL | `msting backup` |
| Configuration | `/opt/sting-ce/conf/` | `msting backup` |
| Environment files | `/opt/sting-ce/env/` | `msting backup` |
| SSL Certificates | `/opt/sting-ce/certs/` | `msting backup` |

### Requires Separate Backup

| Component | Location | Backup Command |
|-----------|----------|----------------|
| **Encryption Keys** | Vault | `msting encryption-keys backup` |
| Uploaded Files | Vault | Included in Vault backup |
| LLM Models | `/opt/sting-ce/models/` | Manual copy |

## Backup Procedures

### 1. Encryption Keys (Critical!)

{{% pageinfo color="danger" %}}
**DO THIS FIRST**: Encryption keys cannot be recovered if lost. All encrypted user files become permanently unreadable.
{{% /pageinfo %}}

```bash
# Backup encryption keys
msting encryption-keys backup

# Save to specific location
msting encryption-keys backup /secure/path/keys.backup

# Verify backup was created
ls -la sting-encryption-keys.backup
```

**Store this backup securely:**
- Password manager (1Password, Bitwarden)
- Encrypted USB drive
- Separate from main backups

### 2. Full System Backup

```bash
# Standard backup
msting backup

# Encrypted backup (recommended for cloud storage)
msting backup --encrypt
```

Backups are saved to: `/opt/sting-ce/backups/`

### 3. Database-Only Backup

```bash
# Direct PostgreSQL dump
docker exec sting-ce-db pg_dump -U sting_user sting_db > backup.sql

# Compressed
docker exec sting-ce-db pg_dump -U sting_user sting_db | gzip > backup.sql.gz
```

## Restore Procedures

### 1. Restore Encryption Keys (Do First!)

```bash
# Restore encryption keys BEFORE starting services
msting encryption-keys restore /path/to/keys.backup

# Verify keys are restored
msting encryption-keys status
```

### 2. Restore Full System

```bash
# From standard backup
msting restore /path/to/backup.tar.gz

# From encrypted backup (auto-detected)
msting restore /path/to/backup.tar.gz.enc
```

### 3. Restore Database Only

```bash
# Stop the app first
msting stop app

# Restore database
docker exec -i sting-ce-db psql -U sting_user sting_db < backup.sql

# Restart
msting start app
```

## Migration to New Server

### Step-by-Step Process

1. **On OLD Server:**
   ```bash
   # Backup encryption keys (CRITICAL)
   msting encryption-keys backup ~/migration/keys.backup
   
   # Backup full system
   msting backup --encrypt
   cp /opt/sting-ce/backups/latest.tar.gz.enc ~/migration/
   ```

2. **Transfer to NEW Server:**
   ```bash
   scp ~/migration/* newserver:/tmp/migration/
   ```

3. **On NEW Server:**
   ```bash
   # Install STING first
   curl -sSL https://get.sting.dev | bash
   
   # Stop services
   msting stop
   
   # Restore encryption keys FIRST
   msting encryption-keys restore /tmp/migration/keys.backup
   
   # Restore full backup
   msting restore /tmp/migration/latest.tar.gz.enc
   
   # Start services
   msting start
   
   # Verify
   msting status
   msting encryption-keys status
   ```

## Automated Backups

### Using Cron

```bash
# Edit crontab
sudo crontab -e

# Daily backup at 2 AM
0 2 * * * /usr/local/bin/msting backup --encrypt >> /var/log/sting-backup.log 2>&1

# Weekly key backup (extra safety)
0 3 * * 0 /usr/local/bin/msting encryption-keys backup /opt/sting-ce/backups/keys-$(date +\%Y\%m\%d).backup
```

### Backup Retention

```bash
# Keep last 7 daily backups
find /opt/sting-ce/backups -name "*.tar.gz*" -mtime +7 -delete
```

## Disaster Recovery

### Scenario: Complete Server Loss

1. Provision new server
2. Retrieve encryption key backup from secure storage
3. Retrieve system backup from offsite storage
4. Follow migration procedure above

### Scenario: Database Corruption

```bash
# Stop services
msting stop

# Restore from last known good backup
msting restore /opt/sting-ce/backups/backup-YYYYMMDD.tar.gz

# Verify encryption keys match
msting encryption-keys status

# Start services
msting start
```

### Scenario: Encryption Key Lost

{{% pageinfo color="danger" %}}
**Unfortunately, if encryption keys are truly lost:**
- Encrypted files cannot be recovered
- Users must re-upload all profile pictures and files
- Database records remain intact

**Prevention**: Always maintain multiple key backups in secure locations.
{{% /pageinfo %}}

## Best Practices

### Backup Schedule

| Component | Frequency | Retention |
|-----------|-----------|-----------|
| Encryption Keys | Weekly + before upgrades | Forever (multiple copies) |
| Full Backup | Daily | 7 days |
| Database | Hourly (production) | 24 hours |

### Storage Recommendations

- **Encryption Keys**: Password manager + encrypted offline storage
- **Daily Backups**: Local + cloud storage (encrypted)
- **Hourly DB**: Local only (rapid recovery)

### Testing

- **Monthly**: Test restore to staging environment
- **Quarterly**: Full disaster recovery drill
- **Before Upgrades**: Verify all backups are current and accessible

## Related Documentation

- [Encryption Key Management](/docs/security/encryption-key-management/)
- [Upgrade Guide](/docs/guides/upgrade/)
- [Troubleshooting](/docs/troubleshooting/)
