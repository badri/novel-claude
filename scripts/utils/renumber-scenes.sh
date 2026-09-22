#!/bin/bash
# RETIRED — do not use.
#
# Scene files used to be renamed to keep filenames in reading order. That is
# no longer how this system works: `scenes/scene-NNN.md` filenames are STABLE
# IDs assigned in creation order and are never renamed or renumbered.
# Reading order now lives in `ORDER.md` (project root), and compile follows
# that file. To reorder, edit the list in ORDER.md.
#
# This file is kept only so that anything still calling it fails loudly
# instead of silently scrambling a project.
#
# Usage: renumber-scenes.sh <project-dir>   → always exits 1

echo "ERROR: renumber-scenes.sh is retired." >&2
echo "" >&2
echo "Scene filenames are STABLE IDs (creation order) and are never renamed." >&2
echo "Reading order lives in ORDER.md. To reorder: edit the list in ORDER.md." >&2
echo "To check a project's consistency: scripts/utils/order-check.sh <project-dir>" >&2
echo "" >&2
echo "Nothing was changed." >&2

exit 1
