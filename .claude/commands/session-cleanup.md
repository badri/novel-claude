# Session Cleanup

Auto-save work and finalize session interaction logs at session end.

## Task

1. **Run `/session end`** to log the session stats

2. **Finalize session interaction log**:
   - If `notes/session-interactions/session-*.md` exists for this session
   - Append session summary footer:

   ```markdown
   ## Session Summary

   **Duration:** [from session stats]
   **Scenes written:** [from session stats]
   **Words written:** [from session stats]
   **Activities:** [from session stats]

   ---

   *This session log is indexed by DevRag for semantic search across writing sessions.*
   ```

3. **Git commit and push**:
   - Stage all changes: `git add -A`
   - Commit with message: `git commit -m "Session end: auto-save work"`
   - Push to remote: `git push`

This ensures:
- No work is lost between sessions
- Session interactions are captured and indexed by DevRag
- You can search across past sessions for decisions and discussions
