---
name: edit-scene
description: Use when the user wants to modify, fix, improve, or revise an existing scene. Trigger on: "fix scene N", "this scene feels off", "rewrite the opening", "scene N needs work", "edit scene", "something's wrong with scene N".
---

# Edit Scene

Edit an existing scene with AI assistance or manual editing.

## Task

1. **Identify scene to edit**:
   - Ask which scene number
   - Or: "current/latest scene"
   - Or: the user names the scene directly (e.g. "edit scene 12")

2. **Read the scene file**:
   - Load `scenes/scene-XXX.md`
   - Parse structure (POV, Location, Time, content, notes)
   - Show current word count

3. **Determine edit type** (ask user):

   User provides natural language editing instructions. No special syntax required.

   **Natural Language Edit Instructions**:

   User can give simple commands or detailed multi-part instructions:

   ```
   Make the dialogue more tense. Add 5 senses description of the park.
   End with a cliffhanger instead of resolution.
   ```

   Or:
   ```
   The opening paragraph needs work - make it more ominous and add
   foreshadowing about the vault. The dialogue in the middle section
   should be shorter and snappier. End it without revealing Joe's
   intentions to the reader.
   ```

   **Common edit instruction patterns**:

   **Specific changes**:
   - "Make the dialogue more tense"
   - "Add sensory details (5 senses)"
   - "Shorten by 20%" / "Make it more concise"
   - "Change POV from third to first person"
   - "Add foreshadowing about X"
   - "Remove filter words (felt, saw, heard)"
   - "Show don't tell in the opening"

   **Section rewrites**:
   - "Rewrite the opening paragraph as more ominous"
   - "Rewrite the confrontation - make it physical not verbal"
   - "Redo the ending as a cliffhanger"

   **Polish**:
   - "Improve prose quality"
   - "Fix pacing issues"
   - "Strengthen character voice"
   - "Tighten the prose"

   **Expand**:
   - "Add a paragraph describing the setting"
   - "Expand the dialogue exchange"
   - "Add [character's] internal thoughts"
   - "More description of the park from Joe's POV"

   **Combine multiple**:
   - "Add sensory details to the park scene AND make the dialogue
      more tense AND end with a cliffhanger"

   **Manual Edit**:
   - User edits directly in their text editor
   - Or provides full replacement text

4. **For AI edits**:

   - Show user's instruction
   - Read full scene content
   - Apply requested changes
   - Maintain scene structure (POV, Location, Time headers)
   - Preserve the scene's voice and style
   - Update word count

5. **Show before/after preview**:

   ```markdown
   ## Original (1,234 words):
   [Relevant section that changed]

   ## Edited (1,189 words):
   [New version of that section]

   Changes:
   - Tightened dialogue
   - Added sensory details
   - Removed 45 words
   ```

6. **Confirmation**:

   Ask user:
   - **[y] Accept changes** - Write to scene file
   - **[e] Edit further** - Additional instructions
   - **[r] Revert** - Keep original
   - **[s] Show full** - See entire edited scene

7. **Update scene file**:

   - Use Edit tool to replace scene content
   - Update word count in Notes section
   - Optionally add edit note:
     ```
     **Notes**:
     - Word count: 1,189
     - Status: draft
     - Date: 2025-10-26
     - Last edited: 2025-10-26 (AI: tightened dialogue)
     ```

8. **Handle summaries**:

   If scene was previously summarized:
   ```
   Note: Scene 012 has a summary. Changes made:
   - Summary may be outdated
   - Re-run summarize if significant changes
   ```

9. **Cycle integration**:

   If edit adds new element (character, location, skill):
   ```
   Detected in edit:
   👤 New character: Dr. Chen
   Add to codex? [y/n/later]
   ```

## Edit Modes Detail

### Specific Changes

User provides instruction, AI modifies accordingly.

### Rewrite Section

User selects portion, AI rewrites.

### Polish

General improvements without changing content:
- Filter words (felt, saw, heard)
- Passive voice
- Weak verbs
- Repetition
- Pacing

### Expand

Add content to existing scene.

## Multiple Iterations

Support refinement — after each edit ask if they want to edit further.

## Safety Features

### Backup

Before first edit, note: "Original backed up by git (if repo initialized)"

### Edit History

Optional: Create `notes/edit-history.md` to track edits.

## Philosophy

**Editing vs Rewriting**:
- Light edits are fine (polish, tension, details)
- Major rewrites contradict discovery writing
- Use for finishing touches, not reimagining
- If scene fundamentally wrong, consider rewriting from scratch vs editing

**When to edit**:
- ✅ Polish prose quality
- ✅ Add sensory details
- ✅ Tighten dialogue
- ✅ Fix pacing in a scene
- ✅ Add foreshadowing you discovered later
- ✅ Character voice consistency

**When NOT to edit (write new instead)**:
- ❌ Completely change what happens
- ❌ Change character decisions fundamentally
- ❌ Reimagine the scene from scratch
- ❌ Force plot points

This is **finishing work**, not revision.
