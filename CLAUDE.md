# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## Development Guidelines

- Commit to git after completing a bead with a detailed commit message.
- When making plugin changes, always run `claude plugin validate .` in the top-level directory.
- Check whether `@CHANGELOG.md` needs updating before every change.

## Project Purpose

This is a **discovery writing system** for fiction authors, packaged as a Claude Code plugin (`fiction-writer`). It supports the "Writing Into the Dark" philosophy: no outlines, scene-by-scene organic writing, with AI assistance for brainstorming, scene management, and worldbuilding.

The plugin is **skills-based**. Writers talk to Claude naturally — there are no slash commands. Claude recognizes intent and invokes the matching skill.

## Architecture

### Skills

All user-facing functionality lives in `skills/<name>/SKILL.md`. Each skill is intent-driven: its YAML `description` frontmatter lists the triggering conditions, and the body is the workflow Claude follows. There are 20 skills:

- **Project setup**: `new-project`, `concept` (pre-project brainstorming), `import`
- **Writing**: `new-scene`, `edit-scene`, `brainstorm`, `chat`, `cycle` (plant setups backward)
- **Scene management**: `scenes`, `reorder`, `search`
- **Worldbuilding**: `codex`
- **Session tracking**: `session-start`, `session-end`, `status`
- **Publication**: `summarize`, `compile`, `shunn-format`, `blurb`, `cover`

There is no slash-command system and no `agents/` subagents — both were removed in the v2.0.0 conversion. Skills that need cheap bulk work (`summarize`, `import`) dispatch a subagent with the `haiku` model via the Task tool.

### Project Structure Model

Each writing project (created by the `new-project` skill) has:

```
project-name/
├── project.json              # Metadata, scene count, word count
├── CLAUDE.md                 # Story-specific context (auto-generated from template)
├── .gitignore
├── .claude/                  # Session hooks + settings (copied from templates)
│   ├── settings.json
│   └── hooks/
├── scenes/
│   ├── scene-001.md          # Active scenes (numbered, zero-padded)
│   ├── drafts/               # Experimental / out-of-order scenes
│   └── archive/              # Deleted scenes kept for reference
├── codex/                    # World bible (copyable for series)
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── notes/
│   ├── current-session.json  # Active session tracking
│   ├── session-log.json      # Session history
│   ├── cycles.md             # Setup-planting log
│   └── reorders.md           # Scene reorganization history
├── summaries/                # Reverse outlines
├── brainstorms/              # Saved brainstorm sessions
└── manuscript/               # Compiled output (MD / DOCX)
```

### Hooks

Project hooks are configured in each project's `.claude/settings.json` and call bash scripts directly (not skills):

- **SessionStart** → `session-start.sh` — starts session tracking
- **SessionEnd** → `session-end.sh` — logs stats, commits work
- **UserPromptSubmit** → `log-interaction.sh` — logs interactions

The hook scripts are scaffolded into new projects from `hooks-template/`.

### Plugin Files

- `skills/` — the 20 skills (auto-discovered by Claude Code)
- `hooks-template/` — hook scripts copied into new projects
- `scripts/` — deterministic helpers (session stats, word count, scene renumbering); skills coordinate, scripts execute
- `generate_manuscript.py` — Shunn submission-format generator, used by the `shunn-format` skill
- `*.template` files (`CLAUDE-PROJECT.md.template`, `.gitignore.template`, `.claude-settings.json.template`) — scaffolding templates; reference them via `${CLAUDE_PLUGIN_ROOT}`
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` — plugin manifest and marketplace entry

### Context Strategy

Story content is stored as human-readable, git-tracked markdown — scenes are the source of truth, the codex is curated worldbuilding, summaries are reverse outlines. There is no vector database. Context is managed by:

- **Per-project `CLAUDE.md`** — story-specific parameters (POV, tense, style, tone)
- **Codex** — persistent world knowledge across sessions
- **Summaries** — reverse outlines that let Claude grasp the story without reading every scene

## Development Workflow

### Active Work (Beads)

This project uses `bd` (beads) for issue tracking:

```bash
bd ready    # unblocked work
bd list     # all issues
```

### Commit Practice

Per the user's `CLAUDE.md`: do a git commit with a brief descriptive message after every bead is completed.

### Validation

No automated test suite. Validate changes by:

1. Running `claude plugin validate .` at the repo root
2. Checking the affected `skills/<name>/SKILL.md` is well-formed (valid frontmatter, `description` starts with "Use when")
3. Confirming markdown structure is correct

## Key Design Principles

### Discovery Writing First
- No forced outlines or plot structures
- Scene-by-scene workflow; reverse outlining happens *after* writing
- `cycle` plants setups backward (write the payoff first, add the setup later)

### Minimal Rewriting
- Clean first-draft philosophy; editing is for polish, not plot changes
- Archive deleted scenes rather than losing work

### Intent-Driven, Auto-Detecting
- Skills are invoked by natural language, not commands
- `new-scene` and `brainstorm` detect new characters/locations and offer codex entries
- Session tracking, scene numbering, and git commits happen automatically

## Documentation

- **README.md** — full system documentation, philosophy, all skills
- **QUICK-START.md** — condensed reference, common workflows
- **CONTEXT-MANAGEMENT.md** — how CLAUDE.md, the codex, and summaries manage context
- **IMPORTING-GUIDE.md** — importing existing manuscripts
- **CHANGELOG.md** — version history

## Important Constraints

1. **Never edit the user's story content** without an explicit request or preview/approval.
2. **Preserve scene numbering** — when adding, deleting, or reordering scenes, renumber subsequent scenes.
3. **Update `project.json`** — any scene change must update its metadata.
4. **Git-friendly** — all files are markdown or JSON, producing readable diffs.
5. **Skills coordinate, scripts execute** — keep deterministic operations in `scripts/`, not inline in skill prose.
