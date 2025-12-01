---
title: "QE Bee Review System"
linkTitle: "QE Bee Review System"
weight: 20
description: >
  Automated output validation agent that reviews AI-generated content before delivery.
---

# 🐝 QE Bee (Quality Engineering Bee)

## Overview

QE Bee is STING-CE's automated output validation agent. It acts as a quality gate, reviewing all AI-generated content before delivery to users. This ensures outputs are complete, properly sanitized, and meet quality standards.

**Key Value Proposition:**
- Catches incomplete PII deserialization before users see raw tokens
- Validates output completeness and format
- Optional LLM-powered quality assessment
- Webhook notifications for integration with external systems

## Key Features

### 1. **PII Token Detection**
- Automatically detects unresolved `[PII_*]` tokens in outputs
- Regex pattern: `\[PII_[A-Z_]+_[a-f0-9]+\]`
- 100% confidence scoring for detected tokens
- Reports exact token locations and counts.

### 2. **Completeness Validation**
- Checks minimum content length (500 chars for reports, 50 for messages)
- Detects truncation indicators (ellipsis, mid-sentence endings)
- Identifies empty or near-empty responses.

### 3. **Format Validation**
- Verifies reports have expected sections (summary, conclusion, etc.)
- Checks for proper markdown structure
- Validates document organization.

### 4. **LLM Quality Review (Optional)**
- AI-powered content coherence assessment
- Uses fast models (phi4 recommended)
- Scores content 1-10 with pass/fail determination
- Configurable timeout and enablement.

### 5. **Webhook Notifications**
- Real-time alerts on review completion
- Configurable per-user webhooks (up to 5 in CE edition)
- Filter by target type, result codes, or event types
- JSON payload with full review details.

## Configuration

### Environment Variables

```bash
# Enable/disable QE Bee
QE_BEE_ENABLED=true

# LLM model for quality reviews (fast model recommended)
QE_BEE_MODEL=phi4

# Enable LLM-powered quality checks
QE_BEE_LLM_ENABLED=true

# Review timeout in seconds
QE_BEE_TIMEOUT=30

# Worker poll interval in seconds
QE_BEE_POLL_INTERVAL=5
```

### Configuration in config.yml

```yaml
ai:
  qe_bee:
    enabled: true
    model: "phi4"
    llm_enabled: true
    timeout: 30
    poll_interval: 5
    webhooks:
      enabled: true
      max_per_user: 5
```

## Review Types

| Review Type | Description | Checks Performed |
|------------|-------------|------------------|
| `output_validation` | Standard output review | PII, completeness, format |
| `pii_check` | PII-focused review | PII tokens only |
| `quality_check` | Quality assessment | LLM-powered content review |
| `format_validation` | Structure check | Section presence, markdown |
| `compliance_check` | Compliance review | Reserved for Enterprise |

## Result Codes

### Pass Codes
| Code | Description |
|------|-------------|
| `PASS` | All checks passed |
| `PASS_WITH_WARNINGS` | Passed with minor issues noted |

### Fail Codes - PII Related
| Code | Description |
|------|-------------|
| `PII_TOKENS_REMAINING` | Found unresolved `[PII_*]` tokens |
| `PII_DESERIALIZATION_INCOMPLETE` | PII restore failed |

### Fail Codes - Output Related
| Code | Description |
|------|-------------|
| `OUTPUT_TRUNCATED` | Content appears cut off |
| `OUTPUT_EMPTY` | Content is empty or too short |
| `OUTPUT_MALFORMED` | Invalid structure |

### Fail Codes - Quality Related
| Code | Description |
|------|-------------|
| `QUALITY_LOW` | LLM assessment score < 5/10 |
| `CONTENT_INCOHERENT` | Content lacks coherence |

## API Endpoints

### User Endpoints

```bash
# Get review statistics
GET /api/qe-bee/stats

# Response:
{
  "total_reviews": 150,
  "passed": 140,
  "passed_with_warnings": 5,
  "failed": 5,
  "pending": 2,
  "pass_rate": 96.7
}
```

```bash
# Get review history
GET /api/qe-bee/history?limit=20

# Response:
{
  "reviews": [
    {
      "id": "uuid",
      "target_type": "report",
      "result_code": "PASS",
      "confidence_score": 95,
      "created_at": "2025-11-21T23:24:20Z"
    }
  ]
}
```

### Webhook Management

```bash
# Create webhook
POST /api/qe-bee/webhooks
Content-Type: application/json

{
  "name": "Slack Notifications",
  "url": "https://hooks.slack.com/...",
  "target_types": ["report"],
  "result_codes": ["PII_TOKENS_REMAINING", "OUTPUT_EMPTY"]
}
```

```bash
# Test webhook
POST /api/qe-bee/webhooks/{id}/test

# Response:
{
  "status_code": 200,
  "verified": true,
  "message": "Test webhook sent successfully"
}
```

## Webhook Payload

When a review completes, webhooks receive this payload:

```json
{
  "event": "review.completed",
  "review_id": "fd82c0c4-e5dd-43a6-81b5-b87d2a5f944e",
  "target_type": "report",
  "target_id": "report-uuid",
  "result": {
    "passed": true,
    "code": "PASS",
    "message": "All checks passed",
    "confidence": 95
  },
  "timestamp": "2025-11-21T23:24:20.538Z",
  "user_id": "user-uuid"
}
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         STING-CE Platform                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐    ┌──────────────────┐    ┌──────────────────┐  │
│  │ Report Worker │───▶│   Review Queue   │◀───│  QE Bee Worker   │  │
│  │   (Reports)   │    │   (PostgreSQL)   │    │   (Validator)    │  │
│  └──────────────┘    └──────────────────┘    └──────────────────┘  │
│         │                     │                       │             │
│         ▼                     ▼                       ▼             │
│  ┌──────────────┐    ┌──────────────────┐    ┌──────────────────┐  │
│  │  Bee Chatbot │    │  Review History  │    │  External AI     │  │
│  │  (Messages)  │    │    (Audit Log)   │    │  (phi4 model)    │  │
│  └──────────────┘    └──────────────────┘    └──────────────────┘  │
│                              │                                      │
│                              ▼                                      │
│                      ┌──────────────────┐                          │
│                      │ Webhook Delivery │                          │
│                      │  (Notifications) │                          │
│                      └──────────────────┘                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Review Flow

1. **Content Generated** - Report worker completes a report
2. **Auto-queued** - Report automatically queued for QE Bee review
3. **Worker Claims Job** - QE Bee worker picks up the review
4. **Validation Checks** - PII, completeness, format, LLM quality
5. **Result Stored** - Result saved to review_queue and review_history
6. **Webhook Sent** - Configured webhooks notified

## Database Schema

### review_queue Table

```sql
CREATE TABLE review_queue (
    id UUID PRIMARY KEY,
    target_type review_target_type NOT NULL,  -- report, message, document
    target_id VARCHAR(100) NOT NULL,
    review_type review_type NOT NULL,
    priority INTEGER DEFAULT 5,               -- 1=highest, 10=lowest
    status review_status NOT NULL,            -- pending, reviewing, passed, failed
    result_code review_result_code,
    result_message TEXT,
    confidence_score INTEGER,                 -- 0-100
    review_details JSONB,
    webhook_url VARCHAR(500),
    worker_id VARCHAR(100),
    created_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);
```

### review_history Table

Audit trail of all completed reviews for analytics and compliance.

### webhook_configs Table

User-configured webhook endpoints with filtering options.

## CE vs Enterprise

| Feature | CE Edition | Enterprise |
|---------|-----------|------------|
| PII Token Detection | Yes | Yes |
| Completeness Check | Yes | Yes |
| Format Validation | Yes | Yes |
| LLM Quality Review | Yes | Yes |
| Local Webhooks | 5 max | Unlimited |
| External Integrations | No | Slack, Teams, etc. |
| Custom QA Agents | No | Yes |
| Review Dashboard | Basic | Enhanced |

## Troubleshooting

### Reviews Not Processing

1. Check QE Bee worker is running:
   ```bash
   docker ps | grep qe-bee
   ```

2. Check worker logs:
   ```bash
   docker logs sting-ce-qe-bee-worker
   ```

3. Verify database tables exist:
   ```bash
   docker exec sting-ce-db psql -U postgres -d sting_app \
     -c "SELECT COUNT(*) FROM review_queue;"
   ```

### High Failure Rate

1. Check for PII deserialization issues in Bee/HiveScrambler
2. Review LLM model availability (phi4)
3. Check content generation quality in report worker

### Webhook Delivery Failures

1. Verify webhook URL is reachable from container network
2. Check webhook endpoint returns 2xx status
3. Review `webhook_configs.last_error` for details

## Related Documentation

- [Bee Conversation Management](/docs/bee-features/bee-conversation-management/)
- [Bee Chat Messaging Architecture](/docs/bee-features/bee-chat-messaging-architecture/)
- [PII Detection System](/docs/features/pii-detection/)

---

🐝 Quality assurance, the STING way!
