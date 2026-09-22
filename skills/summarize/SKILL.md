---
name: summarize
description: Use when the user wants a reverse outline, summary of what they've written, beat sheet, or structure overview of their story. Trigger on: "summarize", "reverse outline", "what did I write", "outline what I have", "beat sheet", "show me the structure", "summarize scenes X to Y".
---

# Summarize / Reverse Outline

Produce a **deep** reverse outline on demand — and keep `ORDER.md`'s
lightweight one honest.

## Two reverse outlines, two jobs

| | `ORDER.md` | `summarize` |
|---|---|---|
| **Weight** | One sentence per scene | Beat-by-beat per scene |
| **Kept current by** | The writing itself — every `new-scene`, `reorder`, `edit-scene` | You, on demand |
| **Lives at** | Project root, next to the reading order | `summaries/` |
| **Used for** | Reading order + a fast "what is this scene" glance | Structural work, continuity, spotting setups and payoffs |

`ORDER.md` is **the** always-current one-line reverse outline. When this skill
runs, it reads `ORDER.md` for the reading order — so "scenes 1-8" means the
first eight **reading positions**, not `scene-001` through `scene-008`.

## Task

1. **Determine scope** from the user:
   - Single scene: "summarize scene 012" (a stable ID)
   - A reading range: "summarize the first eight" / "positions 1-8"
   - All placed scenes: "summarize everything" / "reverse outline"
   - Unplaced only: "summarize the drafts"
   - Continuity check: "check continuity across the manuscript"

   Resolve positions through `ORDER.md` and confirm which stable IDs you're
   covering before spending the run.

2. **Read `ORDER.md`** and the scene files in scope. Skip scenes under
   `## Cut` unless explicitly asked.

3. **Dispatch the subagent** (Task tool, haiku — cheap and fast for bulk
   summarization):

   ```
   You are summarizing fiction scenes for a discovery writer creating a reverse outline.

   Task: [scene-summary | reverse-outline | continuity-check]

   Scenes to analyze:
   [scene content, in reading order, each labelled with its stable ID]

   For scene-summary: return key events, character decisions, emotional beats,
   POV, timeline placement. 2-3 sentences per scene.

   For reverse-outline: a beat-by-beat breakdown — what actually happens in each
   scene, what it accomplishes structurally, any setup/payoff pairs. Say where
   scenes that share a moment overlap deliberately. Numbered list, reading order,
   each entry labelled [scene-NNN].

   For continuity-check: flag timeline inconsistencies, character detail
   contradictions, unresolved threads, and logic gaps. Be specific (stable IDs
   and exact details).

   Be concise. Working document, not literary analysis.
   ```

4. **Save the output**:
   - Single scene: `summaries/summary-scene-NNN.md`
   - Range/all: `summaries/reverse-outline-[date].md`
   - Continuity: `summaries/continuity-check-[date].md`

   Header:
   ```
   # [Type] — [scope]
   Generated: [date]
   Scenes analyzed: [N]
   Reading order: per ORDER.md
   ```

5. **Offer to refresh `ORDER.md`.** This is the part that keeps the
   lightweight outline from rotting:

   - Compare each scene's generated summary against its one-line entry in
     `ORDER.md`.
   - Where the line is stale, missing, or describes a scene the writing has
     moved on from, **propose the replacement line** — one sentence, present
     tense, the same shape as the existing ones.
   - Show the proposed diff and apply only on approval.
   - Where the generated summary disagrees with the line, say which one you
     think is right and why; the author decides.

   Do not rewrite `ORDER.md` wholesale — only the lines that need it.

6. **Confirm**: "Saved to `summaries/[filename]`", plus which `ORDER.md` lines
   changed (if any).
