---
name: scenes
description: Use when the user wants to see what they've written, review the scene list, check scene titles or word counts, or get an overview of the manuscript structure. Trigger on: "what scenes do I have", "show me my scenes", "scene list", "what have I written", "how many scenes".
---

# Scene Navigator

Browse, read, search, and manage all scenes in your project.

## Usage

- List all active scenes
- List draft scenes (`--drafts`)
- List archived scenes (`--archive`)
- List all scenes (active + drafts + archive) (`--all`)
- Read specific scene(s)
- Search scenes
- Promote draft to active scenes
- Archive a scene

## Task

1. **Determine action** (ask user or infer):
   - **List**: Show all scenes with summaries
   - **Read**: Display specific scene(s)
   - **Search**: Find scenes by content, character, location
   - **Jump**: Quick navigation to a scene number
   - **Info**: Show scene metadata and stats
   - **Promote**: Move draft scene to active scenes (with renumbering)
   - **Archive**: Move active scene to archive (with renumbering)

## Actions

### List All Scenes

Display scene index with key information.

**Default**: shows only active scenes
**Flags**:
- `--drafts` - Show only draft scenes
- `--archive` - Show only archived scenes
- `--all` - Show all (active + drafts + archive)

**Active Scenes** (`scenes/`):
```markdown
# Active Scenes - [Project Name]

Total Scenes: [count]
Total Words: [count]

| # | POV | Location | Words | Status | Summary |
|---|-----|----------|-------|--------|---------|
| 001 | Martha | Home | 1,234 | ✓ | Martha receives the letter... |
| 002 | Martha | Diner | 891 | ✓ | She meets with Jack... |
| 003 | Jack | Office | 1,456 | ✓ | Jack discovers the files... |
| 004 | Martha | Highway | 1,112 | Draft | Martha drives north... |
```

**How to extract info**:
- Read each scene file's header (POV, Location, Time)
- Count words in each scene
- Check if corresponding summary exists
- Extract first line of content as mini-summary

### Read Scene(s)

Ask user which scene(s) to read:
- Single: "Scene 12"
- Multiple: "Scenes 5, 8, 12"
- Range: "Scenes 10-15"
- Last N: "Last 3 scenes"
- Current: "Latest scene"

### Search Scenes

Use the Grep tool to search across all scenes for:
- **Content**: Text/dialogue search
- **Character**: Scenes featuring a character
- **Location**: Scenes at a specific place
- **POV**: All scenes from a character's POV

### Promote Draft to Active Scene

Move a draft scene from `scenes/drafts/` to active `scenes/` folder.

**Process**:
1. Ask user which draft to promote (if not specified)
2. Ask where to insert in active scenes:
   - At end (becomes next scene number)
   - After scene N (insert and renumber subsequent scenes)
   - At beginning (becomes scene-001, renumber all)
3. **Before renumbering, confirm with user**:
   "This will rename [N] scene files. Proceed? (y/n)"
   Only proceed if confirmed.
4. **Update scene file**: Change status to `active`, update header
5. **Update project.json**: Increment sceneCount, update wordCount

### Archive Scene

Move an active scene to `scenes/archive/` (deleted but kept for reference).

**Process**:
1. Ask user which scene to archive (if not specified)
2. **Confirm deletion**:
   - Show scene title/summary
   - Warn this will renumber subsequent scenes
   - Ask for confirmation: "This will rename [N] scene files. Proceed? (y/n)"
   Only proceed if confirmed.
3. **Move to archive**: Rename with `-archived-YYYYMMDD` suffix
4. **Renumber subsequent scenes**
5. **Update project.json**

## Tips

- Use list frequently to see the big picture
- Use `--drafts` to review experimental scenes
- Use search to track elements through the story
- Use promote when a draft scene is ready for the manuscript
- Use archive for deleted scenes (keeps them for reference)
