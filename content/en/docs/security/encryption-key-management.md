---
title: "Encryption Key Management"
linkTitle: "Encryption Keys"
weight: 5
description: >
  Critical guide for managing encryption keys that protect user data in STING.
---

# Encryption Key Management

{{% pageinfo color="warning" %}}
**CRITICAL**: The encryption master key protects ALL user files. Loss of this key means **permanent, unrecoverable data loss**. Always maintain secure backups!
{{% /pageinfo %}}

## Overview

STING uses the **Honey Reserve** encryption system to protect sensitive user data at rest, including:

- Profile pictures
- Uploaded file attachments
- Sensitive document content
- API credentials (via Vault)

The encryption uses AES-256-GCM with a hierarchical key structure for maximum security and per-user isolation.

## Key Hierarchy

```
┌─────────────────────────────────────────┐
│     Master Key (HONEY_RESERVE)          │
│     Stored in: HashiCorp Vault          │
│     sting/honey_reserve/master_key      │
└─────────────────┬───────────────────────┘
                  │ HKDF-SHA256
                  ▼
┌─────────────────────────────────────────┐
│     User-Derived Key                    │
│     Unique per user (from user_id)      │
│     Cached in memory (1 hour TTL)       │
└─────────────────┬───────────────────────┘
                  │ AES-256-GCM
                  ▼
┌─────────────────────────────────────────┐
│     File-Specific Key                   │
│     Random 256-bit per file             │
│     Encrypted with user key             │
└─────────────────────────────────────────┘
```

### Why This Matters

1. **User Isolation**: Each user's files are encrypted with keys derived from their unique user ID
2. **Key Compromise Scope**: If a file key is compromised, only that file is affected
3. **Master Key Protection**: The master key never directly encrypts data—it derives user keys

## Managing Encryption Keys

### Check Key Status

```bash
msting encryption-keys status
```

Output:
```
🔑 Encryption Key Status

  Honey Reserve Master Key: ✓ Present (KmkVQCsc...MCM=)
  Vault metadata:
    created_time            2026-01-22T15:30:00Z
    current_version         1

💡 Recommendations:
  • Backup keys BEFORE upgrades: msting encryption-keys backup
  • Store backup in secure location (password manager, offline storage)
  • Never regenerate keys - this destroys encrypted data!
```

### Backup Encryption Keys

{{% pageinfo color="primary" %}}
**Best Practice**: Always backup keys before:
- System upgrades
- Server migrations
- Database restores
- Any maintenance that touches Vault
{{% /pageinfo %}}

```bash
# Create backup (default: sting-encryption-keys.backup)
msting encryption-keys backup

# Create backup with custom filename
msting encryption-keys backup /secure/path/my-sting-keys.backup
```

The backup file contains:
- Timestamped key export
- SHA256 integrity checksum
- Warning metadata
- JSON format for portability

**Sample backup structure** (keys redacted):
```json
{
  "sting_encryption_keys_backup": true,
  "version": "1.0",
  "created_at": "2026-01-24T02:21:14Z",
  "warning": "CRITICAL: These keys are required to decrypt user files.",
  "keys": {
    "honey_reserve_master_key": "***REDACTED***"
  },
  "checksum": "e9bf4e23b2eb1b2bc4c39e225bec070e..."
}
```

### Restore Encryption Keys

```bash
# Restore from backup file
msting encryption-keys restore /path/to/backup-file.backup

# Then restart the app to apply
msting restart app
```

The restore process:
1. Validates backup file format
2. Verifies checksum integrity
3. Warns if different key exists
4. Updates Vault with restored key

## Backup Storage Best Practices

### Where to Store Backups

| Storage Method | Security Level | Recommended |
|----------------|----------------|-------------|
| Password Manager (1Password, Bitwarden) | ⭐⭐⭐⭐⭐ | ✅ Best |
| Encrypted USB in safe | ⭐⭐⭐⭐ | ✅ Good |
| Hardware Security Module (HSM) | ⭐⭐⭐⭐⭐ | ✅ Enterprise |
| Encrypted cloud storage | ⭐⭐⭐ | ⚠️ Acceptable |
| Plain text file on server | ⭐ | ❌ Never |
| Git repository | ⭐ | ❌ Never |

### Recommended: Multiple Locations

Store backups in at least **two independent secure locations**:

1. **Primary**: Password manager or encrypted cloud storage
2. **Secondary**: Offline storage (encrypted USB, printed QR code in safe)

### Encrypting Backup Files

For additional protection, encrypt the backup with GPG:

```bash
# Encrypt backup
gpg --symmetric --cipher-algo AES256 sting-encryption-keys.backup

# Decrypt when needed
gpg --decrypt sting-encryption-keys.backup.gpg > sting-encryption-keys.backup
```

## Recovery Scenarios

### Scenario 1: Key Was Accidentally Changed

**Symptoms:**
- Profile pictures show as broken images
- File downloads fail with 404
- Logs show "Decryption failed" errors

**Solution:**
```bash
# Check current key status
msting encryption-keys status

# If you have a backup, restore it
msting encryption-keys restore /path/to/backup

# Restart the app
msting restart app
```

### Scenario 2: Migrating to New Server

```bash
# On OLD server: backup keys
msting encryption-keys backup ~/sting-keys-migration.backup

# Copy backup to new server (secure method)
scp ~/sting-keys-migration.backup newserver:/tmp/

# On NEW server: restore keys BEFORE starting services
msting encryption-keys restore /tmp/sting-keys-migration.backup
msting start
```

### Scenario 3: No Backup Exists

{{% pageinfo color="danger" %}}
**Unfortunately, if the encryption key is truly lost:**
- Existing encrypted files **cannot be recovered**
- Users will need to re-upload all files
- This is by design—encryption without recovery is the security model
{{% /pageinfo %}}

**Prevention is the only solution**:
- Always backup keys immediately after installation
- Verify backups periodically
- Test restore process in staging environment

## Technical Details

### Key Generation

The master key is generated during initial installation:

```python
# 32 bytes (256 bits) of cryptographically secure randomness
master_key = secrets.token_bytes(32)
# Encoded as base64 for storage
master_key_b64 = base64.b64encode(master_key).decode('utf-8')
```

### Key Derivation (Per-User)

```python
# User key derivation using HKDF
salt = hashlib.sha256(user_id.encode('utf-8')).digest()
hkdf = HKDF(
    algorithm=hashes.SHA256(),
    length=32,
    salt=salt,
    info=b'STING-CE-Honey-Reserve-v1'
)
user_key = hkdf.derive(master_key)
```

### File Encryption

Each file is encrypted with:
1. **File Key**: Random 256-bit AES key (unique per file)
2. **File Encryption**: AES-256-GCM with random nonce
3. **Key Encryption**: File key encrypted with user's derived key
4. **Integrity**: SHA256 hash of original file for verification

### Vault Storage

Keys are stored in HashiCorp Vault at:
```
sting/honey_reserve/master_key
```

Vault provides:
- Encrypted storage at rest
- Access control and audit logging
- Version history (for recovery)
- Automatic unsealing (dev mode) or manual unsealing (production)

## Security Considerations

### What the Master Key Protects

| Data Type | Encrypted | Location |
|-----------|-----------|----------|
| Profile Pictures | ✅ Yes | Vault files storage |
| File Attachments | ✅ Yes | Vault files storage |
| Database Records | ❌ No | PostgreSQL (separate encryption) |
| Session Tokens | ❌ No | Redis (memory-only) |
| API Keys | ✅ Yes | Vault secrets |

### Key Rotation

{{% pageinfo color="info" %}}
**Note**: Key rotation with re-encryption is planned for a future release. Currently, the master key should not be changed after files are encrypted.
{{% /pageinfo %}}

### Compliance Notes

For SOC2, HIPAA, and similar compliance:
- Document your key backup procedures
- Maintain key custody chain records
- Test recovery procedures quarterly
- Consider HSM for key storage in production

## Troubleshooting

### "Encryption key not found" Error

```
RuntimeError: Encryption key at 'honey_reserve' not found.
Cannot generate new key as this would make existing data unreadable.
```

**Cause**: The system is protecting against accidental key regeneration.

**Solution**:
1. Check if Vault is running: `docker ps | grep vault`
2. Check Vault connectivity: `msting encryption-keys status`
3. Restore from backup if key was lost

### "Decryption failed" Errors

```
HoneyReserveEncryptionError: Decryption failed
```

**Cause**: Key mismatch—file was encrypted with different key.

**Solution**:
1. Identify which key encrypted the file (check timestamps)
2. Restore the correct key from backup
3. Re-encrypt files with current key (future feature)

### Vault Connectivity Issues

```bash
# Check Vault status
docker exec sting-ce-vault vault status

# If sealed, unseal it
msting unseal

# Verify key access
docker exec sting-ce-vault vault kv get sting/honey_reserve
```

## Related Documentation

- [Vault Configuration](/docs/configuration/vault/)
- [Backup & Restore](/docs/administration/backup-restore/)
- [Security Architecture](/docs/architecture/security/)
- [Troubleshooting](/docs/troubleshooting/)
