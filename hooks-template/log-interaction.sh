#!/bin/bash
# Hook to log user interactions during writing sessions
# Called on user-prompt-submit to capture commands and questions

set -euo pipefail

# Check if we're in a fiction project (has project.json)
if [[ ! -f "project.json" ]]; then
  exit 0  # Not in a project, skip logging
fi

# Check if session is active
if [[ ! -f "notes/current-session.json" ]]; then
  exit 0  # No active session, skip logging
fi

# Get user input from stdin or first argument
USER_INPUT="${1:-$(cat)}"

# Exit if empty
if [[ -z "$USER_INPUT" ]]; then
  exit 0
fi

# Create session-interactions directory if it doesn't exist
mkdir -p notes/session-interactions

# Get current session start time from current-session.json
SESSION_START=$(jq -r '.startTime' notes/current-session.json 2>/dev/null || echo "")

if [[ -z "$SESSION_START" ]]; then
  exit 0
fi

# Convert ISO timestamp to filename-safe format
SESSION_FILE="notes/session-interactions/session-$(echo "$SESSION_START" | sed 's/[:-]//g' | sed 's/T/-/' | cut -d'.' -f1).md"

# Create session file if it doesn't exist
if [[ ! -f "$SESSION_FILE" ]]; then
  cat > "$SESSION_FILE" <<EOF
# Writing Session - $(date -Iseconds)

**Session Goal:** $(jq -r '.sessionGoal // "Not specified"' notes/current-session.json)

## Interactions

EOF
fi

# Append user input with timestamp
TIMESTAMP=$(date '+%H:%M:%S')
echo "### [$TIMESTAMP] User" >> "$SESSION_FILE"
echo "" >> "$SESSION_FILE"
echo "$USER_INPUT" >> "$SESSION_FILE"
echo "" >> "$SESSION_FILE"

# Success
exit 0
