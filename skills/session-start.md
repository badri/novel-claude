---
name: session-start
description: Use when the user is beginning a writing session, explicitly says they want to start, or when it's the first writing-related interaction in a new Claude Code session in a writing project. Trigger on: "start session", "let's begin", "starting to write", "I want to write today", or infer from context when user opens a project and gives their first task.
---

# Session Start

Begin a writing session and initialize tracking.

## Task

1. **Check for existing active session**:
   - Read `notes/current-session.json` if it exists
   - If active session found: "You have an active session from [time]. Continue it or start fresh?"

2. **Get current project stats**:
   - Read `project.json` for word count and scene count
   - Record as session baseline

3. **Ask for session goal (optional)**:
   - "What do you want to write today? (or skip)"
   - Accept: word count target, scene count, specific scene, or "no goal"

4. **Create `notes/current-session.json`**:
   ```json
   {
     "startTime": "<ISO-8601 timestamp>",
     "startWordCount": <number>,
     "startSceneCount": <number>,
     "sessionGoal": "<goal or null>",
     "status": "active"
   }
   ```

5. **Output**:
   ```
   ✓ Session started at [time]
   Baseline: [N] scenes, [N] words
   Goal: [goal or "open session"]
   ```
