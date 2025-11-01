# Quick Start Guide

## Installation

### 1. Install the Plugin

**Using Plugin Manager (Recommended):**
```bash
claude

# Add marketplace
/plugin marketplace add badri/novel-claude

# Install plugin
/plugin install fiction-writer@badri
```

**Or clone directly:**
```bash
cd ~/.claude/plugins
git clone https://github.com/badri/novel-claude.git fiction-writer
```

### 2. Install Prerequisites

**Required:**
1. **Claude Code CLI** - Install from [claude.ai/code](https://claude.com/code)
2. **Gemini CLI** (for summarization) - Install from [Google AI Studio](https://aistudio.google.com/)
3. **DevRag** (for semantic search):
   ```bash
   # Download from https://github.com/tomohiro-owada/devrag/releases
   # macOS example:
   tar -xzf devrag-macos-apple-silicon.tar.gz
   sudo mv devrag-macos-apple-silicon /usr/local/bin/devrag

   # Configure MCP in ~/.claude.json:
   {
     "mcpServers": {
       "devrag": {
         "type": "stdio",
         "command": "/usr/local/bin/devrag",
         "args": ["--config", ".devrag-config.json"]
       }
     }
   }
   ```

**Optional:**
- `pandoc` for DOCX/EPUB export

### 3. Verify Installation

```bash
claude

# Check installed plugins
/plugin

# Test commands
/new-project
```

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

## All Commands (17)

### Essential Workflow
- `/new-project` - Initialize project
- `/import` - Import existing drafts
- `/session` - Track writing time & word count
- `/new-scene` - Write scenes (auto-detects new codex elements!)
- `/edit-scene` - AI-assisted editing (polish, refine, expand)
- `/brainstorm` - Develop story (auto-offers codex saves!)
- `/summarize` - Reverse outline (Gemini)
- `/status` - Check progress & session stats
- `/search` - Semantic search across project & sessions

### Scene Management (Discovery Writing Power Tools)
- `/cycle` - Plant setups backward
- `/scenes` - Navigate & search scenes
- `/reorder` - Reorganize sequence

### Worldbuilding
- `/codex` - Track characters, locations, lore (natural language + auto-detection!)
- `/chat` - Discuss your story

### Publication
- `/compile` - Create manuscript
- `/blurb` - Marketing copy
- `/cover` - Cover concepts

## Common Workflows

### Session Tracking ✨ NEW!

```
# Start your writing session
/session start
> Goal: Write 2 scenes
✓ Session started at 2:30 PM

# Write...
/new-scene
/new-scene

# Check progress
/session status
> 1h 15m elapsed, +2,234 words, goal reached!

# End session
/session end

📊 Session Summary
Duration: 1h 15min
Words: +2,234
Pace: 1,787 words/hour
🔥 Streak: 7 days

# View history
/session log
> Last 7 days, statistics, streaks
```

### Auto-Codex Magic ✨

```
# During brainstorming
/brainstorm
[Discuss new character Devika Menon...]
> "Add to codex"
✓ Immediately creates codex entry!

# Or after brainstorm
Session complete!
Detected: Devika Menon (character), Forbidden Vault (location)
Add to codex? [all/pick/skip/later]
> all
✓ Both added!

# Or natural language
/codex add character Devika from our discussion
✓ Extracts from conversation and creates entry!
```

### Auto-Detection in Scenes ✨ NEW!

```
/new-scene
> Marcus meets informant Yuki at Jade Dragon restaurant

✓ Scene created!

New elements detected:
👤 Yuki - Add to codex? [y/n/later]
📍 Jade Dragon restaurant - Add? [y/n/later]

> y, y

✓ Codex auto-updated!
Zero context overhead - seamless flow!
```

### Semantic Search Your Story ✨ NEW!

```
# Search across everything (scenes, codex, session logs, brainstorms)
/search Where did I mention the magic system?

🔍 Found 5 results:

📝 scenes/scene-007.md
Marcus collapsed after the spell. "That's why we don't use high-level magic carelessly..."

📚 codex/worldbuilding.md
Magic System: Physical stamina-based. Advanced users can draw from life force...

💭 notes/session-interactions/session-20251028-143000.md
[15:23] User: I decided magic should cost stamina, not just mental energy...

# Search specific areas
/search "character motivation" in:sessions
/search "ancient prophecy" in:scenes

# Search recent work
/search "villain backstory" recent:7d

# 40x fewer tokens, 260x faster than reading all files!
# Your full conversation history is searchable!
```

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
- ✅ Let auto-codex capture elements (just say "add to codex"!)
- ✅ Reorder if structure reveals itself
- ✅ Generate multiple options, pick best
- ✅ Use "later" for codex items, process with `/codex review-todo`

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
- **DevRag** provides semantic search across all your writing
- Invoke with `/summarize` - automatic!

### Semantic Search in Action

```bash
# You write 50 scenes across multiple sessions

You: "Where did I mention the villain's tragic backstory?"

Claude: [Uses DevRag search internally]
"Found in scene 24. Let me read that scene..."
[Reads only scene 24, not all 50 scenes]
Claude: "In scene 24, the villain reveals..."

# ✅ 40x fewer tokens, instant results!
```

### For Existing Projects

If you already have a writing project:

1. Install DevRag (instructions above)
2. Navigate to your project: `cd ~/writing/your-project`
3. Create `.devrag-config.json`:
   ```json
   {
     "documents_dir": "./",
     "db_path": "./.devrag/vectors.db",
     "chunk_size": 500,
     "search_top_k": 5,
     "include_patterns": [
       "scenes/*.md",
       "codex/*.md",
       "notes/*.md"
     ]
   }
   ```
4. Add `.devrag/` to `.gitignore`
5. Run DevRag once to index:
   ```bash
   devrag --config .devrag-config.json
   ```
6. Done! Claude can now search your entire project semantically.

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
