---
title: "AI & Bee Features"
linkTitle: "Bee Features"
weight: 30
description: >
  AI-powered assistance, chat, and intelligent agents in STING.
---

Explore STING's AI capabilities including the Bee chat assistant, conversation management, and intelligent automation.

## Feature Overview

- **Bee Chat** - Conversational AI assistant with knowledge base integration
- **Conversation Management** - Token-aware context with summarization
- **Model Modes** - Different AI modes for various use cases
- **ReviewBee** - Unified quality assurance (requirements + PII + quality)
- **Memory Architecture** - Intelligent context retention

## Quality Assurance

**ReviewBee** is STING's unified quality assurance system. It combines:

| Check | What It Does |
|-------|--------------|
| **Requirements** | Verifies output matches original user request |
| **PII Safety** | Ensures no sensitive data leaks through |
| **Quality** | Grammar, structure, completeness |
| **Regeneration** | Critic-Revise pattern for improvements |

> **Note:** ReviewBee replaces the legacy QE Bee system. See [ReviewBee documentation](review-bee/) for migration details.
