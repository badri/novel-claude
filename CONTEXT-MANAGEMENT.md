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

**How it works (Fully Automatic):**
1. `cd project && claude` → SessionStart hook runs `/session start`
2. `UserPromptSubmit` hook → Captures each user message automatically
3. Appends to session markdown file with timestamps
4. Exit Claude → SessionEnd hook runs `/session-cleanup`
5. Session summary added, git commit/push, DevRag indexes

**Commands (Optional - hooks auto-run these):**
- `/session start` - Manually start (auto via SessionStart hook)
- `/session end` - Manually end (auto via SessionEnd hook)
- `/session status` - Check progress
- `/session log` - View history

**Hooks Configuration (.claude/settings.json):**
- `SessionStart` → Auto-starts session on `claude` launch
- `SessionEnd` → Auto-ends, commits, pushes on exit
- `UserPromptSubmit` → Logs every user message during session

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

When running `/new-project`, it automatically:
1. Creates complete project structure
2. Generates `.devrag-config.json` with session-interactions indexed
3. Adds `.devrag/` to `.gitignore`
4. Copies `.claude/settings.json` with hooks for automatic session tracking
5. Copies `.claude/hooks/log-interaction.sh` for interaction logging
6. Creates `notes/session-interactions/` folder
7. Creates `notes/decisions.md` template

**Zero configuration needed** - everything works automatically!

### Existing Projects

To add DevRag and sync with latest plugin features:

```bash
cd ~/writing/existing-project

# Run the comprehensive upgrade command
/setup-devrag
```

This comprehensive upgrade tool will:
1. **Show dry-run preview** of what will change
2. **Add DevRag** if missing (`.devrag-config.json`, `.mcp.json`)
3. **Create missing folders**: `scenes/drafts/`, `scenes/archive/`, `notes/session-interactions/`
4. **Update hook scripts** to latest versions (bug fixes, improvements)
5. **Merge settings** updates while preserving your customizations
6. **Update `.gitignore`** with recommended exclusions
7. **Update `project.json`** with any missing fields
8. **Rebuild DevRag index** (optional) for fresh semantic search
9. **Provide detailed summary** of all changes made

**Safe to run multiple times** - idempotent and non-destructive. Perfect for:
- Adding DevRag to projects created before semantic search
- Getting latest hook improvements after plugin updates
- Fixing broken or missing configurations
- Adding new folder structure features (drafts, archive)

**Next time you run `claude`:**
- Session auto-starts (SessionStart hook)
- All your commands logged (UserPromptSubmit hook)
- Session auto-ends on exit (SessionEnd hook)
- Git auto-commits work
- DevRag indexes session logs

## Configuration Examples

### Standard Configuration (Auto-Generated)
```json
{
  "name": "my-noir-novel",
  "description": "Fiction writing project - semantic search across scenes, codex, and notes",
  "indexPaths": [
    "scenes/**/*.md",
    "codex/**/*.md",
    "notes/**/*.md",
    "notes/session-interactions/**/*.md",
    "brainstorms/**/*.md",
    "summaries/**/*.md"
  ],
  "excludePaths": [
    "scenes/drafts/**",
    "scenes/archive/**",
    "manuscript/**",
    ".git/**"
  ],
  "chunkSize": 1000,
  "chunkOverlap": 200,
  "updateInterval": "on-save",
  "metadata": {
    "type": "fiction-project",
    "created": "2025-11-01T14:30:00Z",
    "genre": "noir"
  }
}
```

### With Drafts/Archive Excluded (Default)
```json
{
  "indexPaths": [
    "scenes/**/*.md",
    "codex/**/*.md",
    "notes/**/*.md",
    "notes/session-interactions/**/*.md"
  ],
  "excludePaths": [
    "scenes/drafts/**",      // Exclude experimental scenes
    "scenes/archive/**",     // Exclude deleted scenes
    "manuscript/**"          // Exclude compiled output
  ]
}
```

### Including Drafts for Search (Optional)
```json
{
  "indexPaths": [
    "scenes/**/*.md",        // Includes drafts/ and archive/
    "codex/**/*.md",
    "notes/**/*.md"
  ],
  "excludePaths": [
    "manuscript/**"          // Only exclude compiled output
  ]
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

### Searching Session History

```
You: "What did I decide about the villain's motivation last week?"

Claude: [DevRag searches session-interactions/]
"In your session on 2025-10-25, you discussed making
 the villain sympathetic rather than pure evil. You said:
 'I think the noir genre works better with moral ambiguity.'
 This affected scenes 18 and 24."
```

### Recalling Past Brainstorms

```
You: "Remind me what we discussed about the ending?"

Claude: [DevRag finds session from 3 days ago]
"In your session on 2025-10-29 at 15:42, you asked about
 the ending style. We discussed three options and you chose
 the ambiguous ending because it 'aligns with noir tone and
 leaves readers questioning.' You mentioned beta reader
 feedback that the happy ending felt too neat."
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

**Check MCP configuration:**
```bash
# Ensure DevRag MCP server is added
claude mcp add --transport stdio devrag -- /usr/local/bin/devrag --config .devrag-config.json

# Verify MCP servers are configured
claude mcp list
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

## Hooks System (Automatic Behavior)

The system uses Claude Code hooks in `.claude/settings.json` for zero-config automation:

### SessionStart Hook
```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "/session start"
      }]
    }]
  }
}
```

**Triggers:** When you run `claude` in a project directory
**Action:** Automatically starts session tracking
**Creates:** `notes/current-session.json`
**Records:** Start time, initial word/scene counts

### UserPromptSubmit Hook
```json
{
  "UserPromptSubmit": [{
    "hooks": [{
      "type": "command",
      "command": ".claude/hooks/log-interaction.sh \"$USER_MESSAGE\""
    }]
  }]
}
```

**Triggers:** Every time you send a message to Claude
**Action:** Runs bash script to log your message
**Appends to:** `notes/session-interactions/session-YYYYMMDD-HHMMSS.md`
**Format:** Timestamped markdown entries
**Only logs:** When session is active (`current-session.json` exists)

### SessionEnd Hook
```json
{
  "SessionEnd": [{
    "hooks": [{
      "type": "command",
      "command": "/session-cleanup"
    }]
  }]
}
```

**Triggers:** When you exit Claude (Ctrl+D, `exit`, Ctrl+C)
**Action:** Finalizes session and commits work
**Steps:**
1. Runs `/session end` (calculates stats, updates `session-log.json`)
2. Appends session summary to interaction log
3. Deletes `notes/current-session.json`
4. Runs `git add -A && git commit && git push`
5. DevRag auto-indexes the new session log file

### Why This Matters

**Before hooks:**
- Manual `/session start` required
- Easy to forget to log sessions
- Git commits only if you remember
- No interaction history captured

**With hooks:**
- ✅ Completely automatic
- ✅ Never forget a session
- ✅ All work committed on exit
- ✅ Full conversation history preserved
- ✅ Searchable via DevRag forever

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
│ Layer 1: DevRag (Semantic Search Engine)        │
│ - Vector search across ALL markdown             │
│ - Fast: 100ms search vs 25s reading files       │
│ - Efficient: 40x fewer tokens                   │
│ - Derivative: Regenerable from markdown         │
│ - Indexes: scenes, codex, notes, sessions       │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 2: Session Tracking & Interaction Logs    │
│ - AUTOMATIC via hooks (zero config)             │
│ - Tracks: time, words, streaks                  │
│ - Logs: all user commands & questions           │
│ - Files: notes/session-interactions/*.md        │
│ - Auto git commit/push on exit                  │
│ - Searchable via DevRag!                        │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 3: Codex (World Bible)                    │
│ - Persistent worldbuilding reference            │
│ - codex/characters.md, locations.md, etc.       │
│ - Searchable via DevRag                         │
│ - Copyable for series continuity                │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 4: Project Files (Source of Truth)        │
│ - scenes/*.md (git-tracked, human-readable)     │
│ - scenes/drafts/*.md (experimental)             │
│ - scenes/archive/*.md (deleted but kept)        │
│ - notes/decisions.md (plot choices)             │
│ - All markdown, version controlled              │
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
