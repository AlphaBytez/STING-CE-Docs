---
title: "Report Generation"
linkTitle: "Report Generation"
weight: 40
description: >
  How Bee generates comprehensive long-form reports with AI-powered analysis.
---

# Bee Report Generation

Bee can automatically generate comprehensive, professionally formatted reports when users request in-depth analysis. Reports are processed asynchronously, allowing users to continue working while Bee researches and writes.

## Overview

When you ask Bee for detailed analysis (typically **1,500+ words** or ~2,000 tokens), the system automatically:

1. **Detects the request** - AI classifies your query as needing a full report
2. **Queues generation** - Creates a background job for the report worker
3. **Researches the topic** - Uses web search and Honey Jar context
4. **Generates content** - Produces comprehensive, well-structured analysis
5. **Exports as PDF** - Creates a beautifully formatted document
6. **Notifies you** - Report appears in your Reports dashboard

## Classification Threshold

The system uses **2,000 tokens** (~1,500 words) as the threshold:

- **< 2,000 tokens** → Handled as inline chat response
- **≥ 2,000 tokens** → Queued as background report

## When to Use Reports

### ✅ Good Candidates for Reports

- **Comprehensive analysis** - "Provide a detailed analysis of zero-trust architecture"
- **Research documents** - "Write a report on emerging cybersecurity threats"
- **Compliance guides** - "Create a comprehensive HIPAA compliance checklist"
- **Technical deep-dives** - "Explain microservices patterns with implementation examples"
- **Business cases** - "Develop a business case for adopting AI-powered security"

### ❌ Better as Chat Responses

- Quick questions - "What is STING?"
- Lists or summaries - "List the main features"
- How-to guides - "How do I create a Honey Jar?"
- Simple explanations - "Explain what PII means"

## Triggering Report Generation

### Automatic Detection

Bee classifies requests based on keywords that indicate expected length:

| Indicator | Token Estimate | Description |
|-----------|----------------|-------------|
| `comprehensive` | 2,000 | Full coverage expected |
| `report` | 2,500 | Report format |
| `in-depth` | 1,800 | Deep analysis |
| `detailed` | 1,500 | Detailed content |
| `thorough` | 1,500 | Complete examination |
| `essay` | 2,000 | Essay format |
| `document` | 2,000 | Document format |

**Explicit word counts** also trigger reports:
- "Write a 2000 word analysis..."
- "Give me a 1500-word report..."

### Example Prompts

**These will trigger report generation:**

```
"Provide a comprehensive analysis of SCADA/ICS security best practices, 
including NERC CIP compliance and network segmentation strategies."
```

```
"Write a detailed report on implementing zero-trust architecture 
in enterprise environments, with case studies and ROI analysis."
```

```
"Create a thorough technical breakdown of AI-powered threat detection 
systems with implementation examples."
```

### Manual Trigger

You can also force report generation by saying:
- "Generate this as a report"
- "Create a PDF document for this"
- "Queue this as a long-form analysis"

## Report Types

Bee automatically selects the appropriate report style based on your query:

### Use Case Report

**Triggered by:** "how can", "implement", "deploy", "use case"

Focuses on practical implementation scenarios with:
- Real-world applications
- Step-by-step implementation guides
- Industry-specific examples
- Best practices and pitfalls

### Comparison Report

**Triggered by:** "compare", "versus", "vs", "difference"

Side-by-side analysis including:
- Feature comparisons
- Pros and cons tables
- Decision frameworks
- Recommendations

### Summary Report

**Triggered by:** "summarize", "overview", "brief"

Executive-level summaries with:
- Key findings
- High-level recommendations
- Quick reference sections
- Action items

### Technical Report

**Triggered by:** "technical", "architecture", "deep dive"

Detailed technical analysis with:
- Architecture diagrams
- Code examples
- Implementation details
- Performance considerations

## The Generation Process

```
┌─────────────────────────────────────────────────────────────┐
│                    User Request                              │
│  "Provide a detailed analysis on..."                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                 AI Classification                            │
│  • Analyzes query for report indicators                     │
│  • Estimates output length (tokens)                         │
│  • Determines report type (use_case, comparison, etc.)      │
└─────────────────────┬───────────────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          │  < 2,000 tokens?      │
          └───────────┬───────────┘
                      │
         YES ←────────┴────────→ NO
          │                       │
          ▼                       ▼
   ┌──────────────┐    ┌──────────────────────┐
   │ Chat Response│    │ Queue Report Job     │
   │ (immediate)  │    │ (background worker)  │
   └──────────────┘    └──────────┬───────────┘
                                  │
                                  ▼
                       ┌──────────────────────┐
                       │ Report Worker        │
                       │ • Web search context │
                       │ • Honey Jar RAG      │
                       │ • LLM generation     │
                       │ • PDF export         │
                       └──────────────────────┘
```

## Timeline

| Phase | Typical Duration |
|-------|------------------|
| Queue time | < 5 seconds |
| Research & web search | 30-60 seconds |
| Content generation | 3-15 minutes |
| PDF conversion | 15-30 seconds |
| **Total** | **4-20 minutes** |

Generation time depends on:
- Report length requested
- Topic complexity
- Current queue depth
- LLM provider speed

## Web Search Enhancement

When web search is enabled, Bee enriches reports with:

- **Current information** - Latest news, updates, and trends
- **External sources** - Citations and references
- **Broader context** - Industry perspectives beyond your knowledge base

See [Web Search Integration](../web-search/) for configuration details.

## Honey Jar Integration

Reports can leverage your Honey Jars for domain-specific context:

1. **Specify a Honey Jar** when creating the report
2. **RAG retrieval** finds relevant documents
3. **Context injection** adds your knowledge to the prompt
4. **Citation** includes references to your documents

This creates reports that combine:
- 🌐 Web research (current external information)
- 📚 Your knowledge base (domain expertise)
- 🤖 AI analysis (synthesis and recommendations)

## Viewing Reports

### Reports Dashboard

Access your reports at `/reports`:

```
┌─────────────────────────────────────────────────────────────┐
│ 📄 Securing Power Grid SCADA/ICS with STING-CE             │
│                                                             │
│ Status: ✅ Completed                                        │
│ Generated: 12 minutes ago                                   │
│ Size: 2.4 MB (4,200 words)                                 │
│                                                             │
│ [📥 Download PDF]  [🗑️ Delete]                              │
└─────────────────────────────────────────────────────────────┘
```

### Report States

| Status | Icon | Description |
|--------|------|-------------|
| **Queued** | ⏳ | Waiting in queue |
| **Processing** | 🔄 | Currently generating |
| **Completed** | ✅ | Ready to download |
| **Failed** | ❌ | Generation error |

## Output Formats

| Format | Extension | Best For |
|--------|-----------|----------|
| **PDF** | `.pdf` | Sharing, printing, archiving |
| **Markdown** | `.md` | Further editing, version control |
| **HTML** | `.html` | Web publishing |

## Best Practices

### Writing Effective Prompts

✅ **Do:**
- Use trigger words ("comprehensive", "detailed", "in-depth")
- Include specific topics to cover
- Mention the intended audience
- Request specific sections or structure

❌ **Don't:**
- Be vague ("tell me about security")
- Request unrealistic lengths
- Expect real-time response for reports

### Example: Well-Structured Request

```
"Generate a comprehensive report on implementing zero-trust 
architecture for a mid-sized financial services company.

Include:
1. Executive summary for C-suite
2. Technical architecture overview
3. Implementation phases and timeline
4. Vendor comparison (Microsoft, Zscaler, Cloudflare)
5. Compliance considerations (SOX, PCI-DSS)
6. ROI analysis and cost projections

Target audience: IT leadership and security teams."
```

## PII Protection

Reports automatically:
- **Detect PII** in generated content
- **Scramble sensitive data** (configurable)
- **Audit log** PII handling decisions

Enable/disable via `scrambling_enabled` parameter.

## Troubleshooting

### Report Stuck in "Processing"

1. Check queue status at `/reports`
2. Reports typically complete in 4-20 minutes
3. Complex topics may take longer
4. Check system logs if exceeding 30 minutes

### Report Failed

Common causes:
- LLM provider timeout
- Insufficient context for topic
- Rate limiting on web search

**Solution:** Click "Retry" to requeue the report.

### Chat Response Instead of Report

If Bee responds inline instead of queuing a report:
- Add length indicators: "comprehensive", "detailed", "in-depth"
- Explicitly request: "Generate this as a report"
- Specify word count: "Write a 2000 word analysis..."

## API Access

Reports can also be created programmatically. See the [Reports API Reference](../../api/reports-api/) for:
- Creating reports via API
- Polling for completion
- Downloading results

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `REPORT_WORKER_CONCURRENCY` | `2` | Parallel report workers |
| `REPORT_MAX_TOKENS` | `16384` | Maximum output tokens |
| `REPORT_TIMEOUT_SECONDS` | `1800` | Generation timeout (30 min) |
| `REPORT_RETENTION_DAYS` | `30` | Auto-delete after N days |
