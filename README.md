# Pulp Fiction Writing System for Claude Code

A complete discovery writing system inspired by Dean Wesley Smith's "Writing Into the Dark" philosophy, designed for writing short stories, novellas, and novels in any genre.

## Philosophy

This system supports **clean first draft writing** with:
- No outlines before writing (discovery/organic writing)
- Scene-by-scene workflow
- Reverse outlining (summarize after writing)
- Minimal rewriting (except on editorial order)
- AI-assisted brainstorming and generation
- Persistent worldbuilding codex
- Multi-model support (Claude for creative, Gemini for summarizing)

## System Overview

### Core Workflow

```
Brainstorm → Write Scene → Summarize → Repeat
      ↓           ↓            ↓
   /cycle    Navigate      Update
   (plant    (/scenes)     Codex
   setups)      ↓
                ↓
           Reorder
          (/reorder)
                ↓
         Compile Manuscript → Blurb → Cover → Publish
```

### Project Structure

Each project gets:
```
project-name/
├── project.json           # Metadata and tracking
├── scenes/                # Individual scene files (scene-001.md, etc.)
├── summaries/             # Reverse outlines (via Gemini)
├── brainstorms/           # Brainstorming sessions
├── codex/                 # Worldbuilding database (copyable for series!)
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── manuscript/            # Compiled versions (MD/DOCX/EPUB)
└── notes/                 # General notes and ideas
```

## Available Commands

### Project Management

**`/new-project`**
- Initialize a new fiction project
- Creates complete folder structure
- Sets up codex templates
- Initializes tracking

**`/import`**
- Import existing partial drafts or manuscripts
- Context-economical: processes in chunks, uses Gemini for summaries
- Minimal codex setup (user provides brief character/location info)
- Auto-splits into scenes intelligently
- Supports MD, TXT, DOCX formats
- Continue writing from where you left off

**`/status`**
- View project statistics
- Scene count, word count, progress
- Active session status (if writing)
- Session statistics and streaks
- Health check and next steps
- Recent activity summary

**`/session`**
- Track writing sessions (time and word count)
- `/session start` - Begin session with optional goal
- `/session end` - Log session stats
- `/session status` - Check current session progress
- `/session log` - View history, streaks, statistics
- Export data to CSV for analysis
- Builds consistent writing habits with streak tracking

### Writing Workflow

**`/new-scene`**
- Create new scene file with auto-numbering
- Option to write yourself or AI-generate
- Multiple options/alternatives generation
- Auto-context from previous scenes
- Auto-detects new codex elements (characters, locations, skills)
- Updates project.json tracking

**`/edit-scene`**
- AI-assisted scene editing (or manual)
- Modes: specific changes, rewrite section, polish, expand
- Before/after preview with accept/edit/revert
- Auto-backup and edit history
- Detects new elements added in edits
- Preserves scene voice and structure

**`/brainstorm`**
- Interactive brainstorming sessions
- Character development
- Plot exploration
- Problem solving
- Multiple path generation
- Saves session for reference

**`/summarize`**
- Reverse outline scenes using Gemini CLI
- Single scene or range
- Leverages Gemini's large context window
- Saves summaries for future reference
- Continuity checking

**`/chat`**
- Discuss your story with full context
- Ask about characters, plot, themes
- Continuity checks
- Writing problem solving
- Context-aware responses

### Scene Management

**`/cycle`**
- Plant setups backward in earlier scenes
- Discovery writing essential: write payoff first, add setup later
- Example: Martha grabs shotgun (scene 24) → cycle back to plant it (scene 11)
- Generates multiple insertion options (minimal/organic/expanded)
- Tracks all cycles in notes/cycles.md
- Updates scene files while preserving voice and flow

**`/scenes`**
- List all scenes with POV, location, word count, status
- Read specific scenes (single, multiple, ranges)
- Search scenes by content, character, location, POV
- Jump to specific scene numbers
- View detailed scene metadata and statistics
- Quick navigation between related scenes

**`/reorder`**
- Reorganize scene sequence as story structure emerges
- Swap two scenes, move scene to new position, or resequence multiple
- Preview changes before executing
- Auto-updates all references (summaries, cycles, codex)
- Logs all reorders for tracking
- Verifies integrity after changes
- Supports grouping by POV, timeline, or story thread

### Worldbuilding

**`/codex`**
- Add/update/delete/search codex entries
- Natural language support: `/codex add character Devika from our discussion`
- Pulls details from recent conversation context
- Extract from scenes automatically
- Review TODO list from brainstorm/scene detections
- Copyable for series continuity
- Cross-reference with scenes

**Automatic Codex Integration:**
- `/brainstorm` detects new characters/locations and offers to save
- `/new-scene` auto-detects new elements (characters, locations, skills, worldbuilding)
- Inline during work: just say "add to codex" and it happens
- Choose: add now, skip, or save to TODO for later
- Seamless workflow - never breaks creative flow

### Publication

**`/compile`**
- Compile all scenes into manuscript
- Clean formatting for publication
- Export to DOCX/EPUB (via pandoc)
- Statistics and compilation report
- Chapter detection

**`/blurb`**
- Generate story descriptions
- Multiple versions (hook, short, full, long)
- Genre-appropriate formatting
- Marketing copy variations
- A/B testing options

**`/cover`**
- Cover design concepts
- Genre analysis
- AI image generation prompts
- Technical specifications
- Designer brief templates

## Multi-Model Support

The system uses different AI models for different tasks:

- **Claude** (this): Creative writing, brainstorming, character development
- **Gemini** (via CLI): Scene summarizing, reverse outlining, continuity checking
- **claude-mem**: Persistent context compression (uses Claude Sonnet 4.5 by default)

### Gemini Summarizer Subagent

The system includes a `@gemini-summarizer` subagent that:
- Wraps the Gemini CLI for efficient summarization
- Handles large context (1M+ tokens)
- Preserves Claude tokens for creative work
- Automatically invoked by `/summarize` command

**Requirement**: `gemini-cli` must be installed and configured

### Context Persistence via claude-mem

The `claude-mem` plugin provides:
- Automatic session observation capture
- AI-powered context compression
- Persistent memory across conversation compactions
- 7 MCP search tools for querying project history:
  - `search_observations` - Full-text search across captured context
  - `search_sessions` - Search session summaries
  - `search_user_prompts` - Find what you asked for
  - `find_by_concept` - Search by concept tags
  - `find_by_file` - Find work related to specific files
  - `find_by_type` - Filter by decision, bugfix, feature, etc.
  - `get_recent_context` - Get recent session context

**Requirement**: `claude-mem` plugin must be installed (see setup above)

## Getting Started

### 0. One-Time Setup: Install claude-mem

**For persistent context across sessions, install the claude-mem plugin once:**

```bash
# Start Claude Code
claude

# Add the marketplace and install
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem

# Restart Claude Code
# Context will now persist across sessions automatically
```

**What claude-mem does:**
- Captures everything Claude does during sessions (tool use, decisions, file changes)
- Compresses context with AI and stores in local SQLite database
- Auto-injects relevant context when you start new sessions
- Survives conversation compaction - no more "cold starts"
- Provides 7 search tools to query your project history

**Configuration (optional):**
```bash
# If you want to change the AI model used for compression
~/.claude-mem/claude-mem-settings.sh
```

**For existing projects:**

If you already have writing projects in progress and want to add claude-mem:

1. Install claude-mem (instructions above)
2. Restart Claude Code
3. Navigate to your existing project: `cd ~/writing/your-project`
4. Start a new session - claude-mem begins capturing from this point forward
5. Your past work won't be automatically indexed, but:
   - All future sessions will be captured
   - You can reference files and scenes normally
   - Context builds up over subsequent sessions

**Tip:** After installing claude-mem, do a quick session where you:
- Run `/status` to capture current project state
- Run `/scenes list` to index all scenes
- Mention key plot decisions or character details
- This seeds the memory system with current context

### 1. Initialize Your First Project

**Choose your writing directory first:**
```bash
# Navigate to where you want to keep your writing projects
cd ~/writing
# or
mkdir -p ~/writing && cd ~/writing

# Start Claude Code
claude
```

**Create your project:**
```bash
/new-project
```

Provide:
- Project name (e.g., "midnight-noir")
- Genre (e.g., "noir thriller")
- Format (e.g., "novella")
- Premise (e.g., "A burned-out detective finds a cryptic message that reopens his biggest failure")

**Project folder created in current directory:**
- If you ran `/new-project` from `~/writing`, creates `~/writing/midnight-noir/`
- Full folder structure scaffolded and ready

### 2. Start with Brainstorming

```bash
cd midnight-noir
/brainstorm
```

Explore your protagonist, setting, and opening problem.

### 3. Write Your First Scene

```bash
/new-scene
```

Choose to write it yourself or have AI generate options.

### 4. Reverse Outline

```bash
/summarize
```

After writing 3-5 scenes, create a reverse outline to see what's emerging.

### 5. Cycle Back When Needed

```bash
/cycle
```

When you write a payoff (scene 24: "Martha grabs the shotgun from her trunk"), cycle back to plant the setup (scene 11: "Martha puts shotgun in trunk").

### 6. Navigate and Manage Scenes

```bash
/scenes list          # See all scenes
/scenes read 12       # Read specific scene
/scenes search "shotgun"  # Find references
```

As your story grows, use scene navigation to track elements and maintain continuity.

### 7. Reorder If Structure Emerges

```bash
/reorder
```

If you discover a better sequence (e.g., grouping POV scenes), reorder scenes while maintaining all references.

### 8. Repeat Until Done

The workflow is cyclical:
- Write scenes when inspired
- Brainstorm when stuck
- Cycle back to plant setups
- Navigate scenes to maintain context
- Summarize to see the shape
- Update codex as elements emerge
- Reorder if structure reveals itself

### 9. Compile and Publish

```bash
/compile
/blurb
/cover
```

## Tips for Discovery Writing

### Trust the Process
- Don't plan the ending
- Let characters make their own choices
- Follow the energy of the story
- Embrace surprises

### Use the Codex Organically
- Don't pre-populate everything
- Add entries as they emerge in scenes
- Keep it practical, not exhaustive
- Copy for series continuity

### Leverage AI Smartly
- Claude for creative decisions
- Gemini for mechanical summarizing
- Generate multiple options
- Pick what resonates with your vision

### Clean First Drafts
- Write forward, don't revise
- Fix only glaring errors
- Trust your storytelling instinct
- Cycling is setup, not rewriting
- Save rewriting for editorial guidance

### Scene Management
- Use `/scenes` to navigate and search
- Use `/cycle` to plant discovered elements
- Use `/reorder` when structure emerges
- These are finishing tools, not revision

## Series Writing

For a series:

1. Complete first book
2. Copy the `codex/` folder to new project
3. Run `/new-project` for book 2
4. Replace the new codex folder with copied one
5. Maintain continuity across books

## Technical Requirements

### Required
- Claude Code CLI
- Gemini CLI (for `/summarize`)
- **claude-mem plugin** (for persistent context across sessions)

### Optional
- `pandoc` (for DOCX/EPUB export)
- Git (for version control)

## File Naming Conventions

- **Scenes**: `scene-001.md`, `scene-002.md`, etc.
- **Summaries**: `summary-scene-001.md` or `reverse-outline-scenes-001-to-010.md`
- **Brainstorms**: `brainstorm-[date]-[topic].md`
- **Manuscripts**: `[project-name]-manuscript.md`

## Philosophy Notes

This system is inspired by:
- **Dean Wesley Smith**: Writing Into the Dark, clean first drafts
- **Pulp writers**: High volume, forward momentum, publish frequently
- **Discovery writing**: Trust the muse, follow the story
- **Modern tools**: Leverage AI without losing creative control

## Troubleshooting

### claude-mem Not Working?

**Check if claude-mem is running:**
```bash
# View installed plugins
/plugin list

# Check worker service status
npm run worker:logs --prefix ~/.claude-mem
```

**Common issues:**

1. **No context appearing in new sessions:**
   ```bash
   # Restart the worker
   cd ~/.claude-mem
   npm run worker:restart
   ```

2. **Worker not starting:**
   ```bash
   # Check logs for errors
   npm run worker:logs --prefix ~/.claude-mem

   # Reinstall if needed
   /plugin uninstall claude-mem
   /plugin install claude-mem
   ```

3. **Search tools not available:**
   - Ensure you've restarted Claude Code after installation
   - Check that MCP is enabled (it should be by default)

4. **Context seems incomplete:**
   - claude-mem captures from installation forward, not retroactively
   - Do a "seeding session" (run `/status`, `/scenes list`, mention key details)
   - Wait for a few sessions to build up context

**Database location:**
- Context database: `~/.claude-mem/claude-mem.db`
- Logs: `~/.claude-mem/logs/`
- Configuration: `~/.claude-mem/.env`

**For more help:**
- [claude-mem documentation](https://github.com/thedotmack/claude-mem/tree/main/docs)
- [Troubleshooting guide](https://github.com/thedotmack/claude-mem/blob/main/docs/troubleshooting.mdx)

## Support

All commands include detailed help. Each slash command explains:
- What it does
- What options are available
- How it integrates with the system
- Next steps after completion

## Additional Documentation

- **[CONTEXT-MANAGEMENT.md](CONTEXT-MANAGEMENT.md)** - Deep dive into how context persists across sessions, claude-mem usage, and best practices
- **[QUICK-START.md](QUICK-START.md)** - Condensed guide with all commands and workflows
- **[IMPORTING-GUIDE.md](IMPORTING-GUIDE.md)** - How to import existing manuscripts

## Next Steps

- **First time?** Read [QUICK-START.md](QUICK-START.md) for installation
- **Existing project?** See [CONTEXT-MANAGEMENT.md](CONTEXT-MANAGEMENT.md) for claude-mem setup
- Run `/new-project` to create your first story
- Read the command files in `.claude/commands/` for detailed usage
- Experiment with the workflow
- Write into the dark!

---

**Remember**: The system serves the story. You're the writer. AI is your assistant. Trust your instincts, follow your characters, and write!
