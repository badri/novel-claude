# New Scene

Create a new scene file and optionally generate scene content.

## Task

1. **Check project context**:
   - Verify we're in a fiction project folder (has project.json)
   - Read project.json to get current scene count
   - Calculate next scene number (zero-padded, e.g., 001, 002, etc.)

2. **Read relevant context** (if available):
   - Last 1-2 scene files for continuity
   - Latest summary from summaries/ folder
   - Relevant codex entries if user specifies

3. **Ask user**:
   - Do they want to write the scene themselves or have AI generate it?
   - If AI: What should happen in this scene? (brief description)
   - Any specific codex elements to reference? (characters, locations)

4. **Create scene file**: `scenes/scene-XXX.md`

Template structure:
```markdown
# Scene XXX

**POV**: [character name or TBD]
**Location**: [setting]
**Time**: [when this takes place]

---

[Scene content goes here]

---

**Notes**:
- Word count: [calculate]
- Status: draft
- Date: [current date]
```

5. **If AI-generated**:
   - Use Claude to write the scene based on user's description
   - Inject relevant codex context
   - Maintain continuity with previous scenes
   - Write in the style/tone of existing scenes if available
   - Generate multiple options if user requests it

6. **Update project.json**:
   - Increment sceneCount
   - Update currentScene to new scene number
   - Update wordCount (calculate from all scenes)
   - Update lastModified date

7. **Output**:
   - Show path to new scene file
   - Show word count
   - Suggest next steps:
     - Continue writing
     - `/summarize` this scene
     - `/brainstorm` next scene

## Important Notes

- Scene numbers are sequential and zero-padded (001, 002, ..., 010, 011, etc.)
- If user wants multiple options, generate 2-3 variations they can choose from
- Always maintain codex consistency (character names, locations, rules)
- For discovery writing: don't force plot points, follow the character's natural choices
