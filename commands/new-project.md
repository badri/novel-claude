# New Fiction Project

Create a new fiction writing project with the pulp writing system for discovery writers.

**Task**: Set up a complete project structure including:

## 1. Collect Project Metadata

Ask the user for:
- **Project name** (will create folder with this name, use kebab-case)
- **Genre** (e.g., thriller, sci-fi, romance, western, noir, fantasy, mystery)
- **Story format** (short story, novella, novel - for reference only, can change)
- **Working premise/logline** (1-2 sentences: character + problem + stakes)

**Important**: The project folder will be created in the **current working directory** where Claude Code was started.

If user is in `/Users/lakshminp/writing` and runs `/new-project` with name "midnight-noir":
- Creates: `/Users/lakshminp/writing/midnight-noir/`

After creation, tell user:
- **Project location**: `/full/path/to/midnight-noir`
- **To enter project**: `cd midnight-noir`
- **To work on it**: `cd midnight-noir && claude`

## 2. Create Folder Structure

```
[project-name]/
├── project.json           # Metadata and story tracking
├── .devrag-config.json    # DevRag vector search configuration
├── .gitignore             # Git exclusions (includes .devrag/ folder)
├── scenes/                # Individual scene files (scene-001.md, scene-002.md, etc.)
│   ├── .gitkeep
│   ├── drafts/            # Experimental/out-of-order scenes
│   │   └── .gitkeep
│   └── archive/           # Deleted scenes kept for reference
│       └── .gitkeep
├── codex/                 # Worldbuilding database (copyable for series)
│   ├── characters.md
│   ├── locations.md
│   ├── timeline.md
│   ├── worldbuilding.md
│   └── lore.md
├── summaries/             # Scene summaries for reverse outlining
│   └── .gitkeep
├── brainstorms/           # Brainstorming sessions saved here
│   └── initial-brainstorm.md
├── manuscript/            # Compiled versions
│   └── .gitkeep
└── notes/                 # General story notes, ideas, research
    ├── session-interactions/  # Session conversation logs (auto-created, DevRag indexed)
    │   └── .gitkeep
    └── .gitkeep
```

## 3. Initialize project.json

Create with this structure:
```json
{
  "projectName": "",
  "genre": "",
  "format": "",
  "premise": "",
  "createdDate": "",
  "lastModified": "",
  "status": "in-progress",
  "sceneCount": 0,
  "wordCount": 0,
  "currentScene": null,
  "metadata": {
    "povCharacter": null,
    "setting": null,
    "timeframe": null
  }
}
```

## 4. Create Codex Templates

Each codex file should have helpful structure:

**characters.md**: Name, role, age, appearance, personality, goals, conflicts, arc notes
**locations.md**: Name, description, significance, atmosphere, key features
**timeline.md**: Chronological events, story timeline vs narrative timeline
**worldbuilding.md**: Rules of the world, magic systems, tech, society, culture
**lore.md**: History, myths, backstory, world events

## 5. Create Initial Brainstorm File

In `brainstorms/initial-brainstorm.md`, create template:
```markdown
# Initial Brainstorm - [Project Name]

Date: [current date]

## The Premise
[paste user's premise]

## Character
[prompt user to brainstorm the protagonist]

## Setting
[prompt user to describe the world/location]

## The Problem
[what challenge/conflict kicks off the story]

## First Scene Ideas
[possible opening scenes]
```

## 6. Locate Plugin Directory

Find the plugin installation directory:
```bash
PLUGIN_DIR=$(dirname $(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null))
```

If this doesn't work, the plugin is likely at: the directory where this command file exists.

## 7. Create .devrag-config.json

Copy from `$PLUGIN_DIR/.devrag-config.json.template`, replacing:
- `{{PROJECT_NAME}}` with the project name
- `{{CREATED_DATE}}` with current date (ISO format)
- `{{GENRE}}` with the genre

## 8. Create .gitignore

Copy from `$PLUGIN_DIR/.gitignore.template` (ensures .devrag/ folder is not tracked)

## 9. Create .mcp.json

Copy from `$PLUGIN_DIR/.mcp.json.template` to enable DevRag MCP server at project scope.

This file configures the DevRag MCP server for the project. When users start Claude in this project, they'll be prompted to approve the MCP server (one-time approval).

**Important**: This file should be committed to git so all collaborators have access to semantic search.

## 10. Create .claude folder and copy configuration

**CRITICAL**: This step enables automatic session tracking. Do not skip!

Execute these steps:

1. Create `.claude/` folder and `.claude/hooks/` subfolder in the new project
2. Copy settings.json template: `cp $PLUGIN_DIR/.claude-settings.json.template [project-name]/.claude/settings.json`
3. Copy all hook scripts from `$PLUGIN_DIR/hooks-template/` to `[project-name]/.claude/hooks/`:
   - `session-start.sh` - Auto-starts session tracking
   - `session-end.sh` - Auto-ends session, logs stats, commits work
   - `log-interaction.sh` - Logs user interactions during session
4. Make all hook scripts executable: `chmod +x [project-name]/.claude/hooks/*.sh`

**Verification**: After copying, verify these files exist and are correct:
- `[project-name]/.claude/settings.json` (should contain SessionStart, SessionEnd, UserPromptSubmit hooks)
- `[project-name]/.claude/hooks/session-start.sh` (should be executable)
- `[project-name]/.claude/hooks/session-end.sh` (should be executable)
- `[project-name]/.claude/hooks/log-interaction.sh` (should be executable)

This configuration ensures:
- **SessionStart hook**: Automatically creates session tracking on Claude start
- **SessionEnd hook**: Automatically ends session, logs stats, and commits work to git
- **UserPromptSubmit hook**: Logs all user interactions during the session
- All session management happens transparently in the background

**If this step is skipped, sessions will not auto-start/end and interactions won't be logged!**

## 11. Output Summary

After creation, tell the user:
- ✓ Project created at: `[path]`
- ✓ DevRag MCP server configured (`.mcp.json` created)
- ✓ Session tracking and interaction logging enabled (automatic)
- **Next steps**:
  - `cd [project-name]` to enter project
  - Run `claude` to start
  - **First time only**: You'll be prompted to approve the DevRag MCP server - click "Approve" to enable semantic search
  - Start brainstorming with `/brainstorm`
  - Or jump into writing with `/new-scene`
- Available commands: `/new-scene`, `/brainstorm`, `/summarize`, `/compile`
- The codex folder is copyable for series continuity
- Semantic search: Use natural language to find content across all markdown files
- Session logs: All your commands/questions are automatically captured and searchable

**Important**:
- Use absolute paths when creating files
- Initialize git repo in project folder
- Create .gitkeep files so empty folders are tracked
- DevRag will index markdown files automatically for semantic search
- The `.mcp.json` file will be created by the `claude mcp add` command above
