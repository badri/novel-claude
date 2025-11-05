#!/bin/bash
# Ironclad scene renumbering
# Safely renumbers scenes after insertions/deletions
# Usage: renumber-scenes.sh <project-dir>

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

# Verify we're in a fiction project
if [[ ! -f "project.json" ]]; then
  echo "ERROR: Not a fiction project (no project.json found)" >&2
  exit 1
fi

if [[ ! -d "scenes" ]]; then
  echo "ERROR: No scenes directory found" >&2
  exit 1
fi

# Create temporary directory for safe renaming
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Get all scene files sorted by current number
mapfile -t SCENES < <(ls -1 scenes/scene-*.md 2>/dev/null | sort -V || true)

if [[ ${#SCENES[@]} -eq 0 ]]; then
  echo "No scenes to renumber" >&2
  exit 0
fi

# Copy scenes to temp dir with new numbers
COUNTER=1
declare -A RENAME_MAP

for scene in "${SCENES[@]}"; do
  NEW_NUMBER=$(printf "%03d" $COUNTER)
  NEW_NAME="scene-${NEW_NUMBER}.md"
  OLD_NAME=$(basename "$scene")

  # Copy to temp with new name
  cp "$scene" "$TEMP_DIR/$NEW_NAME"

  # Track rename for logging
  RENAME_MAP["$OLD_NAME"]="$NEW_NAME"

  COUNTER=$((COUNTER + 1))
done

# Now safely move back from temp to scenes/
# This avoids clobbering issues during rename
rm -f scenes/scene-*.md
mv "$TEMP_DIR"/scene-*.md scenes/

# Update project.json scene count
SCENE_COUNT=${#SCENES[@]}
jq --arg count "$SCENE_COUNT" '.sceneCount = ($count | tonumber)' \
  project.json > project.json.tmp && mv project.json.tmp project.json

# Log renames
echo "Renumbered $SCENE_COUNT scenes:" >&2
for old_name in "${!RENAME_MAP[@]}"; do
  new_name="${RENAME_MAP[$old_name]}"
  if [[ "$old_name" != "$new_name" ]]; then
    echo "  $old_name → $new_name" >&2
  fi
done

# Update word count
WORD_COUNT_SCRIPT="$(dirname "$0")/word-count.sh"
if [[ -x "$WORD_COUNT_SCRIPT" ]]; then
  "$WORD_COUNT_SCRIPT" . >/dev/null
fi

exit 0
