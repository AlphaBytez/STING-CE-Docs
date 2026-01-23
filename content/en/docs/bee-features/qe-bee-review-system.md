---
title: "QE Bee Review System (Legacy)"
linkTitle: "QE Bee (Legacy)"
weight: 90
description: >
  Legacy output validation agent - replaced by ReviewBee unified quality assurance.
---

{{% pageinfo color="warning" %}}
**Deprecated:** QE Bee has been replaced by **[ReviewBee](../review-bee/)**, which provides unified quality assurance including requirements validation, PII safety, and content quality in a single system.

New deployments should use ReviewBee. Existing QE Bee configurations will continue to work but are no longer actively developed.
{{% /pageinfo %}}

# 🐝 QE Bee (Quality Engineering Bee) - Legacy

## Overview

QE Bee was STING-CE's original output validation agent, focused primarily on PII token detection and basic format validation.

## Migration to ReviewBee

ReviewBee is the successor to QE Bee, providing:

| Feature | QE Bee | ReviewBee |
|---------|--------|-----------|
| PII token detection | ✅ | ✅ |
| Format validation | ✅ | ✅ |
| Requirements checking | ❌ | ✅ |
| Critic-Revise regeneration | ❌ | ✅ |
| Structured task lists | ❌ | ✅ |
| Quality validation gate | ❌ | ✅ |

### Migration Steps

1. Enable ReviewBee in `config.yml`:
   ```yaml
   llm_service:
     review_bee:
       enabled: true
       mode: "critique_and_revise"
   ```

2. Disable QE Bee:
   ```yaml
   qe_bee:
     enabled: false
   ```

3. Update any webhook integrations to use ReviewBee events

See [ReviewBee documentation](../review-bee/) for full configuration options.

---

## Legacy Documentation

The original QE Bee documentation is preserved below for reference.

### Original Features

- **PII Token Detection** - Regex pattern: `\[PII_[A-Z_]+_[a-f0-9]+\]`
- **Completeness Validation** - Minimum content length checks
- **Format Validation** - Section and structure checks
- **Webhook Notifications** - Configurable per-user webhooks

### Original Configuration

```yaml
qe_bee:
  enabled: true
  llm_review_enabled: true
  model: "phi4"
  webhooks:
    enabled: true
    max_per_user: 5
```

### Original Environment Variables

```bash
QE_BEE_ENABLED=true
QE_BEE_LLM_ENABLED=true
QE_BEE_MODEL=phi4
QE_BEE_WEBHOOKS_ENABLED=true
```
