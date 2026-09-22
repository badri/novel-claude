---
name: tic-audit
description: Use when the user wants the book-wide repetition count — phrases, tells, and openers that recur across scenes — or after any multi-scene edit pass. Trigger on "tic audit", "tic sweep", "repetition scan", "n-gram", "what am I overusing", "run the lint", "prose lint", "AI tells", "before I compile, check repetition".
---

# Tic audit

A phrase is invisible inside one scene and a machine tell across the book.
Drafting is scene-local; the tic is book-global. Nobody can see it at reading
scale, so a mechanical count over the whole corpus is the only thing that
finds it. **Finding the pattern is the machine's job. Judgment stays with the
author.**

Standing rule (writing root `CLAUDE.md`, *The Tic Audit*): run this **after
any multi-scene pass and before declaring a batch of new prose done**, and
report the findings even when nothing gets fixed. `compile` runs the count as
a report before assembling.

## Task

1. **Run the count** from the project root:

   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/utils/prose-lint.py --ngrams   # 3–5 word phrases, 10+ hits across 8+ scenes
   ${CLAUDE_PLUGIN_ROOT}/scripts/utils/prose-lint.py            # the regex tells: simile of manner, padding, said-bookisms, bowtie candidates
   ```
   (Under omp: `~/nc/scripts/utils/prose-lint.py`.) Both read `./scenes`,
   narration only — dialogue, metadata, Notes and annotation tags are
   excluded. `--min-hits` / `--min-scenes` widen the net; `--rule <name>`
   and `--scene <NNN>` give the triage queue.

2. **Report the list as-is**, worst first. Flag the **superlative-designation
   family** by name when it appears (*the one thing, the only thing, the
   whole of, there was nothing, more than anything*) — those feel like
   meaning and are the worst offenders. Add anything else mechanically
   countable that the author asked about: scene-opening moves (how many
   scenes open on weather, a room, waking), sentence openers, colour words,
   body-sensation frequency, scene lengths, POV distribution. A `grep -c`
   over `scenes/` answers most of these.

3. **Stop there unless asked.** The author decides which phrases are tics.
   The rules when they do ask for a sweep:
   - The tic is the **frequency**, never the phrase. Don't ban a good phrase.
   - Default ceiling **one per scene**, and it must be doing work — a payoff,
     a closer, a character's creed, a callback named in that scene's Notes.
   - **A scene's ending owns its words.** If an early paragraph spends the
     phrase the closer needs, the early one goes.
   - **Replacements are plainer, never cleverer.** No simile, no image, no
     new flourish. If no plain replacement exists, delete and let the fact
     stand.
   - **Dialogue is exempt.**

4. **Sweeping is `edit-scene` work.** Apply fixes scene by scene through
   that skill, and log each as a `**Tic sweep <date>:**` bullet in the
   scene's Notes — N fixed, M kept, and why the keeps earned it. Never
   search-and-replace across the corpus.

5. **Re-run the count** after a sweep and show the before/after for the
   families that were swept.
