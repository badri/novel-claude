# Changelog

All notable changes to the Fiction Writer plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Corrected MCP server configuration file path from `~/.claude.json` to `.mcp.json` in all documentation (README.md, CONTEXT-MANAGEMENT.md, QUICK-START.md, setup-devrag.md command)
- Added clarification about project-level vs user-level MCP configuration options

## [1.0.0] - 2025-11-01

### Initial Release

First public release of the Fiction Writer plugin for Claude Code - a complete discovery writing system for fiction authors.

### Added

**Core Writing Workflow:**
- `/new-project` - Initialize fiction projects with complete structure
- `/new-scene` - Create scenes with auto-numbering and AI generation
- `/edit-scene` - AI-assisted scene editing with preview
- `/brainstorm` - Interactive brainstorming sessions
- `/summarize` - Reverse outlining using Gemini CLI (large context window)
- `/chat` - Story discussion with full context

**Scene Management:**
- `/scenes` - List, read, and search scenes
- `/reorder` - Reorganize scene sequence with auto-renumbering
- `/cycle` - Plant setups backward (discovery writing feature)
- Drafts/archive workflow for out-of-order writing
- Auto-detection of new characters/locations from scenes

**Worldbuilding:**
- `/codex` - Add/update/search codex entries
- Auto-detection and extraction from brainstorming sessions
- Natural language codex updates
- Persistent world bible (copyable for series)
- Five codex categories: characters, locations, timeline, worldbuilding, lore

**Session Tracking:**
- `/session start/end/status/log` - Track writing time and word count
- Automatic session management via hooks
- Streak tracking and goal setting
- Session statistics and analytics
- Word count, scenes written, words per hour metrics

**Session Interaction Logging:**
- Auto-logs all user interactions during sessions
- Stored in `notes/session-interactions/` (markdown format)
- Fully indexed by DevRag for semantic search
- Search past decisions and discussions

**Semantic Search:**
- `/search` - Natural language search across entire project
- DevRag-powered vector search (40x fewer tokens, 260x faster)
- Searches scenes, codex, notes, session transcripts, brainstorms
- Filter by type: `in:scenes`, `in:sessions`, `in:codex`
- Time-based filtering: `recent:7d`, `recent:30d`

**Publication Tools:**
- `/compile` - Generate manuscripts (MD/DOCX/EPUB)
- `/blurb` - Marketing copy generation
- `/cover` - Cover design concepts
- Export to multiple formats

**Project Setup:**
- `/import` - Import existing manuscripts with intelligent scene splitting
- `/setup-devrag` - Add semantic search to existing projects
- `/status` - Project health check and statistics
- Automatic git integration with session hooks

**Multi-Model Architecture:**
- Claude for creative work (brainstorming, writing, editing)
- Gemini CLI for summarization (token-efficient, 1M+ context)
- DevRag for semantic search (vector embeddings)

**Project Structure:**
- scenes/ with drafts/ and archive/ subdirectories
- codex/ for worldbuilding (5 categories)
- notes/ with session-interactions/ for conversation logs
- summaries/ for reverse outlines
- brainstorms/ for saved sessions
- manuscript/ for compiled output
- Automatic .devrag-config.json generation
- .gitignore with .devrag/ exclusion

**Hooks System:**
- SessionStart hook - Auto-starts sessions
- SessionEnd hook - Auto-cleanup and git commit
- UserPromptSubmit hook - Logs interactions during sessions
- Configured via .claude/settings.json

**Templates:**
- `.devrag-config.json.template` - Vector search configuration
- `.gitignore.template` - Git exclusions for projects
- Codex templates (characters, locations, etc.)
- Project metadata (project.json)

### Documentation
- Comprehensive README.md with philosophy and all commands
- QUICK-START.md for rapid onboarding
- CONTEXT-MANAGEMENT.md explaining hybrid architecture
- IMPORTING-GUIDE.md for existing manuscripts
- Inline command documentation (all commands self-documented)

### Plugin Distribution
- MIT License
- Plugin manifest (.claude-plugin/plugin.json)
- Marketplace configuration (.claude-plugin/marketplace.json)
- Installation via plugin manager or GitHub clone
- Standard plugin directory structure (commands/, agents/)

### Philosophy
- Discovery writing first (no forced outlines)
- Clean first draft approach
- Minimal rewriting
- Scene-by-scene workflow
- Reverse outlining after writing
- Auto-detection over manual entry
- Git-friendly (human-readable files)

---

## Maintenance Guidelines

When updating this changelog:

1. **Version numbering** (Semantic Versioning):
   - MAJOR (X.0.0): Breaking changes, API changes
   - MINOR (0.X.0): New features, backward compatible
   - PATCH (0.0.X): Bug fixes, documentation

2. **Update these files together**:
   - `CHANGELOG.md` (this file)
   - `.claude-plugin/plugin.json` (version field)
   - `.claude-plugin/marketplace.json` (version field and plugin entry)

3. **Changelog sections**:
   - `Added` - New features
   - `Changed` - Changes to existing features
   - `Deprecated` - Soon-to-be-removed features
   - `Removed` - Removed features
   - `Fixed` - Bug fixes
   - `Security` - Security fixes

4. **Release process**:
   ```bash
   # 1. Update CHANGELOG.md with new version and date
   # 2. Update version in plugin.json
   # 3. Update version in marketplace.json
   # 4. Commit changes
   git add CHANGELOG.md .claude-plugin/
   git commit -m "Release v1.X.0"
   git tag v1.X.0
   git push origin main --tags
   ```

---

[1.0.0]: https://github.com/badri/novel-claude/releases/tag/v1.0.0
