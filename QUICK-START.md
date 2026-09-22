# Quick Start

## Install

```bash
claude
/plugin marketplace add badri/novel-claude
/plugin install fiction-writer@badri
```

Restart Claude Code after installing.

## Start a New Project

Navigate to your writing directory, open Claude Code, and say:

> "I want to start a new story"

Claude will ask for title, genre, format, and premise, then create the full project structure — including `ORDER.md`, which holds the reading order from that point on.

## Daily Writing Loop

Open Claude Code in your project directory and just talk:

| What you want | What to say |
|---|---|
| Continue writing | "let's write the next scene" |
| Write a specific scene | "write the scene where Devi finds the encrypted file" |
| Write out of order | "I want to write the climax now — I'll figure out where it fits later" |
| Rewrite a scene | drop `<cut>` / `<change>` / `<add>` tags on the prose, then "rewrite 012" |
| Reorder | "scene 8 should come before scene 5" |
| Get unstuck | "I'm stuck, help me figure out what happens next" |
| Review what you have | "show me my scenes" |
| Plant a setup you missed | "cycle back — I need to plant the backup drive earlier" |
| Update worldbuilding | "add Vikram to the codex" |
| Check progress | "how am I doing?" |
| End the day | "that's it for today" |

Sessions start and end automatically via hooks. Git commits happen on exit.

## Out-of-Order Writing

Write any scene whenever the energy is there:

- Scene filenames (`scene-NNN.md`) are **stable IDs** in the order you wrote them — they are **never renamed or renumbered**
- **`ORDER.md` says what order the scenes read in.** It's also the one-line reverse outline you keep current
- **To reorder, edit that list.** Chapter numbers follow reading positions, so a move costs one line
- "write the climax now" → goes to `scenes/drafts/climax.md`
- "promote the climax draft after scene 12" → it gets the next unused stable ID and an `ORDER.md` entry after whatever reads at position 12

Draft scenes don't count toward the manuscript until promoted.

## Key Concepts

**Stable IDs + ORDER.md** — The number in a filename is "the Nth scene I wrote," not its place in the book. Reading order lives in `ORDER.md` at the project root; reordering means editing that list, never renaming files. Compiling follows that list.

**Cycling** — When you write a payoff and realize the setup is missing, cycle back: "I need to plant the backup drive earlier." Claude inserts it and logs the change. "Earlier" means earlier in reading order.

**Annotate → rewrite** — You direct, Claude drafts. Drop tags on existing prose (`<cut>`, `<change>`, `<add>`, `<keep>`, `<brief>`, `<flow>`, `<q>`), say "rewrite 012", and Claude rewrites to them and strips them. A brand-new scene can just be a freeform skeleton — the whole file is the brief.

**Depth self-check** — Every new scene gets a standing depth pass before it's called done (five senses early through the POV, opinion-tinting, no witness syndrome, no placeholder nouns) — with somatization deliberately varied, not applied to every emotion.

**Codex** — Your world bible. Claude auto-detects new characters and locations in scenes and offers to save them. Or just say "add this to the codex."

**Brainstorm** — When stuck, brainstorm before writing. Saves the session so you can reference it later.

**Summarize** — A deep reverse outline. `ORDER.md` is the lightweight one kept current by the writing; `summarize` gives you the beat-by-beat version on demand.

## Project Structure

```
your-story/
├── ORDER.md             # reading order + one-line reverse outline (source of truth)
├── scenes/
│   ├── scene-001.md     # stable ID — creation order, never renamed
│   └── drafts/          # out-of-order scenes waiting to be placed
├── codex/               # characters, locations, worldbuilding
├── brainstorms/         # brainstorm sessions
├── summaries/           # deep reverse outlines
├── notes/               # session tracking, cycle and reorder logs
└── manuscript/          # compiled output
```

## When You're Ready to Publish

1. "show me my draft scenes" — review and promote any remaining drafts
2. "compile the manuscript" — assembles everything in `ORDER.md` reading order into a DOCX
3. "write a blurb" — back-cover copy
4. "cover concept" — art direction brief
