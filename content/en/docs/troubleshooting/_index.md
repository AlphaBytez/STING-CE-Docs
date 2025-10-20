---
title: "Troubleshooting"
linkTitle: "Troubleshooting"
weight: 8
description: >
  Common issues, solutions, and debugging guides
---

# Troubleshooting Guide

Solutions to common issues and debugging techniques for STING.

## Quick Troubleshooting

### Installation Issues
- Docker build failures
- Permission errors (macOS)
- BuildKit cache issues
- WSL2-specific problems.

### Authentication Issues
- Passkey registration failures
- WebAuthn 403 errors
- Session persistence
- Cross-machine passkey problems
- Login redirect loops
- AAL2 passkey issues.

### Service Issues
- Container startup failures
- Health check failures
- Database connection errors
- Redis connection issues
- LLM service not ready.

### Email & Verification
- Email verification not working
- Mailpit configuration (WSL2, macOS)
- SMTP connection issues
- Verification link problems.

## Platform-Specific Issues

### macOS
- Permission errors
- Domain resolution
- Email verification fixes
- Docker performance.

### Linux/Ubuntu
- Service management
- Permissions
- Network configuration.

### WSL2
- Custom domain setup
- Port forwarding
- File permissions
- Email configuration
- Login/session fixes.

## Common Errors

### Authentication Errors
- "WebAuthn registration failed"
- "Invalid session"
- "CORS policy error"
- "Passkey not found"

### Application Errors
- 500 Internal Server Error
- 403 Forbidden
- 401 Unauthorized
- Connection timeout.

### Database Errors
- Connection refused
- Migration failures
- Schema conflicts.

## Debugging Tools

### Log Files
Where to find logs for each component:
- Application logs
- Kratos logs
- Database logs
- Docker container logs.

### Debug Mode
Enabling debug mode for verbose logging.

### Health Checks
Using health check endpoints to diagnose issues.

## Performance Issues

### Slow Performance
- Database query optimization
- Cache tuning
- Resource allocation
- Concurrent request handling.

### High Memory Usage
- Container resource limits
- Memory leaks
- Cache size configuration.

## Recovery Procedures

### Session Management
- Clear all sessions
- Fix session expiry
- Session sync issues.

### Password Recovery
- Account recovery flows
- Admin password reset
- Manual intervention.

### Data Recovery
- Backup restoration
- Database recovery
- Vault data recovery.

## Getting Help

If you can't find a solution:

1. **Check the docs**: Search this documentation
2. **GitHub Issues**: Check existing issues
3. **GitHub Discussions**: Ask the community
4. **Email Support**: Contact olliec@alphabytez.dev

When reporting issues, include:
- STING version
- Platform (OS, Docker version)
- Error messages and logs
- Steps to reproduce
- Expected vs actual behavior.
