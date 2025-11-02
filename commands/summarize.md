# Summarize Scene

Create a reverse outline summary of one or more scenes using the Gemini CLI subagent.

## Task

1. **Determine scope**:
   - Ask user: Which scene(s) to summarize?
     - Current/latest scene
     - Specific scene number(s)
     - Range (e.g., scenes 5-10)
     - All scenes since last summary
     - All scenes (full reverse outline)

2. **Read the scene file(s)**:
   - Load scene content from scenes/ folder
   - Calculate total word count being summarized

3. **Invoke Gemini summarizer subagent**:
   - Use the @gemini-summarizer subagent
   - Pass scene content with appropriate prompt:
     - For single scene: focused summary
     - For multiple scenes: reverse outline format
   - Leverage Gemini's large context window

4. **Summary format request** (single scene):
```
Summarize this scene for a reverse outline. Include:
- POV character and location
- Key events and turning points
- Character decisions and actions
- Emotional beats
- Plot threads introduced or advanced
- Story questions raised or answered

Keep it concise but complete (2-3 paragraphs).
```

5. **Reverse outline format** (multiple scenes):
```
Create a reverse outline of these scenes. For each scene provide:

**Scene [number]**
- POV & Setting: [who and where]
- Key Events: [what happens]
- Character Development: [decisions, changes, revelations]
- Plot Threads: [what storylines advance]
- Story Questions: [what questions are raised/answered]

Keep each scene summary to 3-5 bullet points.
```

6. **Save summary**:
   - Create file: `summaries/summary-scene-XXX.md` (single scene)
   - Or: `summaries/reverse-outline-scenes-XXX-to-YYY.md` (range)
   - Or: `summaries/full-reverse-outline-[date].md` (all scenes)

Include:
```markdown
# Summary: Scene(s) XXX[-YYY]

Generated: [timestamp]
Model: Gemini [model version]
Word count analyzed: [number]

---

[Gemini's summary output]

---

## Codex Updates Needed
[Note any new characters, locations, or lore to add to codex]
```

7. **Present results**:
   - Show the summary to user
   - Highlight any continuity issues noticed
   - Suggest codex updates if new elements appeared
   - Ask: Ready to brainstorm the next scene?

## Options

User can specify:
- `--format=detailed` for longer summaries
- `--format=brief` for quick bullet points
- `--check-continuity` to ask Gemini to flag issues
- `--codex-extract` to pull character/location details

## Integration

- Update project.json with last summarized scene
- Link summaries to scenes (scene file can reference its summary)
- Use summaries as context for future scene writing

## Benefits

- Uses Gemini for heavy lifting (saves Claude tokens)
- Creates searchable reverse outline as you write
- Helps spot continuity issues early
- Maintains story bible automatically
- Perfect for Dean Wesley Smith's reverse outlining approach
