# Writing Session Tracking

Track time spent writing and words created per session for accountability and progress monitoring.

## Task

### Session Commands

**`/session start`** - Begin a writing session
**`/session end`** - End current session and log stats
**`/session status`** - Check current session time
**`/session log`** - View session history and statistics

## Session Start

1. **Check if session already active**:
   - Read `notes/current-session.json` if exists
   - If active session found, ask: continue or end previous?

2. **Initialize new session**:

   Create `notes/current-session.json`:
   ```json
   {
     "startTime": "2025-10-26T14:30:00Z",
     "startWordCount": 45000,
     "startSceneCount": 24,
     "sessionGoal": "Write 2 scenes",
     "status": "active"
   }
   ```

3. **Ask user (optional)**:
   - Session goal? (e.g., "Write 2 scenes", "1000 words", "Edit scenes 5-8")
   - Or skip and just start

4. **Output**:
   ```
   ✓ Session started at 2:30 PM
     Current stats:
     - Scenes: 24
     - Total words: 45,000
     - Goal: Write 2 scenes

     Happy writing! Use /session end when done.
   ```

## Session Status

While session is active:

```
/session status

📝 Writing Session Active

Started: 2:30 PM (45 minutes ago)
Goal: Write 2 scenes

Current Progress:
- Scenes: 24 → 26 (+2) ✓ Goal reached!
- Words: 45,000 → 47,234 (+2,234)

Keep going or /session end to log this session.
```

## Session End

1. **Read current session**:
   - Load `notes/current-session.json`
   - Calculate duration
   - Count current scenes and words

2. **Calculate session stats**:
   ```
   Start: 24 scenes, 45,000 words
   End: 26 scenes, 47,234 words

   Session Results:
   - Duration: 1h 15min
   - Scenes written: +2
   - Words written: +2,234
   - Words per hour: ~1,787
   - Goal: Write 2 scenes ✓ Achieved!
   ```

3. **Append to session log**:

   Update or create `notes/session-log.json`:
   ```json
   {
     "sessions": [
       {
         "date": "2025-10-26",
         "startTime": "2025-10-26T14:30:00Z",
         "endTime": "2025-10-26T15:45:00Z",
         "duration": 75,
         "startScenes": 24,
         "endScenes": 26,
         "scenesWritten": 2,
         "startWords": 45000,
         "endWords": 47234,
         "wordsWritten": 2234,
         "wordsPerHour": 1787,
         "goal": "Write 2 scenes",
         "goalAchieved": true,
         "activities": ["new-scene", "new-scene", "edit-scene", "brainstorm"]
       }
     ],
     "totalSessions": 15,
     "totalMinutes": 1250,
     "totalWords": 47234,
     "averageWordsPerSession": 1574,
     "averageWordsPerHour": 1509
   }
   ```

4. **Delete current session file**:
   ```bash
   rm notes/current-session.json
   ```

5. **Output**:
   ```
   ✓ Session ended!

   📊 Session Summary

   Duration: 1h 15min
   Scenes: 24 → 26 (+2)
   Words: 45,000 → 47,234 (+2,234)
   Pace: ~1,787 words/hour
   Goal: Write 2 scenes ✓ Achieved!

   🎯 Overall Progress
   Total sessions: 15
   Total time: 20h 50min
   Total words: 47,234
   Average: 1,574 words/session
   ```

## Session Log

View session history:

```
/session log

📊 Writing Session History

Recent Sessions (last 7 days):

Oct 26 │ 1h 15m │ +2,234 words │ ✓ Write 2 scenes
Oct 25 │ 45m    │ +1,123 words │ ✓ Edit scenes 5-8
Oct 24 │ 2h 0m  │ +3,456 words │ ✓ Write 3 scenes
Oct 23 │ 1h 30m │ +2,001 words │ ⚠ Goal: 3000 words (67%)
Oct 22 │ 30m    │ +567 words   │ - Brainstorm only
Oct 21 │ 1h 45m │ +2,789 words │ ✓ Write 2 scenes
Oct 20 │ 1h 0m  │ +1,456 words │ ✓ 1500 words

📈 Statistics

This Week:
- Sessions: 7
- Total time: 8h 45m
- Total words: +13,626
- Average: 1,946 words/session
- Longest streak: 7 days 🔥

This Month:
- Sessions: 22
- Total time: 28h 15m
- Total words: +34,567
- Average: 1,571 words/session

All Time:
- Sessions: 15
- Total time: 20h 50min
- Project words: 47,234
- Average: 1,574 words/session
- Best session: 3,456 words (Oct 24)
```

### Options

```bash
/session log --week      # Last 7 days
/session log --month     # Last 30 days
/session log --all       # All sessions
/session log --stats     # Statistics only
/session log --export    # Export to CSV
```

## Auto-Tracking (Background)

Commands automatically update session activity when session is active:

- `/new-scene` → Logs "new-scene" activity
- `/edit-scene` → Logs "edit-scene" activity
- `/brainstorm` → Logs "brainstorm" activity
- `/cycle` → Logs "cycle" activity

This helps see what you did during the session.

## Integration with /status

Update `/status` command to show active session:

```
/status

# Project Status: Midnight Noir

📝 Active Writing Session
Started: 2:30 PM (45 minutes ago)
Goal: Write 2 scenes
Progress: +2,234 words so far

Genre: Noir Thriller
...
```

## Daily Goals & Streaks

Track writing streaks:

```json
{
  "streaks": {
    "currentStreak": 7,
    "longestStreak": 12,
    "lastSessionDate": "2025-10-26"
  },
  "dailyGoals": {
    "targetWordsPerDay": 1500,
    "targetSessionsPerWeek": 5
  }
}
```

Show in session end:
```
✓ Session ended!

📊 Session Summary
[stats...]

🔥 Streak: 7 days
Keep it up! Next goal: 8 days
```

## Visualization

Optional: Create charts/graphs in `notes/session-stats.md`:

```markdown
# Writing Statistics

## Words Per Session (Last 7 Days)

Oct 20 ▓▓▓▓▓▓▓▓░░ 1,456
Oct 21 ▓▓▓▓▓▓▓▓▓▓ 2,789
Oct 22 ▓▓░░░░░░░░ 567
Oct 23 ▓▓▓▓▓▓▓▓░░ 2,001
Oct 24 ▓▓▓▓▓▓▓▓▓▓ 3,456 ★ Best!
Oct 25 ▓▓▓▓▓░░░░░ 1,123
Oct 26 ▓▓▓▓▓▓▓▓░░ 2,234

Average: 1,946 words/session
Goal: 1,500 words ✓
```

## Export Session Data

```bash
/session export

Creates: notes/session-export.csv

date,duration_min,scenes,words,words_per_hour,goal,achieved
2025-10-26,75,2,2234,1787,"Write 2 scenes",true
2025-10-25,45,0,1123,1496,"Edit scenes 5-8",true
...

✓ Exported to notes/session-export.csv
  Import to spreadsheet for analysis
```

## Reminders

If no session in 24 hours (optional):

```
/status

⚠ No writing session today yet
  Last session: Yesterday (Oct 25)
  Streak at risk! 🔥

  Start session: /session start
```

## Example Complete Workflow

```
# Start writing
/session start
> Goal: Write 2 scenes
✓ Session started!

# Write scenes
/new-scene
[writes scene 25]

/new-scene
[writes scene 26]

# Check progress mid-session
/session status
> 1h 15m elapsed, +2,234 words, goal reached!

# End session
/session end

✓ Session ended!

📊 Session Summary
Duration: 1h 15min
Scenes: +2
Words: +2,234
Pace: 1,787 words/hour
Goal: ✓ Achieved

🔥 Streak: 7 days
🎯 15 total sessions, 47,234 total words

Great work! Same time tomorrow?
```

## Files Created

- `notes/current-session.json` - Active session (deleted on end)
- `notes/session-log.json` - All sessions logged
- `notes/session-stats.md` - Visual statistics (optional)
- `notes/session-export.csv` - Export data (on demand)

## Philosophy

**Why track sessions?**
- Accountability: See actual time spent writing
- Motivation: Watch word count grow
- Patterns: Learn your productive times
- Goals: Set and achieve daily/weekly targets
- Streaks: Build consistent writing habit

**Discovery writing compatible:**
- No pressure to hit word counts
- Brainstorm sessions count too
- Editing counts as writing time
- Goals are optional, not mandatory
- Celebrate showing up, not just output

Track progress without sacrificing creative freedom! 📊✍️
