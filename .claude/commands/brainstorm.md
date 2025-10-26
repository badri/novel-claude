# Brainstorm

Interactive brainstorming session for story development, next scenes, or solving story problems.

## Task

1. **Check context**:
   - Are we in a project folder? Read project.json
   - What's the current scene number?
   - Read the last 2-3 scenes for continuity
   - Check latest summaries

2. **Determine brainstorm type** (ask user or infer):
   - **Next scene**: What happens next? Where does the character go from here?
   - **Story problem**: Stuck on plot? Character motivation? Conflict?
   - **Character development**: Explore character depth, backstory, motivations
   - **World building**: Develop setting, culture, rules, atmosphere
   - **Multiple paths**: Generate 2-4 different directions the story could go

3. **Brainstorming approach**:
   - Ask probing questions to help user discover the story
   - Suggest possibilities without dictating
   - Respect discovery writing - follow character logic, not plot formulas
   - Generate multiple options when useful
   - Reference codex for consistency

4. **Save brainstorm session**:
   - Create file: `brainstorms/brainstorm-[date]-[topic].md`
   - Include:
     - Context (which scene we're after, what the problem was)
     - Questions asked and answers
     - Ideas generated
     - Options explored
     - Decision/direction (if reached)

5. **Output format**:

```markdown
# Brainstorm: [Topic]

Date: [timestamp]
After Scene: [number or "N/A"]

## Context
[Brief summary of where we are in the story]

## Question/Problem
[What we're brainstorming about]

## Ideas Explored

### Option 1: [Title]
[Description, pros/cons, where it leads]

### Option 2: [Title]
[Description, pros/cons, where it leads]

### Option 3: [Title]
[Description, pros/cons, where it leads]

## Notes
[Additional thoughts, questions to consider, codex updates needed]

## Next Steps
[What to do with these ideas]
```

6. **Detect codex-worthy elements**:

   During and after brainstorming, watch for:
   - **New characters** mentioned (names, roles, traits)
   - **New locations** developed (places, settings)
   - **Worldbuilding** details (rules, systems, organizations)
   - **Timeline events** (backstory, history)
   - **Lore** (myths, legends, world history)

7. **Inline codex creation**:

   If user says during brainstorm:
   - "Add to codex"
   - "Save this to codex"
   - "Put this in the codex"

   Immediately:
   - Identify what to add (from recent discussion)
   - Determine type (character/location/etc.)
   - Create entry
   - Continue brainstorming

   **Example**:
   ```
   [Discussing the Forbidden Vault]

   User: This vault is crucial. Add to codex.

   System: ✓ Adding Forbidden Vault to codex/locations.md

           [Creates entry from discussion]

           Done! Continuing brainstorm...
   ```

8. **End-of-session codex review**:

   After brainstorm session ends, before saving:

   ```
   Session complete!

   I noticed we developed:
   👤 Devika Menon (character - red herring suspect)
   📍 Forbidden Vault near Kings Valley (location)
   🌍 "The Order" - secret organization (worldbuilding)

   Add to codex?
   [Select: all / pick individually / skip / later]
   ```

   - **All**: Add all detected elements
   - **Pick individually**: Go through one by one
   - **Skip**: Don't add any
   - **Later**: Save to `notes/codex-todo.md`

9. **Actionable output**:
   - If user picks a direction: offer to create scene or update codex
   - Suggest `/new-scene` with the chosen direction
   - Offer to generate multiple scene openings based on brainstorm

## Brainstorming Philosophy

Following Dean Wesley Smith's approach:
- Trust the character's voice and choices
- Don't force plot structures
- Let the story emerge organically
- Multiple possibilities keep it exploratory
- "What would the character actually do here?"
- Avoid: "The hero must...", "Three-act structure requires...", "The plot needs..."
- Embrace: "What if...", "The character might...", "This could go several ways..."

## Codex Integration Details

### Auto-Detection Logic

Watch for patterns like:
- "Let's call this character [Name]"
- "The [Location] is where..."
- "In this world, [rule/system]..."
- "What if there's an organization called [Name]?"
- "Backstory: [event] happened [when]"

### Extraction Process

When codex element detected:
1. Extract name/title
2. Scan conversation for related details
3. Determine appropriate codex file
4. Generate structured entry
5. Offer to user (inline or end-of-session)

### Natural Language During Brainstorm

User can say:
- "Add Devika to codex" → Creates character entry
- "Save the Forbidden Vault" → Creates location entry
- "Codex this" → Adds last discussed element
- "Put this in worldbuilding" → Adds to worldbuilding.md

System responds immediately without breaking flow.

### Codex TODO for "Later"

When user chooses "later", append to `notes/codex-todo.md`:

```markdown
## From Brainstorm: [Topic] ([Date])
- [ ] **Character**: Devika Menon
      Red herring suspect, works at law firm
      Session: brainstorms/brainstorm-2025-10-26-suspects.md

- [ ] **Location**: Forbidden Vault
      Near Kings Valley, ancient, dangerous
      Session: brainstorms/brainstorm-2025-10-26-vault.md
```

User can later run `/codex review-todo` to process these.

## Integration

- Pull from codex automatically for relevant characters/locations
- Detect and offer to save new elements (inline or end-of-session)
- Link brainstorm sessions to codex entries
- Link to related scenes or previous brainstorm sessions
