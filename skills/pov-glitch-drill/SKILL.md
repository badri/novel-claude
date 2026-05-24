---
name: pov-glitch-drill
description: Use when the user wants to scan a scene for viewpoint glitches — the moments where prose drops out of the character's head. Catches the three documented glitch patterns ("he thought" / italicized thoughts / author-described settings) plus information the POV character couldn't possibly know. Observational; never rewrites. Trigger on "pov drill", "glitch check", "viewpoint check", "find glitches", "where am I out of character's head", "scan for pov glitches".
---

# POV Glitch Drill

Narrow drill: scan a finished scene for viewpoint glitches. Per Dean Wesley Smith: glitches are "the deadliest mechanism in fiction" — every glitch surfaces the reader, and a surfaced reader can leave.

## Philosophy

A drill, not a rewrite. The skill names the exact sentence where the prose escaped the character's head. The writer learns to feel the escape; the drill becomes unnecessary.

This is one of the most concrete drills in the set because glitches are mechanical — they're not judgment calls. A sentence either passes through the POV character's perception or it doesn't.

## Hard rules

1. **Quote the glitch line exactly.** Generic "your POV slips" is useless.
2. **Name which of the four patterns it is** so the writer can recognize the shape.
3. **Don't propose a fixed version.** That's for the writer's next scene.
4. **Self-retire** when the writer says they spotted them all before reading the drill.
5. **Never auto-fire.**

## Task

1. **Identify the scene** (number, "current", or named).
2. **Read the scene**. Identify the POV character with certainty before scanning — most glitches are only glitches because the writer drifted from a specific person.
3. **Scan for the four glitch patterns** (below).
4. **Produce the report** with line-by-line quotes.
5. **Save** to `notes/pov-glitch-drills/drill-YYYYMMDD-HHMM-scene-NNN.md` unless told not to.

## The four glitch patterns

### 1. "He thought" / "she thought" / "he wondered"
The whole story is already inside the POV character's thoughts. Writing "he thought" or "she wondered" kicks the reader out of the head they were already in. It signals "this is a thought" — redundantly.

- Scan for: "he thought", "she thought", "he wondered", "she wondered", "he realized", "she felt that"
- Stage-four writers use these rarely on purpose. For most drafts, it's a glitch.

### 2. Italicized thoughts
Same problem: italicizing a thought signals "this is a thought," which is redundant — every word is already a thought.

- Scan for: italicized sentences/phrases in the middle of regular prose
- Distinguish from legitimate italics (book titles, song titles, foreign words, emphasis on a single word).

### 3. Author-described settings (the cardinal glitch)
Description with no character filter — author standing outside, listing furniture. Per Dean: *"There is a post and a table and a chandelier and a podium" is the writer typing, not the character living.*

- Scan paragraphs that describe setting. For each: does the description come through the POV character's specific perception + opinion, or is it a neutral inventory anyone could've narrated?
- The test: if five different characters could walk into this scene and the description would be identical, that's an author description.

### 4. Information the POV character couldn't know
The POV character can only relay what they perceive. If the prose tells the reader something the character doesn't see, hear, or have evidence for, the prose has jumped out of viewpoint.

- Examples: another character's internal state stated as fact ("she was furious") rather than perception ("her hands were white on the railing"); events happening in another room described directly; the POV character's own appearance described as if from outside ("his blue eyes narrowed").
- The infamous "mirror scene" where a character describes themselves in detail is the textbook case.

## Output format

```markdown
# POV Glitch Drill — Scene NNN
Date: YYYY-MM-DD HH:MM
POV: [character]

## Glitches found

**¶[N], line "[exact quote]"**
- Pattern: "he thought" / italicized thought / author-described setting / unknowable info
- [One-sentence note on why this is a glitch — what the character couldn't have perceived, or what the redundancy is doing.]

**¶[N], line "[exact quote]"**
- Pattern: [...]
- [...]

## Strong POV (where it's working)

**¶[N], line "[exact quote]"**
- Pattern: clear character-filtered perception, opinion intact.

[At least one example so the writer sees the contrast.]

## Pattern

[1–2 sentences. E.g., "Glitches cluster in setting-description paragraphs. Action and dialogue stay in viewpoint. The drift happens when you slow down to show the reader where they are — that's the muscle to build."]

## Footer

Glitches are mechanical — once you can feel one, you'll stop writing them. This drill helps you build the feel.

If most of these were already visible to you before reading the drill: lesson is taking. Retire until a scene genuinely doesn't sit right.
```

## What this drill is NOT

- ❌ Do not rewrite glitch lines.
- ❌ Do not flag legitimate uses (occasional italicized thought for a documented reason; stage-four "he thought" used deliberately).
- ❌ Do not run on a scene mid-draft.
- ❌ Do not score the scene by glitch count.

## Relation to other skills

- **`depth-drill`** — overlaps on author-described settings (covered there as one of six checks). Use `pov-glitch-drill` when you want a focused viewpoint pass; `depth-drill` for the holistic view.
- **`edit-scene`** — to actually change the glitch lines.

## Source grounding

- `classic-point-of-view` week 2 ("Three Common Glitch Patterns to Eliminate" — "he thought", italicized thoughts, author-described settings)
- `classic-point-of-view` week 1 ("Every word of every story is told through a character's point of view" — the foundation that makes the fourth pattern recognizable)
