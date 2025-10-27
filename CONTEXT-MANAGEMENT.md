# Context Management & Memory Persistence

This document explains how context is managed across writing sessions and how to maximize the effectiveness of claude-mem.

## The Problem: Context Compaction

Claude Code conversations eventually get compacted to save tokens. Without persistence:
- ❌ Claude forgets previous sessions
- ❌ Plot decisions are lost
- ❌ Character development context disappears
- ❌ Every session feels like starting fresh
- ❌ You spend time re-explaining context

## The Solution: Multi-Layer Context System

Your writing system uses **four layers** of persistent context:

### Layer 1: claude-mem (Automatic Memory)

**What it does:**
- Captures everything during sessions (tool use, decisions, file changes)
- Compresses observations using AI
- Auto-injects context at session start
- Survives conversation compaction

**Setup:**
```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
# Restart Claude Code
```

**How it works:**
```
Session 1: Write scene 24, decide villain is sympathetic
  ↓
claude-mem captures and compresses
  ↓
[Conversation compacts]
  ↓
Session 2: claude-mem auto-injects previous context
  ↓
Claude: "I remember we made the villain sympathetic..."
```

**Query your history:**
Claude can search past sessions using MCP tools:
- `search_observations query="villain motivation"`
- `find_by_file filePath="scenes/scene-024.md"`
- `search_user_prompts query="change ending"`
- `find_by_type type="decision"`
- `get_recent_context limit=10`

### Layer 2: Session Tracking (Stats & Accountability)

**What it does:**
- Tracks time spent writing
- Counts words per session
- Monitors streaks and goals
- Provides progress statistics

**Files:**
- `notes/current-session.json` - Active session
- `notes/session-log.json` - Historical data

**Commands:**
- `/session start` - Begin tracking
- `/session end` - Save stats
- `/session status` - Check progress
- `/session log` - View history

**Automatic hooks:**
- SessionStart: Runs `/session start` automatically
- SessionEnd: Runs `/session-cleanup` (ends session + git commit/push)

### Layer 3: Codex (World Bible)

**What it does:**
- Persistent worldbuilding reference
- Character details, locations, lore
- Timeline and continuity
- Copyable for series work

**Structure:**
```
codex/
├── characters.md    # All characters
├── locations.md     # Places in your world
├── timeline.md      # Story chronology
├── worldbuilding.md # Rules, magic systems, tech
└── lore.md          # History, legends, culture
```

**Auto-population:**
- `/new-scene` detects new elements → offers to add to codex
- `/brainstorm` detects characters/locations → prompts to save
- `/codex add character Devika from our discussion` → natural language

**Usage:**
- `/codex search villain` - Find codex entries
- `/codex update character Marcus` - Edit entries
- `/codex review-todo` - Process detected elements

### Layer 4: Project Files (Ground Truth)

**What it does:**
- Actual scene files (source of truth)
- Summaries (reverse outlines)
- Cycle logs (setup tracking)
- Reorder history

**Key files:**
- `scenes/scene-*.md` - Your actual story
- `summaries/*.md` - Reverse outlines (via Gemini)
- `notes/cycles.md` - Setup planting log
- `notes/reorders.md` - Scene reorganization history
- `project.json` - Metadata and tracking

## How the Layers Work Together

### Cold Start Prevention

**Without claude-mem:**
```
Session 1: Write 3 scenes, make decisions
[Compaction]
Session 2: "What were we working on?" ❌
You: "We wrote scenes 20-22, made the villain sympathetic..."
```

**With claude-mem:**
```
Session 1: Write 3 scenes, make decisions
[Compaction]
Session 2: claude-mem injects context automatically ✅
Claude: "Last session we wrote scenes 20-22 and decided
         to make the villain sympathetic. Should I continue
         from scene 23?"
```

### Context Retrieval Strategy

Claude uses this hierarchy:

1. **Recent memory (claude-mem)** - Last ~10 sessions, automatically injected
2. **Explicit queries** - Search when needed: `find_by_file`, `search_observations`
3. **Codex reference** - Look up characters/world details
4. **Read actual files** - When needing exact text

### Example Session Flow

```bash
# You start Claude Code
# → SessionStart hook runs /session start
# → claude-mem auto-injects recent context

📊 Previous Context Available:
  Session Oct 27: Wrote scenes 20-22, villain sympathetic
  Session Oct 26: Introduced new character Sarah
  Session Oct 25: Fixed timeline issue in Act 2

Current Session Started: 2:45 PM
Goal: Write 2 scenes

You: "Continue writing from where we left off"

Claude: "Great! Last session we wrote scene 22 where Marcus
         confronts the villain. Since we decided to make the
         villain sympathetic, let's write scene 23 showing
         their backstory..."

# Write scene 23...

You: "/session end"

# → SessionEnd hook runs /session-cleanup
# → Logs session stats
# → Git commits and pushes
# → claude-mem captures the session

✓ Session ended!
Duration: 1h 30min
Words: +2,456
Streak: 8 days 🔥

Changes committed and pushed to git ✓
```

## Best Practices

### For New Projects

1. Install claude-mem first (one-time setup)
2. Run `/new-project` to create structure
3. Start writing - context builds automatically

### For Existing Projects

1. Install claude-mem
2. Navigate to your project
3. Do a "seeding session":
   ```bash
   /status
   /scenes list
   /codex search .

   # Then mention:
   # "So far I've written 24 scenes. Key decisions:
   #  - Villain is sympathetic
   #  - Sarah has trust issues
   #  - Ending will be ambiguous
   #  Main unresolved threads:
   #  - Who sent the warning letter?
   #  - What happened to Marcus's partner?"
   ```
4. Continue writing - context preserved from this point

### Optimizing Context Usage

**Do:**
- ✅ Let claude-mem work automatically
- ✅ Use `/status` to capture current state
- ✅ Update codex with new elements
- ✅ Ask Claude to search past sessions when needed
- ✅ Trust the system - it remembers more than you think

**Don't:**
- ❌ Re-explain context Claude already has
- ❌ Manually write long context primers
- ❌ Worry about compaction - claude-mem handles it
- ❌ Duplicate information across layers

### When Claude Forgets

If Claude seems to have forgotten something:

1. **Ask to search:**
   ```
   "Can you search our previous sessions for when we
    decided about the villain's motivation?"
   ```

2. **Reference the codex:**
   ```
   "/codex search villain"
   ```

3. **Read the actual scene:**
   ```
   "/scenes read 24"
   ```

4. **Check session logs:**
   ```
   "/session log"
   ```

## Troubleshooting

### claude-mem not capturing context

**Check worker status:**
```bash
npm run worker:logs --prefix ~/.claude-mem
```

**Restart worker:**
```bash
cd ~/.claude-mem
npm run worker:restart
```

### Context seems incomplete

- Remember: claude-mem captures forward from installation
- Old sessions aren't retroactively indexed
- Do a seeding session for existing projects
- Wait a few sessions for context to build

### Search tools not available

- Restart Claude Code after installing claude-mem
- Check `/plugin list` to verify installation
- Ensure MCP is enabled (should be by default)

### Session hooks not firing

**Check hooks configuration:**
```bash
cat .claude/settings.json
```

Should show:
```json
{
  "hooks": {
    "SessionStart": [...],
    "SessionEnd": [...]
  }
}
```

## Advanced: Querying Context

### Search Your Project History

Claude can search past sessions using these tools:

**Full-text search:**
```
search_observations with query="villain backstory" and type="decision"
```

**Search by file:**
```
find_by_file with filePath="scenes/scene-024.md"
```

**Search user requests:**
```
search_user_prompts with query="change the ending"
```

**Find by concept:**
```
find_by_concept with concept="character-development"
```

**Get recent context:**
```
get_recent_context with limit=5
```

### Citations

claude-mem provides citations like:
```
claude-mem://observation/abc123
```

These link back to specific observations in the database.

## Database Locations

**claude-mem:**
- Database: `~/.claude-mem/claude-mem.db`
- Logs: `~/.claude-mem/logs/`
- Config: `~/.claude-mem/.env`

**Session tracking:**
- Current: `notes/current-session.json`
- History: `notes/session-log.json`

**Project data:**
- All in your project directory
- Git-tracked (except `.beads/` if using beads)

## Future Enhancements

### Optional: Add beads for complex task tracking

If you need dependency tracking across sessions:

```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
cd your-project
bd init

# Track complex tasks
bd create "Fix timeline inconsistency in Act 2" -p 1
bd create "Develop Sarah's character arc" -p 2
bd dep add <id2> <id1> --type blocks

# Query ready work
bd ready
```

See: https://github.com/steveyegge/beads

## Summary

Your context management stack:

```
┌─────────────────────────────────────────────────┐
│ Layer 1: claude-mem (automatic, survives        │
│          compaction, searchable)                │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 2: Session Tracking (time, words,         │
│          streaks, goals)                        │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 3: Codex (world bible, characters,        │
│          locations, lore)                       │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Layer 4: Project Files (scenes, summaries,      │
│          actual story text)                     │
└─────────────────────────────────────────────────┘
```

**Result:** No more cold starts. Context persists. Writing flows.

---

**Write into the dark, with perfect memory!** 🧠✨
