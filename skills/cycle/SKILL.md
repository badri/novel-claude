---
name: cycle
description: Use when the user wants to write a payoff first and plant setups later, write out of order, or work backward from a known ending. Trigger on: "write the ending first", "I know how this ends", "cycle", "work backwards", "plant the setup for X".
---

# Cycle Back

Insert, modify, or add details to earlier scenes to set up elements discovered later in the story.

## What is Cycling?

In discovery writing, you often write a moment (Martha grabs the shotgun from her trunk in scene 24) and realize you need to plant it earlier (showing her putting it there in scene 11). This is **cycling** - going back to insert the setup after discovering the payoff.

## Task

1. **Identify the need**:
   - Ask user: What needs to be planted/set up?
   - Where does it pay off? (which scene — by stable ID; check `ORDER.md` for
     where that scene actually reads)
   - Where should the setup go? (an earlier scene, or "help me find the right
     spot")

   **Read `ORDER.md` first.** "Earlier" means earlier in *reading order*, not
   a lower stable ID — an out-of-order project's `scene-008` may read after
   `scene-022`. Resolve payoff and target through the reading list before
   touching anything.

2. **Find the best insertion point**:
   - If user knows the scene: read that scene
   - If user isn't sure: read scenes before the payoff and suggest 2-3 good spots
   - Look for natural moments where this detail fits organically

3. **Types of cycles**:

   **Setup insertion**:
   - Plant an object (shotgun in trunk)
   - Establish a skill (she knows how to pick locks)
   - Introduce a relationship (mention of a character before they appear)
   - Set up a location (character's been there before)

   **Foreshadowing**:
   - Add a detail that hints at what's coming
   - Character notices something they'll need later
   - Casual mention that becomes significant

   **Consistency fix**:
   - Character trait mentioned in scene 20 needs to appear in scene 5
   - Timeline adjustment (it's Tuesday not Monday)
   - Detail correction (her eyes are blue not brown)

   **Backstory insertion**:
   - Add a memory or flashback
   - Reference past event
   - Establish history between characters

4. **Approach options**:

   Ask user:
   - **Minimal**: Just add the essential detail (one sentence)
   - **Organic**: Weave it naturally into existing action (paragraph)
   - **Scene expansion**: Add a beat/moment around it (multiple paragraphs)

5. **Generate the insertion**:

   Read the target scene and suggest:
   - 2-3 exact spots where the detail could fit
   - Different versions (subtle vs. prominent)
   - How to make it feel natural, not forced

6. **Show the insertion and wait for approval** — a cycle is an untagged
   edit to finished prose, so it gets the same preview as `edit-scene`:
   the paragraph before and after, the change marked. Write only on accept.
   Alternatively the author drops an `<add>` tag at the spot and says
   "rewrite NNN"; then it's the tagged flow and needs no preview.
   - Maintain the scene's flow and voice
   - Ensure it doesn't feel like a retrofit
   - Run the house-style three-second tests on the inserted text

7. **Track the cycle**:

   Create/update `notes/cycles.md`:
   ```markdown
   # Cycling Tracking

   ## Cycles Made

   ### [Date] - Shotgun Setup
   - **Payoff**: Scene 024 - Martha uses shotgun from trunk
   - **Setup Added**: Scene 011 - Martha puts shotgun in trunk
   - **Type**: Object plant
   - **Approach**: Organic weave

   ---
   ```

8. **Update summary if exists**:
   - Check if summary exists for the modified scene
   - Mark it as needing re-summarization
   - Note: "Scene X modified - added [detail]"

9. **Refresh the `ORDER.md` line if the cycle changed what the scene is**:
   - A planted object or established skill often means the one-line reverse
     outline is now incomplete. Propose the updated line and apply on
     approval. The scene's **position** never changes — a cycle adds content,
     it never reorders.

10. **Continuity check**:
   - Ensure the cycle doesn't conflict with anything else
   - Check related scenes for consistency
   - Update codex if needed (character skills, object inventory, etc.)

## Multiple Cycle Batch

If user has several cycles to make:
- List them all first
- Prioritize by **reading order** (`ORDER.md`) — do setups that read earliest
  first
- Check for conflicts between cycles
- Process one at a time

## Clean First Draft Philosophy

Cycling is NOT rewriting - it's **completing** the first draft:
- You're adding discovered elements
- Not changing the story fundamentally
- Making payoffs work that emerged organically
- This is part of forward momentum

Dean Wesley Smith endorses cycling as distinct from revision.

## Output

After cycling:
- Show the modified scene section
- Confirm the cycle is tracked
- Update word count if changed
- Suggest: continue writing forward, or make another cycle

## Tips

- Cycle as you discover the need, don't batch them all for later
- Keep cycles organic - they should feel like they were always there
- Multiple light cycles are better than one heavy rewrite
- Track your cycles so you remember what you've planted
- Some cycles can wait until first draft complete

This is **discovery writing magic** - letting the story reveal what it needs, then making it whole.
