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

# Find the plugin directory (where scripts are located)
# This hook is in <project>/.claude/hooks/ and scripts are in <plugin>/scripts/
PLUGIN_DIR="${PLUGIN_DIR:-$HOME/.claude/plugins/novel-claude}"

# Use the ironclad session calculator script
CALC_SCRIPT="$PLUGIN_DIR/scripts/session/calculate-stats.sh"

if [[ -x "$CALC_SCRIPT" ]]; then
  # Call the script to calculate stats and update session log
  # It outputs session summary JSON which we can ignore in the hook
  "$CALC_SCRIPT" . >/dev/null 2>&1 || {
    echo "WARNING: Session stats calculation failed, falling back to manual deletion" >&2
    rm -f notes/current-session.json
  }
else
  echo "WARNING: Session calculator script not found at $CALC_SCRIPT" >&2
  echo "Deleting session file without recording stats" >&2
  rm -f notes/current-session.json
fi

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
