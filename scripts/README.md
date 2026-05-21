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

### Session Management (`session/`)

**`calculate-stats.sh`** - Session time/word/streak calculations
- Uses Python for reliable cross-platform date math
- Handles timezone differences (macOS vs Linux)
- Calculates streaks with proper date arithmetic
- Updates `session-log.json` atomically
- Deletes `current-session.json` after successful logging

**Usage:**
```bash
scripts/session/calculate-stats.sh .
# Outputs session summary JSON
# Updates notes/session-log.json
# Deletes notes/current-session.json
```

**Called by:** `hooks-template/session-end.sh`

---

### Utilities (`utils/`)

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

**`renumber-scenes.sh`** - Safe scene renumbering
- Renumbers all scenes sequentially (001, 002, 003...)
- Uses temp directory to avoid clobbering
- Logs all renames
- Updates project.json scene count
- Calls word-count.sh after renumber

**Usage:**
```bash
scripts/utils/renumber-scenes.sh .
# Renumbers all scenes in scenes/ directory
# Updates project.json
```

**Called by:** the `reorder` skill, scene archive/promote operations

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
${CLAUDE_PLUGIN_ROOT}/scripts/session/calculate-stats.sh .
```

Project hooks run scripts copied into the project's own `.claude/hooks/`
directory (scaffolded from `hooks-template/`).

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

# Test session calculation
# (requires an active session and project.json)
```

## Adding New Scripts

When adding a new script:

1. **Name clearly** - `verb-noun.sh` pattern (e.g., `calculate-stats.sh`)
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
