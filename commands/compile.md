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

3. **Compile markdown manuscript**:

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

4. **Clean up for publication**:
   - Remove scene metadata (POV, Location, Time headers)
   - Remove scene numbers
   - Remove draft notes
   - Keep only the prose
   - Format dialogue and paragraphs properly
   - Ensure consistent spacing

5. **Chapter detection** (optional):
   - Look for scene markers or natural chapter breaks
   - User can mark scenes with `# Chapter X` in scene files
   - Or auto-group scenes (e.g., every 5 scenes = chapter)

6. **Export options**:

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
   - Command: `pandoc manuscript.md -o manuscript.epub --metadata title="..." --metadata author="..."`
   - Include metadata for e-readers

7. **Generate compilation report**:

Create `manuscript/compilation-report-[date].md`:

```markdown
# Compilation Report

Project: [name]
Date: [timestamp]
Format: [formats generated]

## Statistics

- Total Scenes: [number]
- Total Words: [count]
- Average Scene Length: [words]
- Estimated Pages (250 words/page): [number]
- Estimated Reading Time: [minutes]

## Files Generated

- [ ] manuscript/[name]-manuscript.md
- [ ] manuscript/[name]-manuscript.docx
- [ ] manuscript/[name]-manuscript.epub

## Scene Breakdown

| Scene | POV | Location | Words |
|-------|-----|----------|-------|
| 001   | ... | ...      | ...   |
| 002   | ... | ...      | ...   |
...

## Next Steps

- [ ] Review manuscript for continuity
- [ ] Run spell/grammar check
- [ ] Beta readers
- [ ] Professional edit
- [ ] Cover design
- [ ] Blurb/description
- [ ] Publish!
```

8. **Output to user**:
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

## Options

- `--clean`: Remove all metadata and draft notes
- `--with-chapters`: Auto-detect or prompt for chapter breaks
- `--format=md`: Markdown only (default)
- `--format=docx`: Include DOCX export
- `--format=epub`: Include EPUB export
- `--format=all`: All formats
- `--range=X-Y`: Compile only scenes X through Y

## Publication Checklist

After compilation, offer to help with:
- `/blurb` - Generate story description/back cover copy
- `/cover` - Cover design ideas and specifications
- Final proofread and continuity check
- Export for specific platforms (KDP, Draft2Digital, etc.)
