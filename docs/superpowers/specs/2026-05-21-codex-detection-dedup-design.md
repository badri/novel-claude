# Codex-Detection Deduplication — Design Spec

**Date:** 2026-05-21
**Status:** Approved, ready for implementation plan
**Scope:** Audit follow-up — remove duplicated codex-detection logic across skills.

## Problem

The workflow for detecting codex-worthy elements (new characters, locations,
worldbuilding, skills) and offering to save them is re-explained in three
skills:

- `new-scene` — steps 7–12 plus the "Codex Detection Strategy" section
  (~180 lines): smart detection, cross-referencing, filtering, batch
  presentation, choice processing, entry templates, cycle integration.
- `brainstorm` — steps 6–8 ("Detect codex-worthy elements", "Inline codex
  creation", "End-of-session codex review") plus the "Codex Integration"
  section.
- `edit-scene` — step 9 ("Cycle integration", ~8 lines).

The `codex` skill already owns an "Extract from Scenes" action but does not
carry the full detection workflow. The result: `new-scene` is bloated
(~309 lines) and the same logic must be maintained in three places.

## Decision

Make the `codex` skill the single source of truth for codex-element detection.
The three callers cross-reference it instead of re-explaining it.

## Canonical home: the `codex` skill

Expand the existing "Extract from Scenes" action into a new authoritative
section: **"## Detecting Codex Elements from Content"**. It documents the
complete reusable workflow:

1. **What to scan for** — named characters (proper names, dialogue
   attribution, descriptions, POV character), named locations (named places
   with atmosphere), worldbuilding (organizations, systems, rules, unique
   tech/magic), demonstrated skills/abilities.
2. **Cross-reference before flagging** — search `codex/characters.md`,
   `codex/locations.md`, `codex/worldbuilding.md`, `codex/lore.md` first;
   only flag genuinely new elements.
3. **Smart filtering** — skip generic terms (guard, waiter, street) unless
   named and developed; flag named characters with dialogue/description,
   named locations, organizations, unique systems, unestablished skills.
4. **Batch presentation** — present all detections together in the
   `✨ New elements detected` block; never one at a time.
5. **Process choices** — `[y]` add now (extract details, show preview,
   confirm, append to the right codex file); `[n]` skip; `[later]` append to
   `notes/codex-todo.md`.
6. **Skill → cycle integration** — when a demonstrated skill was never
   established, offer: (a) add to codex only, (b) add to codex + trigger the
   `cycle` skill to plant it earlier, (c) skip.

The Character/Location entry templates already exist in the `codex` skill and
are NOT duplicated — the new section references them.

`codex` SKILL.md grows from ~165 to ~220 lines.

## Caller changes

### `new-scene`

Delete steps 7–12 and the entire "## Codex Detection Strategy" section
(~180 lines). Replace with a single short step:

> **7. Detect codex elements** — After the scene is created, scan it for new
> codex-worthy elements and offer to add them. Follow the codex skill's
> "Detecting Codex Elements from Content" workflow.

The remaining "Output" step is renumbered accordingly. Scene-creation logic
(steps 0–6) is untouched. `new-scene` drops to ~140 lines or fewer.

### `brainstorm`

Delete steps 6–8 and the "## Codex Integration" section. Replace with one
short step (~10 lines) that keeps the two brainstorm-specific behaviors and
delegates the mechanics:

> **6. Codex elements** — Two triggers:
> - *Inline* — if the user says "add to codex" / "save this" mid-session,
>   act immediately.
> - *End of session* — before saving the brainstorm, surface any
>   codex-worthy elements developed during the discussion.
> For detection criteria and the add/skip/later flow, follow the codex
> skill's "Detecting Codex Elements from Content" workflow.

Remaining steps renumber accordingly.

### `edit-scene`

Replace step 9 ("Cycle integration", ~8 lines) with a one-liner:

> **9. Detect codex elements** — If the edit introduces a new character,
> location, or skill, offer to add it per the codex skill's "Detecting Codex
> Elements from Content" workflow.

## Out of scope

- No changes to any skill's YAML frontmatter (`name`, `description`) —
  triggering conditions are unchanged.
- The `cycle` skill is untouched.
- Entry-template content is untouched (already canonical in `codex`).

## Testing

No automated test suite. Verify by:

1. `claude plugin validate .` passes.
2. The detailed detection prose (scan criteria, filtering rules, the
   `✨ New elements detected` offer format, `[y/n/later]` processing) appears
   in exactly one skill — `codex`.
3. `new-scene`, `brainstorm`, and `edit-scene` contain only short
   cross-references to the codex skill's detection workflow.

## Success criteria

- `codex` SKILL.md has the authoritative "Detecting Codex Elements from
  Content" section.
- `new-scene` SKILL.md is ~140 lines or fewer.
- `brainstorm` and `edit-scene` reference the codex workflow instead of
  re-documenting it.
- No skill re-documents detection criteria, filtering rules, or the offer
  format.
