---
title: "API Reference"
linkTitle: "API Reference"
weight: 50
type: docs
description: >
  Complete API documentation with examples
cascade:
  type: docs
---

# STING API Reference

Comprehensive REST API documentation for integrating with STING.

## Available APIs

### [Platform API](api-reference/)
Complete REST API documentation for the STING platform, including authentication, chat interactions, knowledge management, and system administration.

**Base URL**: `/api`

### [Public Bee API](public-bee-api/)
RESTful API for AI-as-a-Service chatbot platform, enabling bot creation, management, and conversation handling.

**Base URL**: `/api/public`

### [Honey Jar Bulk API](honey-jar-bulk-api/)
Bulk operations for managing Honey Jars, including directory uploads, batch processing, and automation.

**Base URL**: `/api/knowledge/honey-jars`

### [PII Detection API](pii-detection-api/)
Automated detection of personally identifiable information with pattern-based and ML-powered classification.

**Base URL**: `/api/pii-detection`

## API Documentation Structure

Each API section includes:
- Endpoint descriptions
- Request/response formats
- Authentication requirements
- Code examples (curl, Python, JavaScript)
- Error codes and handling

## Authentication

All API requests require authentication. STING supports:
- **Session-based authentication**: Via Ory Kratos integration
- **API tokens**: For programmatic access (see [API Key Management](api-reference/#api-key-management-admin-only))
- **OAuth 2.0**: Enterprise feature for third-party integrations

## Rate Limiting

Default API rate limits:
- Authentication endpoints: 5 requests/minute
- Chat endpoints: 60 requests/minute
- Knowledge search: 100 requests/minute
- General API: 1,000 requests/hour

Rate limit headers are included in all responses:
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1704067200
```

## SDKs and Client Libraries

Use our RESTful API from any language. Community SDKs may be available - check our GitHub discussions.
