# Edit Scene

Edit an existing scene with AI assistance or manual editing.

## Task

1. **Identify scene to edit**:
   - Ask which scene number
   - Or: "current/latest scene"
   - Or: user specifies in command: `/edit-scene 12`

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
   - Re-run /summarize if significant changes
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

User provides instruction, AI modifies accordingly:

```
You: /edit-scene 12

System: Scene 012 loaded (1,234 words)
        What would you like to change?

You: Make the dialogue more tense and add urgency

System: [Reads scene, identifies dialogue]
        [Rewrites dialogue with tension]

        Preview:

        Original:
        "We need to talk," Marcus said.
        "About what?" Elena asked.

        Edited:
        "We need to talk. Now." Marcus's voice was tight.
        Elena's eyes narrowed. "About what?"

        Accept? [y/e/r/s]
```

### Rewrite Section

User selects portion, AI rewrites:

```
You: Rewrite the opening paragraph

System: Current opening:
        "Martha woke to the sound of rain..."

        Rewrite in what style/direction?

You: Make it more ominous, foreshadow danger

System: New opening:
        "Martha woke to silence—the kind that comes
        before something breaks. The rain had stopped,
        but the letter on her nightstand seemed to
        pulse with threat..."

        Accept?
```

### Polish

General improvements without changing content:

```
You: Improve prose quality

System: Analyzing scene for:
        - Filter words (felt, saw, heard)
        - Passive voice
        - Weak verbs
        - Repetition
        - Pacing

        [Makes improvements]

        Changed 12 instances:
        - Removed 5 filter words
        - Strengthened 4 verbs
        - Varied sentence rhythm

        Preview: [shows before/after]
```

### Expand

Add content to existing scene:

```
You: Add more description of the safehouse interior

System: Where in the scene should I add this?

You: Right after "They entered the safehouse"

System: [Generates 2-3 paragraph description]

        Added:
        "The safehouse was smaller than Martha expected.
        Concrete walls, sparse furniture, a single window
        with steel shutters. The air smelled of disuse..."

        Accept?
```

## Multiple Iterations

Support refinement:

```
You: [Accept initial edit]

System: Changes saved. Edit further? [y/n]

You: y

System: What else?

You: Now add foreshadowing about the vault

System: [Makes additional changes]
        [Shows preview]
```

## Safety Features

### Backup

Before first edit, create backup:
```bash
cp scenes/scene-012.md scenes/scene-012.backup.md
```

Or note: "Original backed up by git (if repo initialized)"

### Edit History

Optional: Create `notes/edit-history.md`:
```markdown
## Scene 012 Edits

### 2025-10-26 14:30
- **Type**: AI Edit - Dialogue tension
- **Instruction**: Make dialogue more tense
- **Words**: 1,234 → 1,189 (-45)
- **Backup**: scene-012.backup.md

### 2025-10-26 15:15
- **Type**: AI Edit - Add foreshadowing
- **Instruction**: Add foreshadowing about vault
- **Words**: 1,189 → 1,256 (+67)
```

## Integration

### With `/cycle`

If editing adds element that needs earlier setup:
```
Edit added: Martha speaks Japanese
This wasn't established before.

Options:
a) Leave as discovery
b) Cycle back to plant this skill
```

### With `/summarize`

After significant edits:
```
Scene 012 edited significantly (+200 words, plot change)
Recommend re-summarizing? [y/n]
```

### With `/new-scene`

Quick access from scene creation:
```
/new-scene
[Scene created]

Edit this scene now? [y/n]
```

## Command Variations

Support different invocations:

```bash
/edit-scene              # Ask which scene
/edit-scene 12           # Edit scene 12
/edit-scene current      # Edit latest scene
/edit-scene 12 polish    # Direct to polish mode
```

## Output

After successful edit:
```
✓ Scene 012 updated
  - Word count: 1,234 → 1,189 (-45 words)
  - Changes: Tightened dialogue, added tension
  - Summary: May need update (use /summarize)

Next steps:
- Continue writing (/new-scene)
- Edit another scene
- Summarize changes (/summarize 12)
```

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

## Example Complete Workflow

```
You: /edit-scene 12

System: Scene 012 loaded (1,234 words)
        POV: Martha | Location: Safehouse | Status: draft

        What would you like to change?

You: Make the dialogue more tense and add sensory details
     about the safehouse interior

System: Working on edits...

        Preview of changes:

        === Dialogue (Line 45) ===
        Before: "We need to talk," Marcus said.
        After: "We need to talk. Now." Marcus's voice was tight.

        === Added Description (After line 23) ===
        The safehouse smelled of concrete dust and old coffee.
        Water stains spread across the ceiling like maps of
        forgotten countries.

        [3 more changes shown...]

        Summary:
        - Added tension to 4 dialogue exchanges
        - Added 2 sensory description paragraphs
        - Word count: 1,234 → 1,298 (+64)

        Accept changes? [y/e/r/s]

You: y

System: ✓ Scene 012 updated (1,298 words)
        ✓ Backup saved: scenes/scene-012.backup.md

        Edit further? [y/n]

You: n

System: Done! Scene 012 ready.
        Summary may need update (/summarize 12)
```

This gives you full editorial control while leveraging AI for improvements!
