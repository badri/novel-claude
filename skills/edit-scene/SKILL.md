---
name: edit-scene
description: Use when the user wants to modify, fix, improve, or revise an existing scene. Trigger on: "fix scene N", "this scene feels off", "rewrite the opening", "scene N needs work", "edit scene", "something's wrong with scene N", "rewrite 012".
---

# Edit Scene

Rewrite an existing scene to the author's annotations. **The author directs;
the AI drafts.**

## The two modes

### Mode 1 — Annotate → rewrite (primary path)

The author drops **tags** on the prose, says "rewrite NNN", and the AI
rewrites to the tags.

Why tags: annotations never appear in fiction prose, so they're unambiguous
and greppable, and they carry the instruction *inside* the scene file where
the rewrite happens.

**The seven tags:**

| Tag | Meaning |
|---|---|
| `<brief> … </brief>` | A brief for a stretch of an existing scene — register / keep / change / flow & beats. |
| `<cut> … </cut>` | Remove this. **Wrap the prose to remove.** |
| `<change> … </change>` | Revise. **Wrap the target** and put the instruction inside — e.g. `<change>which felt relieving → cut, it's telly</change>`. |
| `<keep> … </keep>` | Lock this. Do not touch it in the rewrite. |
| `<add> … </add>` | Insert this **at this point**. |
| `<flow> … </flow>` | A beat/flow note, placed where it applies. |
| `<q> … </q>` | A question for the AI. Answer it; then resolve it. |

**Wrap the target.** Whenever the note is about specific text, wrap that text
in the tag — then there is no above/below ambiguity. A *point* tag (`<add>`,
`<flow>`) goes exactly where it applies. A floating note goes **above** the
passage it concerns.

**Handoff:** author annotates → says **"rewrite NNN"** → AI rewrites to the
tags, **strips them** (they're consumed), and **updates the scene's Notes**.

**One editor per file at a time** — if another session or the author has the
file open, coordinate before writing; concurrent edits clobber each other.

**A fresh scene is the other side of the same coin:** the author writes a
freeform skeleton with **no tags** and the whole file is the brief. That's the
`new-scene` skill.

### Mode 2 — Untagged request (preview first)

The author asks for a change in plain language with no tags in the file. Then
the edit is **previewed before it lands** — show the before/after, get
approval, then write.

## Task

1. **Identify the scene**:
   - The user names it ("rewrite 012", "fix scene 3"), or
   - "current/latest scene"

   The ID is a **stable ID** — `scenes/scene-NNN.md`. It is never renumbered;
   reading order is `ORDER.md`, and editing never changes it. Don't
   re-derive the scene's position from its filename.

2. **Read the file** and parse it: `# Scene NNN`, `**POV**`, `**Location**`,
   `**Time**`, `**Status**`, prose, `**Notes**`.

3. **Scan for annotation tags** (`<brief>`, `<cut>`, `<change>`, `<keep>`,
   `<add>`, `<flow>`, `<q>`) and branch:

   - **Tags present → Mode 1.** List them back to the author with your
     reading of each, and flag any `<q>` you need answered before rewriting.
     If a tag is ambiguous or conflicts with another, ask — one round, then
     proceed.
   - **No tags → Mode 2.** Take the request in plain language:
     - *Specific*: "make the dialogue tenser", "add sensory detail in the
       opening", "remove filter words", "shorten by 20%"
     - *Section rewrite*: "rewrite the opening as more ominous", "redo the
       ending as a cliffhanger"
     - *Polish*: "tighten the prose", "fix pacing", "strengthen voice"

4. **Rewrite**:

   - **Mode 1** — rewrite to the tags, and only to the tags:
     - `<cut>` regions are removed; their surrounding rhythm is repaired
     - `<change>` regions are revised per the instruction inside
     - `<keep>` regions are copied through **byte-identical**
     - `<add>` content is inserted at its point; `<flow>` notes are honored
       as beats; `<brief>` sets register for its stretch
     - `<q>` questions are answered (in the chat, or resolved in prose if the
       question implies a fix)
     - Prose outside every tag is left as-is
     - **Then strip all seven tags** — they are consumed by the rewrite and
       must not survive into the file, and never into compiled output
   - **Mode 2** — apply the instruction, preserving structure and voice.

   Either way: keep the scene headers intact, keep continuity with the scenes
   `ORDER.md` places around it, and follow the house register.

5. **Mode 2 only — show the preview before writing**:

   ```markdown
   ## Original (1,234 words):
   [the section that changed]

   ## Edited (1,189 words):
   [new version of that section]

   Changes:
   - Tightened dialogue
   - Added sensory detail
   - Removed 45 words
   ```

   Then confirm: **[y] accept** / **[e] edit further** / **[r] revert** /
   **[s] full scene**. Write only on accept.

6. **Write the file** and update **Notes**:

   ```
   **Notes**:
   - Word count: 1,189
   - Last edited: 2026-09-16 (AI: rewrite — cut telly passage, kept the
     drawer beat; grounded the kitchen in smell/touch; henna detail re-planted)
   ```

   For a tag-driven rewrite, the edit note is the record of what was consumed
   — say which tags were applied and what changed at the level of *approach*,
   not implementation details.

7. **House-style pass** (prose register):
   - Short declarative sentences; concrete nouns, active verbs
   - No "and…and…and" chains; em-dashes rationed
   - Minimal interiority; no bowtie summaries at scene end
   - Ration the "did X the way a Y does Z" simile-of-manner
   - No bare-pronoun scene/section openings

8. **Check `ORDER.md`**:
   - Did the edit change what the scene *is*? The one-line reverse outline for
     `[scene-NNN]` must still be true. If it drifted, offer the updated line.
   - The scene's **position** is unaffected — editing never reorders.

9. **Handle summaries**:
   - If `summaries/summary-scene-NNN.md` exists and the edit was substantive,
     note it's stale and offer to re-run `summarize`.

10. **Detect codex elements**:

    If the edit introduces a new character, location, or demonstrated skill,
    offer to add it — follow the codex skill's "Detecting Codex Elements from
    Content" workflow. For a demonstrated skill the writing never established,
    the codex skill routes to `cycle` to plant the setup.

## Safety

- **Backup**: the original is recoverable via git (if the project is a repo).
- **Preview before changing** an untagged request — always.
- **Never edit story content without a request or an approval.** Tagged
  rewrites are the request; untagged changes need the preview.
- **Never leave a tag in the file.** A surviving tag is a bug: `compile`
  refuses to assemble a manuscript that contains one.

## Philosophy

**Editing vs rewriting** — the point of tags is that both stay on the right
side of the line:

- ✅ Cut telly passages, tighten prose, add grounding, fix pacing, plant a
  foreshadow the writing discovered
- ✅ Rewrite a passage to the author's tags — that's direction, not revision
- ✅ Improve character voice consistency
- ❌ Reimagine the scene, change what happens, reverse character decisions,
  force plot points (Heinlein's Rule 3 — don't revise finished work; **cycle**
  instead)

A tag-driven rewrite is **finishing work**. If a scene is fundamentally wrong,
the answer is to cut it and write the next one — not to keep rewriting it.
