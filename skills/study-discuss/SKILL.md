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

**Curriculum root** (where the source material lives): default `~/course-distiller/`. Override per-invocation: "discuss heinlein's rules from /some/other/path".

**Writing root** (where discussions are saved): default `~/writing/`. These conversations are cross-project — about the writer's career, mindset, and craft thinking in general — not tied to any single book. Storing them inside one project's `notes/` would orphan them when the writer moves to the next project.

Discussions save to `<writing-root>/study-discussions/discussion-YYYYMMDD-HHMM-[topic].md`. The skill creates this directory if it doesn't exist.

**Project-specific exception:** if the discussion is clearly about a specific project (writer says "for this book, let's discuss series strategies" while in `~/writing/the-time-thief/`), save under that project's `notes/study-discussions/` instead and note the project in the file header. Default to cross-project unless the project tie is explicit.

If the curriculum root doesn't exist or doesn't contain the requested course, ask the user where the material is and remember the answer for the session.

## Topic → workshop mapping

When the user names a topic without a specific workshop folder, use this mapping to pick the right source. (This is the "do you have instructions to point to relevant Dean workshops" answer — yes, here.)

### Business of publishing
| Topic / question | Workshop folder |
|---|---|
| Licensing rights / multiple uses of one idea / "magic bakery" | `august-magic-bakery-workshop` |
| Writer's career rules / "should I rewrite?" / forward motion as profession | `july-heinlein-s-rules` |
| Selling individual short stories / submission strategy | `insider-s-guide-to-selling-short-fiction` |
| Book covers / cover design | `february-covers-101` |
| Selling fiction in general / commercial mindset | `10-pop-up-selling-fun-for-fiction-writers` |
| Living on short fiction income | `14-pop-up-making-a-living-with-short-fiction` |
| Series strategy / planning a series | `55-pop-up-series-strategies` + `writing-series-classic-workshop` |
| Standalone novel strategy | `56-pop-up-stand-alone-novel-strategies` |
| Short-story career strategy (collections, magazines) | `57-pop-up-short-stories-strategies` |

### Mindset / productivity
| Topic / question | Workshop folder |
|---|---|
| Critical voice (the internal editor killing your work) | `november-killing-critical-voice` |
| Why am I stuck / story problems / unsticking | `15-pop-up-you-re-stuck-now-what` |
| Productivity / writing more | `productivity` (broad) or `prolific` (more on output) |
| Writing speed / pulp speed / fast first drafts | `speed`, `february-reaching-pulp-speed`, `42-pop-up-learn-from-the-pulp-writers` |
| Carving out writing time / scheduling around life | `carving-out-time-for-your-writing` |
| Starting fresh / returning after a break | `starting-or-restarting-your-writing` |
| Practice methodology / how to actually study | `practice`, `how-to-study-classic-workshop`, `feb-study-and-practice` |
| Attitude / approach to the work | `attitude-in-writing-fiction` |
| Reading as a writer / studying published work | `read-like-a-writer` |
| Stamina across many books | `50-pop-up-stamina-and-strategies-to-write-a-lot` |
| Big-picture career thinking | `11-pop-up-thinking-big-for-fiction-writers` |
| The novel as journey / challenge framing | `the-great-novel-challenge` |
| Mid-draft mindset / "as you write" | `13-pop-up-as-you-write` |

### Craft (when the writer wants to *discuss*, not drill)
If the writer asks to discuss a craft topic rather than run a drill, pull from the same curriculum:
- Depth → `january-depth-in-writing`, `march-advanced-depth`, `plotting-with-depth-workshop`, `48-pop-up-how-to-create-automatic-depth`
- POV → `classic-point-of-view`
- Openings → `january-writing-into-the-dark-online-workshop` (the WITD primary)
- Cliffhangers → `classic-cliffhangers-workshop`
- Pacing → `classic-pacing-workshop`
- Endings → `classic-writing-endings`
- Voice → `character-voice-classic-workshop`, `classic-author-voice`, `attitude-in-writing-fiction`
- Character → `classic-character-development`, `classic-character-and-dialogue`
- Tags / dialogue mechanics → `classic-how-to-use-tags`
- Information flow → `classic-information-flow`
- Reader expectations → `reader-expectations-classic-workshop`
- Subplots | secondary plot lines → `secondary-plot-lines-classic-workshop`
- Suspense → `adding-suspense-classic-workshop`
- Research | grounding fiction in real material → `classic-research-in-fiction-writing`
- Novel structure → `classic-novel-structure`
- Editing your own work → `editing-your-own-work-classic-workshop`
- "Secrets" / catch-all craft → `classic-secrets-in-craft`

If a topic doesn't match anything in this mapping, ask the user — don't guess. Better to surface "I don't see a workshop for X; should we discuss without a source, or do you want to point me at one?"

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

5. **Save the discussion** to `<writing-root>/study-discussions/discussion-YYYYMMDD-HHMM-[topic].md` (default: `~/writing/study-discussions/`). Cross-project by default — see Configuration above for the project-specific exception. Includes:
   - Topic + source file
   - Mode (walkthrough / problem-solve / course-correct)
   - Key passages quoted
   - The writer's reactions / decisions
   - Any follow-ups the writer wants to track

6. **Surface periodically.** At session-start, the project's session-start hook could check `<writing-root>/study-discussions/` for the most recent discussion's `Follow-ups` section. If anything is open and dated > 30 days ago, mention it once. Don't nag. (Hook integration is a future enhancement; for now, the writer surfaces follow-ups by running `study-discuss` again on the same topic.)

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
