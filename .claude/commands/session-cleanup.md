# Session Cleanup

Auto-save work at session end by committing and pushing to git.

## Task

1. Run `/session end` to log the session stats
2. Stage all changes: `git add -A`
3. Commit with message: `git commit -m "Session end: auto-save work"`
4. Push to remote: `git push`

This ensures no work is lost between sessions.
