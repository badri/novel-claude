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

Claude handles the file management, numbering, codex updates, and per-scene git commits behind the scenes.

## Project Structure

Each writing project gets:

```
project-name/
├── project.json              # Metadata, scene count, word count
├── ORDER.md                  # READING order + one-line reverse outline (source of truth)
├── CLAUDE.md                 # Story-specific context (auto-generated)
├── scenes/
│   ├── scene-001.md          # Stable IDs, creation order — never renamed
│   ├── scene-002.md
│   └── drafts/               # Out-of-order scenes (no placement yet)
├── codex/                    # World bible
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── notes/
│   ├── cycles.md             # Setup/payoff log
│   └── reorders.md           # Reading-order change log
├── brainstorms/              # Saved brainstorm sessions
├── summaries/                # Deep reverse outlines
└── manuscript/               # Compiled output
```

**Scene IDs are permanent; reading order is `ORDER.md`.** `scene-009` is the
9th scene written, not the 9th scene read. To change the order, edit the list
in `ORDER.md` — the files never move or get renamed.

## Skills Reference

### Starting Out

**new-project** — Start a new writing project. Claude will ask for title, genre, format, and premise, then scaffold the full project structure with a story-specific `CLAUDE.md`.

*Trigger: "new project", "start a new story", "I want to write something new"*

**import** — Bring an existing manuscript (Word, text, markdown) into the system. Claude splits it into scenes intelligently.

*Trigger: "import", "I wrote this in Word", "bring in my draft"*

---

### Writing

**new-scene** — Write the next scene, or a draft scene out of order. Claude picks the next unused stable ID, pulls context from the scene `ORDER.md` places before it, drafts, and adds the scene's line to `ORDER.md` at the reading position you name. Runs the depth self-check before calling the scene done. Offers to detect new characters/locations for the codex.

For out-of-order writing: tell Claude you want to write a future scene or one you can't place yet — it goes into `scenes/drafts/` with a descriptive name and stays out of the manuscript until promoted.

*Trigger: "let's write", "next scene", "continue", "write the scene where X", "I want to write the climax now"*

**edit-scene** — Rewrite an existing scene **to your annotations**. Drop tags on the prose — `<brief>`, `<cut>`, `<change>`, `<keep>`, `<add>`, `<flow>`, `<q>` — say "rewrite 012", and Claude rewrites to them and strips them. Untagged requests in plain language get a preview before anything changes. The scene never moves: editing doesn't touch reading order.

*Trigger: "fix scene 3", "this scene feels off", "rewrite 012", "scene 4 needs work"*

#### The edit flow — annotate → rewrite

**You direct; Claude drafts.** This keeps the prose in your voice and stops register drift from snowballing across scenes.

- **Fresh scene:** you write a freeform skeleton — beats, register, what to keep in mind, **no tags**. The whole file is the brief; Claude drafts the scene from it.
- **Editing existing prose:** you drop tags on the prose and say "rewrite 012". Claude rewrites to the tags, strips them (consumed), and updates the scene's Notes.

| Tag | Meaning |
|---|---|
| `<brief> … </brief>` | A brief for a stretch of the scene — register / keep / change / flow |
| `<cut> … </cut>` | Remove this (wrap the prose) |
| `<change> … </change>` | Revise — wrap the target and put the instruction inside |
| `<keep> … </keep>` | Lock this; don't touch it in the rewrite |
| `<add> … </add>` | Insert this at this point |
| `<flow> … </flow>` | A beat/flow note, where it applies |
| `<q> … </q>` | A question for Claude |

Tags never appear in fiction prose, so they're unambiguous and greppable. **One editor per file at a time.** A tag that survives into a compile is a bug — `compile` refuses to assemble until it's consumed.

#### Standing step — the depth self-check

Before any new scene is called done, Claude reads it back and fixes the gaps: five senses early through the POV character, opinion-tinted description, no witness syndrome, no placeholder nouns, character-specific perception, and recognition instead of re-narration when returning to established material. It also **varies the somatization** — grounding the load-bearing beats but letting minor emotions land as plain statement, because bodying *every* emotion is the machine default, not depth. The grounding gets recorded in the scene's Notes.

The `depth-drill` skill is different: it's an observational drill you run on request on a finished scene, it never rewrites, and it never auto-fires. `opening-drill`, `pov-glitch-drill`, `fake-detail-drill`, and `cliffhanger-cut-drill` work the same way.

**brainstorm** — Work through story problems, explore what happens next, develop a character, or get unstuck. Saves the session to `brainstorms/` for reference.

*Trigger: "I'm stuck", "help me figure out what happens next", "what if", "let's brainstorm"*

**chat** — Open-ended story discussion when you're not ready to write yet. Talk through characters, themes, decisions, continuity.

*Trigger: general creative conversation about the project*

---

### Out-of-Order Writing

The system supports DWS's "unstuck in time" approach — writing any scene whenever the energy is there, assembling later. **Numbering is decoupled from reading order.**

- **`scenes/scene-NNN.md` filenames are stable IDs** assigned in creation order — the number is just "the Nth scene I wrote." They are never renamed or renumbered, so you can write in any order and never churn git history or break a reference.
- **`ORDER.md` says what order the scenes read in**, and doubles as the one-line reverse outline you keep current as you write.
- **To reorder, edit that list.** Chapter numbers follow reading positions, so reordering costs one line in one file.

**Draft scenes** live in `scenes/drafts/` with descriptive names instead of numbers. They don't count toward the manuscript until promoted. Use them to:
- Write a future scene while it's vivid
- Try alternate versions of a key moment
- Write the climax before you've earned it in sequence
- Explore a subplot that may or may not fit

Promoting a draft assigns the **next unused stable ID** and adds an `ORDER.md` entry at the reading position you name — nothing else is renumbered.

**cycle** — Plant setups backward. Write the payoff first (scene 18: Devi grabs the backup drive), then cycle back to plant the setup earlier (scene 7: Devi stashes a backup drive). "Earlier" means earlier in *reading order*. Logs all cycles in `notes/cycles.md`.

*Trigger: "write the ending first", "I know how this ends", "plant the setup for X", "cycle back"*

---

### Managing Scenes

**scenes** — See what you've written, **in reading order**. Lists every placed scene with its reading position, stable ID, POV, word count, and `ORDER.md` one-line outline — then unplaced/drafts, then archive. Can promote a draft (to the next stable ID, with an `ORDER.md` entry) or cut a scene (file kept, ID retired).

*Trigger: "what scenes do I have", "show me my scenes", "what have I written", "promote the climax draft"*

**reorder** — Change the reading order. Claude shows the proposed new `ORDER.md` list before applying it, logs the change to `notes/reorders.md`, and **never renames, moves, or edits a scene file**. Chapter numbers shift; filenames and stable IDs don't.

*Trigger: "move scene 5 before scene 3", "reorder", "scene 7 should come first", "swap scenes 4 and 6"*

**search** — Find anything across scenes, `ORDER.md`, codex, notes, and brainstorms using natural language. Hits are reported by stable ID and reading position.

*Trigger: "find X", "where did I mention", "which scene has", "did I write about"*

---

### Worldbuilding

**codex** — Add, view, or update characters, locations, timeline, lore. Claude auto-detects new elements in scenes and offers to save them. Pull details from recent conversation context naturally.

*Trigger: "add to codex", "who is Devi", "update Vikram's entry", "what do I know about the AI cabal"*

---

### Progress

**status** — Project snapshot: placed scenes and words, words per day over the last 7 and 30 days computed from git history against the Pulp 1 pace, consistency check, and which publication assets exist. No sessions, no streaks.

*Trigger: "how am I doing", "project status", "word count", "what's my pace"*

**tic-audit** — The book-wide repetition count: every 3–5 word phrase repeated 10+ times across 8+ scenes, plus the regex tells (simile of manner, padding, said-bookisms, bowtie candidates). Reports; never fixes without you. Run it after any multi-scene pass; `compile` runs it as a report.

*Trigger: "tic audit", "what am I overusing", "repetition scan", "prose lint"*

---

### Publication

**summarize** — A deep reverse outline: what you've written, what each scene does structurally, the shape of the story so far. `ORDER.md` is the lightweight one-line outline kept current by the writing; this is the beat-by-beat version you ask for. Offers to refresh any `ORDER.md` lines that drifted.

*Trigger: "summarize", "reverse outline", "show me the structure", "beat sheet"*

**compile** — Assemble the manuscript **in `ORDER.md` reading order**, numbered by reading position, with each section tagged by its stable ID. Refuses to compile if any annotation tag survives in a scene, and warns when the files on disk and `ORDER.md` disagree. Exports to DOCX/EPUB.

*Trigger: "compile", "assemble manuscript", "I need the manuscript file", "export to Word"*

**blurb** — One ~100-word blurb in Dean Wesley Smith's sales shape (setup → turn → stakes → genre line), used everywhere, plus tagline, KDP keywords, categories, BISAC codes and the Notion Press keyword line. Respects the book's own spoiler rule.

*Trigger: "write a blurb", "sales copy", "book description", "keywords for KDP"*

**cover** — One cover brief with Dean's hierarchy (author name huge at top, genre image, title smaller at bottom, tagline), one concept, one image prompt. Print covers are built by `publish`.

*Trigger: "cover concept", "what should the cover look like", "cover brief"*

**publish** — From finished manuscript to live storefronts: publication master, EPUB (epubcheck-clean), KDP and D2D upload sheets, Notion Press print interior and cover from the site's own template. Short stories take the ebook-only path. The human does every payment and every Submit click.

*Trigger: "publish", "get this ready for KDP", "D2D upload", "Notion Press", "paperback"*

### Craft Drills

**depth-drill**, **opening-drill**, **fake-detail-drill**, **pov-glitch-drill**, **cliffhanger-cut-drill** — Dean-over-the-shoulder observations on a finished scene. Quote what the prose is doing; never rewrite, never score, never auto-fire. Each saves to `notes/<drill>-drills/`.

*Trigger: "depth drill on scene 12", "check my opening", "find placeholders", "pov glitch check", "where should I end this scene"*

**study-discuss** — Work through a Dean Wesley Smith workshop (business, mindset, or craft) from the distilled `~/course-distiller/` material. Walkthrough, problem-solving, or course-correct modes. Saves to `~/writing/study-discussions/`.

*Trigger: "discuss heinlein's rules", "what does Dean say about X", "course correct on Y"*

---

## Typical Workflow

### Starting fresh

1. Open Claude Code in your writing directory
2. "I want to start a new story" → new-project scaffolds everything
3. "Let's brainstorm the opening" → brainstorm explores possibilities
4. "Write the first scene" → new-scene creates scene-001.md

### Daily writing

1. Open Claude Code in the project directory
2. "Continue where we left off" or "write the scene where X happens"
3. Claude pulls context from the scenes `ORDER.md` places before it, drafts, runs the depth and house-style checks, places the scene, commits
4. "How am I doing?" → words per day from git, against Pulp 1

### Out-of-order

1. "I know exactly how the climax goes — let me write it now"
2. Claude creates `scenes/drafts/climax-devi-confronts-ai.md`
3. Keep writing in sequence — new scenes take the next stable ID and get their own `ORDER.md` line
4. "Promote the climax draft, it goes after scene 12"
5. Claude moves it to the next unused stable ID and inserts its line in `ORDER.md` after the scene reading at position 12 — nothing else renumbers

### Getting unstuck

1. "I'm stuck — I don't know what happens in act two"
2. brainstorm explores possibilities, saves session
3. Pick a direction, write the next scene
4. If you realize a setup is missing: cycle back to plant it

### Assembling

1. "Show me all my draft scenes" → scenes lists drafts and unplaced scenes
2. Decide which ones to promote and where
3. "Reorder — scene 8 should come before scene 5" → Claude edits `ORDER.md` and shows you the new list
4. "Compile the manuscript" → assembled in that order (with a repetition report first)
5. "Write a blurb" → "cover brief" → "publish" → upload sheets ready to paste

---

## Adding a New Project (Migrating Old Projects)

If you have an existing project using the old commands-based system:

1. Install the plugin (see above)
2. Enable it for your writing directory in `.claude/settings.json`:
   ```json
   { "enabledPlugins": { "fiction-writer@fiction-writer-marketplace": true } }
   ```
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

**Auto-detection over manual entry** — Codex entries, git commits, scene IDs and `ORDER.md` lines — all happen automatically so you stay in the writing flow.

**Git-friendly** — Every project is a git repository. Every placed scene is a commit. Full history of every scene change, and pace comes from that history.
