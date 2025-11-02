# New Scene

Create a new scene file and optionally generate scene content.

## Usage

- `/new-scene` - Create active scene in `scenes/`
- `/new-scene --draft` - Create draft scene in `scenes/drafts/` (experimental/out-of-order writing)
- `/new-scene --draft "villain-backstory"` - Create named draft scene

## Task

0. **Check for --draft flag**:
   - If `--draft` flag present: Create in `scenes/drafts/` folder
   - If `--draft` with name: Use custom name instead of scene number
   - If no flag: Create active scene in `scenes/` (default behavior)

1. **Check project context**:
   - Verify we're in a fiction project folder (has project.json)
   - Read project.json to get current scene count
   - Calculate next scene number (zero-padded, e.g., 001, 002, etc.)
   - For drafts: Use descriptive filename or draft-NNN numbering

2. **Read relevant context** (if available):
   - Last 1-2 scene files for continuity
   - Latest summary from summaries/ folder
   - Relevant codex entries if user specifies

3. **Ask user**:
   - Do they want to write the scene themselves or have AI generate it?
   - If AI: What should happen in this scene? (description + instructions)
   - Any specific codex elements to reference? (characters, locations)

   **Natural Language Scene Instructions**:

   User can mix plot description with writing instructions naturally:

   ```
   Joe meets the weapons dealer at the Park. Add description
   in 5 senses from Joe's PoV of the Park.

   Joe and the dealer have a sour argument about supply chain
   and logistics. More dialogue, make it tense.

   End with cliffhanger, don't resolve, don't hint Joe's intentions.
   ```

   **No special syntax required** - just write naturally. The AI distinguishes:
   - **Plot/what happens**: "Joe meets the dealer"
   - **Writing directives**: "Add 5 senses", "More dialogue", "End with cliffhanger"

   **Common instruction patterns**:
   - "Add description of..." / "Describe the..."
   - "More dialogue" / "Expand the conversation"
   - "Show don't tell" / "Action not exposition"
   - "From [character's] POV" / "[Character's] internal thoughts"
   - "Make it tense/ominous/romantic"
   - "End with cliffhanger" / "Leave it unresolved"
   - "Foreshadow..." / "Plant hints about..."
   - "Skip to..." / "Time jump to..."
   - "5 senses" / "Sensory details"
   - "Don't reveal..." / "Keep [X] mysterious"

   The AI:
   1. Parses plot description (what happens)
   2. Identifies writing directives (how to write it)
   3. Generates scene following both
   4. Returns only prose (no meta-instructions in output)

4. **Create scene file**:
   - Active scene: `scenes/scene-XXX.md`
   - Draft scene (numbered): `scenes/drafts/draft-XXX.md`
   - Draft scene (named): `scenes/drafts/[name].md`

Template structure:
```markdown
# Scene XXX  (or Draft: [Name])

**POV**: [character name or TBD]
**Location**: [setting]
**Time**: [when this takes place]
**Status**: active | draft

---

[Scene content goes here]

---

**Notes**:
- Word count: [calculate]
- Created: [current date]
- Type: [active/draft]
```

**Status field values**:
- `active` - In main scenes/ folder, part of manuscript
- `draft` - In drafts/ folder, experimental/out-of-order

5. **If AI-generated**:
   - Use Claude to write the scene based on user's description
   - Inject relevant codex context
   - Maintain continuity with previous scenes
   - Write in the style/tone of existing scenes if available
   - Generate multiple options if user requests it

6. **Update project.json** (only for active scenes):
   - **IF active scene** (created in `scenes/`):
     - Increment sceneCount
     - Update currentScene to new scene number
     - Update wordCount (calculate from all active scenes)
     - Update lastModified date
   - **IF draft scene** (created in `scenes/drafts/`):
     - Do NOT update scene count (drafts are experimental)
     - Do NOT update currentScene
     - Do NOT include in word count
     - Drafts exist outside official manuscript tracking

7. **Detect new codex elements** (after scene is created):

   Scan the scene content for:
   - **New characters** not in `codex/characters.md`
   - **New locations** not in `codex/locations.md`
   - **Worldbuilding** details (organizations, systems, rules)
   - **Skills/abilities** demonstrated by characters
   - **Timeline events** mentioned
   - **Lore** references

8. **Smart detection process**:

   **New Characters**:
   - Look for proper names in narrative
   - Dialogue attribution: `"Hello," Yuki said`
   - Character descriptions: "A woman named X"
   - POV character if not in codex

   **New Locations**:
   - Named places: "Jade Dragon restaurant", "Kings Valley"
   - Setting descriptions: "They arrived at the [location]"
   - Geographic references

   **Worldbuilding Elements**:
   - Organizations: "the Network", "the Order", "the Council"
   - Systems: "quantum communicators", "blood magic"
   - Rules: "Vampires can't cross running water"
   - Tech/magic items with significance

   **Character Skills/Abilities**:
   - "Martha picked the lock" → lockpicking skill
   - "He spoke fluent Mandarin" → language skill
   - Check if skill was established in codex previously

9. **Offer codex additions**:

   After scene is created, present findings:

   ```
   ✓ Scene 015 created (1,456 words)

   ✨ New elements detected:

   👤 **New Character**: Yuki (informant)
      Not in codex. Add now? [y/n/later]

   📍 **New Location**: Jade Dragon restaurant (Tokyo)
      Not in codex. Add now? [y/n/later]

   🌍 **Worldbuilding**: Network operations in Tokyo
      Expand worldbuilding codex? [y/n/later]

   🔧 **Character Skill**: Martha - lockpicking
      Not established before. Options:
      a) Add to codex only
      b) Add to codex + cycle back to plant skill
      c) Skip
   ```

10. **Process user choices**:

    **[y] - Add now**:
    - Extract details from scene
    - Generate codex entry
    - Show preview
    - User confirms or edits
    - Add to appropriate codex file

    **[n] - Skip**:
    - Don't add (minor character, one-time location)
    - Continue to next detection

    **[later] - Add to TODO**:
    - Append to `notes/codex-todo.md`
    - Process later with `/codex review-todo`

    **For skills - [b] Add + cycle**:
    - Add skill to character's codex entry
    - Trigger `/cycle` workflow to plant earlier
    - Seamless integration

11. **Auto-generated codex entries**:

    When user says "yes", generate entry from scene:

    **Character example**:
    ```markdown
    ## Yuki

    **Role**: Supporting (Informant)
    **Appearance**: [from scene: "slim, dark eyes, nervous hands"]
    **Personality**: Cautious, well-informed, risk-averse
    **Background**: Tokyo-based informant with Network intel
    **Goals**: [TBD - expand as story develops]
    **Conflicts**: Fear vs desire to help
    **Relationships**: Marcus (scene 15 - provides information)
    **First Appearance**: Scene 015

    ---
    ```

    **Location example**:
    ```markdown
    ## Jade Dragon Restaurant

    **Type**: Restaurant
    **Location**: Tokyo
    **Description**: [from scene: "dimly lit, private booths, red lanterns"]
    **Atmosphere**: Discreet, traditional, clandestine meetings
    **Significance**: Information exchange location
    **First Appearance**: Scene 015

    ---
    ```

12. **Output**:
    - Show path to new scene file
    - Show word count
    - Report codex additions made (if any)
    - Show codex TODOs created (if "later" chosen)
    - Suggest next steps:
      - Continue writing
      - `/summarize` this scene
      - `/brainstorm` next scene
      - `/codex review-todo` if items pending

## Important Notes

- Scene numbers are sequential and zero-padded (001, 002, ..., 010, 011, etc.)
- If user wants multiple options, generate 2-3 variations they can choose from
- Always maintain codex consistency (character names, locations, rules)
- For discovery writing: don't force plot points, follow the character's natural choices

## Codex Detection Strategy

### Cross-Reference Before Flagging

Before flagging an element as "new":
1. Search `codex/characters.md` for character name
2. Search `codex/locations.md` for location name
3. Search `codex/worldbuilding.md` and `codex/lore.md` for concepts
4. Only flag if NOT found

### Smart Filtering

Don't flag:
- Generic terms (guard, waiter, bartender) unless given a name
- Common locations (street, building) unless specifically named
- Throwaway mentions (not developed in scene)

DO flag:
- Named characters with dialogue or description
- Named locations with atmosphere/description
- Organizations, systems, unique tech/magic
- Skills demonstrated that aren't established

### Batch Processing

Present all detections together, not one-by-one:
- Shows complete picture
- User can process efficiently
- Can select "all yes" or "all later" for speed

### Integration with Cycle

When skill detected that wasn't established:
```
🔧 Martha demonstrated lockpicking (scene 24)
   This wasn't established before.

   Options:
   a) Add to codex only (accept as discovered skill)
   b) Add to codex + cycle back to plant it earlier
   c) Skip

If user picks (b):
   → Updates codex with skill
   → Automatically launches /cycle
   → Suggests scene to plant (e.g., scene 6 where Martha's background shown)
   → User confirms or picks different scene
   → Cycles back and adds setup
```

This makes discovery → setup workflow seamless!

## Example Complete Workflow

```
You: /new-scene

System: What happens in this scene?

You: Marcus meets a new informant named Yuki at the Jade Dragon
     restaurant in Tokyo. She tells him about Network operations.

System: Generating scene...

        ✓ Scene 015 created (1,456 words)

        ✨ New elements detected:

        👤 **Yuki** (informant)
           Not in codex. Add? [y/n/later]

You: y

System: [Generates entry from scene content]

        ## Yuki
        **Role**: Supporting (Informant)
        **Appearance**: Slim, dark eyes, nervous
        ...

        Looks good? [y/edit]

You: y

System: ✓ Yuki added to codex/characters.md

        📍 **Jade Dragon restaurant** (Tokyo)
           Not in codex. Add? [y/n/later]

You: y

System: ✓ Jade Dragon added to codex/locations.md

        🌍 **Network operations in Tokyo**
           New worldbuilding detail. Add? [y/n/later]

You: later

System: ✓ Added to notes/codex-todo.md

        Complete!
        - 2 codex entries added
        - 1 item saved to TODO

        Next: /new-scene to continue writing?
```
