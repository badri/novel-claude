#!/bin/bash
# Ironclad session statistics calculator
# Handles all time calculations, streak tracking, and stats aggregation
# Usage: calculate-stats.sh <project-dir>

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

# Verify we're in a fiction project
if [[ ! -f "project.json" ]]; then
  echo "ERROR: Not a fiction project (no project.json found)" >&2
  exit 1
fi

# Verify session is active
if [[ ! -f "notes/current-session.json" ]]; then
  echo "ERROR: No active session (no notes/current-session.json)" >&2
  exit 1
fi

# Create session-log.json if it doesn't exist
if [[ ! -f "notes/session-log.json" ]]; then
  echo '{"sessions":[],"totalSessions":0,"totalMinutes":0,"totalWords":0}' > notes/session-log.json
fi

# Use Python for reliable cross-platform date/time calculations
# This avoids bash date parsing issues between macOS/Linux
python3 <<'PYTHON_SCRIPT'
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

try:
    # Read current session
    with open('notes/current-session.json', 'r') as f:
        current = json.load(f)

    # Read project stats
    with open('project.json', 'r') as f:
        project = json.load(f)

    # Read session log
    with open('notes/session-log.json', 'r') as f:
        log = json.load(f)

    # Parse timestamps (handle both ISO with Z and without)
    start_time_str = current['startTime'].replace('Z', '+00:00')
    start_time = datetime.fromisoformat(start_time_str)
    end_time = datetime.now(timezone.utc)

    # Calculate duration in minutes
    duration_seconds = (end_time - start_time).total_seconds()
    duration_minutes = max(1, int(duration_seconds / 60))  # Minimum 1 minute

    # Get start/end stats
    start_scenes = current.get('startSceneCount', 0)
    start_words = current.get('startWordCount', 0)
    end_scenes = project.get('sceneCount', 0)
    end_words = project.get('wordCount', 0)
    goal = current.get('sessionGoal', '')

    # Calculate changes
    scenes_written = max(0, end_scenes - start_scenes)
    words_written = max(0, end_words - start_words)

    # Calculate words per hour
    if duration_minutes > 0:
        words_per_hour = int((words_written * 60) / duration_minutes)
    else:
        words_per_hour = 0

    # Calculate streak
    today = datetime.now(timezone.utc).date()
    current_streak = 1  # At least today
    longest_streak = 1

    if log.get('sessions'):
        # Get unique session dates, sorted descending
        session_dates = sorted(
            set(s['date'] for s in log['sessions']),
            reverse=True
        )

        # Calculate current streak (consecutive days)
        for i, date_str in enumerate(session_dates):
            session_date = datetime.fromisoformat(date_str).date()
            expected_date = today - datetime.timedelta(days=i)

            if session_date == expected_date:
                current_streak = i + 2  # +1 for today, +1 for 0-indexing
            else:
                break

        # Calculate longest streak (historical)
        temp_streak = 1
        for i in range(len(session_dates) - 1):
            current_date = datetime.fromisoformat(session_dates[i]).date()
            next_date = datetime.fromisoformat(session_dates[i + 1]).date()

            if (current_date - next_date).days == 1:
                temp_streak += 1
                longest_streak = max(longest_streak, temp_streak)
            else:
                temp_streak = 1

        longest_streak = max(longest_streak, current_streak)

    # Create session entry
    session_entry = {
        'date': today.isoformat(),
        'startTime': current['startTime'],
        'endTime': end_time.isoformat(),
        'duration': duration_minutes,
        'startScenes': start_scenes,
        'endScenes': end_scenes,
        'scenesWritten': scenes_written,
        'startWords': start_words,
        'endWords': end_words,
        'wordsWritten': words_written,
        'wordsPerHour': words_per_hour,
        'goal': goal,
        'goalAchieved': False  # Can be updated manually
    }

    # Update session log
    log['sessions'].append(session_entry)
    log['totalSessions'] = len(log['sessions'])
    log['totalMinutes'] = sum(s['duration'] for s in log['sessions'])
    log['totalWords'] = end_words

    # Add streak tracking
    if 'streaks' not in log:
        log['streaks'] = {}

    log['streaks']['currentStreak'] = current_streak
    log['streaks']['longestStreak'] = longest_streak
    log['streaks']['lastSessionDate'] = today.isoformat()

    # Calculate aggregates
    if log['totalSessions'] > 0:
        log['averageWordsPerSession'] = int(log['totalWords'] / log['totalSessions'])
        if log['totalMinutes'] > 0:
            log['averageWordsPerHour'] = int((log['totalWords'] * 60) / log['totalMinutes'])
        else:
            log['averageWordsPerHour'] = 0

    # Write updated session log
    with open('notes/session-log.json', 'w') as f:
        json.dump(log, f, indent=2)

    # Output session summary for display
    print(json.dumps({
        'duration': duration_minutes,
        'scenesWritten': scenes_written,
        'wordsWritten': words_written,
        'wordsPerHour': words_per_hour,
        'startScenes': start_scenes,
        'endScenes': end_scenes,
        'startWords': start_words,
        'endWords': end_words,
        'currentStreak': current_streak,
        'longestStreak': longest_streak,
        'totalSessions': log['totalSessions'],
        'totalMinutes': log['totalMinutes'],
        'goal': goal
    }, indent=2))

    # Delete current session file
    Path('notes/current-session.json').unlink()

    sys.exit(0)

except Exception as e:
    print(f"ERROR: Failed to calculate session stats: {e}", file=sys.stderr)
    import traceback
    traceback.print_exc(file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT

# Capture exit code from Python
EXIT_CODE=$?

if [[ $EXIT_CODE -ne 0 ]]; then
  echo "ERROR: Session calculation failed" >&2
  exit 1
fi

exit 0
