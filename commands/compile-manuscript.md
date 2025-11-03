# Compile Manuscript (Shunn Format)

Compile all scenes into a professionally formatted manuscript following **William Shunn's modern manuscript format** - the industry standard for fiction submissions.

## Overview

This command generates a Word document (.docx and .doc) formatted to professional submission standards:

- **Courier New, 12pt, double-spaced**
- **1-inch margins** all sides
- **Title page** with contact info and word count
- **Headers** on pages 2+: `Surname / Keywords / Page#`
- **Left-aligned text** (ragged right margin)
- **0.5-inch paragraph indents**
- **Scene breaks** as centered `#`
- **Preserves markdown** formatting (italics/bold)
- **Strips invisible Unicode** characters

## Task

### 1. Check Prerequisites

```bash
# Ensure python-docx is installed
python3 -c "from docx import Document; print('python-docx: OK')" 2>/dev/null || pip3 install python-docx

# Check for textutil (macOS - for .doc conversion)
which textutil || echo "Note: textutil not found, will create .docx only"
```

### 2. Read Project Metadata

```bash
cd [project-directory]
cat project.json
```

Required fields in `project.json`:
- `projectName` or `title`: Story title
- `author`: Legal name (for check)
- `penName`: Byline name (defaults to author if not set)
- `wordCount`: Total word count
- `contact`: Object with:
  - `address`: Array of address lines
  - `email`: Email address
  - `phone`: Phone number

### 3. Create Manuscript Directory

```bash
mkdir -p manuscript
```

### 4. Run Python Script

The Python script `generate_manuscript.py` handles all formatting per Shunn specification:

```bash
python3 generate_manuscript.py . "manuscript/[projectName]-manuscript.docx"
```

The script will:
1. Read `project.json` for metadata
2. Read all scenes from `scenes/scene-*.md` in order
3. Strip YAML frontmatter from scenes
4. Clean invisible Unicode characters
5. Preserve markdown formatting (`*italic*`, `**bold**`)
6. Format title page with contact info and word count
7. Add headers to pages 2+ with `Surname / Keywords / Page#`
8. Concatenate all scenes with centered `#` scene breaks
9. Add "END" marker at conclusion
10. Save as `.docx`

### 5. Convert to .doc Format

```bash
# macOS only - convert .docx to .doc
if command -v textutil &> /dev/null; then
    textutil -convert doc "manuscript/[projectName]-manuscript.docx" \
        -output "manuscript/[projectName]-manuscript.doc"
    echo "✓ Created .doc version"
else
    echo "Note: Install LibreOffice or use Word to save as .doc manually"
fi
```

### 6. Report Results

```
✓ Manuscript compiled successfully!

Files created:
- manuscript/[name]-manuscript.docx
- manuscript/[name]-manuscript.doc

Formatting:
✓ William Shunn modern manuscript format
✓ Courier New 12pt, double-spaced
✓ 1-inch margins, 0.5-inch paragraph indents
✓ Title page with contact info
✓ Headers: [Surname] / [Keywords] / [Page#]
✓ Scenes concatenated with # breaks
✓ Markdown formatting preserved
✓ Invisible Unicode stripped

Statistics:
- Total scenes: [X]
- Total words: [X,XXX]
- Est. pages (250 words/page): [XXX]

Next steps:
- Review manuscript in Word
- Run spell/grammar check
- Submit to markets or beta readers
```

## Shunn Format Specification

### Title Page (Page 1)

**Upper left:**
```
Author Name
Address Line 1
Address Line 2
City, State ZIP
Country
phone
email
```

**Upper right** (same line as author name):
```
about X,XXX words
```

**Center (1/3 to 1/2 down page):**
```
                        Story Title
                        by Pen Name
```

**Below title** (2 double-spaces down):
Story text begins with indented paragraph...

### Subsequent Pages (2+)

**Header** (upper right):
```
Surname / Keywords / 2
```

**Body:**
- Left-aligned text (ragged right)
- Double-spaced
- 0.5-inch first-line indent
- No extra space between paragraphs

**Scene Breaks:**
```
                            #
```
Centered on its own line

**End Marker:**
```
                           END
```

## Important Notes

### Scene = Continuous Text

Per Shunn format, there are **NO chapter headings** in the manuscript. All scenes flow continuously with scene breaks (`#`) between them.

Your scenes already work as "chapters" in the sense that they're substantial units (1500+ words each), but in submission format they appear as continuous prose with breaks, not numbered chapters.

Editors and publishers will add chapter divisions later during production if needed.

### Formatting Preservation

The script converts markdown to Word formatting:
- `*italic text*` → *italic text*
- `**bold text**` → **bold text**
- `***bold italic***` → ***bold italic***

### Unicode Cleaning

The script automatically strips invisible characters that AI sometimes inserts:
- Zero-width spaces (U+200B)
- Zero-width non-joiners (U+200C)
- Zero-width joiners (U+200D)
- Soft hyphens (U+00AD)
- Zero-width no-break spaces (U+FEFF)
- Word joiners (U+2060)

This ensures clean text that won't cause problems in submission systems.

### Word Count Rounding

- Under 17,500 words: Round to nearest 100
- Over 17,500 words (novella): Round to nearest 500

This gives editors a sense of space requirements without false precision.

## Troubleshooting

**If python-docx is not installed:**
```bash
pip3 install python-docx
```

**If .doc conversion fails:**
- The .docx file is standard and works everywhere
- You can manually save as .doc in Microsoft Word
- Or install LibreOffice: `brew install --cask libreoffice`

**If scenes are missing:**
- Ensure scenes are named `scene-001.md`, `scene-002.md`, etc.
- Check they're in the `scenes/` directory
- Verify no scenes are in `drafts/` or `archive/` subdirectories

**If formatting looks wrong:**
- Check `project.json` has all required fields
- Ensure contact info is properly structured
- Verify scenes don't have markdown formatting errors

## References

- William Shunn manuscript format: https://format.ms/story
- Python script: `generate_manuscript.py` in plugin root
- Sample: See Shunn's PDF guide for visual reference
