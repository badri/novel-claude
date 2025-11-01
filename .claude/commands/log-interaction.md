# Log Session Interaction

Internal command to log user interactions during active writing sessions.

**Task**: Append user input to session interaction log for later vectorization via DevRag.

## Implementation

1. **Check if in project**: Verify `project.json` exists
2. **Check if session active**: Verify `notes/current-session.json` exists
3. **If not active**: Exit silently (no logging outside sessions)
4. **Get user input**: From hook arguments
5. **Create session interactions folder**: `notes/session-interactions/` if needed
6. **Determine session file**: Use session start time from `current-session.json`
   - Format: `session-YYYYMMDD-HHMMSS.md`
   - Example: `session-20251101-143000.md`
7. **Create session file** if doesn't exist with header:

```markdown
# Writing Session - [ISO timestamp]

**Session Goal:** [from current-session.json or "Not specified"]

## Interactions

```

8. **Append user input**:

```markdown
### [HH:MM:SS] User

[user input text]

```

9. **Exit silently**: No output to avoid cluttering the session

## File Format Example

```markdown
# Writing Session - 2025-11-01T14:30:00Z

**Session Goal:** Write 2 scenes

## Interactions

### [14:30:15] User

/new-scene

### [14:45:22] User

Can you help me brainstorm what happens next in the story?

### [14:50:10] User

/edit-scene 12

### [15:10:05] User

What was the detective's motivation again?

```

## Notes

- This command is called by the `UserPromptSubmit` hook automatically
- Only logs when session is active
- Silently does nothing if not in a session
- Session interactions will be summarized and indexed by DevRag when session ends
- Uses bash commands for file manipulation (efficient for appending)
