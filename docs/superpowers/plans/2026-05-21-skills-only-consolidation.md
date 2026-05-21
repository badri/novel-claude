# Skills-Only Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Finish the v2.0.0 commands→skills conversion by porting the two real-functionality commands to skills and deleting the `commands/` directory.

**Architecture:** The plugin is skills-only. `concept` and `shunn-format` become new skills; the `concept` skill delegates project scaffolding to the existing `new-project` skill rather than duplicating it. All 19 command files are then removed. There is no automated test framework — verification is `claude plugin validate .` plus file-existence checks.

**Tech Stack:** Claude Code plugin (markdown skills), `git`, `claude plugin validate`.

---

## File Structure

- Create: `skills/concept/SKILL.md` — pre-project story brainstorming
- Create: `skills/shunn-format/SKILL.md` — Shunn submission-format compilation
- Delete: `commands/` (all 19 `.md` files and the directory)
- Modify: `CHANGELOG.md` — `[Unreleased]` entry

`generate_manuscript.py` already exists at the plugin root and stays. No manifest
edits are needed: `plugin.json` / `marketplace.json` declare no `commands` key.

---

## Task 1: Create the `concept` skill

**Files:**
- Create: `skills/concept/SKILL.md`
- Reference (read-only): `commands/concept.md`, `skills/new-project/SKILL.md`

- [ ] **Step 1: Create `skills/concept/SKILL.md`**

Write this exact content:

````markdown
---
name: concept
description: Use when the user has a story idea they want to explore before committing to a project, or wants pre-project brainstorming outside a project directory. Trigger on: "I have a story idea", "concept", "before I start a project", "explore a story idea", "[X] in space", "kick around an idea for a new story".
---

# Concept — Pre-Project Story Brainstorming

Explore and develop a story idea *before* scaffolding a project. This runs
OUTSIDE a project directory and bridges "I have an idea" and "I have a
structured project."

## Task

### 1. Verify location

Check the current directory is NOT an existing fiction project:
- If `project.json` exists here, this is the wrong moment for pre-project work.
  Tell the user the `brainstorm` skill handles in-project exploration. If they
  genuinely want to concept a *new, separate* story, suggest they `cd` to a
  fresh directory first.

### 2. Capture the concept

Ask for their high-level story concept. Offer examples to prime them:
- "Count of Monte Cristo as a space opera"
- "Hardboiled detective in a cyberpunk city"
- "Small-town horror with cosmic implications"

### 3. Interactive brainstorming

Lead a conversational, discovery-focused session. Ask across these areas
(not as a rigid checklist — follow the user's energy):

- **Genre & tone:** genres, emotional tone, conventions to embrace or subvert
- **Setting:** where, when, what makes it unique, the world's rules
- **Characters:** protagonist and their want, what opposes them, key supporting cast
- **Story:** inciting incident, major conflicts, stakes, any sense of the ending
- **Themes:** questions the story explores, what readers should feel

### 4. Save the session

Create `concept-YYYYMMDD-HHMMSS.md` in the current directory:

```markdown
# Story Concept - [Date]

## High-Level Concept
[User's initial pitch]

## Genre & Tone
[Notes]

## Setting
[Notes]

## Characters
[Notes]

## Story
[Notes]

## Themes
[Notes]

---
Brainstormed: [timestamp]
```

### 5. Offer to create a project

Ask: "Want to create a project from this concept? (yes/no)"

**If no:** Tell the user the concept is saved to `concept-YYYYMMDD-HHMMSS.md`
and they can come back to it anytime. Done.

**If yes:** Continue to step 6.

### 6. Hand off to project creation

Collect the two things project creation still needs:
- **Project name** (kebab-case — suggest one based on the concept)
- **Story format** (short story, novella, novel — infer or ask)

Genre and premise are already known from the brainstorm — summarize the
premise yourself, don't re-ask.

Then invoke the **new-project skill** to scaffold the project, passing the
gathered metadata (name, genre, format, premise) plus the brainstorm content
so it can pre-populate `CLAUDE.md`, `project.json` metadata, and the codex
files.

### 7. Move the concept file into the project

After the project is scaffolded, move `concept-YYYYMMDD-HHMMSS.md` into the
new project as `brainstorms/initial-concept.md`.

### 8. Output summary

Tell the user:

```
✓ Project created at: [full path]
✓ Concept brainstorm moved to brainstorms/initial-concept.md
✓ CLAUDE.md, project.json, and codex pre-populated from the brainstorm

Next: cd [project-name] && claude

Ready to write — start your first scene, expand the codex, or
keep developing the story.
```

## Notes

- This is for the BEGINNING of the creative process: idea → exploration → structure.
- It respects discovery writing — no forced outlines, just exploration.
- Once a project exists, the `brainstorm` skill handles ongoing exploration.
- The concept file is preserved in the project for reference.
````

- [ ] **Step 2: Verify the skill file is well-formed**

Run: `head -4 skills/concept/SKILL.md`
Expected: shows the YAML frontmatter with `name: concept` and a `description:`
starting with `Use when`.

Run: `grep -nE 'PLUGIN_DIR|\.devrag|\.mcp\.json|/brainstorm|/new-project|/new-scene|/codex' skills/concept/SKILL.md`
Expected: no output (no DevRag cruft, no `$PLUGIN_DIR`, no slash-command syntax).

- [ ] **Step 3: Commit**

```bash
git add skills/concept/SKILL.md
git commit -m "Add concept skill (pre-project story brainstorming)"
```

---

## Task 2: Create the `shunn-format` skill

**Files:**
- Create: `skills/shunn-format/SKILL.md`
- Reference (read-only): `commands/compile-manuscript.md`
- Depends on (already exists): `generate_manuscript.py` at the plugin root

- [ ] **Step 1: Create `skills/shunn-format/SKILL.md`**

Write this exact content:

````markdown
---
name: shunn-format
description: Use when the user wants a submission-ready manuscript formatted for agents or publishers. Trigger on: "Shunn format", "submission format", "manuscript for submission", "format for agents", "format for publishers", "professional manuscript", "manuscript I can submit".
---

# Shunn-Format Manuscript

Compile all scenes into a professionally formatted manuscript following
**William Shunn's modern manuscript format** — the industry standard for
fiction submissions. Produces `.docx` (and `.doc` on macOS).

Use this for submission. For a working or reading copy (generic MD/DOCX/EPUB),
use the `compile` skill instead.

## What the format produces

- Courier New, 12pt, double-spaced
- 1-inch margins, 0.5-inch first-line paragraph indents
- Title page with contact info and rounded word count
- Running headers on pages 2+: `Surname / Keywords / Page#`
- Left-aligned text (ragged right)
- Scene breaks as a centered `#`, `END` marker at the close
- Preserves markdown italics/bold; strips invisible Unicode characters

## Task

### 1. Check prerequisites

```bash
python3 -c "from docx import Document; print('python-docx: OK')" 2>/dev/null || pip3 install python-docx
which textutil || echo "Note: textutil not found, will create .docx only"
```

### 2. Read project metadata

Read `project.json` from the project directory. The generator uses:
- `projectName` or `title` — story title
- `author` — legal name (for the contact block)
- `penName` — byline name (defaults to `author` if unset)
- `wordCount` — total word count
- `contact` — object with `address` (array of lines), `email`, `phone`

If contact fields are missing, ask the user for them before continuing.

### 3. Create the manuscript directory

```bash
mkdir -p manuscript
```

### 4. Run the generator

The plugin ships `generate_manuscript.py`, which implements the full Shunn
specification (title page, headers, scene-break concatenation, markdown
conversion, Unicode cleaning, word-count rounding):

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/generate_manuscript.py" . "manuscript/[projectName]-manuscript.docx"
```

Run it from the project directory (`.` is the project root). It reads
`project.json` and all `scenes/scene-*.md` files in order — scenes in
`drafts/` or `archive/` are excluded.

### 5. Convert to .doc (macOS)

```bash
if command -v textutil &> /dev/null; then
    textutil -convert doc "manuscript/[projectName]-manuscript.docx" \
        -output "manuscript/[projectName]-manuscript.doc"
    echo "✓ Created .doc version"
else
    echo "Note: .docx is standard everywhere; save as .doc from Word if needed."
fi
```

### 6. Report results

Tell the user the files created, the formatting applied, and statistics
(total scenes, total words, estimated pages at 250 words/page). Suggest next
steps: review in Word, run spell/grammar check, submit to markets or beta
readers.

## Notes

- **No chapter headings.** Per Shunn format, scenes flow continuously with `#`
  breaks. Editors add chapter divisions later during production.
- **Word-count rounding:** under 17,500 words round to nearest 100; at or above
  17,500 (novella+) round to nearest 500.
- **Scene discovery:** scenes must be named `scene-001.md`, `scene-002.md`, …
  in `scenes/`. Files in `scenes/drafts/` and `scenes/archive/` are skipped.

## Troubleshooting

- `python-docx` missing → `pip3 install python-docx`
- `.doc` conversion fails → the `.docx` is standard; save as `.doc` from Word,
  or install LibreOffice (`brew install --cask libreoffice`)
- Formatting looks wrong → verify `project.json` has all required fields and
  the `contact` object is well-structured

## References

- William Shunn manuscript format: https://format.ms/story
- Generator: `generate_manuscript.py` at the plugin root
````

- [ ] **Step 2: Verify the skill file is well-formed**

Run: `head -4 skills/shunn-format/SKILL.md`
Expected: YAML frontmatter with `name: shunn-format` and a `description:`
starting with `Use when`.

Run: `grep -n 'CLAUDE_PLUGIN_ROOT' skills/shunn-format/SKILL.md`
Expected: one match — the generator is referenced via `${CLAUDE_PLUGIN_ROOT}`,
not a bare path.

- [ ] **Step 3: Commit**

```bash
git add skills/shunn-format/SKILL.md
git commit -m "Add shunn-format skill (submission-format manuscript)"
```

---

## Task 3: Delete the `commands/` directory

**Files:**
- Delete: `commands/` (all 19 `.md` files and the directory)

- [ ] **Step 1: Confirm the two ported commands have skill equivalents**

Run: `ls skills/concept/SKILL.md skills/shunn-format/SKILL.md`
Expected: both paths listed, no error. (Guards against deleting `concept.md`
and `compile-manuscript.md` before their ports exist.)

- [ ] **Step 2: Delete the directory**

```bash
git rm -r commands/
```

Expected: git reports 19 files removed (`blurb.md`, `brainstorm.md`, `chat.md`,
`codex.md`, `compile.md`, `compile-manuscript.md`, `concept.md`, `cover.md`,
`cycle.md`, `edit-scene.md`, `import.md`, `log-interaction.md`,
`new-project.md`, `new-scene.md`, `reorder.md`, `scenes.md`,
`session-cleanup.md`, `session.md`, `status.md`).

- [ ] **Step 3: Verify removal**

Run: `ls commands 2>&1`
Expected: `No such file or directory`.

Run: `ls skills | wc -l`
Expected: `20` (18 original skills + `concept` + `shunn-format`).

- [ ] **Step 4: Commit**

```bash
git commit -m "Remove commands/ directory (skills-only, v2 conversion complete)"
```

---

## Task 4: Update CHANGELOG

**Files:**
- Modify: `CHANGELOG.md` — under the `## [Unreleased]` heading

- [ ] **Step 1: Add `Removed` and `Added` entries**

Under the existing `## [Unreleased]` heading in `CHANGELOG.md`, add these two
sections (place `Added` after the existing `Changed` block, and add a new
`Removed` section):

```markdown
### Added
- **`concept` skill** — pre-project story brainstorming that runs outside a
  project directory; explores a story idea, then delegates project scaffolding
  to the `new-project` skill (idea → exploration → structure).
- **`shunn-format` skill** — compiles scenes into a submission-ready manuscript
  in William Shunn's modern manuscript format (.docx/.doc).

### Removed
- **`commands/` directory** — completes the v2.0.0 commands→skills conversion.
  The plugin is now skills-only; no feature is reachable two ways.
  - 14 command files that duplicated existing skills were deleted.
  - `session.md` deleted — superseded by the `session-start`, `session-end`,
    and `status` skills.
  - `log-interaction.md` and `session-cleanup.md` deleted — dead code; session
    hooks invoke bash scripts directly, not slash commands.
  - `concept.md` and `compile-manuscript.md` were ported to skills (see Added).
```

- [ ] **Step 2: Verify**

Run: `grep -nA2 '### Removed' CHANGELOG.md`
Expected: shows the new `Removed` section under `[Unreleased]`.

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "Update CHANGELOG for skills-only consolidation"
```

---

## Task 5: Validate the plugin

- [ ] **Step 1: Run plugin validation**

Run from the repo root: `claude plugin validate .`
Expected: validation passes with no errors. (Per `nc/CLAUDE.md`, this is
required after any plugin change.)

- [ ] **Step 2: If validation fails**

Read the error, fix the offending file, and re-run `claude plugin validate .`
until it passes. Commit the fix:

```bash
git add -A
git commit -m "Fix plugin validation errors"
```

If validation passes on the first run, skip this step — no empty commit.

---

## Self-Review Notes

- **Spec coverage:** all four spec dispositions are covered — duplicates +
  superseded + dead code deleted in Task 3; `concept` ported in Task 1;
  `compile-manuscript` ported as `shunn-format` in Task 2; CHANGELOG in Task 4;
  `claude plugin validate` in Task 5.
- **Out of scope (unchanged, per spec):** stale `/slash` references inside
  `new-scene`/`edit-scene`/`scenes` bodies, `new-project`'s `$0`/`$PLUGIN_DIR`
  logic, hooks-template, stale `nc/CLAUDE.md`, `marketplace.json` version drift.
- **DevRag scrub:** Task 1 Step 2 explicitly greps the ported `concept` skill
  to confirm no `.devrag`/`.mcp.json`/`$PLUGIN_DIR` cruft survived the port.
