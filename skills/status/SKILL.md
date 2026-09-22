---
name: status
description: Use when the user wants a project snapshot — word count, scene count, pace against Pulp Speed, or overall project health. Trigger on: "how am I doing", "project status", "word count", "how far am I", "show me the stats", "what's my pace".
---

# Project Status

Snapshot of the project and the writer's pace. Words per day come from git,
not from session tracking — git already knows when words landed.

## Task

1. **Read project data**:
   - `project.json`
   - **`ORDER.md`** — it defines the manuscript. Count and sum the scenes
     listed under `## Reading order` (placed scenes, the source of the word
     count). Count `## Unplaced / drafts` and `## Cut` separately.
   - Files in `scenes/drafts/`, `summaries/`, `brainstorms/`
   - `manuscript/` — is there a compile, a blurb, a cover brief, upload
     sheets?

2. **Run the two scripts** (Claude Code; under omp use `~/nc/scripts/...`):

   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/utils/order-check.sh .    # consistency
   ${CLAUDE_PLUGIN_ROOT}/scripts/utils/pace.sh . 7 30      # words/day from git
   ```

3. **Display**:

```markdown
# [Project Name] — [genre], [format]

**Status**: [from project.json]

## Manuscript
- Placed scenes: [N]  ·  words (placed, prose only): [N]  ·  ~[pages] pages
- Unplaced / drafts: [N]  ·  Cut: [N]
- Last stable ID created: [scene-NNN]
- Target: [if set, else "discovery writing — no target"]

## Pace (from git)
- Last 7 days: +[N] words → [N]/day ([N]% of Pulp 1)
- Last 30 days: +[N] words → [N]/day ([N]% of Pulp 1)
- Pulp 1 = 1,000,000 words/year ≈ 2,740/day. Sprint writers run 0 on most
  days and 10k on some — the 30-day line is the honest one.

## Health
[order-check findings, or "clean"]
- Stale `ORDER.md` lines / scenes without summaries, if the deep outline is
  being used
- Days since last commit: [N]

## Publication assets
- Compiled: [yes/no, date]  ·  Blurb: [yes/no]  ·  Cover brief: [yes/no]
- Upload sheets: [kdp / d2d / notion press — present or not]

## Next
[One recommended action, from the state above — e.g. "write the next scene",
"the draft is complete: blurb, then cover, then publish".]
```

4. **Keep it to one screen.** No progress bars, no streaks, no session
   history. The number that matters is words per day; the rest is context.
