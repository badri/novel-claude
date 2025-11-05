#!/bin/bash
# Ironclad DevRag semantic search wrapper
# Performs vector search across project markdown files
# Usage: devrag-search.sh [options] <query>
#
# Options:
#   --type <type>     Filter by type: scenes, codex, notes, sessions, brainstorms
#   --recent <days>   Only search files modified in last N days
#   --limit <n>       Maximum number of results (default: 10)
#   --config <path>   Path to devrag config (default: .devrag/config.json)

set -euo pipefail

# Default values
QUERY=""
FILTER_TYPE=""
RECENT_DAYS=""
LIMIT=10
CONFIG_PATH=".devrag/config.json"
PROJECT_DIR="."

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --type)
      FILTER_TYPE="$2"
      shift 2
      ;;
    --recent)
      RECENT_DAYS="$2"
      shift 2
      ;;
    --limit)
      LIMIT="$2"
      shift 2
      ;;
    --config)
      CONFIG_PATH="$2"
      shift 2
      ;;
    --project)
      PROJECT_DIR="$2"
      shift 2
      ;;
    *)
      # Remaining args are the query
      QUERY="$*"
      break
      ;;
  esac
done

# Validate query
if [[ -z "$QUERY" ]]; then
  echo "Usage: devrag-search.sh [options] <query>" >&2
  echo "" >&2
  echo "Options:" >&2
  echo "  --type <type>     Filter: scenes, codex, notes, sessions, brainstorms" >&2
  echo "  --recent <days>   Only search files from last N days" >&2
  echo "  --limit <n>       Max results (default: 10)" >&2
  echo "  --config <path>   DevRag config path" >&2
  exit 1
fi

cd "$PROJECT_DIR"

# Check if DevRag is configured
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "ERROR: DevRag not configured (no $CONFIG_PATH found)" >&2
  echo "" >&2
  echo "Run /setup-devrag to configure semantic search" >&2
  exit 1
fi

# Find devrag executable
DEVRAG=""
SEARCH_PATHS=(
  "/usr/local/bin/devrag"
  "$HOME/.local/bin/devrag"
  "$(which devrag 2>/dev/null || true)"
  "$(command -v devrag 2>/dev/null || true)"
)

for path in "${SEARCH_PATHS[@]}"; do
  if [[ -n "$path" && -x "$path" ]]; then
    DEVRAG="$path"
    break
  fi
done

if [[ -z "$DEVRAG" ]]; then
  echo "ERROR: devrag executable not found" >&2
  echo "" >&2
  echo "Install DevRag:" >&2
  echo "  npm install -g devrag" >&2
  echo "  # or" >&2
  echo "  cargo install devrag" >&2
  exit 1
fi

# Build search arguments
SEARCH_ARGS=("--config" "$CONFIG_PATH" "search" "$QUERY" "--limit" "$LIMIT")

# Add type filter if specified
if [[ -n "$FILTER_TYPE" ]]; then
  case "$FILTER_TYPE" in
    scenes)
      SEARCH_ARGS+=("--path-filter" "scenes/")
      ;;
    codex)
      SEARCH_ARGS+=("--path-filter" "codex/")
      ;;
    notes)
      SEARCH_ARGS+=("--path-filter" "notes/")
      ;;
    sessions)
      SEARCH_ARGS+=("--path-filter" "notes/session-interactions/")
      ;;
    brainstorms)
      SEARCH_ARGS+=("--path-filter" "brainstorms/")
      ;;
    *)
      echo "ERROR: Unknown type filter: $FILTER_TYPE" >&2
      echo "Valid types: scenes, codex, notes, sessions, brainstorms" >&2
      exit 1
      ;;
  esac
fi

# Add recent filter if specified
if [[ -n "$RECENT_DAYS" ]]; then
  # Calculate cutoff date (YYYY-MM-DD)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CUTOFF_DATE=$(date -v-${RECENT_DAYS}d +%Y-%m-%d)
  else
    # Linux
    CUTOFF_DATE=$(date -d "$RECENT_DAYS days ago" +%Y-%m-%d)
  fi
  SEARCH_ARGS+=("--since" "$CUTOFF_DATE")
fi

# Execute search with error handling
OUTPUT_FILE=$(mktemp)
ERROR_FILE=$(mktemp)

set +e
"$DEVRAG" "${SEARCH_ARGS[@]}" > "$OUTPUT_FILE" 2> "$ERROR_FILE"
EXIT_CODE=$?
set -e

# Check for errors
if [[ $EXIT_CODE -ne 0 ]]; then
  echo "ERROR: DevRag search failed with exit code $EXIT_CODE" >&2
  echo "" >&2
  if [[ -s "$ERROR_FILE" ]]; then
    echo "Error details:" >&2
    cat "$ERROR_FILE" >&2
  fi
  rm -f "$OUTPUT_FILE" "$ERROR_FILE"
  exit $EXIT_CODE
fi

# Check if results are empty
if [[ ! -s "$OUTPUT_FILE" ]]; then
  echo "No results found for: $QUERY" >&2
  rm -f "$OUTPUT_FILE" "$ERROR_FILE"
  exit 0
fi

# Format and output results
# DevRag outputs JSON, we'll pretty-print it
if command -v jq &> /dev/null; then
  # Use jq for nice formatting
  jq -r '.results[] | "📄 \(.path)\nScore: \(.score)\n\(.preview)\n"' "$OUTPUT_FILE" 2>/dev/null || cat "$OUTPUT_FILE"
else
  # Fallback to raw output
  cat "$OUTPUT_FILE"
fi

# Cleanup
rm -f "$OUTPUT_FILE" "$ERROR_FILE"

exit 0
