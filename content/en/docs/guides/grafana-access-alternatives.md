---
title: "Dashboard Access Guide"
linkTitle: "Dashboard Access"
weight: 10
description: >
  Configure and access system monitoring dashboards in STING.
---

# Dashboard Access Guide

> **Implementation Note:** STING-CE includes basic dashboard capabilities when the observability stack is enabled. Advanced dashboard features and integrations described in this guide may require additional configuration or be available in enterprise editions.

STING provides flexible options for viewing system monitoring and analytics dashboards. This guide explains how to access and configure dashboard functionality.

## Dashboard Types

STING supports multiple dashboard implementations depending on your deployment configuration:

### Native Dashboards

Native dashboards are built directly into STING and provide:
- Seamless authentication using your STING credentials
- Responsive design optimized for all devices
- Consistent theme integration
- No additional service dependencies

### Advanced Dashboards (Grafana)

For deployments with observability services enabled, Grafana provides advanced monitoring capabilities including:
- Custom query building
- Complex data visualization
- Historical data analysis
- Advanced alerting

## Accessing Dashboards

### Through STING Interface

1. Log in to your STING account
2. Navigate to the monitoring section
3. Select the dashboard you want to view

Dashboards automatically use your existing STING session for authentication.

### Direct Access (Grafana Only)

If your deployment includes Grafana observability services:

1. Access the Grafana interface at your configured URL
2. Use the credentials provided by your administrator
3. Select from pre-configured STING dashboards

**Note:** Direct Grafana access may require additional network configuration in some deployment environments.

## Available Dashboard Views

### System Overview
Monitor overall system health including:
- Service status and uptime
- Resource utilization
- Request volume and performance
- Active user sessions

### Authentication Audit
Track authentication events:
- Login activity and trends
- Authentication method usage
- Security events
- Failed authentication attempts

### PII Compliance
Monitor privacy compliance:
- PII detection rates
- Data sanitization metrics
- Compliance coverage

## Configuration

### Environment Variables

Configure dashboard access in your STING environment:

```bash
# Enable native dashboards (recommended)
NATIVE_DASHBOARDS_ENABLED=true

# Optional: Grafana integration
GRAFANA_ENABLED=false
GRAFANA_BASE_URL=http://grafana:3000
```

### Dashboard Preferences

You can configure dashboard refresh intervals and other preferences through the STING admin interface.

## Troubleshooting

### Dashboard Not Loading

If dashboards fail to load:

1. Verify your authentication session is active
2. Check that required services are running
3. Review network connectivity
4. Consult the [troubleshooting guide](/docs/troubleshooting/) for detailed diagnostics

### Performance Issues

For slow dashboard loading:

- Reduce the time range of displayed data
- Limit the number of concurrent dashboard panels
- Check system resource availability

## Security Considerations

All dashboard access respects STING's authentication and authorization framework. Users can only view dashboards and data appropriate to their access level.

For deployments requiring advanced access controls, consult the [Security Architecture](/docs/architecture/security-architecture/) documentation.

---

For additional configuration options, see the [Admin Guide](/docs/guides/admin-guide/).
