---
title: "Honey Jar Bulk API"
linkTitle: "Honey Jar Bulk API"
weight: 30
description: >
  Bulk operations for Honey Jar management, including directory uploads and batch processing
---

# Honey Jar Bulk API

## Overview

The Honey Jar Bulk API provides endpoints for bulk operations on Honey Jars, enabling directory uploads, batch processing, and automated workflows.

## Endpoints

### Bulk Upload Directory
```
POST /api/knowledge/honey-jars/{id}/upload-directory
Content-Type: multipart/form-data
```

**Request**:
```bash
curl -X POST "http://localhost:8090/honey-jars/123/upload-directory" \
  -H "Authorization: Bearer <token>" \
  -F "directory=@./docs/" \
  -F "options={\"recursive\":true,\"include_patterns\":[\"*.md\",\"*.pdf\"],\"exclude_patterns\":[\"node_modules\",\".git\"],\"retention_policy\":\"permanent\"}"
```

**Request Body**:
- `directory`: Tar/zip archive of the directory
- `options`: JSON configuration object

**Options Schema**:
```json
{
  "recursive": true,
  "include_patterns": ["*.md", "*.pdf", "*.docx", "*.txt"],
  "exclude_patterns": ["node_modules", ".git", "*.tmp"],
  "retention_policy": "permanent|30d|90d|1y|custom",
  "custom_retention_days": 365,
  "overwrite_existing": false,
  "create_subdirectories": true,
  "metadata": {
    "source": "Documentation Upload",
    "category": "docs",
    "version": "1.0"
  }
}
```

**Response**:
```json
{
  "upload_id": "bulk_upload_abc123",
  "status": "processing",
  "files_queued": 45,
  "estimated_completion": "2025-01-15T10:30:00Z",
  "progress_url": "/api/knowledge/uploads/bulk_upload_abc123/status"
}
```

### Upload Status Tracking
```
GET /api/knowledge/uploads/{upload_id}/status
```

**Response**:
```json
{
  "upload_id": "bulk_upload_abc123",
  "status": "processing|completed|failed",
  "progress": {
    "total_files": 45,
    "processed": 32,
    "successful": 30,
    "failed": 2,
    "percentage": 71
  },
  "files": [
    {
      "path": "docs/README.md",
      "status": "completed",
      "document_id": "doc_456",
      "size_bytes": 2048,
      "processing_time_ms": 150
    },
    {
      "path": "docs/large_file.pdf", 
      "status": "failed",
      "error": "File size exceeds limit",
      "size_bytes": 104857600
    }
  ],
  "completion_time": "2025-01-15T10:28:45Z"
}
```

### Batch Create Honey Jars
```
POST /api/knowledge/honey-jars/batch
```

**Request**:
```json
{
  "jars": [
    {
      "name": "STING Documentation",
      "description": "Platform documentation and guides",
      "type": "public",
      "retention_policy": "permanent"
    },
    {
      "name": "API Reference", 
      "description": "Technical API documentation",
      "type": "public",
      "retention_policy": "permanent"
    }
  ]
}
```

**Response**:
```json
{
  "created": [
    {"id": "jar_123", "name": "STING Documentation"},
    {"id": "jar_124", "name": "API Reference"}
  ],
  "errors": []
}
```

## Retention Policy System

### Default Retention Policies
```yaml
retention_policies:
  permanent:
    description: "Never delete - suitable for documentation"
    days: null
    
  documentation: 
    description: "Long-term documentation storage"
    days: 1825  # 5 years
    
  standard:
    description: "Standard business documents"  
    days: 365   # 1 year
    
  temporary:
    description: "Temporary files and uploads"
    days: 30    # 1 month
    
  custom:
    description: "User-defined retention period"
    days: null  # Set per upload
```

### Retention Configuration
```json
{
  "retention": {
    "policy": "permanent|documentation|standard|temporary|custom",
    "custom_days": 90,
    "auto_delete": true,
    "warning_days": 30,
    "notify_before_deletion": true
  }
}
```

## Usage Examples

### Upload Documentation Directory
```python
import requests
import tarfile
import io

# Create tar archive of docs directory
tar_buffer = io.BytesIO()
with tarfile.open(fileobj=tar_buffer, mode='w:gz') as tar:
    tar.add('./docs', arcname='.')

# Upload to honey jar
response = requests.post(
    'http://localhost:8090/honey-jars/123/upload-directory',
    headers={'Authorization': 'Bearer <token>'},
    files={
        'directory': ('docs.tar.gz', tar_buffer.getvalue()),
        'options': (None, json.dumps({
            'recursive': True,
            'include_patterns': ['*.md', '*.pdf'],
            'retention_policy': 'permanent',
            'metadata': {'source': 'STING Documentation'}
        }))
    }
)
```

### Setup Script Integration
```bash
#!/bin/bash
# setup_default_knowledge.sh

echo "🍯 Setting up STING documentation honey jars..."

# Create honey jar for platform docs
JAR_ID=$(curl -s -X POST "http://localhost:8090/honey-jars" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -d '{"name":"STING Platform Docs","type":"public","retention_policy":"permanent"}' | \
  jq -r '.id')

# Upload docs directory
tar -czf /tmp/docs.tar.gz -C ./docs .
curl -X POST "http://localhost:8090/honey-jars/$JAR_ID/upload-directory" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -F "directory=@/tmp/docs.tar.gz" \
  -F 'options={"recursive":true,"include_patterns":["*.md"],"retention_policy":"permanent"}'

echo "✅ Documentation uploaded to honey jar: $JAR_ID"
```

## Security Considerations

### Authentication & Authorization
- **Bulk Uploads**: All bulk operations require authentication
- **Rate Limiting**: Stricter rate limits apply to bulk endpoints
- **Size Limits**: Configurable per-user and per-operation limits
- **File Validation**: Enhanced security scanning for bulk uploads

### Resource Management
- **Async Processing**: Prevents blocking on large uploads
- **Queue Management**: Fair scheduling across multiple users
- **Storage Quotas**: Per-user and per-jar storage limits enforced
- **Cleanup Jobs**: Automatic cleanup of failed or stale uploads

## Configuration

### Environment Variables
```bash
# Bulk upload settings
HONEY_JAR_BULK_MAX_FILES=1000
HONEY_JAR_BULK_MAX_SIZE_MB=1024
HONEY_JAR_BULK_TIMEOUT_MINUTES=60
HONEY_JAR_BULK_CONCURRENT_JOBS=5

# Retention settings
HONEY_JAR_DEFAULT_RETENTION_POLICY=standard
HONEY_JAR_ENABLE_AUTO_DELETE=true
HONEY_JAR_RETENTION_CHECK_INTERVAL=24h
```

## Key Features

- **Bulk Directory Upload**: Upload entire directories in a single API call
- **Flexible Retention**: Configurable retention policies, with permanent retention for documentation
- **Async Processing**: Non-blocking uploads for large file sets
- **Progress Tracking**: Real-time status updates and detailed progress reporting
- **Secure Operations**: Authentication required with rate limiting and resource management