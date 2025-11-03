# Compile Manuscript (Standard Format)

Compile all scenes into a professionally formatted manuscript in .doc/.docx format following standard submission guidelines.

## Task

You are creating a **standard manuscript format** document suitable for traditional publishing submission:

### 1. Check Prerequisites

```bash
# Check for required tools
python3 -c "from docx import Document; print('python-docx: OK')" 2>/dev/null || pip3 install python-docx
which textutil || echo "textutil not found (macOS only)"
```

### 2. Read Project Data

```bash
cd [project-root]
cat project.json  # Get title, author, genre, word count
ls scenes/*.md | wc -l  # Count scenes
```

Parse `project.json` for:
- `title`: Story title
- `author`: Author name
- `penName`: Pen name (if different from author)
- `genre`: Story genre
- `contact`: Author contact info (email, phone, address)
- Total word count

### 3. Read All Scenes

```bash
# Read scenes in order
for scene in scenes/scene-*.md; do
  cat "$scene"
done
```

**Each scene becomes a chapter** (user confirmed scenes are 1500+ words each).

### 4. Process Scene Content

For each scene:

1. **Strip metadata headers** (POV, Location, Time, etc.) - only keep prose
2. **Preserve markdown formatting**:
   - `*italic*` or `_italic_` → italic text
   - `**bold**` or `__bold__` → bold text
   - Keep paragraph breaks
   - Preserve dialogue formatting
3. **Clean invisible Unicode**:
   - Remove zero-width spaces (U+200B)
   - Remove soft hyphens (U+00AD)
   - Remove zero-width non-joiners (U+200C)
   - Remove zero-width joiners (U+200D)
   - Remove other invisible characters
4. **Scene breaks**: If a scene has internal breaks (like `***` or `# # #`), convert to centered `#`

### 5. Standard Manuscript Formatting

**Title Page:**
```
[Author Name]                    about [word count rounded to nearest 100] words
[Address Line 1]
[Address Line 2]
[City, State ZIP]
[Country]
[email]
[phone]




                               [STORY TITLE]
                               by [Pen Name or Author Name]
```

**Body Pages:**
- Font: Courier New or Times New Roman, 12pt
- Line spacing: Double-spaced
- Margins: 1 inch all sides
- Alignment: Left-aligned (ragged right)
- Paragraph indentation: 0.5 inches (first line)
- NO extra space between paragraphs

**Headers (every page except title page):**
```
[Author Last Name] / [STORY TITLE] / [Page #]
```
Right-aligned, in header section.

**Chapter Headings:**
```
[Blank line]
                              CHAPTER [NUMBER]
[Blank line]
[First paragraph of chapter, indented]
```
Centered, uppercase, no extra formatting.

**Scene Breaks within Chapters:**
```
[End of scene]
                                 #
[Start of next scene]
```
Centered hash symbol with blank lines before/after.

**End Matter:**
```
[Blank line]
                              THE END
[Blank line]
```

### 6. Python Script to Generate .docx

Create and execute a Python script that:

```python
#!/usr/bin/env python3
"""
Generate standard manuscript format .docx from fiction project scenes.
"""

import os
import json
import re
import unicodedata
from docx import Document
from docx.shared import Pt, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

def clean_invisible_unicode(text):
    """Remove invisible Unicode characters that AI might add."""
    # Common invisible characters
    invisible_chars = [
        '\u200B',  # Zero-width space
        '\u200C',  # Zero-width non-joiner
        '\u200D',  # Zero-width joiner
        '\u00AD',  # Soft hyphen
        '\uFEFF',  # Zero-width no-break space
        '\u2060',  # Word joiner
    ]
    for char in invisible_chars:
        text = text.replace(char, '')

    # Normalize Unicode (NFC form)
    text = unicodedata.normalize('NFC', text)

    return text

def parse_markdown_formatting(text):
    """
    Convert markdown to formatting tuples.
    Returns list of (text, is_italic, is_bold) tuples.
    """
    # This is a simplified parser - you may need more robust parsing
    # For now, handles basic *italic* and **bold**
    result = []

    # Pattern: **bold** or *italic*
    pattern = r'(\*\*\*(.+?)\*\*\*|\*\*(.+?)\*\*|\*(.+?)\*|___(.+?)___|__(.+?)__|_(.+?)_)'

    last_end = 0
    for match in re.finditer(pattern, text):
        # Add text before match (plain)
        if match.start() > last_end:
            plain_text = text[last_end:match.start()]
            if plain_text:
                result.append((plain_text, False, False))

        # Determine formatting
        full_match = match.group(0)
        inner_text = match.group(2) or match.group(3) or match.group(4) or \
                     match.group(5) or match.group(6) or match.group(7)

        if full_match.startswith('***') or full_match.startswith('___'):
            # Bold + Italic
            result.append((inner_text, True, True))
        elif full_match.startswith('**') or full_match.startswith('__'):
            # Bold only
            result.append((inner_text, False, True))
        elif full_match.startswith('*') or full_match.startswith('_'):
            # Italic only
            result.append((inner_text, True, False))

        last_end = match.end()

    # Add remaining text
    if last_end < len(text):
        remaining = text[last_end:]
        if remaining:
            result.append((remaining, False, False))

    return result if result else [(text, False, False)]

def add_formatted_text(paragraph, text):
    """Add text to paragraph with markdown formatting preserved."""
    segments = parse_markdown_formatting(text)

    for segment_text, is_italic, is_bold in segments:
        run = paragraph.add_run(segment_text)
        run.italic = is_italic
        run.bold = is_bold
        run.font.name = 'Courier New'
        run.font.size = Pt(12)

def create_header(section, author_last_name, title, start_page=2):
    """Create header with Author/Title/Page# format."""
    header = section.header
    header_para = header.paragraphs[0]
    header_para.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    header_para.text = f"{author_last_name} / {title.upper()} / "

    # Add page number field
    run = header_para.add_run()
    fldChar1 = OxmlElement('w:fldChar')
    fldChar1.set(qn('w:fldCharType'), 'begin')
    run._r.append(fldChar1)

    instrText = OxmlElement('w:instrText')
    instrText.set(qn('xml:space'), 'preserve')
    instrText.text = 'PAGE'
    run._r.append(instrText)

    fldChar2 = OxmlElement('w:fldChar')
    fldChar2.set(qn('w:fldCharType'), 'end')
    run._r.append(fldChar2)

    run.font.name = 'Courier New'
    run.font.size = Pt(12)

def create_manuscript(project_dir, output_path):
    """Main function to create manuscript."""

    # Read project.json
    with open(os.path.join(project_dir, 'project.json'), 'r') as f:
        project = json.load(f)

    title = project.get('title', 'Untitled')
    author = project.get('author', 'Unknown Author')
    pen_name = project.get('penName', author)
    contact = project.get('contact', {})
    word_count = project.get('wordCount', 0)

    # Round word count to nearest 100
    word_count_rounded = round(word_count / 100) * 100

    # Get author last name
    author_last_name = author.split()[-1] if ' ' in author else author

    # Create document
    doc = Document()

    # Set up page margins (1 inch all sides)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(1)
        section.bottom_margin = Inches(1)
        section.left_margin = Inches(1)
        section.right_margin = Inches(1)

    # === TITLE PAGE ===
    # Author info (top left)
    para = doc.add_paragraph()
    run = para.add_run(f"{author}")
    run.font.name = 'Courier New'
    run.font.size = Pt(12)

    # Word count (same line, right-aligned)
    para.add_run('\t' * 5 + f"about {word_count_rounded:,} words")

    # Contact info
    if contact:
        address = contact.get('address', [])
        for line in address if isinstance(address, list) else [address]:
            para = doc.add_paragraph(str(line))
            para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
            run = para.runs[0]
            run.font.name = 'Courier New'
            run.font.size = Pt(12)

        email = contact.get('email', '')
        if email:
            para = doc.add_paragraph(email)
            para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
            run = para.runs[0]
            run.font.name = 'Courier New'
            run.font.size = Pt(12)

        phone = contact.get('phone', '')
        if phone:
            para = doc.add_paragraph(phone)
            para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
            run = para.runs[0]
            run.font.name = 'Courier New'
            run.font.size = Pt(12)

    # Blank lines
    for _ in range(4):
        para = doc.add_paragraph()
        para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE

    # Title (centered)
    para = doc.add_paragraph()
    para.alignment = WD_ALIGN_PARAGRAPH.CENTER
    para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
    run = para.add_run(title.lower())
    run.font.name = 'Courier New'
    run.font.size = Pt(12)

    # Byline (centered)
    para = doc.add_paragraph()
    para.alignment = WD_ALIGN_PARAGRAPH.CENTER
    para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
    run = para.add_run(f"by {pen_name}")
    run.font.name = 'Courier New'
    run.font.size = Pt(12)

    # Page break after title page
    doc.add_page_break()

    # Add header to subsequent pages
    create_header(doc.sections[0], author_last_name, title)

    # === READ AND PROCESS SCENES ===
    scenes_dir = os.path.join(project_dir, 'scenes')
    scene_files = sorted([f for f in os.listdir(scenes_dir)
                         if f.startswith('scene-') and f.endswith('.md')])

    for idx, scene_file in enumerate(scene_files, 1):
        scene_path = os.path.join(scenes_dir, scene_file)

        with open(scene_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Clean invisible Unicode
        content = clean_invisible_unicode(content)

        # Strip frontmatter/metadata (everything before first blank line after ---)
        if content.startswith('---'):
            parts = content.split('---', 2)
            if len(parts) >= 3:
                content = parts[2].strip()

        # Chapter heading
        doc.add_paragraph()  # Blank line
        para = doc.add_paragraph(f"CHAPTER {idx}")
        para.alignment = WD_ALIGN_PARAGRAPH.CENTER
        para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
        run = para.runs[0]
        run.font.name = 'Courier New'
        run.font.size = Pt(12)
        doc.add_paragraph()  # Blank line after chapter heading

        # Process paragraphs
        paragraphs = content.split('\n\n')

        for para_text in paragraphs:
            para_text = para_text.strip()
            if not para_text:
                continue

            # Check for scene break markers
            if para_text in ['***', '* * *', '# # #', '#']:
                # Center scene break
                para = doc.add_paragraph()
                para.alignment = WD_ALIGN_PARAGRAPH.CENTER
                para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
                run = para.add_run('#')
                run.font.name = 'Courier New'
                run.font.size = Pt(12)
                continue

            # Regular paragraph
            para = doc.add_paragraph()
            para.paragraph_format.first_line_indent = Inches(0.5)
            para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
            para.paragraph_format.space_after = Pt(0)

            # Add formatted text
            add_formatted_text(para, para_text)

    # === END MATTER ===
    doc.add_paragraph()  # Blank line
    para = doc.add_paragraph("THE END")
    para.alignment = WD_ALIGN_PARAGRAPH.CENTER
    para.paragraph_format.line_spacing_rule = WD_LINE_SPACING.DOUBLE
    run = para.runs[0]
    run.font.name = 'Courier New'
    run.font.size = Pt(12)

    # Save .docx
    doc.save(output_path)
    print(f"✓ Created: {output_path}")

    return output_path

if __name__ == '__main__':
    import sys

    project_dir = sys.argv[1] if len(sys.argv) > 1 else '.'
    output_file = sys.argv[2] if len(sys.argv) > 2 else 'manuscript.docx'

    create_manuscript(project_dir, output_file)
```

### 7. Execute Manuscript Generation

```bash
# Create manuscript directory if needed
mkdir -p manuscript

# Generate manuscript
python3 /tmp/generate_manuscript.py . "manuscript/[project-name]-manuscript.docx"

# Convert .docx to .doc (macOS)
textutil -convert doc "manuscript/[project-name]-manuscript.docx" -output "manuscript/[project-name]-manuscript.doc"

# Clean up if conversion successful
# Keep both formats for user choice
```

### 8. Report to User

```
✓ Manuscript compiled successfully!

Files created:
- manuscript/[name]-manuscript.docx (Word 2007+ format)
- manuscript/[name]-manuscript.doc (Word 97-2003 format)

Statistics:
- Total chapters: [X]
- Total words: [X,XXX]
- Estimated pages (250 words/page): [XXX]

Format details:
✓ Title page with contact info and word count
✓ Headers: [Author] / [TITLE] / Page #
✓ 12pt Courier New, double-spaced
✓ 1-inch margins, 0.5-inch paragraph indent
✓ Scenes converted to chapters
✓ Markdown formatting preserved (italics, bold)
✓ Invisible Unicode characters stripped
✓ Scene breaks formatted as centered #

Next steps:
- Review manuscript for formatting consistency
- Run spell/grammar check
- Send to beta readers or submit to markets
```

## Important Notes

1. **Formatting Preservation**: The script converts markdown (`*italic*`, `**bold**`) to proper Word formatting
2. **Unicode Cleaning**: Strips invisible characters AI might insert (zero-width spaces, etc.)
3. **Scene = Chapter**: Each scene file becomes one chapter
4. **Standard Format**: Follows Shunn manuscript format (industry standard)
5. **Both Formats**: Creates both .docx and .doc for maximum compatibility

## Error Handling

- If `python-docx` not installed: Install it automatically
- If `textutil` not available: Create .docx only, inform user
- If no scenes found: Error with helpful message
- If project.json missing fields: Use sensible defaults

## Configuration

User can customize in `project.json`:
```json
{
  "title": "Story Title",
  "author": "Real Name",
  "penName": "Pen Name",
  "contact": {
    "address": [
      "Street Address",
      "City, State ZIP",
      "Country"
    ],
    "email": "email@example.com",
    "phone": "+1 234 567 8900"
  }
}
```
