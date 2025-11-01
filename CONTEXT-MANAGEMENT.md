# Context Management & Semantic Search

This document explains how context is managed for fiction writing using a hybrid approach: human-readable markdown storage with LLM-efficient vector search.

## The Core Problem

Fiction writers need two things:
1. **Human-readable files** - Stories in markdown, version-controlled, editable
2. **LLM-efficient retrieval** - Fast semantic search without reading all files

Traditional approaches fail:
- ❌ Reading all 50 scenes = 100k+ tokens
- ❌ Grep search = exact matches only, misses semantic meaning
- ❌ Claude forgets context after compaction

## The Solution: Hybrid Architecture

### Storage Layer (Git-Tracked, Human-Readable)

```
project/
├── scenes/
│   ├── scene-001.md       # Your story
│   ├── drafts/            # Experimental scenes
│   └── archive/           # Deleted but kept
├── codex/
│   ├── characters.md
│   ├── locations.md
│   └── worldbuilding.md
├── notes/
│   ├── session-interactions/  # Session conversations (DevRag indexed)
│   ├── decisions.md           # Plot decisions
│   └── session-log.json       # Session stats
└── project.json
```

**All markdown = source of truth**
- Readable by humans
- Version controlled with git
- Editable in any text editor
- No vendor lock-in

### Index Layer (Gitignored, Regenerable)

```
.devrag/
└── vectors.db           # Vector embeddings (sqlite-vec)
```

**.devrag/ is derivative**
- Can be deleted and rebuilt anytime
- Not tracked in git (.gitignored)
- Generated from markdown files
- LLM-optimized for fast retrieval

## How DevRag Works

### 1. Automatic Indexing

When you write:
```bash
/new-scene
# Write scene about villain's backstory
```

DevRag automatically:
1. Detects new `scene-025.md`
2. Chunks the text (500 chars default)
3. Generates embeddings
4. Stores in `.devrag/vectors.db`

**No manual commands needed!**

### 2. Semantic Search

When Claude needs context:

**Traditional approach (slow):**
```
Claude reads scene-001.md (2k tokens)
Claude reads scene-002.md (2k tokens)
...
Claude reads scene-050.md (2k tokens)
Total: 100k tokens, 25 seconds
```

**DevRag approach (fast):**
```
1. Claude asks: "villain backstory"
2. DevRag searches vectors (100ms)
3. Returns: scene-024.md is most relevant
4. Claude reads only scene-024.md (2k tokens)
Total: 2k tokens, 100ms
```

**Result: 50x fewer tokens, 250x faster**

### 3. MCP Integration

DevRag is an MCP server. Claude can call it directly:

```
You: "Where did I describe the magic system limits?"

Claude internally:
[Calls mcp__devrag__search("magic system limits")]
[Gets: scenes/scene-012.md, codex/worldbuilding.md]
[Reads those 2 files]

Claude: "In scene 12 you established stamina drain,
         and in codex/worldbuilding.md you noted the
         three-spell limit."
```

**Seamless - no manual search commands!**

## The Four-Layer Context System

### Layer 1: DevRag (Semantic Search)

**What it does:**
- Vector search across all markdown
- Finds semantically similar content
- 40x fewer tokens
- 260x faster

**Files indexed:**
- scenes/*.md
- codex/*.md
- notes/*.md
- notes/session-interactions/*.md
- brainstorms/*.md
- summaries/*.md

**MCP Tools:**
- `search` - Semantic search
- `index_markdown` - Index specific file
- `list_documents` - View indexed files
- `delete_document` - Remove from index
- `reindex_document` - Update index

### Layer 2: Session Tracking & Interaction Logging

**What it does:**
- Tracks time spent writing
- Counts words per session
- Monitors streaks and goals
- **Auto-logs all user interactions** (commands, questions, discussions)
- Captures creative decisions and brainstorming
- Git commits work

**Stats Files:**
- `notes/current-session.json` - Active session tracking
- `notes/session-log.json` - Historical session stats

**Interaction Logs** (DevRag indexed):
- `notes/session-interactions/session-YYYYMMDD-HHMMSS.md`
- Captures every user command and question during active sessions
- Includes session summary (duration, words, activities)
- Searchable via DevRag: "What did I decide about the ending last Tuesday?"

**How it works:**
1. `/session start` → Begins logging interactions
2. `UserPromptSubmit` hook → Captures each user message
3. Appends to session markdown file with timestamps
4. `/session end` → Finalizes with session summary
5. DevRag indexes → Session becomes searchable

**Commands:**
- `/session start` - Begin tracking
- `/session end` - Save stats + git commit/push
- `/session status` - Check progress
- `/session log` - View history

### Layer 3: Codex (World Bible)

**What it does:**
- Persistent worldbuilding reference
- Character details, locations, lore
- Searchable via DevRag
- Copyable for series

**Structure:**
```
codex/
├── characters.md
├── locations.md
├── timeline.md
├── worldbuilding.md
└── lore.md
```

**Commands:**
- `/codex search villain`
- `/codex add character Devika`
- `/codex update location Jade Dragon`

### Layer 4: Project Files (Ground Truth)

**What it does:**
- Actual story text
- Summaries (reverse outlines)
- Cycle logs
- Reorder history

**Key files:**
- `scenes/scene-*.md`
- `summaries/*.md`
- `notes/cycles.md`
- `notes/reorders.md`
- `notes/decisions.md` (new!)

## Human-Readable vs LLM-Readable

### Principle: Source of Truth is Markdown

**Markdown files are canonical:**
```markdown
# scenes/scene-024.md

Marcus found the letter in his partner's desk. The
handwriting was unmistakable—the same person who'd
sent the warnings. His hands shook as he read the
final line: "The truth died with him."
```

**Vector DB is derivative:**
```
Vector embedding of chunk:
[0.123, -0.456, 0.789, ...] (384 dimensions)
Stored in .devrag/vectors.db
```

**If vector DB is lost/corrupted:**
```bash
# Just rebuild from markdown!
rm -rf .devrag/
devrag --config .devrag-config.json
```

### Benefits of This Approach

**For You (Human):**
- ✅ Read/edit files normally
- ✅ Git tracks all changes
- ✅ Use any text editor
- ✅ No vendor lock-in
- ✅ Search with grep still works

**For Claude (LLM):**
- ✅ Semantic search finds relevant scenes
- ✅ Massively reduced token usage
- ✅ Fast retrieval (100ms vs 25s)
- ✅ Can answer "where did I..." questions

## Out-of-Order Writing Workflow

### Problem: Discovery Writing Isn't Linear

You might:
- Write scene 40 before scene 20
- Try multiple versions of an ending
- Write experiments you might throw away

### Solution: Drafts & Archive

```
scenes/
├── scene-001.md       # Active scenes (in manuscript)
├── scene-002.md
├── drafts/
│   ├── alternate-ending-v1.md
│   ├── flashback-experiment.md
│   └── villain-backstory-dark.md
└── archive/
    └── scene-015-deleted.md
```

**Commands (coming soon):**
- `/new-scene --draft` - Create in drafts/
- `/scenes promote draft-name` - Move to active
- `/scenes archive 15` - Archive a scene
- `/scenes list --drafts` - Show drafts

**DevRag configuration:**
```json
{
  "include_patterns": [
    "scenes/*.md",       // Active scenes only
    "codex/*.md",
    "notes/decisions.md"
  ],
  "exclude_patterns": [
    "scenes/drafts/*",   // Exclude drafts
    "scenes/archive/*"   // Exclude archive
  ]
}
```

## Decision Tracking

### notes/decisions.md

Track major plot/story decisions:

```markdown
# Story Decisions

## 2025-01-01 - Villain Motivation
Changed from pure evil to sympathetic tragic figure.

**Affected scenes:** 18, 24
**Reasoning:** Needed emotional depth, noir genre fits moral ambiguity
**Context:** After writing confrontation, realized flat villain weakened story

## 2025-01-02 - Ending Style
Changed from happy to ambiguous.

**Affected scenes:** 48-50
**Reasoning:** Aligns with noir tone, leaves reader questioning
**Context:** Beta reader feedback suggested resolution too neat
```

**Searchable via DevRag:**
```
You: "Why did we make the villain sympathetic?"

Claude: [DevRag searches decisions.md]
"On 2025-01-01, we changed the villain to sympathetic
 because you needed emotional depth..."
```

## Setup Guide

### New Projects

When running `/new-project`, it will:
1. Create project structure
2. Generate `.devrag-config.json`
3. Add `.devrag/` to `.gitignore`
4. Create `notes/decisions.md` template

### Existing Projects

To add DevRag to existing projects:

```bash
cd ~/writing/existing-project

# 1. Create DevRag config
cat > .devrag-config.json << 'EOF'
{
  "documents_dir": "./",
  "db_path": "./.devrag/vectors.db",
  "chunk_size": 500,
  "search_top_k": 5,
  "include_patterns": [
    "scenes/*.md",
    "codex/*.md",
    "notes/*.md"
  ],
  "exclude_patterns": [
    "scenes/archive/*",
    "manuscript/*",
    ".devrag/*"
  ]
}
EOF

# 2. Add to .gitignore
echo ".devrag/" >> .gitignore

# 3. Initial index
devrag --config .devrag-config.json

# Done! DevRag now indexes your project
```

## Configuration Examples

### Minimal (Default)
```json
{
  "documents_dir": "./",
  "db_path": "./.devrag/vectors.db",
  "chunk_size": 500,
  "search_top_k": 5
}
```

### With Patterns (Recommended)
```json
{
  "documents_dir": "./",
  "db_path": "./.devrag/vectors.db",
  "chunk_size": 500,
  "search_top_k": 5,
  "include_patterns": [
    "scenes/*.md",
    "codex/*.md",
    "notes/decisions.md"
  ],
  "exclude_patterns": [
    "scenes/drafts/*",
    "scenes/archive/*",
    "manuscript/*"
  ]
}
```

### CPU Mode (Lower Memory)
```json
{
  "documents_dir": "./",
  "db_path": "./.devrag/vectors.db",
  "chunk_size": 500,
  "search_top_k": 5,
  "compute": {
    "device": "cpu",
    "fallback_to_cpu": true
  }
}
```

## Example Workflows

### Continuity Checking

```
You: "Did I ever mention how the magic system drains stamina?"

Claude: [DevRag search]
"Yes, in scene 12 you wrote: 'Each spell drained him,
 leaving his limbs heavy.' And in codex/worldbuilding.md
 you documented the stamina drain mechanic."
```

### Finding Similar Scenes

```
You: "Show me all scenes where characters feel betrayed"

Claude: [Semantic search via DevRag]
"Found semantic matches in scenes 8, 15, 23, and 31.
 Let me read those to give you specifics..."
[Reads only those 4 scenes, not all 50]
```

### Plot Hole Detection

```
You: "Search for any mentions of the mysterious letter"

Claude: [DevRag search]
"Found in scenes 3, 12, and 24. But I notice you
 introduced it in scene 3, reference it in 12, but
 never reveal who sent it in scene 24. Intentional?"
```

## Troubleshooting

### DevRag Not Indexing

**Check configuration:**
```bash
cat .devrag-config.json
# Verify paths are correct
```

**Manual reindex:**
```bash
devrag --config .devrag-config.json
```

### Search Not Working

**Verify MCP setup:**
```bash
# In Claude Code
/mcp

# Should show devrag tools:
# - search
# - index_markdown
# - list_documents
# etc.
```

**Check ~/.claude.json:**
```json
{
  "mcpServers": {
    "devrag": {
      "type": "stdio",
      "command": "/usr/local/bin/devrag",
      "args": ["--config", ".devrag-config.json"]
    }
  }
}
```

### Model Download Failed

First run downloads embeddings from Hugging Face:

```bash
# Check internet connection

# If behind proxy:
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port

# Retry
devrag --config .devrag-config.json
```

## Best Practices

### Do:
- ✅ Let DevRag index automatically
- ✅ Use semantic search for "where did I..." questions
- ✅ Track major decisions in notes/decisions.md
- ✅ Keep .devrag/ in .gitignore
- ✅ Use drafts/ for experiments
- ✅ Trust markdown as source of truth

### Don't:
- ❌ Commit .devrag/ to git
- ❌ Edit vectors.db manually
- ❌ Worry if .devrag/ is deleted (just rebuild)
- ❌ Duplicate info in multiple places
- ❌ Try to read all scenes manually

## Summary

Your writing system uses a hybrid architecture:

```
┌─────────────────────────────────────────────────┐
│ Layer 1: DevRag                                 │
│ (Semantic search, vector retrieval)             │
│ - Fast: 100ms search                            │
│ - Efficient: 40x fewer tokens                   │
│ - Derivative: Regenerable from markdown         │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 2: Session Tracking                       │
│ (Time, words, streaks, git commits)             │
│ - notes/session-log.json                        │
│ - Auto git commit/push on /session end          │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 3: Codex                                  │
│ (World bible, characters, lore)                 │
│ - codex/*.md                                    │
│ - Searchable via DevRag                         │
│ - Copyable for series                           │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 4: Project Files                          │
│ (Source of truth, git-tracked)                  │
│ - scenes/*.md                                   │
│ - notes/decisions.md                            │
│ - All markdown, human-readable                  │
└─────────────────────────────────────────────────┘
```

**Result:**
- ✅ Human-readable storage (markdown)
- ✅ LLM-efficient retrieval (vectors)
- ✅ No vendor lock-in
- ✅ Git-friendly
- ✅ Fast semantic search
- ✅ Massive token savings

---

**Write into the dark, search with precision!** 🔍✨
