---
name: reorder
description: Use when the user wants to restructure, reorganize, or renumber scenes. Trigger on: "move scene X before Y", "reorder", "restructure", "scene X should come first", "swap scenes N and M".
---

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

   **Swap**: "Swap which scenes? e.g. 5 and 8"

   **Move**: "Move which scene? / Move to where?"

   **Resequence**: "Provide new order (comma-separated scene numbers)"

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
   ```

4. **Confirm before renumbering**:

   Before renumbering files, confirm with user:
   "This will rename [N] scene files. Proceed? (y/n)"
   Only proceed if confirmed.

5. **Execute the reorder** (only after confirmation):

   Use temp names to avoid collisions when renaming, then final names.

6. **Update scene headers**:

   After renaming, update the `# Scene XXX` header in each moved file.

7. **Update references**:

   Check and update:
   - **project.json**: Adjust scene count if needed, update currentScene
   - **summaries/**: Rename summary files to match new scene numbers
   - **cycles.md**: Update scene references in cycle tracking
   - **Codex**: Update "First Appearance: Scene XXX" references

8. **Create reorder log**:

   Update `notes/reorders.md` with date, type, change, scene mapping, and reason.

9. **Verify integrity**:

   After reorder, check:
   - All scene files sequentially numbered (no gaps)
   - All scene headers match file numbers
   - Summaries match their scenes
   - No broken references

10. **Output to user**:
    - Show what was changed
    - Confirm new order
    - Highlight any issues to review

## Discovery Writing Philosophy

Reordering is **structure discovery**, not rewriting:
- The scenes stay the same (content unchanged)
- You're finding the best shape for the story you wrote
- This is part of completing the first draft

## When NOT to Reorder

Avoid reordering if:
- You're just worried about "correct" structure (trust discovery!)
- You haven't finished the first draft
- It's based on someone else's outline preference
- The current order emerged naturally from the writing

## Safety

- Logs all changes in `notes/reorders.md`
- Verifies integrity after changes
- Can reverse if needed (using reorder log)
