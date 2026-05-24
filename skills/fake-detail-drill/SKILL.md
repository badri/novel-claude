---
name: fake-detail-drill
description: Use when the user wants to scan a scene for placeholder nouns ("barn", "office", "car", "room") — the words that hand reader control over because every reader fills in their own image. Observational only — names the placeholders, never proposes replacements. Trigger on "fake detail drill", "fake details", "find placeholders", "kill fake details", "scan for vague nouns", "where am I being lazy with detail".
---

# Fake Detail Drill

Narrow drill: scan a finished scene for placeholder nouns and name them. The writer fills in the specifics. Claude does not.

## Philosophy

A drill, not a fix. Per Dean Wesley Smith's depth material: *the moment a reader supplies their own detail, the writer has lost control.* "Barn" means a different building to every reader on the planet. So does "office," "room," "car," "hallway," "building." The fix isn't a replacement the writer adopts — it's the writer's *own character* asking "what would I, specifically, notice here?"

If Claude proposes "a barn with red paint peeling from the eaves," the writer hasn't learned anything about their own character's eye. They've adopted Claude's eye. Wrong direction.

This skill names the placeholders. The writer answers them.

## Hard rules

1. **Quote the placeholder words. Do not propose substitutes.**
2. **No "consider replacing X with Y" suggestions.** That's `edit-scene`'s job.
3. **Frame the question, not the answer.** "Reader supplies their own [word]. What would [POV character] specifically notice?"
4. **Group by paragraph** for scanability.
5. **Self-retire** when the writer says "I already saw all of these before you flagged them."

## Task

1. **Identify the scene** (same as `depth-drill`):
   - Scene number, "current scene", or named directly
2. **Read the scene**. Note the POV character.
3. **Scan for placeholders** — common categories:
   - Generic buildings/rooms: barn, office, room, hall, building, house, store, restaurant, bar
   - Generic vehicles: car, truck, van, bike, plane, boat
   - Generic clothing: shirt, dress, coat, jacket, shoes, hat
   - Generic furniture: chair, table, desk, bed, couch
   - Generic landscape: tree, hill, field, road, path, river
   - Generic people-descriptors when they're the POV character's first sighting: a man, a woman, a kid, a stranger
4. **Use judgment** — a "barn" in a paragraph about Devi parking outside a barn is fake. A "barn" already grounded by three specific details two paragraphs earlier is fine; the placeholder already got filled in. **Don't flag fully grounded nouns.**
5. **Produce the placeholder report** (format below).
6. **Save** to `notes/fake-detail-drills/drill-YYYYMMDD-HHMM-scene-NNN.md` unless told not to.

## Output format

```markdown
# Fake Detail Drill — Scene NNN
Date: YYYY-MM-DD HH:MM
POV: [character]

## Placeholders found

**¶3, line "[exact quote containing the word]"**
- Placeholder: "[word]"
- Reader fills in their own [word]. What does [POV character] specifically notice about this one?

**¶7, line "[exact quote]"**
- Placeholders: "[word1]", "[word2]"
- Two readers, two different [word1]s. What does [POV character] notice here?

[...]

## Already grounded (no action needed)

**¶5, "[word]"** — fully grounded by sensory detail in ¶4. The reader's image is set.

## Pattern

[1–2 sentences. E.g., "Placeholders cluster around physical objects the POV character isn't engaged with — background detail. The objects [character] interacts with are specific. That's worth knowing about your own attention as a writer."]

## Footer

The drill names placeholders. You fill them in — through your character's eye, not through anyone else's. The point isn't to fix this scene's prose; it's to notice the reach for the first word that came to mind.

If most of these were obvious before you read them: lesson is taking. Stop running this drill until a scene genuinely feels fuzzy.
```

## What this drill is NOT

- ❌ Do not propose replacement words.
- ❌ Do not write substitute phrases ("a barn with...").
- ❌ Do not score the scene.
- ❌ Do not flag well-grounded nouns. A placeholder that's already been filled in by surrounding sensory detail is not fake.
- ❌ Do not run during drafting. Drill is for finished scenes.

## Relation to other skills

- **`depth-drill`** — runs the same check as one of six. Use that for the holistic view; use this when you want to drill *only* fake-detail muscle.
- **`edit-scene`** — for actually changing prose.

## Source grounding

- `january-depth-in-writing` (the "barn" example, fake details section)
- `march-advanced-depth` (when fake details are correct — e.g., Grisham summary openings; not enforced in this drill but noted)
