---
name: depth-drill
description: Use when the user wants Dean Wesley Smith-style depth feedback on a scene they've written — observations on witness syndrome, opinion-tinting, sensory grounding, fake details, and character-specific perception. A learning drill, not a rewrite. Trigger on "depth drill", "depth feedback", "depth check", "is this in depth", "check depth on scene N", "Dean over my shoulder", "what's my depth like", "run depth on this scene".
---

# Depth Drill

Give Dean-over-the-shoulder feedback on depth in a scene the writer has already written. The output **teaches a pattern**; it never rewrites the prose.

## Philosophy — read this first

This is a **drill**, not an audit. The distinction matters enormously and the entire skill collapses if it gets blurred.

- **An audit** scans prose, finds "problems," and proposes replacement text. The writer adopts the suggestions, prose sands toward grammatical correctness, voice dies. This is the critical-voice trap Dean Wesley Smith spends entire workshops fighting. **Do not do this.**
- **A drill** scans prose, names what it's *doing* with concrete examples, and shows where depth IS present alongside where it ISN'T — so the writer learns to see the pattern. The writer's *next* scene is the practice. This scene is left alone.

The frame is Dean standing over the writer's shoulder. He points at lines. He says "notice this — Devi observes the cable trays sagging; that's her eye, her opinion. Now look here — 'a small office' — that's you, not her." Then he steps back. He doesn't take the keyboard.

**The lesson is for the next chapter, not this one.**

## Hard rules

1. **Observation only. Never propose replacement text.** It is forbidden to write a single sentence the writer should insert into their prose. "Change line 4 to..." is banned. "Notice that line 4 doesn't pass through Devi" is correct.
2. **Name examples from the scene.** Quote the exact line. Cite paragraph or line number. Generic feedback ("your depth needs work") is worse than no feedback.
3. **Show contrast.** For every check, surface at least one place where the technique IS active in the scene, alongside one place where it isn't. The writer learns from the comparison, not from a list of misses.
4. **End with a self-retirement signal.** If the feedback feels obvious to the writer, the lesson is internalized — tell them so and recommend they stop running the drill until the next time it doesn't.
5. **Never auto-fire.** This skill is only invoked when the writer asks. It does not run as part of `new-scene`, `edit-scene`, `session-end`, or any other workflow.

## Task

1. **Identify the scene**:
   - Ask which scene number, or
   - "current/latest scene" → most recently modified scene in `scenes/`, or
   - User names the scene directly ("depth drill on scene 12")

2. **Read the scene**:
   - Load `scenes/scene-XXX.md`
   - Note the POV character (from scene header, or from the prose itself)
   - Note any relevant codex entries about that character (profession, history, current emotional state) — these inform what witness-syndrome details that character would notice

3. **Run the six depth checks** (see below). For each, identify both:
   - **Active**: at least one line where the technique IS working
   - **Absent**: at least one line where it ISN'T

4. **Produce the observation report** (format below). No replacement text. No "you should change..." Quote lines exactly.

5. **End with the pattern + self-retirement footer**.

6. **Save the drill** to `notes/depth-drills/drill-YYYYMMDD-HHMM-scene-NNN.md`. Unless the user says "don't save". The history lets the writer see internalization over time.

## The six checks (grounded in january-depth + automatic-depth)

For each check, the drill names **what's happening on the page** — not what should be there instead.

### 1. Witness syndrome
Does the POV character notice things only *this character* would notice — given their profession, history, current state? Or are the observations generic (anyone could've made them)?

- **Cue for "active"**: a noticed detail that implies the character's life before page one. An SRE notices network jacks; a chef notices smells; a grieving person notices loss-shaped things.
- **Cue for "absent"**: a noticed detail that any narrator could have observed. "A small office." "A long hallway."

### 2. Opinion tinting
Does each sensory detail come with the character's *opinion* attached? Opinions imply history. Unopinion'd description is generic.

- **Cue for "active"**: a detail + a character-specific judgment about it. *"The cable trays sagged where someone had stacked too many bundles"* — observation + opinion about competence.
- **Cue for "absent"**: detail without tint. *"The cable trays were full."*

### 3. Fake details
Placeholder nouns — barn, room, office, car, building — that the reader fills in with their own image. Specificity puts the writer back in control.

- **Quote the placeholder words** found in the scene. Don't propose replacements. Let the writer feel what their own character would notice.
- Frame: "Reader fills in their own [word] here. Ten readers, ten different [word]s."

### 4. Five senses (with re-anchoring)
Per the practice workshop and the depth foundation: all five senses should appear inside the first ~100 words of a scene, filtered through the character. Reinforced every ~500 words.

- Tally which senses are present in the opening 100 words. Which are missing.
- Note any post-whitespace re-entry that doesn't re-anchor (no sense, no opinion).

### 5. Setting through character (not narration)
Is setting filtered through the character's selective attention — what *this* character notices in *this* state — or is it author-narrated description from outside?

- **Cue for "active"**: setting detail that only matters because the character cares about it.
- **Cue for "absent"**: a paragraph that reads like a real-estate listing of the room.

### 6. Wilhelm's Law (optional — only flag if obvious)
At a major decision point, did the character take the first option that came to mind (low-hanging fruit), or one a reader wouldn't have predicted?

- Only call this out if you can name the decision point and the obvious-first-choice that was taken. Don't speculate broadly.
- Do not propose alternatives. Just name the moment.

## Output format

```markdown
# Depth Drill — Scene NNN
Date: YYYY-MM-DD HH:MM
POV: [character name]
Length: [word count]

## What's working

**Witness syndrome** — ¶[N], line "[exact quote]": [why this is character-specific]

**Opinion tinting** — ¶[N], line "[exact quote]": [the character's opinion + what it implies about their history]

[...other active checks with quotes...]

## What's surface-level

**Witness syndrome absent** — ¶[N], line "[exact quote]": observation belongs to no one in particular. Anyone could have noticed this. What would [POV character] specifically notice here?

**Fake details** — ¶[N]: "[placeholder noun]", ¶[N]: "[placeholder noun]". Reader fills in their own; control is lost.

**Opinion missing** — ¶[N], line "[exact quote]": detail without the character's tint. What does [POV character] think when they see/hear/feel this?

[...other absent checks with quotes...]

## The pattern

[1–3 sentence observation about the through-line: where depth turns on for this character and where it turns off. E.g., "Depth is active when Devi observes physical infrastructure (her professional domain) and turns off when she observes people. That's the pattern worth carrying into scene 13."]

## Footer

The point of this drill is to see the pattern, not to fix this scene. Scene NNN is finished prose — leave it alone. The lesson is for the next chapter you write.

If this feedback felt obvious — if you already saw most of these before reading them — the lesson is internalized. Stop running depth-drill until a chapter genuinely doesn't feel right. The drill is a tool to retire, not a tool to depend on.
```

## What this drill is NOT

Explicit list — Claude must refuse these even if asked:

- ❌ **Do not propose replacement sentences.** Even if the writer says "give me a better line," redirect: "the drill is for seeing the pattern. Try the rewrite yourself; if you want me to edit the scene, use the `edit-scene` skill instead."
- ❌ **Do not produce a "fixed version" of the scene.** That's `edit-scene`, not this.
- ❌ **Do not score the scene.** No "depth: 6/10". No grades. Observation, not evaluation.
- ❌ **Do not generalize.** "Your prose lacks depth" is useless. Quote a specific line and say what it's doing.
- ❌ **Do not run on a scene the writer is still actively drafting.** Drill is for finished scenes, not in-progress prose. If the writer asks mid-draft, suggest finishing the scene first.
- ❌ **Do not auto-suggest follow-up drills.** No "want me to also run a pacing drill?" The writer asks for what they want.

## Relation to other skills

- **`edit-scene`** is for changing prose. Depth-drill is for learning to see. The two are mutually exclusive — never offered together.
- **`craft-reference`** (when it exists) is for recall of Dean's depth material on request. Depth-drill is the *application* of those principles to the writer's own prose, for learning.
- **`new-scene`** writes new scenes. Depth-drill is what the writer might run *occasionally* after a scene, when they want to check what their depth instinct is doing. Not after every scene.

## Source grounding

Concepts drawn from:
- `january-depth-in-writing` (witness syndrome, fake details, opinion-tinting, five senses, setting through character, Wilhelm's Law)
- `48-pop-up-how-to-create-automatic-depth` (sense overwhelm and removal, static setting)
- `march-advanced-depth` (lake metaphor, character voice through opinion) — reserved for v2 of this drill once the writer has worked through that material

If the writer has internalized the foundational checks and wants advanced depth feedback, that's a different version of this drill (`depth-drill-advanced`), not yet built.
