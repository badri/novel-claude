# Ironclad Scripts

This directory contains battle-tested bash/python scripts that handle deterministic operations reliably. These scripts eliminate the fumbling that occurs when Claude tries to interpret complex instructions for:

- Time/date calculations
- JSON manipulation
- File operations with edge cases

## Philosophy

**Skills should coordinate, scripts should execute.**

- **Skills** (`SKILL.md` files) provide creative interpretation and user interaction
- **Scripts** (`.sh` files) handle precise operations that must not fail

## Script Categories

### Utilities (`utils/`)

**`pace.sh`** - Words per day from git history
- Prose-only word count of `scenes/scene-*.md` now vs. the last commit before
  N days ago (default windows 7 and 30), against the Pulp 1 pace (2,740/day)
- Read-only; replaces the retired session tracking

**Usage:**
```bash
scripts/utils/pace.sh . 7 30
```

**Called by:** the `status` skill

---

**`prose-lint.py`** - Regex tells and the n-gram tic audit
- Narration only (dialogue, metadata, Notes, annotation tags excluded);
  prose is the text between a scene's two `---` rules
- Default report: rate rules per 10k words against a budget (simile of
  manner, padding, adverb speech tags, said-bookisms), flag rules, long
  sentences, em-dash density, weather openers, bowtie candidates
- `--ngrams`: every 3–5 word phrase repeated 10+ times across 8+ scenes,
  function-word-only phrases dropped (`--all` keeps them)
- `--rule <name>` triage queue, `--scene <NNN>` one scene, `--selftest`

**Usage:**
```bash
scripts/utils/prose-lint.py --ngrams          # from the project root
scripts/utils/prose-lint.py --rule simile_of_manner
```

**Called by:** the `tic-audit`, `compile`, and `edit-scene` skills

---

**`word-count.sh`** - Accurate word counting
- Counts words in all active scenes (not drafts/archive)
- Updates `project.json` with total count
- Uses `wc -w` for standard word count
- Atomic JSON update with jq

**Usage:**
```bash
scripts/utils/word-count.sh .
# Outputs: 45234
# Updates project.json wordCount field
```

**Called by:** skills that modify scenes (e.g. `new-scene`)

---

**`order-check.sh`** - Reading-order consistency check (read-only)
- Reports scene files in `scenes/` that `ORDER.md` never mentions (they would
  silently vanish from a compile)
- Reports `[scene-NNN]` entries in `ORDER.md` with no file on disk
- Reports un-consumed annotation tags (`<brief> <cut> <change> <keep> <add>
  <flow> <q>`) still in scene **prose**; tag mentions inside a scene's Notes
  block are the author's record of a finished pass and are reported separately
  as informational
- Exits 0 when clean, 1 when anything needs attention
- Bash + grep/sed/awk only — no `jq` dependency

**Usage:**
```bash
scripts/utils/order-check.sh ~/writing/my-novel
# Prints the findings and the reading-order/unplaced counts
```

**Called by:** the `compile`, `reorder`, and `status` skills

---

**`renumber-scenes.sh`** - **RETIRED.** Kept only to fail loudly.
- Scene filenames are **stable IDs assigned in creation order** and are never
  renamed or renumbered
- Reading order lives in `ORDER.md`; reordering means editing that list
- The script now prints a retirement message and `exit 1` — nothing is changed,
  so any stale caller fails visibly instead of scrambling a project
- Replacement for the old use case: edit `ORDER.md` (`reorder` skill), then
  verify with `order-check.sh`

**Usage:**
```bash
scripts/utils/renumber-scenes.sh .
# ERROR: renumber-scenes.sh is retired.
# ... exit 1
```

**Called by:** nothing.

---

## Error Handling Philosophy

All scripts follow these principles:

1. **Fail fast** - Exit with clear error on invalid state
2. **Validate inputs** - Check file existence, JSON validity
3. **Atomic operations** - Write to temp files, then rename
4. **Cleanup on exit** - Use traps to remove temp files
5. **Helpful errors** - Stderr messages explain what went wrong and how to fix

## Integration with Skills

Skills reference scripts via the `${CLAUDE_PLUGIN_ROOT}` environment variable,
which Claude Code sets automatically when a skill runs:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/utils/order-check.sh .
```

Under omp that variable is **not** set — use the plugin's absolute path
instead (`~/nc/scripts/...`):

```bash
~/nc/scripts/utils/order-check.sh .
```


## Testing Scripts

Test scripts manually before relying on them:

```bash
# Create test project
mkdir -p /tmp/test-project
cd /tmp/test-project

# Copy the scripts directory from the plugin
cp -r "${CLAUDE_PLUGIN_ROOT}/scripts" .

# Test word count
./scripts/utils/word-count.sh .

# Self-checks
./scripts/utils/prose-lint.py --selftest
```

## Adding New Scripts

When adding a new script:

1. **Name clearly** - `verb-noun.sh` pattern (e.g., `order-check.sh`)
2. **Document at top** - Usage, description, called by
3. **Validate inputs** - Check args, files exist
4. **Handle errors** - Exit codes, stderr messages
5. **Make executable** - `chmod +x script.sh`
6. **Update this README** - Document purpose and usage
7. **Update CHANGELOG** - Note what operation is now ironclad

## Script vs Skill Decision

**Use a script when:**
- Operation involves date/time math
- JSON must be parsed or updated
- File operations have edge cases (renaming, race conditions)
- Calculation must be precise (word counts, statistics)

**Use skill prose when:**
- Creative interpretation needed
- User interaction required
- Context-dependent decisions
- Natural language processing
- AI-assisted operations

When in doubt: **Script the deterministic, let the skill handle the creative.**
