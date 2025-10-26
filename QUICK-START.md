# Quick Start Guide

## Installation

You already have:
- ✅ Claude Code CLI
- ✅ Gemini CLI (for summarization)

Optional:
- `pandoc` for DOCX/EPUB export

## First Project (5 minutes)

```bash
# 1. Create your project
/new-project
# Enter: name, genre, premise

# 2. Brainstorm your opening
/brainstorm

# 3. Write your first scene
/new-scene
# Choose: write yourself or AI-generate

# 4. Keep writing
/new-scene
# Repeat!

# 5. After 3-5 scenes, create reverse outline
/summarize
```

## All Commands (13)

### Essential Workflow
- `/new-project` - Initialize project
- `/new-scene` - Write scenes
- `/brainstorm` - Develop story
- `/summarize` - Reverse outline (Gemini)
- `/status` - Check progress

### Scene Management (Discovery Writing Power Tools)
- `/cycle` - Plant setups backward
- `/scenes` - Navigate & search scenes
- `/reorder` - Reorganize sequence

### Worldbuilding
- `/codex` - Track characters, locations, lore
- `/chat` - Discuss your story

### Publication
- `/compile` - Create manuscript
- `/blurb` - Marketing copy
- `/cover` - Cover concepts

## Common Workflows

### The Cycling Workflow
```
1. Write scene 24: "Martha grabbed the shotgun from her trunk"
2. Realize: Need to plant this earlier
3. /cycle
4. System: "Where should setup go?" → Scene 11
5. System generates 3 options for inserting the setup
6. Pick one, scene 11 updated
7. Continue writing
```

### Finding What You Wrote
```
/scenes search "shotgun"
# Shows all scenes mentioning shotgun

/scenes list
# See all scenes with POV, location, word count

/scenes read 12
# Read scene 12 with context
```

### Reordering Discovered Structure
```
# You realize Jack's scenes (5, 9, 13) work better grouped
/reorder
# System guides you through reorganization
# All references auto-update
```

## Discovery Writing Tips

### Do:
- ✅ Write forward, follow the character
- ✅ Cycle back to plant discovered elements
- ✅ Summarize every 3-5 scenes
- ✅ Update codex as story emerges
- ✅ Reorder if structure reveals itself
- ✅ Generate multiple options, pick best

### Don't:
- ❌ Plan the ending beforehand
- ❌ Force plot structures
- ❌ Rewrite (except on editorial order)
- ❌ Pre-populate codex
- ❌ Worry about "correct" chapter breaks

## File Structure

```
your-project/
├── scenes/           ← Your story (scene-001.md, etc.)
├── summaries/        ← Reverse outlines (auto-generated)
├── codex/            ← Characters, locations, lore
├── brainstorms/      ← Saved brainstorm sessions
├── manuscript/       ← Compiled versions
└── notes/            ← cycles.md, reorders.md, etc.
```

## Multi-Model Magic

- **Claude** writes and brainstorms with you
- **Gemini** summarizes efficiently (saves Claude tokens)
- Invoke with `/summarize` - automatic!

## Series Workflow

```bash
# Finish book 1
cd book-1
/compile

# Start book 2 with same world
cp -r book-1/codex book-2/codex
cd book-2
/new-scene
# Codex already has your world!
```

## Getting Help

- Read full docs: `README.md`
- Each command has detailed help built-in
- View command source: `.claude/commands/[command].md`
- View subagent: `.claude/subagents/gemini-summarizer.md`

## Ready to Write?

```bash
/new-project
```

**Write into the dark!** 📝✨
