# Scene Navigator

Browse, read, search, and manage all scenes in your project.

## Usage

- `/scenes` or `/scenes list` - List all active scenes
- `/scenes --drafts` - List draft scenes
- `/scenes --archive` - List archived scenes
- `/scenes --all` - List all scenes (active + drafts + archive)
- `/scenes read [number]` - Read specific scene(s)
- `/scenes search [query]` - Search scenes
- `/scenes promote [draft-name]` - Move draft to active scenes
- `/scenes archive [scene-number]` - Archive a scene

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

**Default**: `/scenes` or `/scenes list` shows only active scenes
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
| ... | ... | ... | ... | ... | ... |

Legend:
✓ = Summarized
Draft = Not yet summarized
🔄 = Modified since last summary
```

**Draft Scenes** (`scenes/drafts/`):
```markdown
# Draft Scenes - [Project Name]

Total Drafts: [count]
Total Words: [count] (not in manuscript)

| Name | POV | Location | Words | Created | Notes |
|------|-----|----------|-------|---------|-------|
| villain-backstory | Marcus | Warehouse | 1,456 | 2025-10-25 | Alternate timeline |
| flashback-experiment | Martha | School | 892 | 2025-10-26 | Childhood memory |
| alternate-ending-v1 | Martha | Border | 2,134 | 2025-10-27 | Happy ending version |
| ... | ... | ... | ... | ... | ... |

Use `/scenes promote [name]` to move to active scenes
```

**Archived Scenes** (`scenes/archive/`):
```markdown
# Archived Scenes - [Project Name]

Total Archived: [count]

| Original # | Name | Words | Archived | Reason |
|------------|------|-------|----------|--------|
| 015 | Confrontation at warehouse | 1,234 | 2025-10-28 | Cut for pacing |
| 023 | Flashback to childhood | 891 | 2025-10-29 | Replaced with draft version |
| ... | ... | ... | ... | ... |

Archived scenes preserved in scenes/archive/ for reference
```

**How to extract info**:
- Read each scene file's header (POV, Location, Time)
- Count words in each scene
- Check if corresponding summary exists
- Extract first line of content as mini-summary

**Options**:
- `--full`: Show longer summaries
- `--by-pov`: Group by POV character
- `--by-location`: Group by setting
- `--range=X-Y`: Show only scenes X through Y

### Read Scene(s)

Ask user which scene(s) to read:
- Single: "Scene 12"
- Multiple: "Scenes 5, 8, 12"
- Range: "Scenes 10-15"
- Last N: "Last 3 scenes"
- Current: "Latest scene"

**Display format**:

```markdown
# Scene 012

**POV**: Martha
**Location**: Border checkpoint
**Time**: Night, Tuesday

---

[Full scene content]

---

**Metadata**:
- Words: 1,234
- Status: Draft
- Created: 2025-10-20
- Modified: 2025-10-22
- Summary: summaries/summary-scene-012.md
- Cycles: None

**Context**:
- Previous: Scene 011 - Martha packs the car
- Next: Scene 013 - Martha crosses into Mexico
```

**Options**:
- `--with-summary`: Include the summary alongside
- `--with-context`: Show previous/next scenes too
- `--metadata-only`: Just show the header info

### Search Scenes

Search across all scenes for:
- **Content**: Text/dialogue search
- **Character**: Scenes featuring a character
- **Location**: Scenes at a specific place
- **POV**: All scenes from a character's POV
- **Date range**: Scenes written in a time period

**Examples**:

User: "Find scenes with Marcus"
→ Search character mentions + POV field

User: "Scenes at the safehouse"
→ Search location field + content

User: "Where did I mention the blue car?"
→ Full text search across all scenes

**Output**:
```markdown
# Search Results: "shotgun"

Found in 3 scenes:

## Scene 011 - Martha packs the car
**Match**: "...grabbed the shotgun from the closet..."
[Show context around match]

## Scene 024 - At the checkpoint
**Match**: "...Martha popped the trunk and grabbed the Remington shotgun..."
[Show context around match]

## Scene 031 - Final confrontation
**Match**: "...the shotgun felt heavy in her hands..."
[Show context around match]
```

### Jump to Scene

Quick navigation:
- "Jump to scene 15" → Opens scene 015
- "Jump to latest" → Opens current scene
- "Jump to first" → Opens scene 001

Displays the scene and asks:
- Read another?
- Edit this scene?
- Cycle back from here?
- Return to writing?

### Scene Info

Show detailed metadata for a scene:

```markdown
# Scene 012 - Details

**Basic Info**:
- Number: 012
- Title: [if scene has a title]
- POV: Martha
- Location: Border checkpoint
- Time: Night, Tuesday

**Statistics**:
- Words: 1,234
- Characters: 6,543
- Paragraphs: 45
- Dialogue lines: 23

**Story Position**:
- Previous: Scene 011 (Martha packs the car)
- Next: Scene 013 (Crossing into Mexico)
- Chapter: [if assigned]

**References**:
- Characters: Martha, Border Guard (Carlos)
- Locations: Border checkpoint, Martha's car
- Objects: Shotgun, fake papers

**History**:
- Created: 2025-10-20 14:30
- Last Modified: 2025-10-22 09:15
- Cycles: 1 (added shotgun plant from scene 024)
- Summarized: Yes (2025-10-21)
- Summary needs update: No

**Files**:
- Scene: scenes/scene-012.md
- Summary: summaries/summary-scene-012.md
- Related brainstorm: brainstorms/brainstorm-2025-10-20-checkpoint.md
```

## Implementation

### Reading scene headers

Expected scene file format:
```markdown
# Scene XXX

**POV**: [character]
**Location**: [setting]
**Time**: [when]

---

[Scene content]

---

**Notes**:
- Word count: [auto-calculated]
- Status: draft/summarized/revised
- Date: [date]
```

Parse this structure to extract metadata.

### Word counting

Use `wc -w` or similar to count words in scene content (exclude metadata).

### Checking summaries

Look for matching file in `summaries/` folder:
- `summary-scene-XXX.md` = summarized
- No match = not summarized
- Scene modified date > summary date = needs update

### Smart suggestions

Based on what user is viewing, suggest:
- "Scene 12 hasn't been summarized yet - run /summarize?"
- "Scene 15 was modified after summarizing - update summary?"
- "You're at scene 20 - might be time to /compile and review?"

## Output Format

- Clear, scannable lists
- Easy navigation between scenes
- Quick access to related files (summaries, brainstorms)
- Contextual next actions

## Integration

- Links to `/read` for deep reading
- Links to `/cycle` for modifications
- Links to `/summarize` for unsummarized scenes
- Links to `/chat` to discuss specific scenes
- Updates scene metadata when viewed

## Example Workflow

```
User: /scenes

System: How would you like to browse scenes?
        [List all | Read specific | Search | Jump to scene]

User: List all

System: [Shows scene index table with 24 scenes]

User: Read scene 12

System: [Displays scene 012 with full content and metadata]

        Previous: Scene 011 - Martha packs the car
        Next: Scene 013 - Crossing into Mexico

        What next?
        [Read another | Edit | Cycle | Continue writing]

User: Search for "shotgun"

System: [Shows 3 scenes with shotgun mentions]

        This shows your cycle in action:
        - Scene 011: Setup (shotgun planted)
        - Scene 024: Payoff (shotgun retrieved)
        - Scene 031: Use (shotgun in action)
```

### Promote Draft to Active Scene

**Usage**: `/scenes promote [draft-name]`

Move a draft scene from `scenes/drafts/` to active `scenes/` folder.

**Process**:
1. Ask user which draft to promote (if not specified)
2. Ask where to insert in active scenes:
   - At end (becomes next scene number)
   - After scene N (insert and renumber subsequent scenes)
   - At beginning (becomes scene-001, renumber all)
3. **Renumber if needed**:
   - If inserting mid-sequence, renumber all scenes after insertion point
   - Example: Promoting to after scene-005:
     - `draft-flashback.md` → `scene-006.md`
     - Old `scene-006.md` → `scene-007.md`
     - Old `scene-007.md` → `scene-008.md` (etc.)
4. **Update scene file**:
   - Change `**Status**: draft` to `**Status**: active`
   - Update header to reflect new scene number
5. **Update project.json**:
   - Increment sceneCount
   - Update wordCount (now includes promoted scene)
   - Update currentScene if promoting at end
6. **Confirm success**:
   - Show before/after scene numbers
   - Show new file path
   - Warn if this affects summaries (need to regenerate)

**Example**:
```
User: /scenes promote villain-backstory

System: Where should this scene go?
        1. At end (becomes scene-025)
        2. After scene 018 (insert as 019, renumber rest)
        3. At beginning (becomes 001, renumber all)

User: 2

System: Promoting scenes/drafts/villain-backstory.md...

        Renumbering:
        ✓ villain-backstory.md → scene-019.md
        ✓ scene-019.md → scene-020.md
        ✓ scene-020.md → scene-021.md
        ✓ scene-021.md → scene-022.md
        (4 scenes renumbered)

        ✓ Updated project.json (scene count: 24 → 25)
        ✓ Word count: +1,456 words

        ⚠ Summaries after scene 018 may need regeneration

        Scene 019 is now active!
```

### Archive Scene

**Usage**: `/scenes archive [scene-number]`

Move an active scene to `scenes/archive/` (deleted but kept for reference).

**Process**:
1. Ask user which scene to archive (if not specified)
2. **Confirm deletion**:
   - Show scene title/summary
   - Warn this will renumber subsequent scenes
   - Ask for confirmation
3. **Move to archive**:
   - Rename: `scene-015.md` → `scene-015-archived-YYYYMMDD.md`
   - Move to `scenes/archive/`
4. **Renumber subsequent scenes**:
   - `scene-016.md` → `scene-015.md`
   - `scene-017.md` → `scene-016.md` (etc.)
5. **Update project.json**:
   - Decrement sceneCount
   - Update wordCount (subtract archived scene words)
   - Update currentScene if needed
6. **Confirm success**:
   - Show archived file path
   - Show renumbering summary
   - Remind user archived scene is in archive/ if they need it later

**Example**:
```
User: /scenes archive 15

System: Archive scene 015?

        Title: "Confrontation at the warehouse"
        Words: 1,234
        POV: Marcus

        This will:
        - Move to scenes/archive/scene-015-archived-20251101.md
        - Renumber scenes 016-025 → 015-024

        Continue? [y/n]

User: y

System: Archiving scene 015...

        ✓ Moved to scenes/archive/scene-015-archived-20251101.md

        Renumbering:
        ✓ scene-016.md → scene-015.md
        ✓ scene-017.md → scene-016.md
        ...
        ✓ scene-025.md → scene-024.md
        (10 scenes renumbered)

        ✓ Updated project.json (scene count: 25 → 24)
        ✓ Word count: -1,234 words

        Scene archived! You can find it in scenes/archive/ if needed.
```

## Tips

- Use `/scenes list` frequently to see the big picture
- Use `/scenes --drafts` to review experimental scenes
- Use `/scenes search` to track elements through the story
- Use `/scenes read` to refresh context before writing
- Use `/scenes promote` when a draft scene is ready for the manuscript
- Use `/scenes archive` for deleted scenes (keeps them for reference)
- Scene navigator helps you see the emerging story shape

This complements the reverse outline (summaries) with direct scene access.
