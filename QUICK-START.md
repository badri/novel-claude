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

Claude will ask for title, genre, format, and premise, then create the full project structure.

## Daily Writing Loop

Open Claude Code in your project directory and just talk:

| What you want | What to say |
|---|---|
| Continue writing | "let's write the next scene" |
| Write a specific scene | "write the scene where Devi finds the encrypted file" |
| Write out of order | "I want to write the climax now — I'll figure out where it fits later" |
| Get unstuck | "I'm stuck, help me figure out what happens next" |
| Review what you have | "show me my scenes" |
| Plant a setup you missed | "cycle back — I need to plant the backup drive earlier" |
| Update worldbuilding | "add Vikram to the codex" |
| Check progress | "how am I doing?" |
| End the day | "that's it for today" |

Sessions start and end automatically via hooks. Git commits happen on exit.

## Out-of-Order Writing

Write any scene whenever the energy is there:

- "write the climax now" → goes to `scenes/drafts/climax.md`
- Keep writing in sequence normally
- "promote the climax draft after scene 12" → becomes `scene-013.md`

Draft scenes don't count toward the manuscript until promoted.

## Key Concepts

**Cycling** — When you write a payoff and realize the setup is missing, cycle back: "I need to plant the backup drive in scene 7." Claude inserts it and logs the change.

**Codex** — Your world bible. Claude auto-detects new characters and locations in scenes and offers to save them. Or just say "add this to the codex."

**Brainstorm** — When stuck, brainstorm before writing. Saves the session so you can reference it later.

**Summarize** — Reverse outline of what you've written. Useful after every 5-10 scenes to see the shape of the story.

## Project Structure

```
your-story/
├── scenes/
│   ├── scene-001.md     # active, numbered scenes
│   └── drafts/          # out-of-order scenes waiting to be placed
├── codex/               # characters, locations, worldbuilding
├── brainstorms/         # brainstorm sessions
├── summaries/           # reverse outlines
├── notes/               # session tracking
└── manuscript/          # compiled output
```

## When You're Ready to Publish

1. "show me my draft scenes" — review and promote any remaining drafts
2. "compile the manuscript" — assembles everything into a DOCX
3. "write a blurb" — back-cover copy
4. "cover concept" — art direction brief
