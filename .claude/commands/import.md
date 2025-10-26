# Import Existing Work

Import a partial draft, half-finished manuscript, or existing story into the pulp writing system.

## Philosophy

**Context-economical import**: Don't load the entire manuscript into context. Instead:
1. Get minimal codex info upfront (user provides or quick extract)
2. Split draft into scenes intelligently
3. Summarize each scene via Gemini (uses Gemini tokens, not Claude)
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
   ```
   Who are the key players? Just names and one-line descriptions.
   Example: "Martha - burned-out detective, Jack - her former partner,
   Elena - mysterious informant"
   ```

   **Key locations** (2-3 sentence summary):
   ```
   Where does this story take place?
   Example: "Border town in Texas, safehouse in Mexico City"
   ```

   **World/Setting** (2-3 sentences):
   ```
   Any special world rules, time period, or context?
   Example: "Contemporary thriller, 2024, realistic world"
   or "Fantasy world with elemental magic system"
   ```

   **POV structure** (1 sentence):
   ```
   How is it told?
   Example: "Single POV (Martha, first person)"
   or "Multiple POV (Martha & Jack, third person)"
   ```

   This is **just enough** for context, not a full codex. We'll build the real codex later.

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
- User provides: "Scenes are already marked with [SCENE X]"

**Option C - Hybrid**:
- Try automatic, show preview, user confirms or adjusts

### Phase 3: Execute Import (Context-Economical!)

**Important**: Process in small chunks, don't load entire draft at once.

1. **Create project structure**:
   ```bash
   mkdir -p project-name/{scenes,summaries,codex,brainstorms,manuscript,notes}
   ```

2. **Save original draft**:
   ```
   manuscript/original-draft.md  # Keep the source
   ```

3. **Initialize minimal codex** from Phase 1 info:

   `codex/characters.md`:
   ```markdown
   # Characters

   ## [Character names from user's brief]

   [One-line descriptions provided]

   ---

   *Note: Imported from existing draft. Expand as needed using /codex*
   ```

   Similar minimal entries for locations, worldbuilding.

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

5. **Summarize scenes via Gemini** (THIS IS KEY - saves Claude tokens!):

   For each scene file created:
   - Invoke `@gemini-summarizer` subagent
   - Generate summary focusing on:
     - Key events
     - Characters present
     - Location
     - Plot progression
   - Save to `summaries/summary-scene-XXX.md`

   This happens in batches (process 5-10 scenes, summarize via Gemini, repeat).

   **Result**: You have summaries without loading full scenes into Claude context!

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

   `notes/import-report.md`:
   ```markdown
   # Import Report

   Date: [timestamp]
   Source: original-draft.md

   ## Summary
   - Scenes created: 24
   - Total words: 45,000
   - Summaries generated: 24 (via Gemini)
   - Codex initialized: Minimal (characters, locations, worldbuilding)

   ## Scene Breakdown
   | Scene | Words | POV | Status |
   |-------|-------|-----|--------|
   | 001   | 1,234 | Martha | ✓ Summarized |
   | 002   | 1,456 | Martha | ✓ Summarized |
   ...

   ## Next Steps
   - [ ] Review scene splits (use /scenes list)
   - [ ] Expand codex as you write (/codex)
   - [ ] Continue writing from scene 25 (/new-scene)
   - [ ] Fix any scene breaks that look wrong (/cycle or manual edit)

   ## Codex Status
   - Characters: 3 minimal entries (expand with /codex)
   - Locations: 2 minimal entries (expand with /codex)
   - Timeline: Not yet created
   - Worldbuilding: Basic entry
   - Lore: Not yet created

   ## Notes
   - Original draft preserved in manuscript/original-draft.md
   - All scenes have summaries (context-economical!)
   - Ready to continue writing or refining
   ```

### Phase 4: Post-Import Guidance

After import completes, tell user:

```markdown
✓ Import complete!

**Created**:
- 24 scenes in scenes/
- 24 summaries in summaries/ (via Gemini)
- Minimal codex in codex/
- Project tracking in project.json

**Your draft is now in the system!**

**Next steps**:

1. Review the scene splits:
   /scenes list

2. Check a few scenes to verify splits are good:
   /scenes read 1
   /scenes read 12

3. If any scene splits look wrong:
   - Manually edit scene files, or
   - Use /cycle to move content between scenes

4. Continue writing:
   /new-scene

   (Will create scene-025 with context from summaries)

5. Gradually expand codex as you write:
   /codex

   (Add details for characters, locations as they come up)

**What's economical about this**:
- ✓ Full draft split into manageable scenes
- ✓ All scenes summarized (using Gemini tokens, not Claude)
- ✓ Only load 1-3 scenes at a time when writing
- ✓ Summaries provide context without full text
- ✓ Minimal codex is enough to start
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
If user has chapters in separate files:
```
chapter-01.md
chapter-02.md
...
```

- Process each file
- Treat each as one or more scenes
- Number sequentially across all files

## Scene Detection Intelligence

When auto-detecting scenes, look for:

1. **Explicit markers**:
   - `***`, `* * *`, `# # #`
   - `---` (horizontal rules)
   - `[SCENE]`, `[Scene X]`

2. **Chapter breaks**:
   - `# Chapter X`
   - `## Chapter X`
   - `Chapter X` on its own line

3. **POV switches** (if multiple POV):
   - "Martha watched..." vs "Jack watched..."
   - First person switch

4. **Time/location jumps**:
   - "The next day..."
   - "Back at the office..."
   - "Meanwhile..."

5. **Blank line patterns**:
   - Multiple blank lines (3+) often indicate scene breaks

**Preview before committing**:
```
Found 24 potential scene breaks:

Scene 001: Lines 1-87 (1,234 words) - Starts: "Martha woke to..."
Scene 002: Lines 88-165 (1,456 words) - Starts: "The diner was..."
Scene 003: Lines 166-234 (1,123 words) - Starts: "Jack paced his..."

Look good? [y/n] or specify adjustments
```

## Codex Extraction (Gradual, Not Upfront)

**Don't try to build full codex during import!**

Instead:
1. Start with user's minimal info (Phase 1)
2. Import and summarize scenes
3. **After import**, offer optional codex enrichment:

```
Import complete!

Want me to scan summaries and suggest codex additions?
[y/n]

If yes:
- Read all summaries (small context footprint)
- Identify character names, locations mentioned
- Suggest additions to codex
- User confirms what to add
```

This is **optional** and **post-import** to keep the import process fast.

## Edge Cases

### Very long draft (100k+ words)
- Process in batches
- Import 10-20 scenes at a time
- Pause between batches to avoid context overflow
- Use Gemini heavily for summarization

### Draft with no clear scene breaks
- Offer: "Split every N words" (default 1500)
- User can manually add breaks later with `/reorder` or editing

### Draft with multiple POVs
- Ask user to identify POV characters upfront
- Use names to detect POV switches
- Tag each scene with POV

### Incomplete draft
- Import what exists
- User continues with `/new-scene` from where it stops

## Integration with Existing Commands

After import:
- `/scenes` works normally (list, read, search imported scenes)
- `/new-scene` continues from last imported scene number
- `/summarize` can re-summarize if needed
- `/codex` expands the minimal starter codex
- `/cycle` can fix any import issues
- `/reorder` can fix scene sequence if auto-split was wrong
- `/compile` can recreate manuscript from scenes

## Example Workflow

```
User: /import

System: What file do you want to import?
User: ~/drafts/my-thriller.md

System: This is a 45,000 word draft. To understand it without
        loading the whole thing, tell me briefly:

        Main characters (one-line each):
User: Martha - detective, Jack - her partner, Elena - informant

System: Key locations:
User: Border town Texas, safehouse in Mexico

System: POV structure:
User: Multiple POV, third person, mostly Martha and Jack

System: How should I split into scenes?
        [Auto-detect / Every N words / Manual guidance]
User: Auto-detect

System: [Processing in chunks...]
        Found 24 scene breaks. Preview:

        Scene 001: "Martha woke to the sound..." (1,234 words)
        Scene 002: "The diner was crowded..." (1,456 words)
        ...

        Looks good?
User: Yes

System: [Creates project structure]
        [Splits into 24 scene files]
        [Invoking @gemini-summarizer for each scene...]
        [Creates minimal codex]
        [Generates import report]

        ✓ Import complete!
        - 24 scenes created
        - 24 summaries generated (Gemini)
        - Minimal codex initialized

        Next: /scenes list to review
              /new-scene to continue writing
```

## Why This Works

1. **Context-economical**: Never load full draft, process in chunks
2. **Gemini does heavy lifting**: Summarization uses Gemini tokens
3. **Minimal codex upfront**: Just enough to understand, expand later
4. **Summaries replace full text**: Use summaries for context, not scenes
5. **Gradual enrichment**: Build codex as you continue writing
6. **User in control**: Multiple decision points, preview before committing

The imported project works exactly like a project started from scratch - but you didn't have to manually split your draft!
