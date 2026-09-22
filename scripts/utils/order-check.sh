#!/bin/bash
# order-check.sh — read-only consistency check for a fiction project
#
# Checks the reading-order (ORDER.md) workflow for the three things that
# silently corrupt a compile:
#   1. scene files on disk that ORDER.md never mentions (they vanish from the
#      manuscript without a word)
#   2. [scene-NNN] entries in ORDER.md with no file on disk (the ## Cut
#      section is exempt: a cut scene's ID is retired whether or not the
#      file was kept)
#   3. un-consumed annotation tags still sitting in scene *prose*
#      (<brief> <cut> <change> <keep> <add> <flow> <q>)
#
# Prose is the text between the scene's two --- rules (metadata above the
# first, Notes and tag-pass commentary below the second). Tags quoted in that
# tail are the author's record of a finished pass, not live annotations —
# those are reported separately as informational and do not fail the check.
#
# Usage: order-check.sh [project-dir]
# Exit:  0 = clean, 1 = something needs attention
#
# Read-only. Bash + grep/sed/awk only — no jq.

set -uo pipefail

PROJECT_DIR="${1:-.}"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: no such directory: $PROJECT_DIR" >&2
  exit 1
fi

cd "$PROJECT_DIR" || exit 1

if [[ ! -f "ORDER.md" ]]; then
  echo "ERROR: no ORDER.md in $(pwd)" >&2
  echo "       This check applies to projects that keep reading order in ORDER.md." >&2
  exit 1
fi

PROBLEMS=0

ORDER_TEXT=$(< ORDER.md)

# --------------------------------------------------------------------------
# 1. Files on disk that ORDER.md never mentions
# --------------------------------------------------------------------------

NOT_LISTED=()
STRAY=()

for f in scenes/*.md; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f")
  stem="${base%.md}"
  if [[ "$stem" =~ ^scene-[0-9]+$ ]]; then
    [[ "$ORDER_TEXT" == *"[$stem]"* ]] || NOT_LISTED+=("$base")
  else
    STRAY+=("$base")
  fi
done

if [[ ${#NOT_LISTED[@]} -gt 0 ]]; then
  PROBLEMS=1
  echo "✗ Scene files not listed in ORDER.md (${#NOT_LISTED[@]}) — these will NOT compile:"
  for f in "${NOT_LISTED[@]}"; do
    echo "    scenes/$f"
  done
  echo "    → add each to '## Reading order' or '## Unplaced / drafts' in ORDER.md"
  echo
fi

if [[ ${#STRAY[@]} -gt 0 ]]; then
  echo "i Files in scenes/ that are not named scene-NNN.md (${#STRAY[@]}) — not treated as scenes:"
  for f in "${STRAY[@]}"; do
    echo "    scenes/$f"
  done
  echo
fi

# --------------------------------------------------------------------------
# 2. ORDER.md references with no file on disk
# --------------------------------------------------------------------------

MISSING=()
while read -r id; do
  [[ -n "$id" ]] || continue
  found=0
  for f in "scenes/$id.md" "scenes/$id"-*.md scenes/*/"$id".md scenes/*/"$id"-*.md; do
    [[ -f "$f" ]] && { found=1; break; }
  done
  if [[ $found -eq 0 ]]; then
    pos=$(grep -n "\[$id\]" ORDER.md | head -n 1 | cut -d: -f1)
    MISSING+=("$id  (ORDER.md line $pos)")
  fi
done < <(awk '/^## Cut/ { exit } { print }' ORDER.md | grep -o '\[scene-[0-9][0-9]*\]' | sed 's/[][]//g' | sort -u)

if [[ ${#MISSING[@]} -gt 0 ]]; then
  PROBLEMS=1
  echo "✗ ORDER.md references with no file on disk (${#MISSING[@]}):"
  for m in "${MISSING[@]}"; do
    echo "    $m"
  done
  echo "    → the scene was removed, renamed, or the ID was never used;"
  echo "      drop the reference or restore the file"
  echo
fi

# --------------------------------------------------------------------------
# 3. Annotation tags still in scene prose
# --------------------------------------------------------------------------

FILES=()
for pat in scenes/*.md scenes/drafts/*.md scenes/archive/*.md scenes/cut/*.md; do
  for f in $pat; do
    [[ -f "$f" ]] && FILES+=("$f")
  done
done

PROSE_HITS=""
NOTES_COUNT=0

if [[ ${#FILES[@]} -gt 0 ]]; then
  PROSE_HITS=$(awk '
    FNR == 1 { rules = 0; innotes = 0 }
    /^---[[:space:]]*$/ { rules++; next }
    /^\*\*Notes/ { innotes = 1 }
    (rules == 1 && !innotes) && /<(brief|cut|change|keep|add|flow|q)>/ {
      print FILENAME ":" FNR ":" substr($0, 1, 120)
    }
  ' "${FILES[@]}")

  NOTES_COUNT=$(awk '
    FNR == 1 { rules = 0; innotes = 0 }
    /^---[[:space:]]*$/ { rules++; next }
    /^\*\*Notes/ { innotes = 1 }
    (rules != 1 || innotes) && /<(brief|cut|change|keep|add|flow|q)>/ { print FILENAME }
  ' "${FILES[@]}" | sort -u | wc -l | tr -d ' ')
fi

if [[ -n "$PROSE_HITS" ]]; then
  PROBLEMS=1
  echo "✗ Un-consumed annotation tags in prose — compile will refuse:"
  echo "$PROSE_HITS" | while IFS= read -r line; do
    echo "    $line"
  done
  echo "    → run the edit-scene rewrite for each: the tags are the author's"
  echo "      instruction, and stripping them by hand loses it"
  echo
fi

if [[ "$NOTES_COUNT" -gt 0 ]]; then
  echo "i Tag mentions inside Notes blocks (${NOTES_COUNT} file(s)) — historical record, not blocking"
  echo
fi

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------

POSITIONS=$(grep -c '^[0-9]\+\. \*\*\[scene-' ORDER.md)
UNPLACED=$(sed -n '/^## Unplaced/,/^## /p' ORDER.md | grep -c '^- \*\*\[scene-')

echo "Reading order: ${POSITIONS} scene(s); unplaced/drafts: ${UNPLACED}"

if [[ $PROBLEMS -eq 0 ]]; then
  echo "✓ order-check: clean"
  exit 0
fi

echo "✗ order-check: issues found (see above)"
exit 1
