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

**`/setup-devrag`**
- Add DevRag vector search to existing projects
- Creates `.devrag-config.json` configuration
- Updates `.gitignore` to exclude vector database
- Enables semantic search across all markdown files
- Use for projects created before DevRag integration

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

The system uses different AI models and tools for different tasks:

- **Claude** (this): Creative writing, brainstorming, character development
- **Gemini** (via CLI): Scene summarizing, reverse outlining, continuity checking
- **DevRag**: Semantic search and vector-based context retrieval

### Gemini Summarizer Subagent

The system includes a `@gemini-summarizer` subagent that:
- Wraps the Gemini CLI for efficient summarization
- Handles large context (1M+ tokens)
- Preserves Claude tokens for creative work
- Automatically invoked by `/summarize` command

**Requirement**: `gemini-cli` must be installed and configured

### Vector Search via DevRag

DevRag provides semantic search capabilities:
- Automatic indexing of markdown files (scenes, codex, notes)
- Semantic search using natural language queries
- MCP integration for Claude Code
- Fast vector search (~100ms vs 25s for reading files)
- 40x fewer tokens than reading entire documents
- Multilingual support (100+ languages)

**MCP Tools available:**
- `search` - Semantic vector search across all documents
- `index_markdown` - Index specific files
- `list_documents` - View indexed documents
- `delete_document` - Remove from index
- `reindex_document` - Update index for changed files

**Requirement**: DevRag must be installed and configured (see setup below)

## Getting Started

### 0. One-Time Setup: Install DevRag

**For semantic search across your writing, install DevRag once:**

```bash
# Download DevRag binary for your platform
# Visit: https://github.com/tomohiro-owada/devrag/releases

# macOS (Apple Silicon example):
tar -xzf devrag-macos-apple-silicon.tar.gz
chmod +x devrag-macos-apple-silicon
sudo mv devrag-macos-apple-silicon /usr/local/bin/devrag

# Verify installation
devrag --version
```

**Configure Claude Code MCP:**

Add to `~/.claude.json` (create if it doesn't exist):

```json
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

**Notes:**
- The `~/.claude.json` file is in your home directory (global configuration)
- Each writing project has its own `.devrag-config.json` (per-project settings)
- DevRag will use the `.devrag-config.json` in whichever project directory you're working in
- If `~/.claude.json` already exists with other MCP servers, just add the `devrag` entry to the `mcpServers` object
- After editing `~/.claude.json`, restart Claude Code for changes to take effect

**What DevRag does:**
- Automatically indexes your markdown files (scenes, codex, notes)
- Provides semantic search using natural language queries
- Claude can search your story without reading all files
- 40x fewer tokens, 260x faster than traditional file reading
- Works across all your writing projects

**For existing projects:**

To add DevRag to existing writing projects created before DevRag integration:

```bash
# Navigate to your existing project
cd ~/writing/your-project-name

# Run the setup command
/setup-devrag
```

This command will:
- Create `.devrag-config.json` with your project settings
- Update `.gitignore` to exclude the `.devrag/` folder
- Configure semantic search for all markdown files
- Test the search functionality

**Manual setup (if needed):**

If you prefer manual setup, create `.devrag-config.json`:

```json
{
  "name": "your-project-name",
  "description": "Fiction writing project - semantic search across scenes, codex, and notes",
  "indexPaths": [
    "scenes/**/*.md",
    "codex/**/*.md",
    "notes/**/*.md",
    "brainstorms/**/*.md",
    "summaries/**/*.md"
  ],
  "excludePaths": [
    "scenes/drafts/**",
    "scenes/archive/**",
    "manuscript/**",
    ".git/**"
  ],
  "chunkSize": 1000,
  "chunkOverlap": 200,
  "updateInterval": "on-save",
  "metadata": {
    "type": "fiction-project",
    "created": "2025-01-15T10:30:00Z",
    "genre": "thriller"
  }
}
```

Then add to `.gitignore`:
```
# DevRag vector database (derivative data, regenerated from markdown)
.devrag/
```

**Usage:**

DevRag indexes automatically when you use semantic search. Just ask natural language questions:
- "Where did I mention the magic system?"
- "Which scenes feature Detective Morgan?"
- "Find all references to the ancient prophecy"

**Tip:** DevRag watches for file changes and auto-reindexes. Just write normally!

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
- **DevRag** (for semantic search and vector-based context retrieval)

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

### DevRag Not Working?

**Check if DevRag is running:**
```bash
# Verify DevRag is installed
devrag --version

# Test configuration
devrag --config .devrag-config.json list
```

**Common issues:**

1. **Search not working in Claude:**
   - Ensure `~/.claude.json` has the devrag MCP server configured
   - Restart Claude Code after MCP configuration changes
   - Check MCP is enabled: `/mcp` command should show devrag tools

2. **Files not being indexed:**
   ```bash
   # Check your .devrag-config.json paths
   cat .devrag-config.json

   # Manually trigger reindex
   devrag --config .devrag-config.json
   ```

3. **Model download issues:**
   - First run downloads embedding models from Hugging Face
   - Requires internet connection
   - Check proxy settings if behind firewall:
     ```bash
     export HTTP_PROXY=http://your-proxy:port
     export HTTPS_PROXY=http://your-proxy:port
     ```

4. **Performance issues:**
   - DevRag auto-detects GPU/CPU
   - For lower memory usage, set CPU mode in config:
     ```json
     {
       "compute": {
         "device": "cpu",
         "fallback_to_cpu": true
       }
     }
     ```

**Database location:**
- Vector database: `./.devrag/vectors.db` (in project directory)
- Gitignored (regenerable from markdown files)

**For more help:**
- [DevRag documentation](https://github.com/tomohiro-owada/devrag)
- [DevRag releases](https://github.com/tomohiro-owada/devrag/releases)

## Support

All commands include detailed help. Each slash command explains:
- What it does
- What options are available
- How it integrates with the system
- Next steps after completion

## Additional Documentation

- **[CONTEXT-MANAGEMENT.md](CONTEXT-MANAGEMENT.md)** - Deep dive into context management, DevRag vector search, and best practices
- **[QUICK-START.md](QUICK-START.md)** - Condensed guide with all commands and workflows
- **[IMPORTING-GUIDE.md](IMPORTING-GUIDE.md)** - How to import existing manuscripts

## Next Steps

- **First time?** Read [QUICK-START.md](QUICK-START.md) for installation
- **Existing project?** See [CONTEXT-MANAGEMENT.md](CONTEXT-MANAGEMENT.md) for DevRag setup
- Run `/new-project` to create your first story
- Read the command files in `.claude/commands/` for detailed usage
- Experiment with the workflow
- Write into the dark!

---

**Remember**: The system serves the story. You're the writer. AI is your assistant. Trust your instincts, follow your characters, and write!
