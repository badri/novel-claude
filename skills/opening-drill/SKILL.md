---
name: opening-drill
description: Use when the user wants Dean Wesley Smith-style feedback on the opening of a scene or chapter — five-senses grounding in the first 100 words, character-anchoring through opinion, the 400–500-word depth-before-action rule. Observational only; names what the opening is doing, never rewrites. Trigger on "opening drill", "check my opening", "is my opening grounded", "five senses check", "drill the opening of scene N", "Dean over my shoulder on the opening".
---

# Opening Drill

Narrow drill: feedback on the opening of a scene or chapter. Openings are one of Dean's four named practice areas — they earn their own drill.

## Philosophy

A drill, not a rewrite. Dean's openings rules are mechanical enough to check: all five senses inside the first 100 words, filtered through the character; depth (opinion + emotion + sensory) before action or dialogue; 400–500 words of grounding before anything explodes. These are checkable patterns. The fix is not Claude inserting "the smell of wet asphalt" into the writer's opening — it's the writer noticing they didn't reach for smell, and writing differently next time.

The opening sets the lake's depth. Everything after rides on it.

## Hard rules

1. **Observation only.** Quote what's there, name what's missing. No proposed sentences.
2. **Inventory, not invention.** "Sight: present. Sound: present. Smell: absent. Taste: absent. Touch: present." Not "you could add the smell of coffee."
3. **Anchored in the POV character.** A "sound" that's narrated by the author doesn't count. Senses must come through the character.
4. **Self-retire** when the writer says they spotted everything before reading the feedback.
5. **Never auto-fire.** Only invoked.

## Task

1. **Identify the scene/chapter opening**:
   - Default: first 500 words of the named scene
   - Or any opening the user names (chapter, scene, post-whitespace re-entry)
2. **Read** those first 500 words specifically. (Read more for context, but the drill operates on the opening.)
3. **Run the four opening checks** (below).
4. **Produce the report** with active/absent split + pattern + footer.
5. **Save** to `notes/opening-drills/drill-YYYYMMDD-HHMM-scene-NNN.md` unless told not to.

## The four opening checks

### 1. Five senses in the first 100 words (filtered through character)
Tally each sense:
- **Sight** — what the character sees, with their opinion
- **Sound** — what they hear (or notably don't)
- **Smell** — what's in the air
- **Taste** — even a residual taste from earlier (warm soda, cigarette, salt)
- **Touch** — temperature, fabric, pressure, weight

Senses must be character-filtered. "There were dishes clattering in the kitchen" is narration. "The clatter of dishes from the kitchen pulled her back to her mother's house" is sense-through-character.

### 2. Depth before action / dialogue
Per Dean: action openings and dialogue openings fail because the reader hasn't connected to the character yet. **400–500 words of grounding** (opinion + emotion + sensory) is the floor before action or dialogue starts doing the work.

Check: does action or dialogue begin before the 400-word mark? Flag if yes. The opening may still work, but the writer should know the rule they're working against.

### 3. Anchoring at scene re-entry
If this isn't a scene 1 opening but a post-whitespace re-entry: does the first paragraph re-anchor the reader in place + character + sense + opinion? Or does it pick up assuming the reader remembers everything?

Per Dean: every re-entry is a re-anchoring opportunity. Skipping it surfaces the reader.

### 4. Likable character at depth (if scene-1 opening)
For chapter / scene 1 of a novel or short:
- Is the POV character at depth (8+ on Dean's 1–10 lake scale)?
- Is the character someone the reader would invite into their living room for a few hours?
- Whining vs. struggling — flag self-pity that crosses into whining.

This check only applies to scene-1 openings. Skip for mid-novel scenes.

## Output format

```markdown
# Opening Drill — Scene NNN
Date: YYYY-MM-DD HH:MM
POV: [character]
First 100 words: [show the actual first 100 words]

## Five senses inventory (first 100 words)

- ✅ Sight — "[exact line]" (character-filtered)
- ✅ Touch — "[exact line]" (character-filtered)
- ⚠️ Sound — present but author-narrated, not through [character]. Line: "[quote]"
- ❌ Smell — absent
- ❌ Taste — absent

## Depth before action

[Action / dialogue begins at word N.]
[If before 400: "Action starts at word [N]. Dean's rule is 400–500 words of depth first. Worth knowing whether you broke this on purpose or by reflex."]
[If after: "Action starts at word [N]. Within range."]

## Re-anchoring (if mid-novel)

[Quote first sentence. Note whether it re-anchors place + character + sense + opinion, or assumes reader memory.]

## Likable character (if scene-1)

[Observation on depth level (1–10 estimate), and whether the character has the "would-I-invite-them-into-my-living-room" quality. Flag whining if present.]

## Pattern

[1–2 sentences. E.g., "Strong on visual + tactile, weak on smell/taste — that's a common pattern for SRE-minded characters whose attention defaults to infrastructure. Forcing one olfactory or gustatory detail per opening builds the muscle."]

## Footer

Openings are practice area #1 in Dean's curriculum. This drill is for muscle-building, not for fixing this opening. The next opening you write is the practice.

If most of the senses you missed felt obvious as you read the inventory: the rule is taking. Stop running this drill until an opening feels off.
```

## What this drill is NOT

- ❌ Do not propose specific sensory details to add.
- ❌ Do not rewrite the opening.
- ❌ Do not flag missing senses past the first 100 words. The drill is about the opening.
- ❌ Do not score or grade.

## Source grounding

- `january-writing-into-the-dark-online-workshop` (the five-senses rule)
- `practice` workshop (openings as practice area #1; the 100-word/500-word reinforcement cycle)
- `classic-point-of-view` week 2 (depth before action, likable characters, lake metaphor)
- `january-depth-in-writing` (depth through opinion + sensory + emotion)
