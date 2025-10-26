# Reorder Scenes

Reorganize scene sequence when you discover a better order for your story.

## When to Reorder

In discovery writing, you might realize:
- A scene works better earlier/later in the story
- Two scenes should be swapped
- Flashbacks should move
- POV scenes should be interleaved differently
- Timeline needs adjustment

## Task

1. **Determine reorder type**:
   - **Swap**: Exchange two scenes (swap 5 and 8)
   - **Move**: Move one scene to different position (move 12 to after 7)
   - **Resequence**: Manually set new order for multiple scenes
   - **Insert gap**: Make room for a new scene between existing ones

2. **Ask for the reorder**:

   **Swap**:
   ```
   Swap which scenes?
   > "5 and 8" or "scene-005 and scene-008"
   ```

   **Move**:
   ```
   Move which scene?
   > "12"

   Move to where?
   > "After scene 7" or "Before scene 3" or "Position 2"
   ```

   **Resequence**:
   ```
   Provide new order (comma-separated scene numbers):
   > "1,2,3,7,8,4,5,6,9,10..."

   Or describe the change:
   > "Move all Jack POV scenes (5,9,13) to come after their corresponding Martha scenes"
   ```

3. **Preview the change**:

   Show before and after:
   ```markdown
   # Reorder Preview

   ## Current Order
   001 - Martha receives letter
   002 - Martha meets Jack
   003 - Jack discovers files
   004 - Martha drives north
   005 - Jack confronts boss

   ## Proposed Order (Move scene 5 to after 3)
   001 - Martha receives letter
   002 - Martha meets Jack
   003 - Jack discovers files
   004 - Jack confronts boss    [was 005]
   005 - Martha drives north    [was 004]

   This change:
   - Keeps Jack's storyline together
   - Shifts Martha's journey later
   - Maintains chronological flow

   Proceed with reorder? [y/n]
   ```

4. **Execute the reorder**:

   **Method: Rename files with temp names, then final names**

   For swap of 005 and 008:
   ```bash
   mv scenes/scene-005.md scenes/scene-005.tmp
   mv scenes/scene-008.md scenes/scene-008.tmp
   mv scenes/scene-005.tmp scenes/scene-008.md
   mv scenes/scene-008.tmp scenes/scene-005.md
   ```

   For move (scene 12 to position 8):
   ```bash
   # Save scene 12
   mv scenes/scene-012.md scenes/scene-temp.md

   # Shift scenes 8-11 down one position
   mv scenes/scene-011.md scenes/scene-012.md
   mv scenes/scene-010.md scenes/scene-011.md
   mv scenes/scene-009.md scenes/scene-010.md
   mv scenes/scene-008.md scenes/scene-009.md

   # Place old scene 12 in position 8
   mv scenes/scene-temp.md scenes/scene-008.md
   ```

   For complete resequence:
   ```bash
   # Create temp directory
   mkdir scenes/temp

   # Copy all scenes to temp with new numbers based on new order
   # Then move back to scenes/ and delete temp
   ```

5. **Update scene headers**:

   After renaming, update the `# Scene XXX` header in each moved file:
   ```markdown
   # Scene 008  [update this number]

   **POV**: Martha
   ...
   ```

6. **Update references**:

   Check and update:
   - **project.json**: Adjust scene count if needed, update currentScene
   - **summaries/**: Rename summary files to match new scene numbers
   - **cycles.md**: Update scene references in cycle tracking
   - **brainstorms/**: Update any scene number references
   - **Codex**: Update "First Appearance: Scene XXX" references

7. **Create reorder log**:

   Update `notes/reorders.md`:
   ```markdown
   # Scene Reorder Log

   ## [Date] - Jack Storyline Consolidation

   **Type**: Move
   **Change**: Moved scene 012 (Jack confronts boss) to position 008
   **Reason**: Keep Jack's investigative thread together before Martha's journey

   **Scene Mapping**:
   - Old 012 → New 008 (Jack confronts boss)
   - Old 008 → New 009 (Martha drives north)
   - Old 009 → New 010 (Border checkpoint)
   - Old 010 → New 011 (Crossing border)
   - Old 011 → New 012 (Jack follows lead)

   **Files Updated**:
   - Renamed 5 scene files
   - Updated scene headers
   - Renamed 3 summary files
   - Updated cycles.md references
   - Updated codex references

   **Impact**:
   - Timeline: Still coherent (Jack's scene happens earlier same day)
   - Continuity: No issues detected
   - Narrative flow: Improved - keeps character threads together

   ---
   ```

8. **Verify integrity**:

   After reorder, check:
   - All scene files sequentially numbered (no gaps)
   - All scene headers match file numbers
   - Summaries match their scenes
   - No broken references
   - Timeline still makes sense
   - Continuity preserved

   Generate verification report:
   ```markdown
   # Reorder Verification

   ✓ Scene sequence: 001-024 (no gaps)
   ✓ Scene headers updated: 5 files
   ✓ Summaries renamed: 3 files
   ✓ References updated: cycles.md, 2 codex entries
   ⚠ Timeline check needed: Scene 008 now before 009 - verify dates
   ✓ No continuity breaks detected

   Ready to continue writing!
   ```

9. **Output to user**:
   - Show what was changed
   - Confirm new order
   - Highlight any issues to review
   - Suggest next steps

## Reorder Strategies

### By POV Character
Group all scenes by character, then interleave:
```
Before: M,M,J,M,J,M,M,J
After:  M,J,M,J,M,J,M,M
```

### By Timeline
Arrange chronologically if discovered timeline is different from narrative order:
```
Narrative: 1(Tuesday),2(Wednesday),3(Monday),4(Thursday)
Timeline:  3(Monday),1(Tuesday),2(Wednesday),4(Thursday)
```

### By Story Thread
Keep related plot threads together:
```
Before: A,B,A,C,B,A,C
After:  A,A,A,B,B,C,C
```

### Create Flashback Structure
Move present-day scenes together, then interleave flashbacks:
```
Before: Present,Flashback,Present,Present,Flashback
After:  Flashback,Flashback,Present,Present,Present
Or:     Present,Flashback,Present,Flashback,Present
```

## Important Notes

### When NOT to Reorder

Avoid reordering if:
- You're just worried about "correct" structure (trust discovery!)
- You haven't finished the first draft
- It's based on someone else's outline preference
- The current order emerged naturally from the writing

### When TO Reorder

Reorder when:
- Character threads got tangled and you see a clearer way
- Timeline reveals itself and current order is confusing
- You discovered the story structure and want to enhance it
- Pacing needs adjustment (slow sections grouped vs. spread)
- Readers (or you) lose track of a storyline

### Discovery Writing Philosophy

Reordering is **structure discovery**, not rewriting:
- The scenes stay the same (content unchanged)
- You're finding the best shape for the story you wrote
- This is part of completing the first draft
- Dean Wesley Smith considers this acceptable "finishing work"

## Options

- `--dry-run`: Show preview only, don't execute
- `--with-content-check`: Verify continuity after reorder
- `--update-summaries`: Regenerate affected summaries after reorder
- `--timeline-check`: Verify timeline coherence

## Integration

- `/scenes list` shows current order
- `/chat` can discuss if reorder makes sense
- `/summarize` can regenerate summaries after reorder
- `/compile` uses the new order automatically

## Example Workflow

```
User: I wrote scenes 1-15 but realized all the Jack scenes
      (5,9,13) should come right after their Martha scenes
      to keep the parallel storylines clear.

/reorder

System: What type of reorder?
You: Resequence - move scenes around

System: Current order:
        001-Martha, 002-Martha, 003-Jack, 004-Martha, 005-Jack,
        006-Martha, 007-Jack, 008-Martha, 009-Martha, 010-Jack...

        Describe the change:
You: Move scene 5 to after 4, scene 9 to after 8, scene 13 to after 12

System: [Calculates new mapping]

        Preview:
        001-Martha
        002-Martha
        003-Martha [was 004]
        004-Jack [was 005]
        005-Jack [was 003]
        006-Martha [was 006]
        007-Martha [was 008]
        008-Jack [was 009]
        ...

        This groups Martha-Jack pairs together.
        Proceed?

You: Yes

System: ✓ 10 scenes renamed
        ✓ Scene headers updated
        ✓ 8 summaries renamed
        ✓ cycles.md updated
        ✓ Verification complete

        New order active! Continue writing scene 016?
```

## Safety

- Creates backup before major resequencing
- Logs all changes in `notes/reorders.md`
- Verifies integrity after changes
- Can reverse if needed (using reorder log)

This gives you complete control over scene sequence as your story reveals its natural structure!
