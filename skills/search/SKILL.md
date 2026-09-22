---
name: search
description: Use when the user wants to find something in their manuscript, codex, notes, or brainstorms. Trigger on: "find X", "where did I mention", "search for", "which scene has", "look for", "did I write about", "find all references to".
---

# Search Project

Search across scenes, codex, and notes using keyword and pattern matching.

## Task

1. **Parse the search query** from user input.

2. **Search across project directories**:

   Use the Grep tool to search these locations:
   - `scenes/` — scene files (including `drafts/` and `archive/`)
   - `codex/` — worldbuilding entries
   - `brainstorms/` — brainstorm sessions
   - `summaries/` — deep reverse outlines
   - `notes/` — session notes (excluding current-session.json)
   - `ORDER.md` — reading order + one-line reverse outline

   Run grep with `-i` (case insensitive) and `-l` (file names) first to find matching files, then read the relevant sections.

3. **Present results grouped by type**:
   ```
   🔍 Search: "[query]"

   📝 Scenes (N matches):
   - scene-003.md (reads at position 6): "...matching context..."
   - scene-012.md (unplaced): "...matching context..."

   📚 Codex (N matches):
   - characters.md: "...matching context..."

   💭 Notes/Brainstorms (N matches):
   - brainstorms/magic-rules.md: "...matching context..."

   📄 ORDER.md (N matches):
   - position 6: [scene-003] — "...matching line..."
   ```

   Report scenes by **stable ID plus reading position** (from `ORDER.md`), or
   "unplaced" — the filename alone doesn't say where a scene reads.

4. **If no results**: "Nothing found for '[query]'. Try a broader term?"

5. **Follow-up**: Offer to open any matching file for full context.

## Notes

- No external dependencies — uses Claude's built-in Grep tool
- For semantic/conceptual search, describe what you're looking for in plain language and Claude will interpret
- Searches file content, not filenames
