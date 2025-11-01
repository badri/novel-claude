# Concept - Pre-Project Story Brainstorming

Brainstorm a story concept before creating a project. This command runs OUTSIDE of a project directory and helps you develop your idea before scaffolding the full structure.

**Use case**: You have a story idea (e.g., "Count of Monte Cristo in space") and want to explore it before committing to a full project structure.

## Workflow

### 1. Verify Location

Check that you are NOT in an existing fiction project:
- If `project.json` exists in current directory, inform user this command is for pre-project brainstorming
- Suggest they use `/brainstorm` instead if they're in a project
- If they're in a project and still want to concept a NEW story, suggest they `cd` to their writing directory first

### 2. Capture the Concept

Ask the user for their high-level story concept:

```
What's your story concept?

Examples:
- "Count of Monte Cristo as a space opera"
- "Hardboiled detective in a cyberpunk city"
- "Romeo and Juliet but they're rival AI developers"
- "Small-town horror with cosmic implications"

Concept:
```

### 3. Interactive Brainstorming Session

Lead the user through exploring their concept with open-ended questions. Keep it conversational and discovery-focused:

**Genre & Tone:**
- What genre(s) does this story fit into?
- What's the emotional tone? (dark, hopeful, suspenseful, humorous, etc.)
- Any genre conventions you want to embrace or subvert?

**Setting:**
- Where does this story take place?
- When? (time period, futuristic, alternate history)
- What makes this setting unique or interesting?
- What are the "rules" of this world? (technology, magic, society, culture)

**Characters:**
- Who is the protagonist? What do they want?
- What's standing in their way?
- Who are the key supporting characters? (allies, antagonists, mentors)
- What makes these characters compelling?

**Story:**
- What's the inciting incident that kicks off the story?
- What are the major conflicts or obstacles?
- What's at stake? What happens if the protagonist fails?
- Do you have a sense of the ending? (it's okay if not!)

**Themes:**
- What questions or ideas does this story explore?
- What do you want readers to feel or think about?

### 4. Save the Session

Create a file in the current directory:
- Filename: `concept-YYYYMMDD-HHMMSS.md`
- Format:
  ```markdown
  # Story Concept - [Date]

  ## High-Level Concept

  [User's initial pitch]

  ## Genre & Tone

  [Notes from brainstorming]

  ## Setting

  [Notes from brainstorming]

  ## Characters

  [Notes from brainstorming]

  ## Story

  [Notes from brainstorming]

  ## Themes

  [Notes from brainstorming]

  ---

  Brainstormed: [timestamp]
  ```

### 5. Offer to Create Project

After saving the concept file, ask:

```
Would you like to create a project from this concept? (yes/no)
```

**If no:**
- Inform user: "Concept saved to concept-YYYYMMDD-HHMMSS.md"
- "Run /concept again to create the project later, or manually run /new-project"
- Exit

**If yes:**
- Proceed to step 6

### 6. Collect Project Metadata

Ask for the information needed by `/new-project`:

- **Project name** (kebab-case, will create directory)
  - Suggest a name based on the concept if appropriate
- **Story format** (short story, novella, novel)
  - Can infer from brainstorm or ask

Extract from brainstorm session (don't ask again):
- Genre (already discussed)
- Premise/logline (summarize from concept)

### 7. Create Project Structure

Run the `/new-project` workflow with the collected information:
1. Create all directories (scenes/, codex/, notes/, etc.)
2. Create project.json with metadata from brainstorm
3. Create codex templates
4. Copy .devrag-config.json
5. Copy .gitignore
6. Copy .claude/settings.json and hooks
7. **Move** `concept-YYYYMMDD-HHMMSS.md` to `[project-name]/brainstorms/initial-concept.md`
8. Initialize git repo

### 8. Populate Project Metadata

Update `project.json` with rich metadata from the brainstorm:

```json
{
  "projectName": "[user's choice]",
  "genre": "[from brainstorm]",
  "format": "[user's choice]",
  "premise": "[summarized from concept]",
  "createdDate": "[ISO timestamp]",
  "lastModified": "[ISO timestamp]",
  "status": "in-progress",
  "sceneCount": 0,
  "wordCount": 0,
  "currentScene": null,
  "metadata": {
    "concept": "[user's initial pitch]",
    "tone": "[from brainstorm]",
    "setting": "[brief summary]",
    "themes": "[from brainstorm]"
  }
}
```

### 9. Populate Codex from Brainstorm

Extract information from the brainstorm session and add to codex files:

**codex/characters.md:**
- Add any characters discussed with details mentioned

**codex/locations.md:**
- Add setting/location details

**codex/worldbuilding.md:**
- Add world rules, magic/tech systems, society notes

**codex/timeline.md:**
- Add any time period or historical context mentioned

This gives the writer a head start instead of empty codex files.

### 10. Output Summary

Tell the user:

```
✓ Project created at: [full path]
✓ Concept brainstorm moved to brainstorms/initial-concept.md
✓ Codex pre-populated with brainstorm notes
✓ DevRag vector search configured
✓ Session tracking enabled (automatic)

Next steps:
  cd [project-name]
  claude

Ready to write!
  /new-scene - Start writing your first scene
  /codex - Review/expand your world details
  /brainstorm - Continue developing the story

Your concept is the foundation - now build on it!
```

## Important Notes

- This command is designed for the BEGINNING of the creative process
- It respects discovery writing: no forced outlines, just exploration
- The brainstorm is preserved in the project for reference
- Writers can always run `/brainstorm` again after project creation
- If user already has a concept file, they can re-run `/concept` and it will offer to create the project
- The workflow is: **idea → exploration → structure**, matching natural creative flow

## Example Session

```
User: /concept

Claude: What's your story concept?

User: Count of Monte Cristo but in space - wrongfully imprisoned pilot seeks revenge on the empire that betrayed him

Claude: Love it! Let's explore this. What genre(s) does this fit?

User: Space opera with noir elements

Claude: What's the emotional tone?

User: Dark, morally complex, but with hope for redemption

[... brainstorming continues ...]

Claude: [Saves concept-20251101-203000.md]

Would you like to create a project from this concept? (yes/no)

User: yes

Claude: Great! What would you like to name this project?

User: cosmic-vengeance

Claude: [Creates project structure, moves concept file, populates codex]

✓ Project created at: /Users/you/writing/cosmic-vengeance
✓ Concept brainstorm moved to brainstorms/initial-concept.md
✓ Codex pre-populated with brainstorm notes

Next steps:
  cd cosmic-vengeance
  claude

Ready to write!
```

## Design Philosophy

This command bridges the gap between "I have an idea" and "I have a structured project." It respects that discovery writers often:
- Start with a spark of inspiration
- Need to explore before committing
- Want help developing the concept
- Benefit from capturing early thoughts
- Prefer organic development over rigid planning

The result is a project that starts with substance, not empty templates.
