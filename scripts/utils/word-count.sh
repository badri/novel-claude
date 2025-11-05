#!/bin/bash
# Ironclad word counting for fiction projects
# Counts words in all scenes and updates project.json
# Usage: word-count.sh [project-dir]

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

# Verify we're in a fiction project
if [[ ! -f "project.json" ]]; then
  echo "ERROR: Not a fiction project (no project.json found)" >&2
  exit 1
fi

# Count words in all active scenes
TOTAL_WORDS=0
SCENE_COUNT=0

if [[ -d "scenes" ]]; then
  # Count words using wc -w (word count)
  # Only count .md files in scenes/ root (not drafts/ or archive/)
  for scene in scenes/scene-*.md; do
    if [[ -f "$scene" ]]; then
      WORDS=$(wc -w < "$scene" 2>/dev/null || echo "0")
      TOTAL_WORDS=$((TOTAL_WORDS + WORDS))
      SCENE_COUNT=$((SCENE_COUNT + 1))
    fi
  done
fi

# Update project.json with new counts
# Use jq for safe JSON manipulation
jq --arg words "$TOTAL_WORDS" --arg scenes "$SCENE_COUNT" \
  '.wordCount = ($words | tonumber) | .sceneCount = ($scenes | tonumber)' \
  project.json > project.json.tmp && mv project.json.tmp project.json

# Output results
echo "$TOTAL_WORDS"

# Also output stats to stderr for logging (won't interfere with piping the number)
echo "Word count: $TOTAL_WORDS across $SCENE_COUNT scenes" >&2

exit 0
