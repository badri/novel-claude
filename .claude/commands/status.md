# Project Status

Display current status and statistics for the writing project.

## Task

1. **Read project data**:
   - Load project.json
   - Count files in scenes/ folder
   - Count files in summaries/ folder
   - Count files in brainstorms/ folder
   - Calculate total word count from all scenes

2. **Display comprehensive status**:

```markdown
# Project Status: [Project Name]

**Genre**: [genre]
**Format**: [short story/novella/novel]
**Status**: [in-progress/first-draft-complete/revision/ready]

## Writing Progress

- **Scenes Written**: [number]
- **Current Scene**: [latest scene number]
- **Total Words**: [count]
- **Estimated Pages**: [count / 250] pages
- **Target**: [if set, or "Discovery writing (no target)"]

## Reverse Outline

- **Scenes Summarized**: [number] of [total]
- **Last Summarized**: Scene [number]
- **Full Reverse Outline**: [Yes/No]

## Worldbuilding

- **Characters Tracked**: [count from codex/characters.md]
- **Locations Tracked**: [count from codex/locations.md]
- **Timeline Entries**: [count from codex/timeline.md]
- **Brainstorm Sessions**: [count from brainstorms/]

## Recent Activity

- **Last Modified**: [date from project.json]
- **Last Scene**: [scene number] - [word count] words
- **Last Brainstorm**: [most recent brainstorm file]
- **Last Summary**: [most recent summary file]

## Manuscript

- **Compiled**: [Yes/No - check manuscript/ folder]
- **Last Compilation**: [date if exists]
- **Formats Available**: [MD/DOCX/EPUB]

## Next Steps

[Suggest what to do next based on status]:
- [ ] Write next scene (/new-scene)
- [ ] Summarize recent scenes (/summarize)
- [ ] Brainstorm what comes next (/brainstorm)
- [ ] Update codex with new elements (/codex)
- [ ] Compile manuscript (/compile)
- [ ] Generate blurb (/blurb)
- [ ] Design cover (/cover)

---

**Project Path**: [full path to project]
**Created**: [creation date]
**Days Active**: [days since creation]
**Average Words/Day**: [total words / days active]
```

3. **Visual progress**:

Create simple progress indicators:

```
Scene Progress: [=====>              ] 15 scenes

Word Count Goal: [Discovery writing - no goal set]
or
Word Count: [========>           ] 25,000 / 80,000 (31%)

Reverse Outline: [==============>     ] 12/15 scenes summarized
```

4. **Health check**:

Flag potential issues:
- Scenes without summaries (if > 5)
- Long time since last activity
- Missing codex entries for characters
- Scenes not compiled yet

5. **Statistics breakdown**:

Optional detailed view:
- Word count per scene (table)
- Scene length trends (average, shortest, longest)
- Writing velocity over time
- POV distribution (if tracked in scenes)

6. **Output**:
   - Display status report
   - Highlight recommended next action
   - Offer to jump into suggested command

## Quick Status

For a brief status, just show:
- Scene count and word count
- Last modified date
- Next suggested action

## Integration

- Update project.json with status check timestamp
- Use this to maintain motivation tracking
- Generate reports for writing logs
