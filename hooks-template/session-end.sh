#!/bin/bash
# Hook to end a writing session and save work
# Called on SessionEnd event

set -euo pipefail

# Check if we're in a fiction project (has project.json)
if [[ ! -f "project.json" ]]; then
  exit 0  # Not in a project, skip session tracking
fi

# Check if session is active
if [[ ! -f "notes/current-session.json" ]]; then
  exit 0  # No active session
fi

# Create session-log.json if it doesn't exist
if [[ ! -f "notes/session-log.json" ]]; then
  echo '{"sessions":[],"totalSessions":0,"totalMinutes":0,"totalWords":0}' > notes/session-log.json
fi

# Read session data
START_TIME=$(jq -r '.startTime' notes/current-session.json)
START_SCENES=$(jq -r '.startSceneCount // 0' notes/current-session.json)
START_WORDS=$(jq -r '.startWordCount // 0' notes/current-session.json)
GOAL=$(jq -r '.sessionGoal // ""' notes/current-session.json)

# Get current stats
END_SCENES=$(jq -r '.sceneCount // 0' project.json 2>/dev/null || echo "0")
END_WORDS=$(jq -r '.wordCount // 0' project.json 2>/dev/null || echo "0")
END_TIME=$(date -Iseconds)

# Calculate duration in minutes
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  START_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${START_TIME:0:19}" +%s 2>/dev/null || date +%s)
  END_EPOCH=$(date +%s)
else
  # Linux
  START_EPOCH=$(date -d "$START_TIME" +%s 2>/dev/null || date +%s)
  END_EPOCH=$(date +%s)
fi
DURATION=$(( (END_EPOCH - START_EPOCH) / 60 ))

# Calculate stats
SCENES_WRITTEN=$((END_SCENES - START_SCENES))
WORDS_WRITTEN=$((END_WORDS - START_WORDS))

# Calculate words per hour
if [[ $DURATION -gt 0 ]]; then
  WORDS_PER_HOUR=$(( (WORDS_WRITTEN * 60) / DURATION ))
else
  WORDS_PER_HOUR=0
fi

# Create session entry
SESSION_ENTRY=$(cat <<EOF
{
  "date": "$(date -I)",
  "startTime": "$START_TIME",
  "endTime": "$END_TIME",
  "duration": $DURATION,
  "startScenes": $START_SCENES,
  "endScenes": $END_SCENES,
  "scenesWritten": $SCENES_WRITTEN,
  "startWords": $START_WORDS,
  "endWords": $END_WORDS,
  "wordsWritten": $WORDS_WRITTEN,
  "wordsPerHour": $WORDS_PER_HOUR,
  "goal": "$GOAL"
}
EOF
)

# Append to session log
jq ".sessions += [$SESSION_ENTRY] | .totalSessions += 1 | .totalMinutes += $DURATION | .totalWords = $END_WORDS" \
  notes/session-log.json > notes/session-log.json.tmp && mv notes/session-log.json.tmp notes/session-log.json

# Delete current session file
rm notes/current-session.json

# Git commit and push (non-blocking)
if git rev-parse --git-dir > /dev/null 2>&1; then
  # Check if there are changes to commit
  if [[ -n $(git status --porcelain) ]]; then
    git add -A 2>/dev/null || true
    git commit -m "Session end: auto-save work - $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true

    # Try to push, but don't fail if no remote
    git push 2>/dev/null || true
  fi
fi

# Success
exit 0
