---
name: shunn-format
description: Use when the user wants a submission-ready manuscript formatted for agents or publishers. Trigger on: "Shunn format", "submission format", "manuscript for submission", "format for agents", "format for publishers", "professional manuscript", "manuscript I can submit".
---

# Shunn-Format Manuscript

Compile all scenes into a professionally formatted manuscript following
**William Shunn's modern manuscript format** — the industry standard for
fiction submissions. Produces `.docx` (and `.doc` on macOS).

Use this for submission. For a working or reading copy (generic MD/DOCX/EPUB),
use the `compile` skill instead.

## What the format produces

- Times New Roman, 12pt, double-spaced
- 1-inch margins, 0.5-inch first-line paragraph indents
- Title page with contact info and rounded word count
- Running headers on pages 2+: `PenNameSurname / Keywords / Page#`
- Left-aligned text (ragged right)
- Each scene starts on a new page with a centered `CHAPTER N` heading
- In-scene break markers (`***`, `# # #`, `---`, …) become a centered `#`
- `END` marker at the close
- Preserves markdown italics/bold; strips invisible Unicode characters

## Task

### 1. Check prerequisites

```bash
python3 -c "from docx import Document; print('python-docx: OK')" 2>/dev/null || pip3 install python-docx
which textutil || echo "Note: textutil not found, will create .docx only"
```

### 2. Read project metadata

Read `project.json` from the project directory. The generator uses:
- `projectName` or `title` — story title
- `author` — legal name (for the contact block)
- `penName` — byline name (defaults to `author` if unset)
- `wordCount` — total word count
- `contact` — object with `address` (array of lines), `email`, `phone`

If contact fields are missing, ask the user for them before continuing.

### 3. Create the manuscript directory

```bash
mkdir -p manuscript
```

### 4. Run the generator

The plugin ships `generate_manuscript.py`, which implements the full Shunn
specification (title page, headers, scene-break concatenation, markdown
conversion, Unicode cleaning, word-count rounding). It lives at the plugin
root — `${CLAUDE_PLUGIN_ROOT}/generate_manuscript.py` (Claude Code) or
`~/nc/generate_manuscript.py` (omp):

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/generate_manuscript.py" . "manuscript/[projectName]-manuscript.docx"
```

Run it from the project directory (`.` is the project root). It reads
`project.json` and all `scenes/scene-*.md` files, **sorted by filename** —
scenes in `drafts/` or `archive/` are excluded.

**⚠ The generator is filename-ordered, not `ORDER.md`-ordered.** In a
pantser project the two almost never agree: the Nth scene written is not the
Nth scene read, so running it against the project root produces **the wrong
chapter sequence**. Check first — compare the `## Reading order` list in
`ORDER.md` against the sorted filenames. If they differ, stage an ordered
copy:

1. `mkdir -p manuscript/.shunn-staging/scenes` and copy `project.json` into
   `manuscript/.shunn-staging/`
2. Walk `ORDER.md`'s `## Reading order` top to bottom, and for each entry copy
   the scene file into the staging `scenes/` directory **named by its reading
   position** — position 1 → `scene-001.md`, position 2 → `scene-002.md`, and
   so on. Now filename order *is* reading order, so the generator's sort
   produces the right book.
3. Run the generator against the staging directory:
   `python3 "${CLAUDE_PLUGIN_ROOT}/generate_manuscript.py" manuscript/.shunn-staging "manuscript/[projectName]-manuscript.docx"`
4. Delete `manuscript/.shunn-staging/` when done.

Never rename the real scene files to fix this. If the reading order looks
wrong in the output, fix `ORDER.md` and re-stage.

Original scene files are never modified by this step — the staging copy is
throwaway.

### 5. Convert to .doc (macOS)

```bash
if command -v textutil &> /dev/null; then
    textutil -convert doc "manuscript/[projectName]-manuscript.docx" \
        -output "manuscript/[projectName]-manuscript.doc"
    echo "✓ Created .doc version"
else
    echo "Note: .docx is standard everywhere; save as .doc from Word if needed."
fi
```

### 6. Report results

Tell the user the files created, the formatting applied, and statistics
(total scenes, total words, estimated pages at 250 words/page). Suggest next
steps: review in Word, run spell/grammar check, submit to markets or beta
readers.

## Notes

- **Chapter layout.** Each scene file becomes its own chapter — a centered
  `CHAPTER N` heading on a fresh page. Scene-break markers *within* a scene's
  text are converted to a centered `#`.
- **Word-count rounding:** 17,500 words or fewer round to the nearest 100;
  above 17,500 (novella+) round to the nearest 500.
- **Scene discovery:** scenes must be named `scene-001.md`, `scene-002.md`, …
  in `scenes/`. Files in `scenes/drafts/` and `scenes/archive/` are skipped.
  Discovery is **alphabetical by filename** — that's why an out-of-order
  project must be staged in `ORDER.md` order first (step 4).

## Troubleshooting

- `python-docx` missing → `pip3 install python-docx`
- `.doc` conversion fails → the `.docx` is standard; save as `.doc` from Word,
  or install LibreOffice (`brew install --cask libreoffice`)
- Formatting looks wrong → verify `project.json` has all required fields and
  the `contact` object is well-structured

## References

- William Shunn manuscript format: https://format.ms/story
- Generator: `generate_manuscript.py` at the plugin root
