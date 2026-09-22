---
name: status
description: Use when the user wants a project snapshot — total word count, scene count, progress toward goal, or overall project health. Trigger on: "how am I doing", "project status", "word count", "how far am I", "show me the stats".
---

# Project Status

Display current status and statistics for the writing project.

## Task

1. **Read project data**:
   - Load project.json
   - **Read `ORDER.md`** — it defines the manuscript. Count and sum the scenes
     listed under `## Reading order` (those are the active/placed scenes and
     the source of the word count). Count `## Unplaced / drafts` and `## Cut`
     separately.
   - Count files in `scenes/drafts/` (drafts not listed in `ORDER.md`)
   - Count files in summaries/ folder
   - Count files in brainstorms/ folder
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

- **Scenes Placed** (in `ORDER.md` reading order): [number]
- **Drafts**: [number] ([number] not yet placed)
- **Current Scene**: [highest stable ID created, from project.json]
- **Total Words** (placed scenes only): [count]
- **Draft Words**: [count] — not part of the manuscript, reported separately
- **Estimated Pages**: [placed words / 250] pages
- **Target**: [if set, or "Discovery writing (no target)"]

## Reading Order

- **Ordered Scenes**: [number] in `ORDER.md`
- **Unplaced / Drafts**: [number]
- **Cut**: [number] (IDs retired, files kept)
- **Lightweight Reverse Outline**: `ORDER.md` (kept current by the writing)
- **Deep Reverse Outline**: [Yes/No — check `summaries/`]

## Reverse Outline

- **Scenes Summarized**: [number] of [placed total]
- **Last Summarized**: [stable ID or reading position]
- **Stale `ORDER.md` lines**: [number, if any] — offer to refresh via `summarize`

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
- Scenes on disk that aren't in `ORDER.md` (unplaced — they won't compile)
- `[scene-NNN]` in `ORDER.md` with no file on disk
- Surviving annotation tags in any scene (`<brief>`, `<cut>`, `<change>`,
  `<keep>`, `<add>`, `<flow>`, `<q>`) — these block compile

  Run `${CLAUDE_PLUGIN_ROOT}/scripts/utils/order-check.sh .` (Claude Code) or
  `~/nc/scripts/utils/order-check.sh .` (omp) and surface its findings.
- Scenes without summaries (if > 5)
- Unplaced drafts sitting for a long time
- Long time since last activity
- Missing codex entries for characters
- Scenes not compiled yet

5. **Output**:
   - Display status report
   - Highlight recommended next action
   - Offer to jump into suggested workflow
