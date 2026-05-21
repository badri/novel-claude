# Skills-Only Consolidation — Design Spec

**Date:** 2026-05-21
**Status:** Approved, ready for implementation plan
**Scope:** Issue #1 from the v2.0.0 skills audit — finish the commands→skills conversion.

## Problem

The v2.0.0 conversion (commits `d47e390`, `84a66ba`, `e13d30e`) moved the plugin
to intent-driven skills but left the old `commands/` directory in place. Claude
Code auto-discovers both `commands/` and `skills/`, so the plugin currently ships
every feature twice — once as a `/slash` command, once as a skill. Two commands
also reference removed infrastructure (DevRag) and are no longer invoked by
anything.

## Decision

Go **skills-only**. Delete `commands/` entirely. Each feature lives as exactly
one skill, invoked by intent. This matches the v2.0.0 architecture decision; the
leftover `commands/` directory was an incomplete conversion, not a deliberate
hybrid.

## Disposition of the 19 command files

### Delete — duplicate of an existing skill (14)

`blurb`, `brainstorm`, `chat`, `codex`, `compile`, `cover`, `cycle`,
`edit-scene`, `import`, `new-project`, `new-scene`, `reorder`, `scenes`,
`status`.

Each has an equivalent `skills/<name>/SKILL.md`. The skill is the source of
truth; the command is redundant.

### Delete — superseded (1)

`session.md` — the old multi-subcommand `/session start|end|status|log`. Its
functionality is covered by the `session-start`, `session-end`, and `status`
skills. The `log` subcommand (session history) is surfaced by the `status`
skill's session-statistics section.

### Delete — dead code (2)

`log-interaction.md`, `session-cleanup.md`. CHANGELOG's own "Fixed" note records
that session hooks were changed to invoke bash scripts directly, not slash
commands. Nothing invokes these two command files. `log-interaction.md`
additionally references DevRag, which v2.0.0 removed.

### Port to a new skill, then delete (2)

`concept.md` and `compile-manuscript.md` hold real functionality that no skill
currently provides.

## New skill: `concept`

**Path:** `skills/concept/SKILL.md`

**Purpose:** Pre-project story brainstorming that runs *outside* a project
directory — exploring a story idea before scaffolding a full project.

**Frontmatter:**
- `name: concept`
- `description:` "Use when..." triggering on pre-project intent: "I have a story
  idea", "before I start a project", "explore a story concept", "[X] in space",
  "kick around an idea for a new story". Must NOT summarize workflow.

**Disambiguation from the `brainstorm` skill:** `brainstorm` is in-project
(it reads `project.json`, recent scenes, summaries). `concept` is pre-project.
The body retains the existing location check — if `project.json` exists in the
cwd, it tells the user this is for pre-project work and points them at the
`brainstorm` skill instead.

**Body:** Ported from `commands/concept.md`. Rewrite slash-command references
(`/brainstorm`, `/new-project`) into intent language ("the brainstorm skill",
"the new-project skill"). Scrub any DevRag/Gemini-era references if present.

## New skill: `shunn-format`

**Path:** `skills/shunn-format/SKILL.md`

**Purpose:** Compile scenes into a submission-ready manuscript in William
Shunn's modern manuscript format (.docx/.doc) — for agents and publishers.

**Frontmatter:**
- `name: shunn-format`
- `description:` "Use when..." triggering on: "Shunn format", "submission
  format", "manuscript for submission", "format for agents/publishers",
  "professional manuscript". Must NOT summarize workflow.

**Disambiguation from the `compile` skill:** `compile` produces a working /
reading copy (generic MD/DOCX/EPUB). `shunn-format` produces a submission
artifact with title page, contact info, running headers, Courier New 12pt,
double-spacing, 1-inch margins, and centered `#` scene breaks.

**Body:** Ported from `commands/compile-manuscript.md` essentially verbatim
(it is already skill-shaped — no slash-command idioms to scrub).

## Final cleanup

- Delete the now-empty `commands/` directory.
- `plugin.json` and `marketplace.json` declare no `commands` key — auto-discovery
  handles directories — so no manifest edit is needed for command removal.
- Add an `[Unreleased]` CHANGELOG entry under `Removed` (commands/ directory,
  `session.md`, `log-interaction.md`, `session-cleanup.md`) and `Added`
  (`concept`, `shunn-format` skills).
- Run `claude plugin validate .` at the repo root (per `nc/CLAUDE.md`).

## Out of scope

- Stale `/slash` references *inside* skill bodies (`new-scene`, `edit-scene`,
  `scenes`) — audit issue #2.
- `new-project`'s broken `$0`/`$PLUGIN_DIR` plugin-path logic — audit issue #3.
- `hooks-template/` scripts and the `session-start`/`session-end` skill-vs-hook
  overlap.
- The stale `nc/CLAUDE.md` (still documents DevRag, Gemini, the command system).
- `marketplace.json` version drift (`1.1.0` vs `plugin.json` `2.0.0`) — noted
  for a later release-hygiene pass.

## Success criteria

- `commands/` directory no longer exists.
- `skills/` contains 20 skills (18 existing + `concept` + `shunn-format`).
- No feature is reachable two ways.
- `claude plugin validate .` passes.
- Pre-project concept brainstorming and Shunn-format compilation remain
  available — as skills.
