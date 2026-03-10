# Importing Existing Work

How to bring a draft you wrote elsewhere into the Fiction Writer system.

## When to Import

You have an existing manuscript — partial or complete — written in Word, Scrivener, a text editor, or anywhere else. You want to:

- Continue writing with Claude's assistance
- Build a codex from your existing world
- Use scene management, cycling, and reordering
- Get reverse outlines of what you've already written

## How It Works

Tell Claude you want to import an existing manuscript:

> "I have an existing draft I want to import"
> "I wrote 30,000 words in Word — bring it into this project"

Claude will:
1. Ask for the file path (MD, TXT, or DOCX)
2. Read the manuscript and split it into scenes intelligently
3. Number the scenes sequentially
4. Ask you for brief character and location information to seed the codex
5. Create a `CLAUDE.md` with the story metadata

## Before You Import

**Clean up the source file first:**
- Remove author notes, comments, and tracked changes
- Ensure scene breaks are consistent (blank lines, `***`, or `---`)
- Fix obvious encoding issues (smart quotes gone wrong, etc.)

**Decide your codex strategy:**
- Minimal: just the main characters and key locations — Claude can detect more as you write
- Full: bring everything across — takes longer but gives Claude better context from day one

## What Gets Created

```
your-story/
├── scenes/
│   ├── scene-001.md    # each detected scene as its own file
│   ├── scene-002.md
│   └── ...
├── codex/
│   ├── characters.md   # seeded from your input
│   └── locations.md    # seeded from your input
└── CLAUDE.md           # story metadata
```

## After Importing

1. **Verify the scene splits** — "show me my scenes" to review. Some splits may be off; edit manually if needed.
2. **Fill in the codex** — "add Vikram to the codex — he's the surveillance officer" — or let Claude detect as you continue writing.
3. **Get a reverse outline** — "summarize what I've written" — useful for reorienting before continuing.
4. **Continue writing** — pick up where you left off: "write the next scene"

## Large Manuscripts

For manuscripts over 50,000 words, importing in sections works better than all at once:

> "import just the first act — chapters 1 through 8"

Then import the rest after verifying the first section looks right.

## Scrivener Projects

Export from Scrivener as a single compiled document (DOCX or RTF → save as TXT/MD), then import that file. Scrivener's internal format isn't directly supported.
