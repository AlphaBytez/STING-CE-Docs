---
title: "ReviewBee - Unified Quality Assurance"
linkTitle: "ReviewBee"
weight: 20
description: >
  STING's unified AI output quality assurance system - ensuring requirements fulfillment, PII safety, and professional quality.
---

# 🐝 ReviewBee - Unified Quality Assurance

## Overview

ReviewBee is STING's **unified quality assurance system** for all AI-generated content. It combines requirements validation, PII safety checks, and professional quality assurance into a single, streamlined reviewer.

**Core Philosophy:**
> "Compare the final output against the original ask, while ensuring safety and quality."

ReviewBee handles everything in one pass:
- ✅ **Requirements Fulfillment** - Does it answer what the user asked?
- ✅ **PII Safety** - Are all PII tokens properly resolved?
- ✅ **Content Quality** - Grammar, structure, completeness
- ✅ **Format Validation** - Proper sections, markdown, professional tone

**Why Unified?**
Previously, STING had separate systems (QE Bee for sanitization, other checks scattered). ReviewBee consolidates everything into one intelligent reviewer that runs once, checks everything, and provides actionable feedback.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     User Request                                │
│  "Generate a report about X with 3 use cases"                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Primary LLM Generation                        │
│              (phi-4-reasoning-plus, etc.)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🐝 ReviewBee                                 │
│                  (unified reviewer)                              │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 1. REQUIREMENTS CHECK                                    │   │
│  │    • Extract asks from original request                  │   │
│  │    • Compare output against requirements                 │   │
│  │    • Score fulfillment (YES/PARTIAL/NO)                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 2. PII SAFETY CHECK                                      │   │
│  │    • Detect unresolved [PII_*] tokens                    │   │
│  │    • Flag potential data leakage                         │   │
│  │    • Block if critical PII exposed                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 3. QUALITY CHECK                                         │   │
│  │    • Grammar and clarity                                 │   │
│  │    • Structure and formatting                            │   │
│  │    • Completeness (no truncation)                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4. GENERATE TASK LIST (if issues found)                  │   │
│  │    • Specific, actionable improvements                   │   │
│  │    • Prioritized by severity                             │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                    Overall Score < Threshold?
                              │
              ┌───────────────┴───────────────┐
              │ YES                           │ NO
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────┐
│   Regenerate with       │     │   Deliver to User       │
│   Task List Feedback    │     │   ✅                    │
└─────────────────────────┘     └─────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Quality Validation                            │
│  ✓ Revision ≥ 70% of original length                            │
│  ✓ No unexpected characters introduced                          │
│  ✓ Structure preserved                                          │
│  ✓ PII issues resolved                                          │
└─────────────────────────────────────────────────────────────────┘
              │
    Validation Passed? ───► NO ───► Keep Original
              │
              ▼ YES
       Use Revised Output
```

## Key Features

### 1. Requirements Extraction & Validation

ReviewBee extracts what the user actually asked for:

| Requirement Type | Examples |
|-----------------|----------|
| **Word count** | "at least 1000 words", "brief summary" |
| **Sections** | "include executive summary", "add architecture" |
| **Specific asks** | "3 use cases", "HIPAA compliance" |
| **Questions** | Any explicit questions that need answers |

### 2. PII Safety Checks

Ensures no sensitive data leaks through:

```
✓ Detect unresolved [PII_NAME_xyz] tokens
✓ Flag partial deserialization
✓ Block delivery if critical PII exposed
✓ Report exact token locations
```

### 3. Structured Task List

When issues are found, ReviewBee generates specific tasks:

```
**Your task list:**
  1. Add the requested deployment architecture section
  2. Resolve 2 unresolved PII tokens in paragraph 3
  3. Expand the third use case with more technical detail
```

### 4. Quality Validation Gate

Before accepting ANY revision, validates it's actually an improvement:

| Check | Threshold | Purpose |
|-------|-----------|---------|
| Length ratio | ≥ 70% | Prevent content loss |
| Unexpected chars | < original + 5 | Catch encoding issues |
| Header count | ≥ 50% | Preserve structure |
| PII tokens | = 0 | Ensure safety |

### 5. Security by Design

- **All data is ephemeral** — dies with the request
- **No Redis/persistence** — nothing stored
- **PII-aware** — understands token format
- **Logs sanitized** — no sensitive data in logs

## Configuration

```yaml
llm_service:
  review_bee:
    # Master toggle
    enabled: true
    
    # Mode: critique_only | critique_and_revise
    mode: "critique_and_revise"
    
    # Score threshold (0.0-1.0)
    revision_threshold: 0.75
    
    # Critic model (lightweight)
    critic:
      model: "phi4"
    
    # Safety settings
    safety:
      block_on_pii_leak: true
      max_unresolved_tokens: 0
    
    # Quality thresholds
    quality_validation:
      min_length_ratio: 0.7
      min_structure_ratio: 0.5
```

### Environment Variables

```bash
REVIEW_BEE_ENABLED=true
REVIEW_BEE_MODE=critique_and_revise
REVIEW_BEE_THRESHOLD=0.75
REVIEW_BEE_CRITIC_MODEL=phi4
REVIEW_BEE_BLOCK_ON_PII=true
```

## API Response

```json
{
  "response": "...",
  "review_bee": {
    "enabled": true,
    "critic_model": "phi4",
    "mode": "critique_and_revise",
    "critique_score": 0.75,
    "requirements_met": "PARTIAL",
    "pii_check": {
      "passed": true,
      "unresolved_tokens": 0
    },
    "gaps_count": 2,
    "task_list_count": 3,
    "revision_applied": true,
    "quality_metrics": {
      "length_ratio": 1.38,
      "unexpected_chars": 0,
      "original_headers": 12,
      "revised_headers": 20
    }
  }
}
```

## Migration from QE Bee

ReviewBee **replaces** the previous QE Bee system. Key differences:

| Feature | QE Bee (Legacy) | ReviewBee (Unified) |
|---------|-----------------|---------------------|
| Focus | PII sanitization only | Full quality assurance |
| Requirements check | ❌ | ✅ |
| PII detection | ✅ | ✅ |
| Content quality | Basic | Comprehensive |
| Regeneration | ❌ Flag only | ✅ Critic-Revise |
| Task lists | ❌ | ✅ Actionable tasks |
| Webhooks | ✅ | ✅ (coming soon) |

**For existing QE Bee users:** ReviewBee is a superset — it does everything QE Bee did plus more. Simply enable ReviewBee and disable QE Bee.

## Best Practices

### When to Enable

✅ **Always enable for:**
- Production report generation
- User-facing content
- Any output that leaves the system

⚠️ **Consider critique_only mode for:**
- Development/testing
- High-volume, low-stakes content

### Threshold Tuning

| Threshold | Behavior |
|-----------|----------|
| `0.9` | Very strict — most outputs revised |
| `0.75` | Balanced — catches clear issues ✅ |
| `0.6` | Lenient — only major problems |

---

## 🚀 Future Roadmap

### Custom ReviewBees

Specialized reviewers for different domains:

- **ComplianceBee** — HIPAA, SOC2, GDPR checking
- **TechnicalBee** — Code review and accuracy
- **ToneBee** — Brand voice consistency
- **FactBee** — Citation verification

### Cloud Orchestration

Harness cloud for heavy loads with local AI orchestration:

```
Local Orchestrator (always-on, lightweight)
    ├── Local GPU (fast, private)
    ├── Cloud API (powerful, scalable) 
    └── Edge Node (private, secure)
```

**Benefits:**
- Local AI handles orchestration and sensitive decisions
- Cloud bursts for heavy generation
- Only anonymized content leaves appliance
- Cost-effective scaling

### Webhook Notifications

Real-time alerts when ReviewBee takes action:
- Review completion events
- Revision applied/rejected
- PII safety blocks
- Configurable filters

---

*ReviewBee is STING's commitment to quality — one unified reviewer for all AI outputs.*
