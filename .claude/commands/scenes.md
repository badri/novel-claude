# Scene Navigator

Browse, read, search, and manage all scenes in your project.

## Task

1. **Determine action** (ask user or infer):
   - **List**: Show all scenes with summaries
   - **Read**: Display specific scene(s)
   - **Search**: Find scenes by content, character, location
   - **Jump**: Quick navigation to a scene number
   - **Info**: Show scene metadata and stats

## Actions

### List All Scenes

Display scene index with key information:

```markdown
# Scene Index - [Project Name]

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

## Tips

- Use `/scenes list` frequently to see the big picture
- Use `/scenes search` to track elements through the story
- Use `/scenes read` to refresh context before writing
- Scene navigator helps you see the emerging story shape

This complements the reverse outline (summaries) with direct scene access.
