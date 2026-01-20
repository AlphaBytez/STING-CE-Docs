---
title: "Reports API"
linkTitle: "Reports API"
weight: 25
description: >
  API documentation for report generation, templates, and queue management.
---

# Reports API Reference

The Reports API enables programmatic generation of long-form, AI-powered reports. Reports are processed asynchronously through a dedicated worker queue and exported as professionally formatted PDFs.

**Base URL:** `/api/reports`

## Authentication

All report endpoints require authentication via:
- **Session cookie** (`ory_kratos_session`)
- **API key** (`X-API-Key` header or `Authorization: Bearer` header)

Most endpoints require **AAL2** (second-factor authentication) for session-based access. API key access requires `admin` or `read` scope.

---

## Endpoints Overview

| Method | Endpoint | Description | Auth Level |
|--------|----------|-------------|------------|
| `GET` | `/templates` | List available report templates | AAL2 / API Key |
| `POST` | `/` | Create new report | AAL2 / API Key |
| `GET` | `/` | List user's reports | AAL2 / API Key |
| `GET` | `/{report_id}` | Get report details | AAL2 / API Key |
| `GET` | `/{report_id}/download` | Download report file | AAL2 / API Key |
| `POST` | `/{report_id}/cancel` | Cancel pending report | AAL2 / API Key |
| `POST` | `/{report_id}/retry` | Retry failed report | AAL2 / API Key |
| `GET` | `/queue/status` | Get queue status | Public |

---

## Report Templates

### List Templates

Get available report templates for the authenticated user.

```http
GET /api/reports/templates
```

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | string | Filter by category (optional) |

**Response:**

```json
{
  "success": true,
  "data": {
    "templates": [
      {
        "id": "cc030440-0005-470f-8341-6ec798d00445",
        "name": "Bee Conversational Report",
        "description": "AI-generated long-form analysis with web search context",
        "category": "analysis",
        "required_role": "user",
        "is_active": true,
        "output_formats": ["pdf", "md", "html"],
        "requires_scrambling": true,
        "max_output_tokens": 16384,
        "estimated_time_minutes": 15
      }
    ],
    "count": 1,
    "user_role": "user"
  }
}
```

**Template Categories:**

| Category | Description |
|----------|-------------|
| `analysis` | In-depth analysis and research reports |
| `system` | System health and performance reports |
| `security` | Security audits and compliance |
| `knowledge` | Knowledge base analytics |
| `compliance` | PII/data compliance reports |

---

## Creating Reports

### Create Report

Queue a new report for generation.

```http
POST /api/reports/
Content-Type: application/json
```

**Request Body:**

```json
{
  "template_id": "cc030440-0005-470f-8341-6ec798d00445",
  "title": "SCADA Security Best Practices Analysis",
  "description": "Comprehensive analysis of ICS/SCADA security frameworks",
  "priority": "normal",
  "parameters": {
    "user_query": "Provide a detailed 4500+ word analysis of SCADA/ICS security best practices, including NERC CIP compliance, network segmentation, and incident response.",
    "conversation_id": null,
    "generation_mode": "conversational",
    "context": {}
  },
  "output_format": "pdf",
  "honey_jar_id": null,
  "scrambling_enabled": true
}
```

**Request Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `template_id` | string | Yes | Report template UUID |
| `title` | string | Yes | Report title |
| `description` | string | No | Brief description |
| `priority` | string | No | `urgent`, `high`, `normal`, `low` (default: `normal`) |
| `parameters` | object | Yes | Template-specific parameters |
| `parameters.user_query` | string | Yes | The query/topic for the report |
| `parameters.conversation_id` | string | No | Link to existing conversation |
| `parameters.generation_mode` | string | No | `conversational` (default) |
| `output_format` | string | No | `pdf`, `md`, `html` (default: `pdf`) |
| `honey_jar_id` | string | No | Honey jar for RAG context |
| `scrambling_enabled` | boolean | No | Enable PII detection (default: `true`) |

**Response (201 Created):**

```json
{
  "success": true,
  "data": {
    "report": {
      "id": "991a8dca-b90c-406d-9a64-dcc9b1bec33c",
      "title": "SCADA Security Best Practices Analysis",
      "status": "queued",
      "priority": "normal",
      "created_at": "2026-01-20T15:30:00Z",
      "output_format": "pdf"
    },
    "queue_position": 2,
    "estimated_completion": "2026-01-20T15:45:00Z"
  }
}
```

### cURL Example

```bash
curl -X POST "https://your-sting.com/api/reports/" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: sk_your_api_key_here" \
  -d '{
    "template_id": "cc030440-0005-470f-8341-6ec798d00445",
    "title": "Security Analysis Report",
    "parameters": {
      "user_query": "Provide a comprehensive 5000+ word analysis of zero-trust architecture implementation for enterprise networks."
    },
    "output_format": "pdf"
  }'
```

### Python Example

```python
import requests

api_key = "sk_your_api_key_here"
base_url = "https://your-sting.com"

response = requests.post(
    f"{base_url}/api/reports/",
    headers={
        "Content-Type": "application/json",
        "X-API-Key": api_key
    },
    json={
        "template_id": "cc030440-0005-470f-8341-6ec798d00445",
        "title": "Zero Trust Architecture Analysis",
        "parameters": {
            "user_query": "Provide a detailed analysis of zero-trust security implementation..."
        },
        "output_format": "pdf",
        "priority": "high"
    }
)

data = response.json()
report_id = data["data"]["report"]["id"]
print(f"Report queued: {report_id}")
```

---

## Managing Reports

### List Reports

Get all reports for the authenticated user.

```http
GET /api/reports/
```

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | int | 50 | Max results (1-100) |
| `offset` | int | 0 | Pagination offset |
| `status` | string | - | Filter by status |
| `search` | string | - | Search in title/description |

**Response:**

```json
{
  "success": true,
  "data": {
    "reports": [
      {
        "id": "991a8dca-b90c-406d-9a64-dcc9b1bec33c",
        "title": "SCADA Security Analysis",
        "status": "completed",
        "created_at": "2026-01-20T15:30:00Z",
        "completed_at": "2026-01-20T15:42:00Z",
        "output_format": "pdf",
        "file_size_bytes": 2457600,
        "template_name": "Bee Conversational Report"
      }
    ],
    "pagination": {
      "total": 24,
      "limit": 50,
      "offset": 0
    }
  }
}
```

### Get Report Details

Get detailed information about a specific report.

```http
GET /api/reports/{report_id}
```

**Response:**

```json
{
  "success": true,
  "report": {
    "id": "991a8dca-b90c-406d-9a64-dcc9b1bec33c",
    "title": "SCADA Security Analysis",
    "description": "Comprehensive ICS/SCADA security analysis",
    "status": "completed",
    "progress_percentage": 100,
    "created_at": "2026-01-20T15:30:00Z",
    "completed_at": "2026-01-20T15:42:00Z",
    "output_format": "pdf",
    "file_size_bytes": 2457600,
    "result_file_id": "file-xyz-789",
    "download_url": "/api/reports/991a8dca-b90c-406d-9a64-dcc9b1bec33c/download",
    "parameters": {
      "user_query": "Provide a detailed analysis..."
    }
  }
}
```

### Download Report

Download a completed report file.

```http
GET /api/reports/{report_id}/download
```

**Response:** Binary file download (Content-Type based on output_format)

```bash
curl -X GET "https://your-sting.com/api/reports/{report_id}/download" \
  -H "X-API-Key: sk_your_api_key_here" \
  -o report.pdf
```

### Cancel Report

Cancel a pending or processing report.

```http
POST /api/reports/{report_id}/cancel
```

**Response:**

```json
{
  "success": true,
  "message": "Report cancelled successfully"
}
```

### Retry Failed Report

Retry generation of a failed report.

```http
POST /api/reports/{report_id}/retry
```

**Response:**

```json
{
  "success": true,
  "report_id": "991a8dca-b90c-406d-9a64-dcc9b1bec33c",
  "status": "queued",
  "message": "Report requeued for processing"
}
```

---

## Queue Status

### Get Queue Status (Public)

Get current report queue status. This endpoint does not require authentication.

```http
GET /api/reports/public/queue/status
```

**Response:**

```json
{
  "success": true,
  "data": {
    "queue_name": "default",
    "pending_reports": 3,
    "processing_reports": 1,
    "completed_today": 12,
    "failed_today": 0,
    "average_processing_time": "8.5 minutes",
    "estimated_wait_time": "25.5 minutes"
  }
}
```

---

## Report Status Values

| Status | Description |
|--------|-------------|
| `pending` | Report created, waiting to be queued |
| `queued` | In the processing queue |
| `processing` | Currently being generated |
| `completed` | Ready for download |
| `failed` | Generation failed (check error_message) |
| `cancelled` | Cancelled by user |

---

## Report Types & Templates

### Bee Conversational Report

The primary report template for AI-generated long-form content.

**Template ID:** `cc030440-0005-470f-8341-6ec798d00445`

**Supported Report Styles:**

| Style | Trigger Keywords | Description |
|-------|-----------------|-------------|
| **Use Case** | "how can", "implement", "deploy", "use case" | Practical implementation scenarios |
| **Comparison** | "compare", "versus", "vs", "difference" | Side-by-side analysis |
| **Summary** | "summarize", "overview", "brief" | Executive summaries |
| **Technical** | "technical", "architecture", "deep dive" | Detailed technical analysis |

Reports automatically detect the appropriate style based on query keywords.

---

## Polling for Completion

Reports are generated asynchronously. Use polling to check status:

```python
import time
import requests

def wait_for_report(report_id, api_key, timeout=1800):
    """Poll for report completion with smart intervals."""
    base_url = "https://your-sting.com"
    start = time.time()
    
    while time.time() - start < timeout:
        response = requests.get(
            f"{base_url}/api/reports/{report_id}",
            headers={"X-API-Key": api_key}
        )
        data = response.json()
        status = data["report"]["status"]
        
        if status == "completed":
            return data["report"]["download_url"]
        elif status == "failed":
            raise Exception(f"Report failed: {data['report'].get('error_message')}")
        
        # Smart polling: shorter intervals when processing
        interval = 3 if status == "processing" else 10
        time.sleep(interval)
    
    raise TimeoutError("Report generation timed out")
```

---

## Error Responses

### Common Errors

```json
{
  "success": false,
  "error": "Template not found or not available"
}
```

| HTTP Code | Error | Description |
|-----------|-------|-------------|
| 400 | `JSON data required` | Missing request body |
| 400 | `template_id and title are required` | Missing required fields |
| 401 | `Authentication required` | No valid session or API key |
| 403 | `Insufficient permissions` | User lacks access to template |
| 404 | `Template not found` | Invalid template_id |
| 404 | `Report not found` | Invalid report_id |
| 500 | `Failed to queue report` | Internal queue error |

---

## Rate Limits

| Operation | Limit | Window |
|-----------|-------|--------|
| Create Report | 10 | 1 hour |
| List Reports | 100 | 1 minute |
| Download | 50 | 1 minute |

---

## Best Practices

1. **Use webhooks for completion** (if available) instead of polling
2. **Set appropriate priority** - `urgent` for time-sensitive reports
3. **Enable PII scrambling** for sensitive topics
4. **Link to Honey Jars** for domain-specific context
5. **Monitor queue status** before submitting large batches
6. **Handle timeouts gracefully** - reports can take 5-25 minutes
