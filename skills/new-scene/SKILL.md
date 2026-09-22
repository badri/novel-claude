---
name: new-scene
description: Use when the user wants to write the next scene, continue the story, add a new chapter, or generate new prose. Trigger on: "let's write", "next scene", "continue", "what happens next", "write the scene where X", "I want to write", or any intent to produce new story content.
---

# New Scene

Create a new scene file, draft it, and place it in `ORDER.md`.

## Scene IDs are stable

`scenes/scene-NNN.md` filenames are **stable IDs assigned in creation order**
— "the Nth scene I wrote." They are **NEVER renamed or renumbered**, no matter
where the scene lands in the book. Reading order lives in `ORDER.md`
(see the `reorder` skill).

**Next ID = highest NNN already used + 1.** A number once used is spent
forever, even if its scene was cut. Scan everywhere a number can exist
before choosing:

- `scenes/scene-*.md`
- `scenes/drafts/*.md` — a numbered draft has already consumed that ID
- `scenes/archive/*.md`
- `scenes/cut/*.md` (if the project uses it)
- every `[scene-NNN]` reference still listed in `ORDER.md`, including the
  `## Cut` and `## Unplaced / drafts` sections

Zero-pad to three digits: `001`, `002`, …, `010`.

## Scene types

- **Active scene** (default) — added to `scenes/`, placed in `ORDER.md`.
- **Draft scene** — added to `scenes/drafts/` for experimental or out-of-order
  writing. Use when the user asks for a draft, an experimental scene, or wants
  to write a scene they can't place yet (e.g. "draft the villain's backstory").
  A draft can take a descriptive name instead of a scene number.

## Task

0. **Determine scene type** (from the user's intent):
   - The user asked for a draft or an experimental/unplaceable scene → create
     in `scenes/drafts/`. Use a descriptive name if they gave one, otherwise
     `draft-NNN` numbering.
   - Otherwise → an active scene in `scenes/` (default).

1. **Check project context**:
   - Verify we're in a fiction project folder (has `project.json`)
   - **Read `ORDER.md`** — it is the reading order *and* the current one-line
     reverse outline. It's how you know what precedes this scene in the book
     and what's still unplaced.
   - Read `project.json` for `currentScene` (last stable ID created)
   - Compute the next stable ID as described above

2. **Read relevant context**:
   - The scene that will read **immediately before this one** (per `ORDER.md`)
     and its neighbour, for continuity — not simply the highest-numbered file
   - Relevant codex entries
   - Latest summary from `summaries/` if one exists

3. **Get the brief**. Two shapes — accept either without ceremony:
   - **The user hands you a freeform skeleton** (a file path, or text pasted
     in). **That skeleton *is* the brief** — the beats, what to keep in mind,
     the register. There is no `<brief>` wrapper on a fresh scene; the whole
     thing is the brief. Draft from it.
   - **The user describes the scene in prose.** Mix plot and writing
     instructions naturally; no special syntax required.

```
Joe meets the weapons dealer at the Park. Add description
in 5 senses from Joe's PoV of the Park.

Joe and the dealer have a sour argument about supply chain
and logistics. More dialogue, make it tense.

End with cliffhanger, don't resolve, don't hint Joe's intentions.
```

   The AI separates **plot/what happens** ("Joe meets the dealer") from
   **writing directives** ("Add 5 senses", "More dialogue", "End with
   cliffhanger"), drafts following both, and returns prose only — no
   meta-instructions, no tags, in the output.

   Common directive patterns: "add description of…", "more dialogue",
   "show don't tell", "from [character]'s POV", "5 senses", "make it
   tense/ominous", "end with a cliffhanger", "foreshadow…", "time jump to…",
   "don't reveal…".

4. **Create scene file**:
   - Active scene: `scenes/scene-NNN.md`
   - Draft scene (numbered): `scenes/drafts/draft-NNN.md`
   - Draft scene (named): `scenes/drafts/[name].md`

   **If the user supplied a skeleton, save it into the scene file verbatim
   first** — the skeleton is the brief of record, and the draft replaces it
   only once written. Never discard the brief.

Template structure:
```markdown
# Scene NNN  (or Draft: [Name])

**POV**: [character name or TBD]
**Location**: [setting]
**Time**: [when this takes place]
**Status**: active | draft

---

[Scene content goes here]

---

**Notes**:
- Word count: [calculate]
- Created: [current date]
- Type: [active/draft]
```

**Status field values**:
- `active` — in `scenes/`, placed in `ORDER.md`
- `draft` — in `scenes/drafts/`, experimental / not yet placed

5. **Draft the scene**:
   - **First read the *Craft & House Style* section of the writing root's
     `CLAUDE.md`** (the parent directory of the project). It holds the prose
     register, the five banned habits, the no-bowtie rule, the
     simile-of-manner ban and the lived-in-interruption rule, and it
     outranks anything in this skill or in a per-scene Craft note.
   - Maintain continuity with the scene `ORDER.md` puts before it
   - Don't pre-plot; follow the character's natural choices
   - Generate multiple options if the user asks

6. **Place it in `ORDER.md`** (active scenes only):

   - **Ask the user where it reads**, unless they already said ("this goes
     after scene 012", "this is the opener", "not sure yet").
   - Add one line at that reading position:
     `N. **[scene-NNN]** — one-sentence reverse outline (~word count)`
     — the list positions are re-counted from 1 (1., 2., 3., …); the
     `[scene-NNN]` IDs never change.
   - **Placement unknown → put it under `## Unplaced / drafts`** rather than
     guessing a slot.
   - Get the one-sentence line from the user, or write it yourself and show it
     for approval. Keep it one sentence.

   Drafts are not placed yet — they either stay out of `ORDER.md` (a named
   draft file) or appear under `## Unplaced / drafts`.

7. **Depth self-check — STANDING STEP, not optional** (active scenes):

   Before declaring the scene done, read it back and fix the gaps in place.
   This is an inline pass you run yourself — it is **not** a `depth-drill`
   invocation (that drill is observational, never rewrites, and only runs when
   the writer asks for it).

   - **Five senses, early, through the POV.** The opening grounds the
     character in the physical scene through *their* body and perception —
     sight, sound, smell, touch, taste — not a neutral author-camera. Run the
     same lens over the first ~100 words especially.
   - **VARY the somatization — do not body every emotion.** Rendering feeling
     as body sensation *every* time is the machine default (AI does it ~81% of
     the time vs ~38% for humans, and flatly names the feeling only ~8% vs
     ~29%). Ground the load-bearing beats; let minor emotions land as plain
     statement ("He was afraid." — full stop, next sentence). The human
     signature is the **variance**, not the technique.
   - **Opinion-tinting** — description carries the POV character's judgment,
     not flat reportage.
   - **No witness syndrome / floating camera** — everything on the page is
     something *this* character perceives, thinks, or feels.
   - **No fake/placeholder nouns** — kill vague "room / car / building" where
     a concrete, located noun belongs.
   - **Character-specific perception** — the same room reads differently
     through different eyes. Cross-POV scenes must *read* differently, not
     merely be labelled so; lead each with that character's mode of attention.
   - **Recognize, don't re-narrate** — returning to a room or a beat the
     reader already met gets the *new* thing and the character's recognition,
     never the same description a second time.

   Record the grounding in the scene's **Notes**. If the scene is deliberately
   spare, say so in Notes instead of skipping the check.

7b. **House-style pass — the three-second tests** (same standing step; fix
    in place, narration only, dialogue is exempt):

   - **Bowtie?** *Does the last paragraph tell the reader something the scene
     already showed?* Cut it and end one beat earlier, on the peak.
   - **Simile of manner?** Any *"did X the way a Y does Z"* / *"like a…"*
     manner-clause: render the concrete action instead. At most one
     load-bearing comparison per scene, named in Notes.
   - **Staged or timed interruption?** Real life intrudes in the margins of a
     beat about something else, unresolved, at an undramatic moment. Never
     played out in full; never landing on the climax as a button.
   - **The five habits?** Read each sentence aloud: *would he have written
     it, or is it performing?* Break long hinge-sentences (one idea, full
     stop); cut aphoristic tails; say what the thing is instead of a
     withheld-subject rhythm; subject-verb-fact instead of appositive
     stacks; a plain noun instead of a composed image.
   - **Bare-pronoun opening?** Name the subject or open on the concrete thing
     in the first line of the scene and after every section break.
   - **Padding?** *began to / started to / for a moment / a little / somehow
     / seemed to / made himself* — one verb beats a verb plus helper.

8. **Update `project.json`** (active scenes only):
   - **Active scene** (created in `scenes/`):
     - Increment `sceneCount` (placed active scenes)
     - Set `currentScene` to the new stable ID
     - Update `wordCount` (sum of scenes placed in `ORDER.md`)
     - Update `lastModified`
   - **Draft scene** (created in `scenes/drafts/`):
     - Do NOT increment scene count, do NOT set `currentScene`, do NOT count
       it in the word count — drafts sit outside manuscript tracking until
       promoted

   `${CLAUDE_PLUGIN_ROOT}/scripts/utils/word-count.sh .` (Claude Code) or
   `~/nc/scripts/utils/word-count.sh .` (omp) recomputes `wordCount` and
   `sceneCount` from the `scenes/scene-NNN.md` files on disk. If a scene file
   is on disk but absent from `ORDER.md`, `order-check.sh` reports it — it
   won't be in the manuscript even though it's in the count.

9. **Commit.** One scene, one commit, message `scene NNN: <the ORDER.md line>`.
   Every scene lands in git the moment it is placed; there is no session-end
   step that does it for you.

10. **Detect codex elements** (after the scene is written):

   Scan for codex-worthy elements (characters, locations, worldbuilding,
   demonstrated skills) and offer to add them — follow the codex skill's
   "Detecting Codex Elements from Content" workflow. The codex grows by
   accretion from what the writing established; never pre-build it.

11. **Output**:
    - Path to the new scene file
    - Word count
    - Where it was placed in `ORDER.md` (or that it's under Unplaced)
    - The depth self-check result (what you fixed)
    - Codex additions made
    - Next steps: continue writing, brainstorm next scene, update codex

## Important Notes

- **Never rename or renumber a scene file.** IDs are permanent; reading order
  is `ORDER.md`.
- A cut scene's ID stays retired — never reuse it for a new scene.
- If the user wants multiple options, generate 2-3 variations they can choose
  from.
- Always maintain codex consistency (character names, locations, rules).
- For discovery writing: don't force plot points, follow the character's
  natural choices.
- An **existing** scene gets the tag-based annotate→rewrite flow — that's the
  `edit-scene` skill, not this one.
