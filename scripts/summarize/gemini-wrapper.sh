#!/bin/bash
# Ironclad Gemini CLI wrapper
# Finds gemini-cli executable and executes summarization commands
# Usage: gemini-wrapper.sh <task-type> <input-file-or-text>
#
# Task types:
#   scene-summary    - Summarize a single scene
#   reverse-outline  - Generate reverse outline from scenes
#   continuity-check - Check continuity across scenes

set -euo pipefail

TASK_TYPE="${1:-}"
INPUT="${2:-}"

# Validate arguments
if [[ -z "$TASK_TYPE" || -z "$INPUT" ]]; then
  echo "Usage: gemini-wrapper.sh <task-type> <input-file-or-text>" >&2
  echo "" >&2
  echo "Task types:" >&2
  echo "  scene-summary    - Summarize a single scene" >&2
  echo "  reverse-outline  - Generate reverse outline from scenes" >&2
  echo "  continuity-check - Check continuity across scenes" >&2
  exit 1
fi

# Find gemini-cli executable
GEMINI_CLI=""

# Check common installation locations
SEARCH_PATHS=(
  "$HOME/.local/bin/gemini-cli"
  "$HOME/.npm-global/bin/gemini-cli"
  "$HOME/.nvm/versions/node/$(nvm current 2>/dev/null || echo 'latest')/bin/gemini-cli"
  "/usr/local/bin/gemini-cli"
  "/opt/homebrew/bin/gemini-cli"
  "$(which gemini-cli 2>/dev/null || true)"
  "$(command -v gemini-cli 2>/dev/null || true)"
)

for path in "${SEARCH_PATHS[@]}"; do
  if [[ -n "$path" && -x "$path" ]]; then
    GEMINI_CLI="$path"
    break
  fi
done

# If still not found, try npm global bin
if [[ -z "$GEMINI_CLI" ]]; then
  NPM_BIN=$(npm bin -g 2>/dev/null || true)
  if [[ -n "$NPM_BIN" && -x "$NPM_BIN/gemini-cli" ]]; then
    GEMINI_CLI="$NPM_BIN/gemini-cli"
  fi
fi

# Error if not found
if [[ -z "$GEMINI_CLI" ]]; then
  echo "ERROR: gemini-cli not found" >&2
  echo "" >&2
  echo "Please install gemini-cli:" >&2
  echo "  npm install -g @google/generative-ai-cli" >&2
  echo "" >&2
  echo "Or specify GEMINI_CLI environment variable:" >&2
  echo "  export GEMINI_CLI=/path/to/gemini-cli" >&2
  exit 1
fi

# Verify it's executable
if [[ ! -x "$GEMINI_CLI" ]]; then
  echo "ERROR: gemini-cli found but not executable: $GEMINI_CLI" >&2
  exit 1
fi

# Read input (file or stdin)
if [[ -f "$INPUT" ]]; then
  INPUT_TEXT=$(cat "$INPUT")
else
  INPUT_TEXT="$INPUT"
fi

# Build prompt based on task type
case "$TASK_TYPE" in
  scene-summary)
    PROMPT="Summarize this fiction scene focusing on:
- Key events and turning points
- Character actions and decisions
- Emotional beats
- Story progression
- POV and timeline details

Keep it concise (2-3 paragraphs):

$INPUT_TEXT"
    ;;

  reverse-outline)
    PROMPT="Create a reverse outline of these fiction scenes. For each scene provide:
- Scene number
- POV character
- Setting (location and time)
- Key events (what happens)
- Character development (how characters change)
- Plot threads (which storylines progress)

Format as a structured outline:

$INPUT_TEXT"
    ;;

  continuity-check)
    PROMPT="Analyze these fiction scenes for:
- Continuity issues (timeline, character knowledge, object persistence)
- Character consistency (behavior, voice, motivations)
- Timeline coherence (does the sequence make sense?)
- Plot holes or logical inconsistencies

List any issues found:

$INPUT_TEXT"
    ;;

  *)
    echo "ERROR: Unknown task type: $TASK_TYPE" >&2
    echo "Valid types: scene-summary, reverse-outline, continuity-check" >&2
    exit 1
    ;;
esac

# Execute gemini-cli with error handling
echo "Running Gemini CLI..." >&2

# Use --yolo mode for non-interactive execution
# Capture both stdout and stderr
OUTPUT_FILE=$(mktemp)
ERROR_FILE=$(mktemp)

set +e  # Don't exit on error yet
"$GEMINI_CLI" -p "$PROMPT" > "$OUTPUT_FILE" 2> "$ERROR_FILE"
EXIT_CODE=$?
set -e

# Check for errors
if [[ $EXIT_CODE -ne 0 ]]; then
  echo "ERROR: gemini-cli failed with exit code $EXIT_CODE" >&2
  echo "" >&2
  echo "STDERR:" >&2
  cat "$ERROR_FILE" >&2
  rm -f "$OUTPUT_FILE" "$ERROR_FILE"
  exit $EXIT_CODE
fi

# Check if output is empty
if [[ ! -s "$OUTPUT_FILE" ]]; then
  echo "ERROR: gemini-cli produced no output" >&2
  if [[ -s "$ERROR_FILE" ]]; then
    echo "" >&2
    echo "STDERR:" >&2
    cat "$ERROR_FILE" >&2
  fi
  rm -f "$OUTPUT_FILE" "$ERROR_FILE"
  exit 1
fi

# Output results
cat "$OUTPUT_FILE"

# Cleanup
rm -f "$OUTPUT_FILE" "$ERROR_FILE"

exit 0
