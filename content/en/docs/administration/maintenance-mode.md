---
title: "Maintenance Mode"
linkTitle: "Maintenance Mode"
weight: 25
description: >
  Enable maintenance windows for updates, migrations, or scheduled downtime.
---

# Maintenance Mode Guide

## Overview

STING includes a comprehensive Maintenance Window System that allows administrators to gracefully take the platform offline for updates, migrations, or scheduled maintenance.

**Key Features:**
- Full-page maintenance screen for unauthenticated users
- CLI commands for quick enable/disable via terminal
- Admin UI panel for scheduled maintenance with custom messages
- Redis-backed state for distributed deployments
- Automatic recovery when maintenance ends

## Quick Reference

### CLI Commands

```bash
# Enable maintenance mode immediately
sudo msting maintenance on

# Enable with custom message
sudo msting maintenance on --message "Upgrading database. Back in 30 minutes."

# Disable maintenance mode
sudo msting maintenance off

# Check current status
sudo msting maintenance status
```

### API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/system/maintenance/status` | GET | Public | Check maintenance status |
| `/api/admin/maintenance/enable` | POST | Admin | Enable maintenance mode |
| `/api/admin/maintenance/disable` | POST | Admin | Disable maintenance mode |

## Best Practices

### Before Enabling Maintenance

1. **Notify users in advance** - Use the scheduled maintenance banner feature
2. **Complete pending operations** - Check for running reports, active chats
3. **Create a backup** - `sudo msting backup create`
4. **Document the reason** - Use meaningful maintenance messages

### After Maintenance

1. **Verify services** - `sudo msting status`
2. **Check health endpoints** - Ensure all services are healthy
3. **Test critical paths** - Login, chat, API responses

## Troubleshooting

### Maintenance Mode Stuck

```bash
# Force disable via Redis
sudo docker exec sting-ce-redis redis-cli DEL "sting:maintenance:state"

# Restart frontend to clear cached state
sudo msting restart frontend
```

## Related Documentation

- [Admin Guide](/docs/administration/admin-guide/)
- [Admin Setup](/docs/administration/admin-setup/)
