# Context Management

How the plugin manages story context across sessions without losing continuity.

## The Problem

Fiction projects accumulate fast. 20 scenes, a codex, brainstorm sessions, notes — far more than fits in a single Claude context window. The plugin solves this without external tools.

## How It Works

**Human-readable storage** — Everything lives in markdown files. Scenes, codex entries, session notes, brainstorms. Git-tracked, readable diffs, no vendor lock-in.

**Selective loading** — Skills load only what's needed for the task. Writing the next scene? Claude reads the last 2-3 scenes for continuity, not the whole manuscript. Updating a character? Claude reads `codex/characters.md`, not all 30 scenes.

**Session continuity** — `notes/current-session.json` tracks the active session. `notes/session-log.json` tracks history, streaks, and word counts across sessions.

**Story-specific CLAUDE.md** — Each project gets a `CLAUDE.md` with story metadata: POV, tense, voice, genre, characters, world rules. Claude reads this at the start of every session, so story context persists even when conversation history is compacted.

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

After writing 5-10 scenes, ask for a reverse outline ("summarize what I've written"). Summaries live in `summaries/` and give Claude a compressed view of the manuscript — useful for continuity checks and spotting structural patterns without loading all scene files.

## What This Means for Your Workflow

- **Start every session in the project directory** — Claude reads `CLAUDE.md` automatically
- **Keep the codex current** — it's the fastest way to give Claude accurate world context
- **Summarize periodically** — reverse outlines help Claude track long-range continuity
- **Don't worry about compaction** — `CLAUDE.md` and the codex survive context window resets
