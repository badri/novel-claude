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

All user-facing functionality lives in `skills/<name>/SKILL.md`. Each skill is intent-driven: its YAML `description` frontmatter lists the triggering conditions, and the body is the workflow Claude follows. There are 26 skills:

- **Project setup**: `new-project`, `concept` (pre-project brainstorming), `import`
- **Writing**: `new-scene`, `edit-scene`, `brainstorm`, `chat`, `cycle` (plant setups backward)
- **Scene management**: `scenes`, `reorder`, `search`
- **Worldbuilding**: `codex`
- **Session tracking**: `session-start`, `session-end`, `status`
- **Publication**: `summarize`, `compile`, `shunn-format`, `blurb`, `cover`
- **Craft drills** (observational, never rewrite): `depth-drill`, `opening-drill`, `fake-detail-drill`, `pov-glitch-drill`, `cliffhanger-cut-drill`
- **Business/mindset**: `study-discuss`

There is no slash-command system and no `agents/` subagents — both were removed in the v2.0.0 conversion. Skills that need cheap bulk work (`summarize`, `import`) dispatch a subagent with the `haiku` model via the Task tool.

### Scene Ordering Model (v2.2.0)

The system separates **identity** from **reading order**:

- `scenes/scene-NNN.md` filenames are **stable IDs assigned in creation order** ("the Nth scene I wrote"). They are **never renamed or renumbered** — not by `reorder`, not by archive/promote, not by anything. A cut scene's ID is retired and never reused.
- **`ORDER.md` (project root) is the source of truth for reading order** and doubles as the always-current one-line reverse outline.
- **`reorder` edits the list in `ORDER.md` and touches nothing else.** Chapter numbers are reading positions, and `compile` walks `ORDER.md`, emitting a `<!-- scene-NNN -->` comment before each section so reading position and stable ID stay in contact.
- New scenes take the next unused ID, then get an `ORDER.md` line at their reading position (or under `## Unplaced / drafts`).
- Drafts live in `scenes/drafts/` under descriptive names; promoting one assigns the next unused stable ID and adds an `ORDER.md` entry.

This is what makes out-of-order writing cheap: moving a scene costs one line in one file, with no git churn and no broken `[scene-NNN]` references in the codex or notes.

### Annotation Flow (v2.2.0)

Editing an existing scene is **author-directed**: the author drops open/close tags on the prose (`<brief>`, `<cut>`, `<change>`, `<keep>`, `<add>`, `<flow>`, `<q>`), says "rewrite NNN", and the AI rewrites to the tags and **strips them** (consumed). A fresh scene can instead be handed over as a freeform skeleton with no tags — the whole file is the brief. Untagged edit requests still get a preview before anything is written.

### Project Structure Model

Each writing project (created by the `new-project` skill) has:

```
project-name/
├── project.json              # Metadata, scene count, word count
├── ORDER.md                  # READING order + one-line reverse outline (source of truth)
├── CLAUDE.md                 # Story-specific context (auto-generated from template)
├── .gitignore
├── .claude/                  # Session hooks + settings (copied from templates)
│   ├── settings.json
│   └── hooks/
├── scenes/
│   ├── scene-001.md          # Stable IDs, creation order — never renamed
│   ├── drafts/               # Out-of-order scenes waiting on placement
│   └── archive/              # Cut scenes, kept for reference (IDs retired)
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
│   └── reorders.md           # Reading-order change log (positions, not files)
├── summaries/                # Deep reverse outlines
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

- `skills/` — the 26 skills (auto-discovered by Claude Code)
- `hooks-template/` — hook scripts copied into new projects
- `scripts/` — deterministic helpers (session stats, word count, `order-check.sh`); skills coordinate, scripts execute. `renumber-scenes.sh` is retired and exits 1.
- `generate_manuscript.py` — Shunn submission-format generator, used by the `shunn-format` skill; it reads scenes in **filename order**, so out-of-order projects must be staged in `ORDER.md` order first
- `*.template` files (`CLAUDE-PROJECT.md.template`, `ORDER.md.template`, `.gitignore.template`, `.claude-settings.json.template`) — scaffolding templates; reference them via `${CLAUDE_PLUGIN_ROOT}` (Claude Code) or `~/nc/` (omp)
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

1. **Never edit the user's story content** without an explicit request or preview/approval. Tagged rewrites are the request; untagged changes get a preview first.
2. **Never rename or renumber a scene file.** `scene-NNN` is a stable ID assigned in creation order. Reading order lives in `ORDER.md` and is changed by editing that list — never by touching files. A cut scene's ID stays retired.
3. **`ORDER.md` is the source of truth for reading order** and the always-current one-line reverse outline. Keep each scene's line true when a scene is written, moved, or edited; `compile` follows the list, not filenames.
4. **Update `project.json`** — any scene change must update its metadata (`sceneCount` = placed scenes, `wordCount` = placed scenes only, `currentScene` = last stable ID created).
5. **No annotation tag may survive into compiled output.** Tags are consumed by the rewrite that acts on them; `compile` refuses to assemble a manuscript containing one.
6. **Git-friendly** — all files are markdown or JSON, producing readable diffs.
7. **Skills coordinate, scripts execute** — keep deterministic operations in `scripts/`, not inline in skill prose.
