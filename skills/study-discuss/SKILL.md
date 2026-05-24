---
name: study-discuss
description: Use when the user wants to discuss a craft, business, or mindset workshop they're studying — pulls the distilled material into a structured conversation. Designed for periodic course-correction on business-of-publishing and writer-mindset topics that don't belong in writing-time tooling. Trigger on "discuss [topic]", "let's talk about [Dean's workshop X]", "study [topic]", "course correct on [topic]", "what does Dean say about [topic]", "I want to think through [topic]".
---

# Study Discuss

Conversational skill for working through Dean Wesley Smith / WMG (or any) workshop material — outside the writing flow, on purpose. This is the home for buckets the writer deliberately *doesn't* want as silent drilling skills: business of publishing, writer mindset / productivity, study & practice methodology.

## Philosophy

Some Dean material is for *application* (depth, openings, cliffhangers — the drills). Some is for *thinking about your career and your relationship to the work*. The second kind is wrong-shaped as auto-firing tools; it belongs in conversation. This skill makes those conversations easy to start and easy to ground in source material.

Course-correction happens here. Not in a heads-up notification while drafting.

## What this skill covers

By design, two buckets:

- **Business of publishing** — Magic Bakery, Heinlein's Rules, covers, selling short fiction, series strategies, indie distribution, market positioning.
- **Mindset / productivity** — Killing critical voice, carving out time, prolific writing, study methodology, pulp speed, attitude in writing, stuck-now-what.

It can also be used for craft topics if the writer just wants to *discuss* (not drill) — e.g., "let's talk about endings" before they've written one, or "what's Dean's argument against rewriting" when curiosity strikes.

## Configuration

Default curriculum root: `~/course-distiller/`. Override by passing a path explicitly: "discuss heinlein's rules from /some/other/path".

If the default path doesn't exist or doesn't contain the requested course, ask the user where the material is and remember the answer for the session.

## Task

1. **Identify the topic.** Either:
   - User names a specific course folder ("discuss july-heinlein-s-rules")
   - User names a topic and you pick the closest match from the curriculum ("discuss productivity" → `productivity/book.md` or `february-reaching-pulp-speed/book.md`)
   - User just says "let's discuss" — ask what topic, then offer 3–4 candidates from the bucket they care about

2. **Locate the source file.**
   - Look in `~/course-distiller/<folder>/book.md` (or wherever the user has pointed)
   - If multiple courses fit, list them and let the user pick
   - If none exist, ask where the material lives

3. **Load the relevant sections.** Don't dump the whole book.md into the conversation. Read the table of contents (section headers), pick the sections most relevant to the user's question, read those.

4. **Run the discussion.** Three modes — ask which (or infer):

   **a. Walkthrough** — "explain this workshop to me." Summarize the key ideas in 4–8 paragraphs, ground each in specific quotes/examples from the source, and end with 2–3 questions for the writer to react to. No advice; this is for absorption.

   **b. Problem-solving** — "I'm stuck on X, what does Dean say?" Pull the specific guidance from the source. Quote the relevant passages. Apply to the writer's situation. The writer is using the material as counsel.

   **c. Course-correct** — "am I in alignment with this?" The writer describes how they're currently operating (re: time, mindset, business model). Compare against Dean's argument from the source. Name the gaps honestly. Reference [[course-correct-with-reasoning]] — explain *why*, not just what.

5. **Save the discussion** to `notes/study-discussions/discussion-YYYYMMDD-HHMM-[topic].md`. Includes:
   - Topic + source file
   - Mode (walkthrough / problem-solve / course-correct)
   - Key passages quoted
   - The writer's reactions / decisions
   - Any follow-ups the writer wants to track

6. **Surface periodically.** At session-start (when the project's session-start hook fires), check `notes/study-discussions/` for the most recent discussion's `Follow-ups` section. If anything is open and dated > 30 days ago, mention it once. Don't nag.

## Output format

Walkthrough example:

```markdown
# Discussion — Heinlein's Rules
Date: 2026-05-24
Source: ~/course-distiller/july-heinlein-s-rules/book.md
Mode: walkthrough

## The five rules (Dean's framing)

1. **You must write.** [Quote a key passage. 1–2 sentences of context.]
2. **You must finish what you write.** [Quote + context.]
3. **You must not rewrite** unless to editorial demand (Ellison corollary: only if you agree). [Quote + context.]
4. **You must mail what you write.** [Quote + context.]
5. **You must keep it on the market.** [Quote + context.]

## What Dean says underneath them

[2–3 paragraphs distilling Dean's core argument: that the rules force perpetual forward motion, that 90% of aspirants fail rule 2 or 3, that the rules together are the entire professional life.]

## Questions to react to

1. Which of these are you currently breaking?
2. Rule 3 (no rewriting) is the hardest for most writers — what's your relationship to it?
3. In indie publishing, "mail it" = "publish it". Are you publishing fast enough by Heinlein's standard?

## Follow-ups
[Empty until the writer adds them.]
```

Course-correct example:

```markdown
# Discussion — Magic Bakery, course-correct
Date: 2026-05-24
Source: ~/course-distiller/august-magic-bakery-workshop/book.md
Mode: course-correct

## Current state (writer's description)

[The writer's situation as they described it — e.g., "I have 16 published shorts, all on KDP, no licensing of subsidiary rights."]

## What Dean argues

[Quote the relevant Magic Bakery passages. Summarize Dean's licensing-not-selling framework.]

## The gap

[Honest naming of where the writer is vs. where Dean's argument places them. Reasoning, not just a verdict.]

## What course-correction would look like

[Concrete steps Dean's argument implies — not as prescriptions, as logical implications. The writer decides what to act on.]

## Follow-ups

- [User-added.]
```

## Hard rules

1. **Always ground in source.** Every claim attributed to Dean / WMG must come from a quoted passage in the actual material. No paraphrase-as-fact.
2. **Course-correction must explain reasoning.** Per [[course-correct-with-reasoning]] — "Dean says X, here's why he says it, here's how it applies to you, your call." Never just "Dean disagrees with you."
3. **No drilling.** This skill never scans the writer's prose. It only discusses their craft / business / mindset.
4. **Discussion saves, doesn't decide.** The skill produces a record of the conversation. The writer chooses what (if anything) to act on. Don't open beads, don't modify project.json, don't auto-update plans.
5. **Periodic check-ins are gentle.** Surfacing old follow-ups happens at most once per session-start, with a single line. The writer ignores or engages — never both nagged.

## What this skill is NOT

- ❌ Not a drill. Doesn't scan finished scenes. Use the `*-drill` skills for that.
- ❌ Not a coach. The skill quotes Dean's reasoning; the writer applies it. Claude doesn't issue prescriptions.
- ❌ Not a research assistant for non-curriculum material. If the writer wants to discuss something not in their distilled library, point them at the right course or ask them to add the source.
- ❌ Not interruptive. Never auto-fires mid-drafting.

## Relation to other skills

- **Drill skills** (`depth-drill`, `opening-drill`, etc.) — application of craft to the page. Different purpose.
- **`brainstorm`** — story-level problem-solving. Use when the question is "what happens in scene 13?" not "what does Dean say about productivity?"
- **`session-start`** — surfaces old discussion follow-ups (when implemented).

## Source grounding

The skill is source-agnostic by design. Configured default is `~/course-distiller/`. Workshops typically referenced (Dean / WMG):
- Business: `august-magic-bakery-workshop`, `july-heinlein-s-rules`, `insider-s-guide-to-selling-short-fiction`, `february-covers-101`, series/stand-alone/short-story strategies
- Mindset: `november-killing-critical-voice`, `productivity`, `speed`, `prolific`, `practice`, `february-reaching-pulp-speed`, `how-to-study-classic-workshop`, `attitude-in-writing-fiction`, `read-like-a-writer`, `15-pop-up-you-re-stuck-now-what`, `carving-out-time-for-your-writing`, `starting-or-restarting-your-writing`

Other authors / sources can be slotted in by pointing the skill at their book.md files.
