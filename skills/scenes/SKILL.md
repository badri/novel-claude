---
name: scenes
description: Use when the user wants to see what they've written, review the scene list, check scene titles or word counts, or get an overview of the manuscript structure. Trigger on: "what scenes do I have", "show me my scenes", "scene list", "what have I written", "how many scenes".
---

# Scene Navigator

Browse, read, search, and manage all scenes in your project — in **reading
order**, which is defined by `ORDER.md`, not by filenames.

## What this skill does

- List scenes in reading order (the default), or show unplaced scenes,
  archived scenes, or everything
- Read specific scene(s)
- Search scenes
- Promote a draft to the manuscript
- Cut / archive a scene

## Task

1. **Determine action** (ask user or infer):
   - **List** — show scenes with summaries
   - **Read** — display specific scene(s)
   - **Search** — find scenes by content, character, location
   - **Jump** — quick navigation to a stable ID
   - **Info** — scene metadata and stats
   - **Promote** — move a draft into the manuscript under a new stable ID
   - **Cut / Archive** — remove a scene from the manuscript, keep the file

## Actions

### List Scenes

**Read `ORDER.md` first** — it is the reading order and the reverse outline.
Then present in three blocks, using `ORDER.md`'s own one-line outlines rather
than re-deriving them:

```markdown
# Scenes — [Project Name]

Total placed: [count]   Total words: [sum of placed scenes]

## Reading order

| # | ID | POV | Words | Outline |
|---|----|-----|-------|---------|
| 1 | scene-001 | Divya | 1,630 | Divya's wedding night; the directive surfaces as dread; she drives off into the night |
| 2 | scene-004 | Arvind | 1,480 | The morning after; she's gone, nothing taken; he goes to the police |
| 3 | scene-002 | Rishi | 1,490 | Rishi begs an LKG seat for his son; the seat is one bribe away |

## Unplaced / drafts

| ID / file | POV | Words | Outline |
|---|---|---|---|
| scene-077 | Meera | 1,240 | An ordinary Thursday, weeks before the pale car |
| drafts/climax-v2.md | Divya | 980 | Alternate climax, unplaced |

## Archive / cut

| ID | Words | Note |
|----|-------|------|
| scene-012 | 1,100 | Cut 2026-07-01; file kept, ID retired |
```

- **Position** is the reading position — the chapter number on the next
  compile. **ID** is the permanent `scene-NNN`.
- Word counts come from each scene file (or `Notes`).
- The **Outline** column comes straight from `ORDER.md`. If a line is missing
  or stale, say so and offer to fix it.
- **Archived/cut IDs are retired** — never reused for a new scene.
- The user can ask for a subset: unplaced only, archive only, or everything.

### Read Scene(s)

Ask which scene(s):
- Single: "scene 012", or by reading position ("chapter 5")
- Multiple: "012, 017, 019"
- Range in reading order: "the first five"
- Last N written
- Current (highest stable ID)

### Search Scenes

Use the Grep tool across `scenes/` for:
- **Content** — text/dialogue
- **Character** — scenes featuring someone
- **Location**
- **POV**

Report hits by **stable ID and reading position** ("scene-019, reads at
position 17").

### Promote a Draft to the Manuscript

A draft becomes a placed scene under a **new stable ID** — the next unused
number. Promotion is one of the few operations that creates an ID.

**Process**:
1. Ask which draft (a file in `scenes/drafts/`, or an unplaced numbered
   scene already in `scenes/`).
2. Compute the **next stable ID** = highest used NNN + 1, scanning
   `scenes/`, `scenes/drafts/`, `scenes/archive/`, `scenes/cut/`, and every
   `[scene-NNN]` in `ORDER.md`. Never reuse a retired ID.
3. Confirm the destination path and ID with the user.
4. Move the file: `scenes/drafts/<name>.md` → `scenes/scene-NNN.md`
   (an already-numbered unplaced scene keeps its ID and just moves).
5. Update the scene file: `# Scene NNN` header, `**Status**: active`,
   recalculate the word count in Notes.
6. **Add its line to `ORDER.md` at the reading position the user names** —
   `N. **[scene-NNN]** — one-sentence outline (~words)` — or under
   `## Unplaced / drafts` if placement is still unknown. Remove it from the
   Unplaced list if it was listed there.
7. Update `project.json`: increment `sceneCount`, set `currentScene`,
   recompute `wordCount`.

**Nothing else is renumbered.** Existing scenes keep their IDs and their
positions in the list.

### Cut / Archive a Scene

Removing a scene from the manuscript.

**Process**:
1. Ask which scene.
2. Show its one-line outline and word count; confirm.
3. Move the file to `scenes/archive/` (or `scenes/cut/` if the project uses
   that). **Keep the filename — the ID stays with the file.**
4. **Remove its line from `## Reading order`** and add it to `## Cut` with
   the reason and the archive path. **The ID is retired and never reused.**
5. Update `project.json`: decrement `sceneCount`, recompute `wordCount`.
6. **No renaming, no renumbering** of any other scene, ever.

## Tips

- Reading order lives in `ORDER.md`; the file list will look scrambled and
  that's correct.
- Use the list view to catch a stale one-line outline — that's the cheapest
  place to notice the reverse outline has drifted.
- Promote a draft the moment you know where it reads; leave it unplaced if you
  don't.
- Archive rather than delete — cut prose sometimes gets re-homed later.
