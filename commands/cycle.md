# Cycle Back

Insert, modify, or add details to earlier scenes to set up elements discovered later in the story.

## What is Cycling?

In discovery writing, you often write a moment (Martha grabs the shotgun from her trunk in scene 24) and realize you need to plant it earlier (showing her putting it there in scene 11). This is **cycling** - going back to insert the setup after discovering the payoff.

## Task

1. **Identify the need**:
   - Ask user: What needs to be planted/set up?
   - Where does it pay off? (which scene number)
   - Where should the setup go? (earlier scene number, or "help me find the right spot")

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

   Example for "Martha puts shotgun in trunk":

   **Option 1 - Minimal** (add to existing action):
   ```
   Martha tossed her overnight bag in the trunk, then hesitated.
   She grabbed the shotgun from the hall closet and tucked it
   under the spare tire. Better safe than sorry.
   ```

   **Option 2 - Organic** (weave into scene):
   ```
   As Martha loaded the car, she ran through the mental checklist.
   Clothes, check. Cash, check. The old Remington from dad's
   collection—she lifted it from the hall closet, felt its familiar
   weight, and buried it under the spare tire in the trunk.
   The highway was a long, lonely stretch at night.
   ```

   **Option 3 - Expanded** (add emotional beat):
   ```
   Martha paused at the hall closet. The shotgun had been her
   father's—a Remington 870 he'd taught her to shoot when she
   was twelve. She hadn't fired it in years. Probably wouldn't
   need it now. But her instincts were screaming, and she'd
   learned to listen to them. She carried it to the car and
   tucked it carefully in the trunk, under the spare tire
   where it wouldn't shift during the drive.
   ```

6. **Update the scene file**:
   - Use Edit tool to insert the new content
   - Maintain the scene's flow and voice
   - Ensure it doesn't feel like a retrofit

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

   ### [Date] - Lock-picking Skill
   - **Payoff**: Scene 018 - Marcus picks the lock
   - **Setup Added**: Scene 006 - Mention he learned from his uncle
   - **Type**: Skill establishment
   - **Approach**: Minimal (one line of dialogue)

   ---
   ```

8. **Update summary if exists**:
   - Check if summary exists for the modified scene
   - Mark it as needing re-summarization
   - Note: "Scene X modified - added [detail]"

9. **Continuity check**:
   - Ensure the cycle doesn't conflict with anything else
   - Check related scenes for consistency
   - Update codex if needed (character skills, object inventory, etc.)

## Multiple Cycle Batch

If user has several cycles to make:
- List them all first
- Prioritize by scene order (do earlier scenes first)
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

## Integration

- `/summarize` can note cycles made since last summary
- `/status` can show pending cycles
- `/compile` uses the cycled versions
- `/chat` can help identify what cycles are needed

## Example Workflow

```
You: Just wrote scene 24 where Martha grabs the shotgun.
     Need to cycle back and plant it earlier.

/cycle

System: What needs to be set up?
You: Martha putting a shotgun in her car trunk

System: Where does it pay off?
You: Scene 24

System: Where should the setup go?
You: Scene 11, when she's packing to leave

System: [Reads scene 11]
        I found 3 good spots to insert this...

        [Shows options]

        Which version feels right?

You: Option 2

System: [Edits scene 011]
        ✓ Scene 011 updated
        ✓ Cycle tracked in notes/cycles.md
        ✓ Ready for scene 024 payoff

        Continue writing?
```

## Tips

- Cycle as you discover the need, don't batch them all for later
- Keep cycles organic - they should feel like they were always there
- Multiple light cycles are better than one heavy rewrite
- Track your cycles so you remember what you've planted
- Some cycles can wait until first draft complete

This is **discovery writing magic** - letting the story reveal what it needs, then making it whole.
