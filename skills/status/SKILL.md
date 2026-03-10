---
name: status
description: Use when the user wants a project snapshot — total word count, scene count, progress toward goal, or overall project health. Trigger on: "how am I doing", "project status", "word count", "how far am I", "show me the stats".
---

# Project Status

Display current status and statistics for the writing project.

## Task

1. **Read project data**:
   - Load project.json
   - Count files in scenes/ folder
   - Count files in summaries/ folder
   - Count files in brainstorms/ folder
   - Calculate total word count from all scenes
   - Check for active writing session (notes/current-session.json)
   - Load session log (notes/session-log.json) if exists

2. **Display comprehensive status**:

```markdown
# Project Status: [Project Name]

**Genre**: [genre]
**Format**: [short story/novella/novel]
**Status**: [in-progress/first-draft-complete/revision/ready]

## Active Session (if session running)

📝 **Writing Session Active**
- Started: [time] ([duration] ago)
- Goal: [session goal]
- Progress: +[words written this session] words
- Scenes this session: +[scenes created]

---

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

## Session Statistics (if session log exists)

📊 **Writing Sessions**
- Total sessions: [count]
- Total time: [hours]h [minutes]m
- Total words: [count]
- Average: [words/session] words/session
- Current streak: [days] 🔥

**This Week**: [sessions] sessions, [words] words
**Last session**: [date] ([words] words, [duration])

---

## Next Steps

[Suggest what to do next based on status]:
- [ ] Start writing session
- [ ] Write next scene
- [ ] Summarize recent scenes
- [ ] Brainstorm what comes next
- [ ] Update codex with new elements
- [ ] Compile manuscript
- [ ] Generate blurb
- [ ] Design cover

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

5. **Output**:
   - Display status report
   - Highlight recommended next action
   - Offer to jump into suggested workflow
