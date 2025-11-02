#!/bin/bash
# Hook to start a writing session automatically
# Called on SessionStart event

set -euo pipefail

# Check if we're in a fiction project (has project.json)
if [[ ! -f "project.json" ]]; then
  exit 0  # Not in a project, skip session tracking
fi

# Create notes directory if it doesn't exist
mkdir -p notes

# Check if session already active
if [[ -f "notes/current-session.json" ]]; then
  # Session already active, don't start a new one
  exit 0
fi

# Get current stats from project.json
SCENE_COUNT=$(jq -r '.sceneCount // 0' project.json 2>/dev/null || echo "0")
WORD_COUNT=$(jq -r '.wordCount // 0' project.json 2>/dev/null || echo "0")

# Create new session file
cat > notes/current-session.json <<EOF
{
  "startTime": "$(date -Iseconds)",
  "startWordCount": ${WORD_COUNT},
  "startSceneCount": ${SCENE_COUNT},
  "sessionGoal": "",
  "status": "active"
}
EOF

# Success
exit 0
