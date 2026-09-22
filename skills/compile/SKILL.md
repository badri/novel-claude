---
name: compile
description: Use when the user wants to assemble the complete manuscript into a single document. Trigger on: "compile", "put it together", "assemble manuscript", "I need the manuscript file", "generate the manuscript", "export to Word/EPUB".
---

# Compile Manuscript

Assemble the scenes into a complete manuscript **in the order `ORDER.md`
defines** — never in filename order.

## Task

1. **Read `ORDER.md` first.** It is the source of truth for reading order. The
   `## Reading order` list is the manuscript; anything under
   `## Unplaced / drafts` or `## Cut` is **not** included.

2. **Verify the project is consistent** — run:

   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/utils/order-check.sh .
   ```
   (Claude Code — under omp it's `~/nc/scripts/utils/order-check.sh .`)

   It reports:
   - scene files under `scenes/` that are missing from `ORDER.md`
   - `[scene-NNN]` references in `ORDER.md` with no file on disk
   - surviving annotation tags anywhere under `scenes/`

   **Exit 1 means something needs attention** — surface it to the user and
   decide together. A file on disk that isn't in `ORDER.md` and isn't a
   draft/archive is *unplaced*: it will be silently left out, so say so before
   compiling.

3. **Refuse to compile if any annotation tag survives.** Tags are
   editor-to-AI instructions (`<brief>`, `<cut>`, `<change>`, `<keep>`,
   `<add>`, `<flow>`, `<q>`); a scene on the reading list that still contains
   one was never actually rewritten. **List the file and the tags, and stop.**

   ```
   ✗ Ordered 012 contains 2 un-consumed tags: <cut>, <q>
   ✗ Ordered 019 contains 1 un-consumed tag: <change>
   Compile stopped — these scenes contain editor annotations, not finished prose.
   Run edit-scene ("rewrite 012") to consume them, then compile again.
   ```

   Do not strip the tags and compile anyway — the annotations carry the
   author's direction and stripping them loses it. Do not compile around the
   scene. Fix the scene, then compile.

4. **Check project metadata**: `project.json` for title, author, genre; total
   placed scenes; total words from the placed scenes only (drafts excluded).

5. **Ask for compilation options**:
   - **Range**: the whole reading order, or a slice of positions?
   - **Format**: markdown only, or also DOCX/EPUB?
   - **Front matter**: title page, dedication, copyright?
   - **Chapter treatment** (see below)
   - **Scene separators**: `***`, `# # #`, or custom

6. **Confirm before writing files**:

   ```
   This will write manuscript/[project-name]-manuscript.md in ORDER.md reading
   order ([N] scenes, [N] words). [Format: MD/DOCX]. Proceed? (y/n)
   ```

7. **Compile in reading order** — walk the `## Reading order` list top to
   bottom, and for each entry:

   - **Chapter number = reading position.** Position 1 is `Chapter 1`,
     position 2 is `Chapter 2`, and so on, regardless of the scene's stable
     ID. A scene list of `001, 004, 002` compiles as chapters 1, 2, 3.
   - **Emit the stable ID as an HTML comment immediately before each
     section**, so the reading order and the IDs never lose contact:

     ```markdown
     <!-- scene-001 -->

     # Chapter 1

     [prose]

     ***
     ```

   - Strip the scene's metadata block (the `# Scene NNN` heading, `**POV**`,
     `**Location**`, `**Time**`, `**Status**`) and the `**Notes**` section —
     prose only.
   - Keep in-scene break markers as the chosen separator.

8. **Write the manuscript**:

```markdown
# [Project Title]

By [Author Name]

Genre: [genre]
Word Count: [total words]

---

[Optional: Dedication, Copyright, Epigraph]

---

<!-- scene-001 -->

# Chapter 1

[scene prose]

***

<!-- scene-004 -->

# Chapter 2

[scene prose]

---

## About This Manuscript

- Compiled: [date/time]
- Scenes: [number] (in ORDER.md reading order)
- Words: [count]
- Project: [project name]
- Format: [short story/novella/novel]

---

THE END
```

9. **Clean up for publication**:
   - Prose only — no metadata blocks, no notes, no scene numbers in the text
   - **No annotation tags** (step 3 already guaranteed this; verify once more
     on the assembled output with a grep for the seven tag names)
   - Consistent spacing, proper dialogue formatting

10. **Export options** (if requested):

    **DOCX** — `pandoc manuscript.md -o manuscript.docx` (12pt,
    double-spaced, 1-inch margins).

    **EPUB** — `pandoc manuscript.md -o manuscript.epub`.

    For a **submission-format** manuscript (Shunn), use the `shunn-format`
    skill instead — and note its generator reads filenames, so hand it an
    ORDER.md-ordered markdown file rather than the raw `scenes/` folder.

11. **Generate a compilation report** — `manuscript/compilation-report-[date].md`
    with the reading order, positions, IDs, and word counts.

12. **Output**:
    - File paths created
    - Scene count and word count
    - The reading order used (positions + IDs), so the author can eyeball it
    - Any warnings from `order-check.sh` that remain unresolved
    - Next steps (blurb, cover, shunn-format)

## Prerequisites

For DOCX/EPUB export: `which pandoc`. If absent, offer markdown-only.
