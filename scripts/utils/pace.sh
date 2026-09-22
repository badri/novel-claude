#!/bin/bash
# pace.sh — words per day from git history (Pulp Speed tracking)
#
# Compares the word count of scenes/scene-*.md now against the last commit
# before N days ago, for N = 7 and 30 (or the windows you pass). Nothing is
# written; sessions are not tracked — git already knows when words landed.
#
# Usage: pace.sh [project-dir] [days ...]
# Called by: the `status` skill

set -uo pipefail

PROJECT_DIR="${1:-.}"
shift || true
WINDOWS=("$@")
[[ ${#WINDOWS[@]} -gt 0 ]] || WINDOWS=(7 30)

cd "$PROJECT_DIR" || exit 1
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "ERROR: not a git repo" >&2; exit 1; }

PULP1=2740   # 1,000,000 words / 365 days

# Prose only: the text between a scene's two --- rules (metadata above,
# Notes and commentary below). A one-rule file counts everything after it.
prose_words() {
  awk '/^---[[:space:]]*$/ { r++; next } r == 1 { print }' | wc -w
}

count_now() {
  local n=0
  for f in scenes/scene-*.md; do [[ -f "$f" ]] && n=$((n + $(prose_words < "$f"))); done
  echo "$n"
}

count_at() {
  local rev="$1" n=0 f
  while IFS= read -r f; do
    n=$((n + $(git show "$rev:./$f" | prose_words)))
  done < <(git ls-tree -r --name-only "$rev" -- scenes/ 2>/dev/null | grep -E '^scenes/scene-[0-9]+\.md$')
  echo "$n"
}

NOW=$(count_now)
echo "words now: $NOW   (Pulp 1 pace = $PULP1 words/day)"
for d in "${WINDOWS[@]}"; do
  rev=$(git rev-list -1 --before="$d days ago" HEAD 2>/dev/null)
  if [[ -z "$rev" ]]; then
    echo "last $d days: no commit older than $d days — project is younger than the window"
    continue
  fi
  then=$(count_at "$rev")
  delta=$((NOW - then))
  perday=$((delta / d))
  pct=$((perday * 100 / PULP1))
  echo "last $d days: +$delta words  →  $perday/day  ($pct% of Pulp 1)"
done
