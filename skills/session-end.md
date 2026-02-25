---
name: session-end
description: Use when the user signals they are done writing for now. Trigger on: "wrapping up", "done for today", "end session", "that's it for today", "save and close", "I'm done writing", "calling it a day". Always confirm before committing to git.
---

# Session End

Close the writing session, log stats, and commit work.

## Task

1. **Check for active session**:
   - Read `notes/current-session.json`
   - If no active session: "No active session found. Nothing to close."

2. **Calculate stats**:
   - Duration: now - startTime (in minutes)
   - Words written: current word count - startWordCount
   - Scenes written: current scene count - startSceneCount
   - Words/hour: (wordsWritten / duration) * 60

3. **Show summary and confirm**:
   ```
   Session summary:
   ⏱  Duration: [N] minutes
   ✍️  Words: [+N] ([total] total)
   📄  Scenes: [+N] ([total] total)
   🚀  Pace: [N] words/hour
   Goal: [achieved/not achieved]

   Save stats and commit to git? (y/n)
   ```
   Only proceed if user confirms.

4. **If confirmed**:
   - Append to `notes/session-log.json`:
     ```json
     {
       "date": "YYYY-MM-DD",
       "startTime": "<ISO>",
       "endTime": "<ISO>",
       "duration": <minutes>,
       "wordsWritten": <number>,
       "scenesWritten": <number>,
       "wordsPerHour": <number>,
       "goal": "<string>",
       "goalAchieved": <boolean>
     }
     ```
   - Delete `notes/current-session.json`
   - Run git add + commit:
     ```bash
     git add -A && git commit -m "session: +[N] words, [N] scenes ([date])"
     ```

5. **Output**:
   ```
   ✓ Session logged and committed.
   Streak: [N] days
   ```

6. **Streak calculation**:
   - Check `notes/session-log.json` for consecutive dates
   - Update streak in session-log metadata
