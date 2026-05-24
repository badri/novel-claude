---
name: cliffhanger-cut-drill
description: Use when the user wants Dean Wesley Smith-style feedback on a scene's ending — Dent-zone length (800–1,500 words), the kicker line, and the "petered-out tail" check (writing past the natural cut point). Observational only; names where the energy peaks and where the prose drains past it. Trigger on "cliffhanger drill", "cut drill", "where should I end this scene", "did I write past the cliffhanger", "Dent check", "scene ending feedback".
---

# Cliffhanger Cut Drill

Narrow drill: scan a scene's ending for the natural cut point. Per Dean: *"Notice when you have written past the cliffhanger. The energy will dip; the prose will peter out. Delete the two or three sentences after the natural cut."* That's the procedure.

## Philosophy

A drill, not an edit. The skill identifies where the scene's energy peaks and where it drains. The writer decides whether to cut. Claude does not delete sentences from the scene file.

The rule from the cliffhangers workshop is also explicit: *"Many writers instinctively continue writing beyond their best cut point. The cliffhanger line appears in the draft, but there's another paragraph, or half a page, written past it."* This drill catches that. Once.

## Hard rules

1. **Identify, don't delete.** Claude points at the kicker line. The writer decides whether to cut.
2. **Show the petered tail in full** so the writer can feel the drain themselves. Don't summarize "the last 3 sentences are weaker." Quote them.
3. **Word-count fact, not judgment.** "Scene is 2,134 words. Dent zone is 800–1,500." Not "your scene is too long."
4. **Self-retire** when the writer says "I felt the petered tail before you flagged it."
5. **Never auto-fire.**

## Task

1. **Identify the scene** (number, "current", or named).
2. **Read the scene**. Especially the last 30% — that's where the cut likely lives.
3. **Run the three cliffhanger checks** (below).
4. **Produce the report** with quoted kicker line + petered tail + Dent context.
5. **Save** to `notes/cliffhanger-drills/drill-YYYYMMDD-HHMM-scene-NNN.md` unless told not to.

## The three checks

### 1. Dent zone (word count)
Lester Dent: scenes/chapters in 800–1,500 word segments. Most modern commercial bestsellers run in this zone. Outside it isn't wrong, but it's worth knowing.

- Report the scene's word count.
- Note where it sits relative to the Dent zone.
- No prescription — the writer might be running a literary or slow-burn scene that needs more room.

### 2. The kicker line
Per the cliffhangers workshop: "the best chapter endings often have a single line that lands with force — a line that crystallizes the emotional moment and gives the reader no choice but to turn the page."

- Scan the last ~300 words for the strongest line.
- Quote it.
- Name what kind of cliffhanger it is (physical, character/emotional, plot, structural, thematic) per the workshop's five categories.
- If the line lands more than 2–3 sentences before the actual scene end, that's a petered-out tail signal — see check 3.

### 3. The petered-out tail
If the kicker line isn't the last line of the scene: quote everything that comes after it. Show the drain.

Per Dean: the prose physically loses energy past the cut. The writer can usually feel it once it's pointed at.

- Quote the kicker line.
- Quote the sentences after it, in full.
- Note: "Lines after the kicker — Dean's call would be to end at the kicker. Your call whether to keep them."

## Output format

```markdown
# Cliffhanger Cut Drill — Scene NNN
Date: YYYY-MM-DD HH:MM
POV: [character]
Word count: NNNN

## Dent zone

- Scene length: NNNN words
- Dent zone: 800–1,500
- [Within / above / below]. [One-line context — e.g., "above, but the scene is doing two threads of work which earns the extra room."]

## Kicker line

**¶[N], last line of strongest beat:** "[exact quote]"

This is a [physical / character / emotional / plot / structural / thematic] cliffhanger. [One sentence on why it works — what reader-pull it creates.]

## Petered-out tail (if applicable)

Lines after the kicker:

> "[quote sentence 1 in full]"
>
> "[quote sentence 2 in full]"
>
> "[quote sentence N in full]"

[NNN words past the kicker. Per Dean: the energy is in the kicker; what follows drains it. Your call whether to cut, but the drill is naming where the prose loses force.]

## If no petered tail

The kicker is the last line. The cut is clean.

## Pattern

[1–2 sentences. E.g., "Strong emotional kicker, but you wrote one paragraph past it explaining how Devi felt about it. The unwritten reaction is louder than the explained one." Or: "Clean cut. The discipline is taking."]

## Footer

This drill names where the energy peaks. You cut or don't. Once you've felt the petered tail in your own prose three or four times, you'll catch it during the next draft without needing the drill.
```

## What this drill is NOT

- ❌ Do not delete the petered-out tail yourself. Even if asked. Tell the user to use `edit-scene` for changes.
- ❌ Do not propose a new kicker line.
- ❌ Do not run on scenes mid-draft. Drill is for completed scenes.
- ❌ Do not flag word-count drift as a problem. The Dent zone is a reference, not a rule.

## Relation to other skills

- **`edit-scene`** — if the writer wants to actually delete the petered tail, that's the skill.
- **`opening-drill`** — for the other end of the scene.
- **`depth-drill`** — for the body of the scene.

## Source grounding

- `classic-cliffhangers-workshop` (five categories of cliffhanger, kicker line, "writing past the cliffhanger" failure mode)
- `practice` workshop (Lester Dent formula, 800–1,500 word segments, the "delete the two or three sentences after the natural cut" rule)
