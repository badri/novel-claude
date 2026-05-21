# Codex-Detection Deduplication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the codex-element detection workflow into the `codex` skill as the single source of truth, and replace the duplicated copies in `new-scene`, `brainstorm`, and `edit-scene` with short cross-references.

**Architecture:** The `codex` skill gains a new authoritative section, "Detecting Codex Elements from Content". The three caller skills delete their inline detection prose and point to it. No frontmatter or triggering changes.

**Tech Stack:** Claude Code plugin (markdown skills), `git`, `claude plugin validate`. No automated test framework — verification is `claude plugin validate .` plus grep checks.

---

## File Structure

- Modify: `skills/codex/SKILL.md` — replace the "Extract from Scenes" stub, add the canonical detection section
- Modify: `skills/new-scene/SKILL.md` — collapse steps 7–12 + "Codex Detection Strategy" section to one step
- Modify: `skills/brainstorm/SKILL.md` — collapse steps 6–8 + "Codex Integration" section to one step
- Modify: `skills/edit-scene/SKILL.md` — collapse step 9 to a one-liner
- Modify: `CHANGELOG.md` — `[Unreleased]` entry

Each task is one skill file (plus CHANGELOG last), one commit.

---

## Task 1: Add the canonical detection section to the `codex` skill

**Files:**
- Modify: `skills/codex/SKILL.md`

- [ ] **Step 1: Replace the "Extract from Scenes" action stub**

Use the Edit tool. old_string:

```
### Extract from Scenes

- Ask which scene(s) to analyze
- Read scene content
- Identify new characters, locations, or world details
- Suggest codex additions
- User confirms what to add
```

new_string:

```
### Extract from Scenes

Detect codex-worthy elements in one or more scenes and offer to save them.
Ask which scene(s) to analyze, read them, then follow the "Detecting Codex
Elements from Content" workflow below.
```

- [ ] **Step 2: Add the canonical detection section**

Use the Edit tool. old_string:

```
## Codex Philosophy

The codex should be:
```

new_string:

```
## Detecting Codex Elements from Content

The shared workflow for spotting codex-worthy elements in a scene or in
brainstorm discussion and offering to save them. The `new-scene`,
`edit-scene`, and `brainstorm` skills invoke this workflow.

### 1. Scan for elements

In the content, look for:
- **New characters** — proper names in narrative, dialogue attribution
  (`"Hello," Yuki said`), explicit descriptions ("a woman named X"), the POV
  character if not yet in the codex
- **New locations** — named places with atmosphere ("Jade Dragon restaurant",
  "Kings Valley")
- **Worldbuilding** — organizations ("the Network", "the Order"), systems
  ("quantum communicators", "blood magic"), rules ("vampires can't cross
  running water"), unique tech/magic items
- **Demonstrated skills** — abilities a character uses ("Martha picked the
  lock" → lockpicking) that were not previously established
- **Timeline events** and **lore** references

### 2. Cross-reference before flagging

Before flagging anything as new, search the codex:
- `codex/characters.md` for character names
- `codex/locations.md` for location names
- `codex/worldbuilding.md` and `codex/lore.md` for concepts

Only flag elements NOT already present.

### 3. Filter

Don't flag:
- Generic, unnamed roles (guard, waiter, bartender)
- Common unnamed places (a street, a building)
- Throwaway mentions with no development

Do flag:
- Named characters with dialogue or description
- Named locations with atmosphere/description
- Organizations, systems, unique tech/magic
- Skills demonstrated but never established

### 4. Present all detections together

Show everything in one batch, never one at a time:

```
✨ New elements detected:

👤 **New Character**: Yuki (informant)
   Not in codex. Add now? [y/n/later]

📍 **New Location**: Jade Dragon restaurant (Tokyo)
   Not in codex. Add now? [y/n/later]

🌍 **Worldbuilding**: Network operations in Tokyo
   Expand worldbuilding codex? [y/n/later]

🔧 **Character Skill**: Martha — lockpicking
   Not established before. Options:
   a) Add to codex only
   b) Add to codex + cycle back to plant the skill earlier
   c) Skip
```

The user can also answer for all at once ("all yes", "all later").

### 5. Process choices

- **[y]** — extract details from the content, generate an entry using the
  Character/Location templates above, show a preview, let the user confirm or
  edit, then append to the right codex file.
- **[n]** — skip (minor character, one-time location).
- **[later]** — append to `notes/codex-todo.md` for the Review TODO action.

### 6. Skill → cycle integration

When a demonstrated skill was never established and the user picks **(b)**:
- Add the skill to the character's codex entry
- Trigger the `cycle` skill to plant the skill earlier — suggest a likely
  scene, let the user confirm or choose another, then cycle back and add the
  setup

This makes the discovery → setup workflow seamless.

## Codex Philosophy

The codex should be:
```

- [ ] **Step 3: Verify**

Run: `grep -n 'Detecting Codex Elements from Content' skills/codex/SKILL.md`
Expected: two matches — the new section heading, and the reference inside the
"Extract from Scenes" action.

Run: `grep -c '✨ New elements detected' skills/codex/SKILL.md`
Expected: `1`.

Run: `head -4 skills/codex/SKILL.md`
Expected: frontmatter intact (`name: codex`).

- [ ] **Step 4: Commit**

```bash
git add skills/codex/SKILL.md
git commit -m "Add canonical codex-detection workflow to codex skill"
```

---

## Task 2: Slim the `new-scene` skill

**Files:**
- Modify: `skills/new-scene/SKILL.md`

- [ ] **Step 1: Replace steps 7–12 with one short step plus Output**

Use the Edit tool. old_string is the entire block from step 7 through the end
of step 12 (the "Output" step). old_string:

```
7. **Detect new codex elements** (after scene is created):

   Scan the scene content for:
   - **New characters** not in `codex/characters.md`
   - **New locations** not in `codex/locations.md`
   - **Worldbuilding** details (organizations, systems, rules)
   - **Skills/abilities** demonstrated by characters
   - **Timeline events** mentioned
   - **Lore** references

8. **Smart detection process**:

   **New Characters**:
   - Look for proper names in narrative
   - Dialogue attribution: `"Hello," Yuki said`
   - Character descriptions: "A woman named X"
   - POV character if not in codex

   **New Locations**:
   - Named places: "Jade Dragon restaurant", "Kings Valley"
   - Setting descriptions: "They arrived at the [location]"
   - Geographic references

   **Worldbuilding Elements**:
   - Organizations: "the Network", "the Order", "the Council"
   - Systems: "quantum communicators", "blood magic"
   - Rules: "Vampires can't cross running water"
   - Tech/magic items with significance

   **Character Skills/Abilities**:
   - "Martha picked the lock" → lockpicking skill
   - "He spoke fluent Mandarin" → language skill
   - Check if skill was established in codex previously

9. **Offer codex additions**:

   After scene is created, present findings:

   ```
   ✓ Scene 015 created (1,456 words)

   ✨ New elements detected:

   👤 **New Character**: Yuki (informant)
      Not in codex. Add now? [y/n/later]

   📍 **New Location**: Jade Dragon restaurant (Tokyo)
      Not in codex. Add now? [y/n/later]

   🌍 **Worldbuilding**: Network operations in Tokyo
      Expand worldbuilding codex? [y/n/later]

   🔧 **Character Skill**: Martha - lockpicking
      Not established before. Options:
      a) Add to codex only
      b) Add to codex + cycle back to plant skill
      c) Skip
   ```

10. **Process user choices**:

    **[y] - Add now**:
    - Extract details from scene
    - Generate codex entry
    - Show preview
    - User confirms or edits
    - Add to appropriate codex file

    **[n] - Skip**:
    - Don't add (minor character, one-time location)
    - Continue to next detection

    **[later] - Add to TODO**:
    - Append to `notes/codex-todo.md`
    - Process later via the codex skill's review-todo action

    **For skills - [b] Add + cycle**:
    - Add skill to character's codex entry
    - Trigger the cycle skill to plant it earlier
    - Seamless integration

11. **Auto-generated codex entries**:

    When user says "yes", generate entry from scene:

    **Character example**:
    ```markdown
    ## Yuki

    **Role**: Supporting (Informant)
    **Appearance**: [from scene: "slim, dark eyes, nervous hands"]
    **Personality**: Cautious, well-informed, risk-averse
    **Background**: Tokyo-based informant with Network intel
    **Goals**: [TBD - expand as story develops]
    **Conflicts**: Fear vs desire to help
    **Relationships**: Marcus (scene 15 - provides information)
    **First Appearance**: Scene 015

    ---
    ```

    **Location example**:
    ```markdown
    ## Jade Dragon Restaurant

    **Type**: Restaurant
    **Location**: Tokyo
    **Description**: [from scene: "dimly lit, private booths, red lanterns"]
    **Atmosphere**: Discreet, traditional, clandestine meetings
    **Significance**: Information exchange location
    **First Appearance**: Scene 015

    ---
    ```

12. **Output**:
    - Show path to new scene file
    - Show word count
    - Report codex additions made (if any)
    - Show codex TODOs created (if "later" chosen)
    - Suggest next steps:
      - Continue writing
      - Summarize this scene
      - Brainstorm next scene
      - Review codex todo if items pending
```

new_string:

```
7. **Detect codex elements** (after the scene is created):

   Scan the new scene for codex-worthy elements (characters, locations,
   worldbuilding, demonstrated skills) and offer to add them — follow the
   codex skill's "Detecting Codex Elements from Content" workflow.

8. **Output**:
   - Show path to new scene file
   - Show word count
   - Report codex additions made (if any)
   - Show codex TODOs created (if "later" chosen)
   - Suggest next steps:
     - Continue writing
     - Summarize this scene
     - Brainstorm next scene
     - Review codex todo if items pending
```

- [ ] **Step 2: Delete the "Codex Detection Strategy" section**

Use the Edit tool. old_string (note the leading blank line):

```

## Codex Detection Strategy

### Cross-Reference Before Flagging

Before flagging an element as "new":
1. Search `codex/characters.md` for character name
2. Search `codex/locations.md` for location name
3. Search `codex/worldbuilding.md` and `codex/lore.md` for concepts
4. Only flag if NOT found

### Smart Filtering

Don't flag:
- Generic terms (guard, waiter, bartender) unless given a name
- Common locations (street, building) unless specifically named
- Throwaway mentions (not developed in scene)

DO flag:
- Named characters with dialogue or description
- Named locations with atmosphere/description
- Organizations, systems, unique tech/magic
- Skills demonstrated that aren't established

### Batch Processing

Present all detections together, not one-by-one:
- Shows complete picture
- User can process efficiently
- Can select "all yes" or "all later" for speed

### Integration with Cycle

When skill detected that wasn't established:
```
🔧 Martha demonstrated lockpicking (scene 24)
   This wasn't established before.

   Options:
   a) Add to codex only (accept as discovered skill)
   b) Add to codex + cycle back to plant it earlier
   c) Skip

If user picks (b):
   → Updates codex with skill
   → Automatically launches cycle workflow
   → Suggests scene to plant (e.g., scene 6 where Martha's background shown)
   → User confirms or picks different scene
   → Cycles back and adds setup
```

This makes discovery → setup workflow seamless!
```

new_string: empty (delete the block entirely).

- [ ] **Step 3: Verify**

Run: `grep -c 'Codex Detection Strategy' skills/new-scene/SKILL.md`
Expected: `0`.

Run: `grep -c 'Detecting Codex Elements from Content' skills/new-scene/SKILL.md`
Expected: `1`.

Run: `wc -l < skills/new-scene/SKILL.md`
Expected: a number `<= 155` (down from 311 — the codex-detection prose is
gone; the remaining length is legitimate scene-creation content).

Run: `tail -1 skills/new-scene/SKILL.md`
Expected: the last line of the "Important Notes" section
(`- For discovery writing: don't force plot points, follow the character's natural choices`) —
confirms the file ends cleanly with no trailing stray content.

- [ ] **Step 4: Commit**

```bash
git add skills/new-scene/SKILL.md
git commit -m "Slim new-scene: reference codex detection workflow"
```

---

## Task 3: Slim the `brainstorm` skill

**Files:**
- Modify: `skills/brainstorm/SKILL.md`

- [ ] **Step 1: Replace steps 6–8 with one step, renumber step 9**

Use the Edit tool. old_string:

```
6. **Detect codex-worthy elements**:

   During and after brainstorming, watch for:
   - **New characters** mentioned (names, roles, traits)
   - **New locations** developed (places, settings)
   - **Worldbuilding** details (rules, systems, organizations)
   - **Timeline events** (backstory, history)
   - **Lore** (myths, legends, world history)

7. **Inline codex creation**:

   If user says during brainstorm:
   - "Add to codex"
   - "Save this to codex"
   - "Put this in the codex"

   Immediately:
   - Identify what to add (from recent discussion)
   - Determine type (character/location/etc.)
   - Create entry
   - Continue brainstorming

8. **End-of-session codex review**:

   After brainstorm session ends, before saving:

   ```
   Session complete!

   I noticed we developed:
   👤 Devika Menon (character - red herring suspect)
   📍 Forbidden Vault near Kings Valley (location)
   🌍 "The Order" - secret organization (worldbuilding)

   Add to codex?
   [Select: all / pick individually / skip / later]
   ```

9. **Actionable output**:
```

new_string:

```
6. **Codex elements** — two triggers:

   - **Inline** — if the user says "add to codex" / "save this to codex"
     mid-session, act immediately: identify what to add from the recent
     discussion, create the entry, and continue brainstorming.
   - **End of session** — before saving the brainstorm, surface any
     codex-worthy elements developed during the discussion.

   For detection criteria and the add/skip/later flow, follow the codex
   skill's "Detecting Codex Elements from Content" workflow.

7. **Actionable output**:
```

- [ ] **Step 2: Delete the "Codex Integration" section**

Use the Edit tool. old_string (note the leading blank line):

```

## Codex Integration

- Pull from codex automatically for relevant characters/locations
- Detect and offer to save new elements (inline or end-of-session)
- Link brainstorm sessions to codex entries
- Link to related scenes or previous brainstorm sessions
```

new_string: empty (delete the block entirely).

- [ ] **Step 3: Verify**

Run: `grep -c 'Codex Integration' skills/brainstorm/SKILL.md`
Expected: `0`.

Run: `grep -c 'Detecting Codex Elements from Content' skills/brainstorm/SKILL.md`
Expected: `1`.

Run: `grep -nE '^[0-9]+\. ' skills/brainstorm/SKILL.md`
Expected: steps numbered 1–7 with no gap or duplicate (step 6 is "Codex
elements", step 7 is "Actionable output").

Run: `tail -1 skills/brainstorm/SKILL.md`
Expected: the last line of the "Brainstorming Philosophy" section
(`- Embrace: "What if...", "The character might...", "This could go several ways..."`).

- [ ] **Step 4: Commit**

```bash
git add skills/brainstorm/SKILL.md
git commit -m "Slim brainstorm: reference codex detection workflow"
```

---

## Task 4: Slim the `edit-scene` skill

**Files:**
- Modify: `skills/edit-scene/SKILL.md`

- [ ] **Step 1: Replace step 9 with a one-liner**

Use the Edit tool. old_string:

```
9. **Cycle integration**:

   If edit adds new element (character, location, skill):
   ```
   Detected in edit:
   👤 New character: Dr. Chen
   Add to codex? [y/n/later]
   ```
```

new_string:

```
9. **Detect codex elements**:

   If the edit introduces a new character, location, or skill, offer to add
   it — follow the codex skill's "Detecting Codex Elements from Content"
   workflow.
```

- [ ] **Step 2: Verify**

Run: `grep -c 'Cycle integration' skills/edit-scene/SKILL.md`
Expected: `0`.

Run: `grep -c 'Detecting Codex Elements from Content' skills/edit-scene/SKILL.md`
Expected: `1`.

Run: `grep -nE '^[0-9]+\. ' skills/edit-scene/SKILL.md`
Expected: the Task steps are still numbered in sequence (step 9 present, no
duplicate numbers).

- [ ] **Step 3: Commit**

```bash
git add skills/edit-scene/SKILL.md
git commit -m "Slim edit-scene: reference codex detection workflow"
```

---

## Task 5: Update CHANGELOG and validate

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Add a CHANGELOG entry**

The `## [Unreleased]` section has a `### Changed` block whose first line is
`- **Complete documentation rewrite for v2.0.0 skills-based system**`. Use the
Edit tool to add a new bullet immediately before it. old_string:

```
### Changed
- **Complete documentation rewrite for v2.0.0 skills-based system**
```

new_string:

```
### Changed
- **Codex-detection workflow deduplicated** — the logic for detecting
  codex-worthy elements (characters, locations, worldbuilding, skills) and
  offering to save them now lives only in the `codex` skill, as the
  "Detecting Codex Elements from Content" section. `new-scene`, `brainstorm`,
  and `edit-scene` cross-reference it instead of each carrying their own copy;
  `new-scene` drops from ~310 to ~135 lines.
- **Complete documentation rewrite for v2.0.0 skills-based system**
```

- [ ] **Step 2: Verify the whole refactor**

Run: `for f in codex new-scene brainstorm edit-scene; do echo -n "$f: "; grep -c 'Detecting Codex Elements from Content' skills/$f/SKILL.md; done`
Expected: `codex: 2`, `new-scene: 1`, `brainstorm: 1`, `edit-scene: 1`.

Run: `grep -rl '✨ New elements detected' skills/*/SKILL.md`
Expected: only `skills/codex/SKILL.md` (the detailed offer format lives in one
place).

Run: `claude plugin validate .`
Expected: validation passes (a pre-existing `marketplace.json` version warning
is acceptable and out of scope).

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "Update CHANGELOG for codex-detection deduplication"
```

---

## Self-Review Notes

- **Spec coverage:** Task 1 creates the canonical section in `codex` (spec
  "Canonical home"); Tasks 2–4 slim `new-scene`, `brainstorm`, `edit-scene`
  (spec "Caller changes"); Task 5 covers CHANGELOG and the spec's "Testing"
  greps. All success criteria map to a verification step.
- **Section name consistency:** every task uses the exact string
  "Detecting Codex Elements from Content".
- **Out of scope (untouched):** skill frontmatter/descriptions, the `cycle`
  skill, the Character/Location entry templates.
