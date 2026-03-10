# Fiction Writer — A Claude Code Plugin

A discovery writing system for fiction authors, built as a Claude Code plugin. Inspired by Dean Wesley Smith's *Writing Into the Dark* philosophy: no outlines, no rewriting, clean first drafts written scene by scene.

## Philosophy

- **Write into the dark** — no outlines before writing, no character sketches, no planning
- **Clean first drafts** — cycling builds momentum and produces finished prose, not sloppy drafts to fix later
- **Discovery over engineering** — follow the story, trust the creative voice
- **Out-of-order freedom** — write any scene whenever the energy is there, assemble later
- **Scene-by-scene** — the unit of work is a scene, not a chapter or a manuscript

## Installation

### Via Claude Code Plugin Manager

```bash
claude
/plugin marketplace add badri/novel-claude
/plugin install fiction-writer@badri
```

Or use the interactive menu: `/plugin` → Browse → fiction-writer → Install

### Manual (GitHub Clone)

```bash
cd ~/.claude/plugins
git clone https://github.com/badri/novel-claude.git fiction-writer
# Restart Claude Code
```

## How It Works

This is a **skills-based** system. You write naturally — no slash commands to memorize. Claude recognizes your intent and invokes the right skill automatically.

Just talk to Claude:

> "let's start a new project"
> "I want to write the scene where Devi finds the encrypted file"
> "I'm stuck — help me figure out what happens next"
> "show me what I've written so far"
> "I know how the climax ends — let me write it now"

Claude handles the file management, numbering, codex updates, and session tracking behind the scenes.

## Project Structure

Each writing project gets:

```
project-name/
├── project.json              # Metadata, scene count, word count
├── CLAUDE.md                 # Story-specific context (auto-generated)
├── scenes/
│   ├── scene-001.md          # Numbered, active scenes
│   ├── scene-002.md
│   └── drafts/               # Out-of-order scenes (no sequence yet)
├── codex/                    # World bible
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── notes/
│   ├── current-session.json  # Active session tracking
│   ├── session-log.json      # Session history
│   └── cycles.md             # Setup/payoff log
├── brainstorms/              # Saved brainstorm sessions
├── summaries/                # Reverse outlines
└── manuscript/               # Compiled output
```

## Skills Reference

### Starting Out

**new-project** — Start a new writing project. Claude will ask for title, genre, format, and premise, then scaffold the full project structure with a story-specific `CLAUDE.md`.

*Trigger: "new project", "start a new story", "I want to write something new"*

**import** — Bring an existing manuscript (Word, text, markdown) into the system. Claude splits it into scenes intelligently.

*Trigger: "import", "I wrote this in Word", "bring in my draft"*

---

### Writing

**new-scene** — Write the next scene, or a draft scene out of order. Claude auto-numbers, pulls context from previous scenes, and offers to detect new characters/locations for the codex.

For out-of-order writing: tell Claude you want to write a future scene or a scene you're not sure where it fits — it goes into `scenes/drafts/` with a descriptive name instead of a number.

*Trigger: "let's write", "next scene", "continue", "write the scene where X", "I want to write the climax now"*

**edit-scene** — Fix, improve, or rework an existing scene. Claude shows a preview before changing anything.

*Trigger: "fix scene 3", "this scene feels off", "scene 4 needs work"*

**brainstorm** — Work through story problems, explore what happens next, develop a character, or get unstuck. Saves the session to `brainstorms/` for reference.

*Trigger: "I'm stuck", "help me figure out what happens next", "what if", "let's brainstorm"*

**chat** — Open-ended story discussion when you're not ready to write yet. Talk through characters, themes, decisions, continuity.

*Trigger: general creative conversation about the project*

---

### Out-of-Order Writing

The system supports DWS's "unstuck in time" approach — writing any scene whenever the energy is there, assembling later.

**Draft scenes** live in `scenes/drafts/` with descriptive names instead of numbers. They don't count toward the manuscript until promoted. Use them to:
- Write a future scene while it's vivid
- Try alternate versions of a key moment
- Write the climax before you've earned it in sequence
- Explore a subplot that may or may not fit

**cycle** — Plant setups backward. Write the payoff first (scene 18: Devi grabs the backup drive), then cycle back to plant the setup earlier (scene 7: Devi stashes a backup drive). Logs all cycles in `notes/cycles.md`.

*Trigger: "write the ending first", "I know how this ends", "plant the setup for X", "cycle back"*

---

### Managing Scenes

**scenes** — See what you've written. Lists all scenes with title, word count, POV, location. Can show draft scenes separately. Can promote a draft into the main sequence.

*Trigger: "what scenes do I have", "show me my scenes", "what have I written", "promote the climax draft"*

**reorder** — Restructure the scene sequence when you discover a better order. Preview before executing. Logs all reorders.

*Trigger: "move scene 5 before scene 3", "reorder", "scene 7 should come first", "swap scenes 4 and 6"*

**search** — Find anything across scenes, codex, notes, and brainstorms using natural language.

*Trigger: "find X", "where did I mention", "which scene has", "did I write about"*

---

### Worldbuilding

**codex** — Add, view, or update characters, locations, timeline, lore. Claude auto-detects new elements in scenes and offers to save them. Pull details from recent conversation context naturally.

*Trigger: "add to codex", "who is Devi", "update Vikram's entry", "what do I know about the AI cabal"*

---

### Session Tracking

**session-start** — Begin a writing session. Records start time and word count baseline. Hooks run this automatically when you open a project.

**session-end** — End the session. Calculates time, words written, updates streak. Commits work to git. Hooks run this automatically on exit.

**status** — Project snapshot: total words, scene count, session stats, streak.

*Trigger: "how am I doing", "project status", "word count", "how far am I"*

---

### Publication

**summarize** — Reverse outline: what you've written, what each scene does structurally, the shape of the story so far.

*Trigger: "summarize", "reverse outline", "show me the structure", "beat sheet"*

**compile** — Assemble all scenes into a single manuscript file. Formatted for submission (Shunn standard) or self-publishing. Exports to DOCX.

*Trigger: "compile", "assemble manuscript", "I need the manuscript file", "export to Word"*

**blurb** — Generate back-cover copy, Amazon description, query letter pitch, or marketing copy.

*Trigger: "write a blurb", "book description", "pitch the story"*

**cover** — Cover design brief, concept, and art direction. Produces a designer brief and AI image generation prompts.

*Trigger: "cover concept", "what should the cover look like", "cover brief"*

---

## Typical Workflow

### Starting fresh

1. Open Claude Code in your writing directory
2. "I want to start a new story" → new-project scaffolds everything
3. "Let's brainstorm the opening" → brainstorm explores possibilities
4. "Write the first scene" → new-scene creates scene-001.md

### Daily writing

1. Open Claude Code in the project directory
2. Session starts automatically (hook)
3. "Continue where we left off" or "write the scene where X happens"
4. Claude pulls context from previous scenes, writes forward
5. Exit → session ends automatically, git commit made

### Out-of-order

1. "I know exactly how the climax goes — let me write it now"
2. Claude creates `scenes/drafts/climax-devi-confronts-ai.md`
3. Keep writing in sequence
4. "Promote the climax draft, it goes after scene 12"
5. Claude moves it to scene-013.md, renumbers what follows

### Getting unstuck

1. "I'm stuck — I don't know what happens in act two"
2. brainstorm explores possibilities, saves session
3. Pick a direction, write the next scene
4. If you realize a setup is missing: cycle back to plant it

### Assembling

1. "Show me all my draft scenes" → scenes lists drafts
2. Decide which ones to promote and where
3. "Reorder — scene 8 should come before scene 5"
4. "Compile the manuscript" → single DOCX ready for submission

---

## Adding a New Project (Migrating Old Projects)

If you have an existing project using the old commands-based system:

1. Install the plugin (see above)
2. Enable it for your writing directory in `.claude/settings.json`:
   ```json
   { "enabledPlugins": { "fiction-writer@fiction-writer-marketplace": true } }
   ```
3. Update the `PLUGIN_DIR` in `.claude/hooks/session-end.sh` to point to where the plugin is installed
4. The project structure (scenes, codex, notes) is fully compatible — no file changes needed

---

## Series Writing

1. Complete first book
2. Copy `codex/` folder to new project directory
3. Start new project ("new project — this is book 2 of the Devi series")
4. Claude uses the copied codex as the world bible

---

## Design Principles

**Human-readable storage** — All story content is markdown. No vendor lock-in. Git-tracked, readable diffs, portable.

**Skills coordinate, not control** — Skills handle file operations and structure. The creative work is yours. Claude assists, doesn't direct.

**Auto-detection over manual entry** — Codex entries, session tracking, git commits, scene numbering — all happen automatically so you stay in the writing flow.

**Git-friendly** — Every project is a git repository. Session ends commit automatically. Full history of every scene change.
