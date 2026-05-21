---
name: concept
description: Use when the user has a story idea they want to explore before committing to a project, or wants pre-project brainstorming outside a project directory. Trigger on: "I have a story idea", "concept", "before I start a project", "explore a story idea", "[X] in space", "kick around an idea for a new story".
---

# Concept — Pre-Project Story Brainstorming

Explore and develop a story idea *before* scaffolding a project. This runs
OUTSIDE a project directory and bridges "I have an idea" and "I have a
structured project."

## Task

### 1. Verify location

Check the current directory is NOT an existing fiction project:
- If `project.json` exists here, this is the wrong moment for pre-project work.
  Tell the user the `brainstorm` skill handles in-project exploration. If they
  genuinely want to concept a *new, separate* story, suggest they `cd` to a
  fresh directory first.

### 2. Capture the concept

Ask for their high-level story concept. Offer examples to prime them:
- "Count of Monte Cristo as a space opera"
- "Hardboiled detective in a cyberpunk city"
- "Small-town horror with cosmic implications"

### 3. Interactive brainstorming

Lead a conversational, discovery-focused session. Ask across these areas
(not as a rigid checklist — follow the user's energy):

- **Genre & tone:** genres, emotional tone, conventions to embrace or subvert
- **Setting:** where, when, what makes it unique, the world's rules
- **Characters:** protagonist and their want, what opposes them, key supporting cast
- **Story:** inciting incident, major conflicts, stakes, any sense of the ending
- **Themes:** questions the story explores, what readers should feel

### 4. Save the session

Create `concept-YYYYMMDD-HHMMSS.md` in the current directory:

Save this before asking anything else — nothing is lost if the user steps away.

```markdown
# Story Concept - [Date]

## High-Level Concept
[User's initial pitch]

## Genre & Tone
[Notes]

## Setting
[Notes]

## Characters
[Notes]

## Story
[Notes]

## Themes
[Notes]

---
Brainstormed: [timestamp]
```

### 5. Offer to create a project

Ask: "Want to create a project from this concept? (yes/no)"

**If no:** Tell the user the concept is saved to `concept-YYYYMMDD-HHMMSS.md`
and they can come back to it anytime. Done.

**If yes:** Continue to step 6.

### 6. Hand off to project creation

Collect the two things project creation still needs:
- **Project name** (kebab-case — suggest one based on the concept)
- **Story format** (short story, novella, novel — infer or ask)

Genre and premise are already known from the brainstorm — summarize the
premise yourself, don't re-ask.

Now run the **new-project skill** to scaffold the project. You already hold
the project name, genre, format, and premise from this session, plus the
full brainstorm — carry that forward and supply it directly at new-project's
metadata-collection step instead of re-asking the user. Use the brainstorm
content to enrich the generated `CLAUDE.md`, `project.json` metadata, and the
codex files. Git initialization is handled by the new-project skill.

### 7. Move the concept file into the project

After the project is scaffolded, move `concept-YYYYMMDD-HHMMSS.md` into the
new project as `brainstorms/initial-concept.md`.

### 8. Output summary

Tell the user:

```
✓ Project created at: [full path]
✓ Concept brainstorm moved to brainstorms/initial-concept.md
✓ CLAUDE.md, project.json, and codex pre-populated from the brainstorm

Next: cd [project-name] && claude

Ready to write — start your first scene, expand the codex, or
keep developing the story.
```

## Notes

- This is for the BEGINNING of the creative process: idea → exploration → structure.
- It respects discovery writing — no forced outlines, just exploration.
- Once a project exists, the `brainstorm` skill handles ongoing exploration.
- The concept file is preserved in the project for reference.
