---
title: "First Steps with Nectar"
linkTitle: "First Steps"
weight: 3
description: >
  Your first 15 minutes with Nectar - creating Honey Jars, adding documents, and chatting with Bee.
---

# First Steps with Nectar

You've installed Nectar. Now let's put it to work! This guide takes about 15 minutes.

---

## Understanding the Interface

When you open Nectar, you'll see:

- **Sidebar** (left): Navigation to Honey Jars, Bee chat, Settings
- **Main Area** (center): Your current workspace
- **Status Bar** (bottom): AI status, sync status

---

## 1. Create Your First Honey Jar (2 min)

A **Honey Jar** is a secure container for your knowledge. Think of it as a smart folder that AI can search.

1. Click **+ New Honey Jar** in the sidebar
2. Give it a name (e.g., "Meeting Notes" or "Project Research")
3. Add a description (optional but helpful)
4. Click **Create**

{{% alert title="Tip" color="info" %}}
Start with one Honey Jar for testing. You can create unlimited Honey Jars.
{{% /alert %}}

---

## 2. Add Your First Documents (5 min)

Now let's give Bee something to learn from.

### Drag and Drop

1. Open your Honey Jar
2. Drag files from your computer into the main area
3. Wait for processing (you'll see a progress indicator)

### Supported File Types

| Type | Extensions |
|------|------------|
| Documents | `.pdf`, `.docx`, `.doc`, `.txt`, `.md` |
| Spreadsheets | `.xlsx`, `.xls`, `.csv` |
| Presentations | `.pptx`, `.ppt` |
| Web | `.html`, URLs |

### What Happens During Processing

1. **Text Extraction** - Nectar reads the content
2. **Chunking** - Content is split into searchable pieces
3. **Embedding** - AI creates searchable vectors
4. **Indexing** - Added to your Honey Jar's knowledge base

Processing time depends on file size and your computer's speed.

---

## 3. Chat with Bee (5 min)

Now the fun part - talking to your documents!

### Start a Conversation

1. Click **Bee** in the sidebar
2. Select which Honey Jar(s) to search
3. Ask a question about your documents

### Example Prompts

If you uploaded meeting notes:
> "What were the main decisions from last week's meeting?"

If you uploaded research:
> "Summarize the key findings about [topic]"

If you uploaded contracts:
> "What are the payment terms?"

### How Bee Works

1. **You ask** - Type your question
2. **Bee searches** - Finds relevant chunks in your Honey Jar
3. **AI answers** - Uses your documents + the AI model to respond
4. **Sources shown** - See which documents Bee used

{{% alert title="Privacy Note" color="success" %}}
Everything happens locally. Your questions and documents never leave your computer.
{{% /alert %}}

---

## 4. Try These Features

### Search Within a Honey Jar

1. Open a Honey Jar
2. Use the search bar at the top
3. Find documents by content, not just filename

### Ask Follow-up Questions

Bee remembers context within a conversation:
- "Tell me more about that"
- "What's the source for that claim?"
- "Explain it more simply"

### Switch AI Models

If you installed multiple models:
1. Go to **Settings → AI**
2. Change the default model
3. Or switch models per-conversation using the dropdown

---

## 5. Best Practices

### Organize Your Honey Jars

| Honey Jar | Use For |
|-----------|---------|
| Work Projects | Current project documents |
| Personal | Personal notes, ideas, journals |
| Research | Articles, papers, references |

### Write Better Prompts

**Too vague:**
> "Tell me about the project"

**Better:**
> "What are the deadlines mentioned in the project brief?"

**Best:**
> "Based on the project brief, what milestones are due in Q1, and who is responsible for each?"

### Keep Documents Updated

- Nectar doesn't auto-sync folders (yet)
- Re-upload documents when they change
- Or delete and re-add updated versions

---

## What's Next?

You've learned the basics! Here's where to go from here:

- **[Connect to STING Server](../connecting-to-sting-server/)** - Share knowledge with your team
- **[Advanced Features](../advanced/)** - Power user tips
- **[Keyboard Shortcuts](../shortcuts/)** - Work faster

---

## Quick Reference

| Action | How |
|--------|-----|
| New Honey Jar | Click **+** or `Cmd/Ctrl + N` |
| Add documents | Drag & drop or click **Add** |
| Chat with Bee | Click **Bee** in sidebar |
| Search | `Cmd/Ctrl + K` |
| Settings | Click gear icon or `Cmd/Ctrl + ,` |

---

## Need Help?

- **Something not working?** See [Troubleshooting](../troubleshooting/)
- **Have a question?** Check the [FAQ](/docs/faq/)
- **Found a bug?** [Report it on GitHub](https://github.com/AlphaBytez/Nectar/issues)
