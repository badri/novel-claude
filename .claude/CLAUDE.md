# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a **discovery writing system** for fiction authors, designed as a Claude Code plugin. It supports "Writing Into the Dark" philosophy: no outlines, scene-by-scene organic writing, with AI-assisted tools for brainstorming, scene management, and worldbuilding.

## Architecture

### Multi-Model Strategy

- **Claude (you)**: Creative work, brainstorming, scene generation, character development
- **Gemini CLI**: Summarization and reverse outlining (large context window, token-efficient)
- **DevRag MCP**: Semantic vector search across markdown files (per-project indexing)

### Project Structure Model

Each writing project (created by `/new-project`) has:

```
project-name/
├── project.json              # Metadata, scene count, word count
├── scenes/
│   ├── scene-001.md          # Active scenes (numbered)
│   ├── drafts/               # Experimental scenes (future feature)
│   └── archive/              # Deleted scenes kept for reference (future)
├── codex/                    # World bible (copyable for series)
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── notes/
│   ├── decisions.md          # Plot decisions log (future)
│   ├── current-session.json  # Active session tracking
│   ├── session-log.json      # Session history
│   ├── cycles.md             # Setup planting log
│   └── reorders.md           # Scene reorganization history
├── summaries/                # Reverse outlines (Gemini-generated)
├── brainstorms/              # Saved brainstorm sessions
├── manuscript/               # Compiled output (MD/DOCX/EPUB)
└── .devrag-config.json       # Vector search configuration
```

### Command System

All user-facing functionality is in `.claude/commands/*.md` files:

**Core Workflow:**
- `/new-project` - Initialize project structure
- `/new-scene` - Create scene (auto-numbering, optional AI generation)
- `/edit-scene` - AI-assisted editing with preview
- `/brainstorm` - Interactive story development
- `/summarize` - Generate reverse outlines (calls Gemini subagent)
- `/cycle` - Plant setups backward (payoff → setup)

**Scene Management:**
- `/scenes` - List, read, search scenes
- `/reorder` - Reorganize scene sequence

**Worldbuilding:**
- `/codex` - Add/update/search codex entries (auto-detection from scenes)

**Session Tracking:**
- `/session start/end/status/log` - Track time, words, streaks
- Auto-commits via hooks on session end

**Publication:**
- `/compile` - Generate manuscript
- `/blurb` - Marketing copy
- `/cover` - Cover design concepts

### Hooks System

Configured in `.claude/settings.json`:

- **SessionStart**: Runs `/session start` automatically
- **SessionEnd**: Runs `/session-cleanup` (logs stats + git commit/push)

### Context Management Philosophy

**Human-Readable Storage (Git-Tracked):**
- All story content in markdown
- Scenes are source of truth
- Codex is manually curated
- Version controlled, no vendor lock-in

**LLM-Efficient Retrieval (Derivative, Gitignored):**
- DevRag indexes markdown → vector embeddings
- `.devrag/vectors.db` per project (gitignored)
- 40x fewer tokens, 260x faster than reading all files
- Semantic search: "where did I mention the magic system?"

## Development Workflow

### Active Work (Tracked in Beads)

This project uses `bd` (beads) for issue tracking. Check status:

```bash
bd ready        # See unblocked work
bd list         # All issues
bd dep tree nc-7  # View dependency chain
```

Current priorities:
- **nc-2**: Integrate DevRag (update `/new-project` to create `.devrag-config.json`)
- **nc-3**: Implement drafts/archive workflow
- **nc-4**: Add `notes/decisions.md` tracking
- **nc-7**: Convert to Claude Code plugin (epic)

### Commit Practice

Per user's `CLAUDE.md` instructions:
- **Do a git commit with brief descriptive message after every bead is completed**

### Testing Commands

No automated tests. Manual validation:
1. Run command in `.claude/commands/*.md`
2. Verify file creation/modification
3. Check `project.json` updates
4. Ensure markdown format is correct

### Working with Gemini Subagent

The `@gemini-summarizer` in `.claude/subagents/gemini-summarizer.md` wraps `gemini-cli`:
- Use for `/summarize` command
- Handles 1M+ token context windows
- Preserves Claude tokens for creative work
- Requires `gemini-cli` installed globally

## Key Design Principles

### Discovery Writing First
- No forced outlines or plot structures
- Scene-by-scene workflow
- Reverse outlining happens *after* writing
- `/cycle` plants setups backward (write payoff first, add setup later)

### Minimal Rewriting
- Clean first draft philosophy
- Editing only for polish, not plot changes
- Archive deleted scenes (don't lose work)

### Auto-Detection Over Manual Entry
- `/new-scene` detects new characters/locations → offers codex save
- `/brainstorm` detects elements → prompts to save
- Natural language: `/codex add character Devika from our discussion`

### Multi-Session Continuity
- Session tracking with streaks
- Codex persists world knowledge
- DevRag enables semantic search across sessions
- Git commits preserve history

## Documentation Structure

- **README.md**: Full system documentation, philosophy, all commands
- **QUICK-START.md**: Condensed reference, common workflows
- **CONTEXT-MANAGEMENT.md**: Hybrid architecture, DevRag setup, best practices
- **IMPORTING-GUIDE.md**: How to import existing manuscripts

## Future Planned Features

Tracked in beads:
- Drafts/archive workflow for out-of-order writing (nc-3)
- `notes/decisions.md` for plot decision tracking (nc-4)
- Plugin conversion for easy distribution (nc-7)

## Important Constraints

1. **Never edit the user's story content** without explicit request or preview/approval
2. **Gemini for summarization only** - use `@gemini-summarizer` subagent, don't call Gemini directly
3. **Preserve scene numbering** - when adding/deleting scenes, renumber subsequent scenes
4. **Update project.json** - any scene changes must update metadata
5. **Git-friendly** - all files are markdown or JSON, readable diffs
6. **Per-project DevRag** - each project has own `.devrag-config.json` and `.devrag/vectors.db`
