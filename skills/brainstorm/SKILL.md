---
name: brainstorm
description: Use when the user is stuck, exploring story possibilities, or needs to work through plot problems before writing. Trigger on: "I'm stuck", "what should happen", "brainstorm", "help me figure out", "what if", "I can't decide what to do next", "let's think through".
---

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

6. **Codex elements** — two triggers:

   - **Inline** — if the user says "add to codex" / "save this to codex"
     mid-session, act immediately: identify what to add from the recent
     discussion, create the entry, and continue brainstorming.
   - **End of session** — before saving the brainstorm, surface any
     codex-worthy elements developed during the discussion.

   For detection criteria and the add/skip/later flow, follow the codex
   skill's "Detecting Codex Elements from Content" workflow.

7. **Actionable output**:
   - If user picks a direction: offer to create scene or update codex
   - Suggest writing the next scene with the chosen direction
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
