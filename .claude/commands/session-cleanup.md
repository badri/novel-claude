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
   - Check if there are any changes to commit: `git status --porcelain`
   - If changes exist:
     - Stage all changes: `git add -A`
     - Commit with message: `git commit -m "Session end: auto-save work - [date/time]"`
     - Push to remote if configured: `git push` (ignore errors if no remote exists)
   - If no changes, skip commit

**Important**:
- Always attempt git operations even if there's no remote configured
- Commit locally ensures work is versioned
- Push failures are non-critical (user might not have a remote yet)
- Use `git push 2>/dev/null || true` to prevent errors from stopping the cleanup

This ensures:
- No work is lost between sessions (locally committed)
- Session interactions are captured and indexed by DevRag
- You can search across past sessions for decisions and discussions
- Auto-backup to remote if configured
