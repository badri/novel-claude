---
name: new-scene
description: Use when the user wants to write the next scene, continue the story, add a new chapter, or generate new prose. Trigger on: "let's write", "next scene", "continue", "what happens next", "write the scene where X", "I want to write", or any intent to produce new story content.
---

# New Scene

Create a new scene file and optionally generate scene content.

## Scene types

- **Active scene** (default) — added to `scenes/` as part of the manuscript.
- **Draft scene** — added to `scenes/drafts/` for experimental or out-of-order
  writing. Use when the user asks for a draft, an experimental scene, or wants
  to write out of sequence (e.g. "draft the villain's backstory"). A draft can
  take a descriptive name instead of a scene number.

## Task

0. **Determine scene type** (from the user's intent):
   - If the user asked for a draft or an experimental/out-of-order scene:
     create in `scenes/drafts/`. Use a descriptive name if they gave one,
     otherwise `draft-NNN` numbering.
   - Otherwise: create an active scene in `scenes/` (default).

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

7. **Detect codex elements** (after the scene is created):

   Scan the new scene for codex-worthy elements (characters, locations,
   worldbuilding, demonstrated skills) and offer to add them — follow the
   codex skill's "Detecting Codex Elements from Content" workflow.

8. **Output**:
   - Show path to new scene file
   - Show word count
   - Report codex additions made (if any)
   - Show codex TODOs created (if "later" chosen)
   - Suggest next steps:
     - Continue writing
     - Summarize this scene
     - Brainstorm next scene
     - Review codex todo if items pending

## Important Notes

- Scene numbers are sequential and zero-padded (001, 002, ..., 010, 011, etc.)
- If user wants multiple options, generate 2-3 variations they can choose from
- Always maintain codex consistency (character names, locations, rules)
- For discovery writing: don't force plot points, follow the character's natural choices
