# Context Management

How the plugin manages story context across sessions without losing continuity.

## The Problem

Fiction projects accumulate fast. 20 scenes, a codex, brainstorm sessions, notes — far more than fits in a single Claude context window. The plugin solves this without external tools.

## How It Works

**Human-readable storage** — Everything lives in markdown files. Scenes, codex entries, session notes, brainstorms. Git-tracked, readable diffs, no vendor lock-in.

**Selective loading** — Skills load only what's needed for the task. Writing the next scene? Claude reads the last 2-3 scenes for continuity, not the whole manuscript. Updating a character? Claude reads `codex/characters.md`, not all 30 scenes.

**Continuity across sessions** — `ORDER.md` is the one-line reverse outline kept current by the writing; a project's `NEXT-SESSION.md` or `notes/` carry hand-offs. Git history carries pace.

**Story-specific CLAUDE.md** — Each project gets a `CLAUDE.md` with story metadata: POV, tense, voice, genre, characters, world rules. Claude reads this at the start of every session, so story context persists even when conversation history is compacted.

**ORDER.md — the cheap one** — One file at the project root holds the reading order *and* a one-sentence reverse outline of every placed scene, kept current as you write. Reading it costs almost nothing and tells Claude what the book looks like right now: what reads first, what's unplaced, what was cut. It's the first thing to read before any writing or structure work.

## The CLAUDE.md File

The most important context file. Created when you start a project, it contains:

- Title, genre, format
- POV and tense
- Protagonist and key characters
- Core premise and themes
- Writing style reference (author/book you're matching)
- Story rules and world constraints

Keep it updated as the story evolves. When Claude seems to drift from your voice or forget story rules, check this file first.

## Codex as Context

The `codex/` folder is your persistent world bible:

- `characters.md` — everyone who appears
- `locations.md` — everywhere scenes are set
- `timeline.md` — chronology of events
- `worldbuilding.md` — how the world works
- `lore.md` — backstory, history, mythology

Claude reads relevant codex files when writing or editing scenes. Update the codex to keep Claude aligned with your world.

## Scene Summaries

Two depths of reverse outline:

- **`ORDER.md`** — one sentence per scene, at the project root, kept current by the writing itself (every new scene, edit, and move). Free to read, always true. Read it first.
- **`summaries/`** — the deep beat-by-beat outline you ask for on demand ("summarize what I've written"), useful for continuity checks and spotting structural patterns without loading scene files. When it runs it also offers to refresh any `ORDER.md` lines that have drifted.

## What This Means for Your Workflow

- **Start every session in the project directory** — Claude reads `CLAUDE.md` automatically
- **Read `ORDER.md` before structure work** — it's the cheapest accurate picture of the book
- **Keep the codex current** — it's the fastest way to give Claude accurate world context
- **Summarize periodically** — deep reverse outlines help Claude track long-range continuity
- **Don't worry about compaction** — `CLAUDE.md`, `ORDER.md`, and the codex survive context window resets

## Why Stable IDs Save Context

Because `scene-NNN` never changes, a reference to `scene-014` in the codex, a
note, or a brainstorm stays correct forever — Claude can trust it without
re-reading a scene to check whether the numbering shifted. Reading order is
one small file, not a property spread across 70 filenames.
