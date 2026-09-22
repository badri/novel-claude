---
name: reorder
description: Use when the user wants to restructure, reorganize, or change the reading order of scenes. Trigger on: "move scene X before Y", "reorder", "restructure", "scene X should come first", "swap scenes N and M", "this scene reads later".
---

# Reorder Scenes

Change the **reading order** of the manuscript.

## The rule

**Reorder = edit the list in `ORDER.md`. Nothing else.**

Scene filenames are **stable IDs assigned in creation order**. This skill
**NEVER renames, renumbers, moves, or edits a scene file.** The 9th scene
written stays `scenes/scene-009.md` whether it reads 2nd or 70th.

This is the point of the system: the writer is a pantser who writes out of
order, and renaming files every time a scene moves would churn git history,
break every `[scene-NNN]` reference in the codex and notes, and destroy the
link between an ID and the moment it was written.

The retired `scripts/utils/renumber-scenes.sh` exists only to fail loudly if
anything still calls it. Never invoke it.

## Task

1. **Read `ORDER.md`** — the source of truth. Note the current `## Reading
   order` list, the `## Unplaced / drafts` section, and any locked placement
   constraints in the header notes (e.g. "this must precede that").

2. **Take the request.** It can be phrased against **positions** ("move the
   scene at position 5 to after 3"), against **stable IDs** ("move 019 before
   017"), or structurally ("the flashback cluster should run after the case
   reopens"). If positions are involved, resolve them to `[scene-NNN]` IDs
   first and confirm which scenes you mean — positions shift, IDs don't.

3. **Show the proposed new list before applying it.** Print the whole
   `## Reading order` list, with a `[was at N]` marker on moved lines:

   ```markdown
   # Reorder Preview — ORDER.md

   ## Current reading order
   1. [scene-001] — Martha receives the letter
   2. [scene-002] — Martha meets Jack
   3. [scene-003] — Jack discovers the files
   4. [scene-004] — Martha drives north
   5. [scene-005] — Jack confronts his boss

   ## Proposed reading order (move [scene-005] to position 4)
   1. [scene-001] — Martha receives the letter
   2. [scene-002] — Martha meets Jack
   3. [scene-003] — Jack discovers the files
   4. [scene-005] — Jack confronts his boss        [was 5 — unmoved file, new position]
   5. [scene-004] — Martha drives north            [was 4]

   File names are NOT touched. Chapters are reading positions: this moves
   [scene-005] from chapter 5 to chapter 4 on the next compile.
   ```

   Call out anything the change breaks: a "must precede" constraint from the
   header, a placement note on a moved line, a cliffhanger that now lands
   wrong, an Unplaced scene that should have been considered.

4. **Wait for approval.** Reordering is structure discovery — the author
   decides. Only write the file once they say go.

5. **Apply the edit to `ORDER.md`**:
   - Reorder (or insert/remove) the lines in the `## Reading order` list
   - Renumber the **list positions** (1., 2., 3., …) so they stay consecutive
   - **Never touch the `[scene-NNN]` IDs themselves**
   - Moving a scene out of the manuscript entirely: move its line to `## Cut`,
     keep the ID retired, note the archive path, and note it in `notes/`
   - Promoting an Unplaced scene: move its line up into the reading order
     (see the `scenes` skill)
   - Keep each line's one-sentence reverse outline intact and true

6. **Log to `notes/reorders.md`** (append):

   ```markdown
   ## [YYYY-MM-DD] — [short description]

   - **Type**: move | swap | resequence
   - **Change**: [scene-005] from position 5 → position 4
   - **Unchanged**: no files renamed; IDs stable
   - **Reason**: [why the author wanted it]
   - **Constraints checked**: [e.g. "011 still precedes 020", "no locked note violated"]
   ```

   The old behaviour — a rename map of old → new filenames — no longer exists,
   because nothing is renamed. The log records **positions**, not files.

7. **Update the affected one-line outlines.** A move often reveals that a
   line no longer describes what the scene does in its new slot (a kicker that
   landed as a cliffhanger now reads as a recap). Offer the rewrites; don't
   apply them without approval.

8. **Check consistency**, then report:
   - Every `[scene-NNN]` in `ORDER.md` has a file on disk, and vice versa —
     run `${CLAUDE_PLUGIN_ROOT}/scripts/utils/order-check.sh .` (Claude Code)
     or `~/nc/scripts/utils/order-check.sh .` (omp)
   - No scene file was renamed, moved, or edited
   - `project.json` is unchanged (order is not tracked there — `wordCount` and
     `sceneCount` only count placed scenes, which hasn't changed)

9. **Output**: the new order, the log entry, and hint that the next `compile`
   picks up the new order (chapter numbers follow reading positions).

## Discovery-writing philosophy

Reordering is **structure discovery**, not rewriting:

- The scenes stay exactly as written — content, files and IDs untouched
- You're finding the best shape for the story you already wrote
- It's cheap and reversible: one file, one list, full git history
- It's part of completing the first draft

## When NOT to reorder

- You're chasing a "correct" structure instead of trusting discovery
- The order emerged naturally from the writing and feels right
- It's driven by someone else's outline preference
- You'd be doing it to avoid writing the next scene

## Safety

- One file touched: `ORDER.md`. Everything else is history.
- Approval before the write.
- Every move logged in `notes/reorders.md` with positions and reason.
- Reversible by editing the list back — file names were never involved.
