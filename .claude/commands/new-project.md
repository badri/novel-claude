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

## 6. Create .devrag-config.json

Copy from template at `/Users/lakshminp/nc/.devrag-config.json.template`, replacing:
- `{{PROJECT_NAME}}` with the project name
- `{{CREATED_DATE}}` with current date (ISO format)
- `{{GENRE}}` with the genre

## 7. Create .gitignore

Copy from template at `/Users/lakshminp/nc/.gitignore.template` (ensures .devrag/ folder is not tracked)

## 8. Create .claude folder and copy configuration

Create `.claude/` folder in the new project:
```
[project-name]/.claude/
├── settings.json          # Copy from /Users/lakshminp/nc/.claude/settings.json
└── hooks/
    └── log-interaction.sh # Copy from /Users/lakshminp/nc/.claude/hooks/log-interaction.sh
```

This ensures:
- Session tracking works automatically (SessionStart/SessionEnd hooks)
- User interactions are logged (UserPromptSubmit hook)
- Session cleanup and git commits happen automatically

**Important**: Make the hook script executable: `chmod +x .claude/hooks/log-interaction.sh`

## 9. Output Summary

After creation, tell the user:
- ✓ Project created at: `[path]`
- ✓ DevRag vector search configured
- ✓ Session tracking and interaction logging enabled (automatic)
- Next steps:
  - `cd [project-name]` to enter project
  - Run `claude` to start (sessions auto-start/end via hooks)
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
