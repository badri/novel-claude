---
name: import
description: Use when the user wants to bring an existing manuscript written elsewhere into an NC project. Trigger on: "import", "I wrote this in Word", "bring in my draft", "import manuscript", "I have existing scenes to import".
---

# Import Existing Work

Import a partial draft, half-finished manuscript, or existing story into the writing system.

## Philosophy

**Context-economical import**: Don't load the entire manuscript into context. Instead:
1. Get minimal codex info upfront (user provides or quick extract)
2. Split draft into scenes intelligently
3. Summarize each scene via a fast haiku subagent (saves main context)
4. Result: Full project with manageable context

## Task

### Phase 1: Gather Initial Information

Ask user for:

1. **Source file**:
   - Path to existing draft (markdown, txt, docx)
   - What format is it? (single file, chapters in separate files, etc.)

2. **Project metadata**:
   - Project name
   - Genre
   - Premise/logline
   - How far along? (%, scenes, word count estimate)

3. **Minimal codex starter** (keep it light!):

   Ask: "To help me understand your story without reading the whole draft, tell me briefly:"

   **Main characters** (3-5 sentence summary):
   Just names and one-line descriptions.

   **Key locations** (2-3 sentence summary):
   Where does this story take place?

   **World/Setting** (2-3 sentences):
   Any special world rules, time period, or context?

   **POV structure** (1 sentence):
   How is it told?

### Phase 2: Scene Detection Strategy

Ask user how to split the draft:

**Option A - Automatic scene detection**:
- Look for scene breaks: `***`, `# # #`, `---`, blank lines
- Look for chapter markers: `# Chapter`, `## Chapter`
- Look for POV switches (if multiple POV)
- Look for time/location jumps in text

**Option B - Manual guidance**:
- User specifies: "Split every 1500 words"
- User specifies: "Split at chapter breaks"

**Option C - Hybrid**:
- Try automatic, show preview, user confirms or adjusts

### Phase 3: Execute Import

**Confirm before overwriting**:
"This will create [N] scene files in scenes/. Any existing scenes with the same numbers will be moved to scenes/archive/. Proceed? (y/n)"
Only proceed if confirmed.

1. **Create project structure**:
   ```bash
   mkdir -p project-name/{scenes,summaries,codex,brainstorms,manuscript,notes}
   ```

2. **Save original draft**:
   ```
   manuscript/original-draft.md  # Keep the source
   ```

3. **Initialize minimal codex** from Phase 1 info.

4. **Split draft into scenes** (based on chosen strategy):

   Process the draft file in chunks:
   - Read 5000 words at a time (manageable context)
   - Identify scene breaks within that chunk
   - Extract scenes
   - Write to `scenes/scene-001.md`, `scene-002.md`, etc.

   **Scene file format**:
   ```markdown
   # Scene 001

   **POV**: [Auto-detect or use user's guidance]
   **Location**: [TBD - extract later]
   **Time**: [TBD - extract later]

   ---

   [Scene content from original draft]

   ---

   **Notes**:
   - Word count: [calculated]
   - Status: imported
   - Date: [import date]
   - Source: original-draft.md
   ```

5. **Summarize scenes using Task tool (haiku)**:

   For each scene file created, use the Task tool with model haiku to summarize:
   - Key events
   - Characters present
   - Location
   - Plot progression

   Save to `summaries/summary-scene-XXX.md`

   Process in batches (5-10 scenes at a time).

   **Result**: You have summaries without loading full scenes into main context!

6. **Create project.json**:
   ```json
   {
     "projectName": "...",
     "genre": "...",
     "premise": "...",
     "createdDate": "...",
     "importedFrom": "original-draft.md",
     "importDate": "...",
     "status": "imported-draft",
     "sceneCount": 24,
     "wordCount": 45000,
     "currentScene": 24,
     "metadata": {
       "importNotes": "Imported existing draft, scenes auto-split, summaries generated"
     }
   }
   ```

7. **Create import report**:

   `notes/import-report.md` with summary of scenes created, word count, and next steps.

### Phase 4: Post-Import Guidance

After import completes, tell user:

```
✓ Import complete!

**Created**:
- [N] scenes in scenes/
- [N] summaries in summaries/
- Minimal codex in codex/
- Project tracking in project.json

**Next steps**:

1. Review the scene splits: scenes list
2. Check a few scenes to verify splits are good
3. If any scene splits look wrong: manually edit scene files
4. Continue writing: new scene
5. Gradually expand codex as you write: codex
```

## Handling Different Source Formats

### Markdown (.md)
- Direct processing
- Look for existing structure

### Plain text (.txt)
- Convert to markdown
- Detect scene breaks by formatting (blank lines, dividers)

### Word docs (.docx)
- Use `pandoc` to convert to markdown first:
  ```bash
  pandoc original.docx -o temp-draft.md
  ```
- Then process as markdown

### Multiple files
If user has chapters in separate files, process each file and number sequentially across all files.

## Scene Detection Intelligence

When auto-detecting scenes, look for:

1. **Explicit markers**: `***`, `* * *`, `# # #`, `---`
2. **Chapter breaks**: `# Chapter X`, `## Chapter X`
3. **POV switches** (if multiple POV)
4. **Time/location jumps**: "The next day...", "Back at the office..."
5. **Blank line patterns**: Multiple blank lines (3+)

**Preview before committing**:
```
Found 24 potential scene breaks:

Scene 001: Lines 1-87 (1,234 words) - Starts: "Martha woke to..."
Scene 002: Lines 88-165 (1,456 words) - Starts: "The diner was..."
Scene 003: Lines 166-234 (1,123 words) - Starts: "Jack paced his..."

Look good? [y/n] or specify adjustments
```
