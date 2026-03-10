---
name: compile
description: Use when the user wants to assemble the complete manuscript into a single document. Trigger on: "compile", "put it together", "assemble manuscript", "I need the manuscript file", "generate the manuscript", "export to Word/EPUB".
---

# Compile Manuscript

Compile all scenes into a complete manuscript in markdown format, with optional export to DOCX and EPUB.

## Task

1. **Check project status**:
   - Read project.json for metadata
   - Count total scenes in scenes/ folder
   - Calculate total word count

2. **Ask user for compilation options**:
   - **Include**: All scenes, or specific range?
   - **Format**: Markdown only, or also DOCX/EPUB?
   - **Front matter**: Title page, dedication, copyright?
   - **Chapter breaks**: Auto-detect or manual markers?
   - **Scene separators**: `***`, `# # #`, or custom?

3. **Confirm before writing files**:

   Before writing any files, confirm:
   "This will write [project-name]-manuscript.md to manuscript/. [Format: MD/DOCX]. Proceed? (y/n)"
   Only proceed if confirmed.

4. **Compile markdown manuscript**:

Create `manuscript/[project-name]-manuscript.md`:

```markdown
# [Project Title]

By [Author Name]

Genre: [genre]
Word Count: [total words]

---

[Optional: Dedication, Copyright, Epigraph]

---

[Scene 001 content]

***

[Scene 002 content]

***

[Scene 003 content]

...

---

## About This Manuscript

- Compiled: [date/time]
- Total Scenes: [number]
- Total Words: [count]
- Project: [project name]
- Format: [short story/novella/novel]

---

THE END
```

5. **Clean up for publication**:
   - Remove scene metadata (POV, Location, Time headers)
   - Remove scene numbers
   - Remove draft notes
   - Keep only the prose
   - Format dialogue and paragraphs properly
   - Ensure consistent spacing

6. **Chapter detection** (optional):
   - Look for scene markers or natural chapter breaks
   - User can mark scenes with `# Chapter X` in scene files
   - Or auto-group scenes (e.g., every 5 scenes = chapter)

7. **Export options**:

   **DOCX Export** (if requested):
   - Use `pandoc` to convert markdown to DOCX
   - Command: `pandoc manuscript.md -o manuscript.docx`
   - Standard manuscript formatting:
     - 12pt font
     - Double-spaced
     - 1-inch margins
     - Times New Roman or Courier

   **EPUB Export** (if requested):
   - Use `pandoc` to convert to EPUB
   - Include metadata for e-readers

8. **Generate compilation report**:

Create `manuscript/compilation-report-[date].md` with statistics and scene breakdown.

9. **Output to user**:
   - Show file paths for all generated files
   - Display word count and stats
   - Confirm formats created
   - Suggest next steps (blurb, cover, etc.)

## Prerequisites

For DOCX/EPUB export, check if pandoc is installed:
```bash
which pandoc
```

If not installed, provide instructions or markdown-only option.
