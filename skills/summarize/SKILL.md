---
name: summarize
description: Use when the user wants a reverse outline, summary of what they've written, beat sheet, or structure overview of their story. Trigger on: "summarize", "reverse outline", "what did I write", "outline what I have", "beat sheet", "show me the structure", "summarize scenes X to Y".
---

# Summarize / Reverse Outline

Generate a reverse outline of written scenes using a fast subagent.

## Task

1. **Determine scope** from user input:
   - Single scene: "summarize scene 3"
   - Range: "summarize scenes 1-8"
   - All scenes: "summarize everything" / "reverse outline"
   - Continuity check: "check continuity across scenes"

2. **Read the scene files** in scope.

3. **Dispatch Task tool with haiku model**:

   Use the Task tool to spawn a subagent with this prompt template:

   ```
   You are summarizing fiction scenes for a discovery writer creating a reverse outline.

   Task: [scene-summary | reverse-outline | continuity-check]

   Scenes to analyze:
   [scene content]

   For scene-summary: Return key events, character decisions, emotional beats, POV, timeline placement. 2-3 sentences per scene.

   For reverse-outline: Return a beat-by-beat breakdown — what actually happens in each scene, what it accomplishes structurally, any setup/payoff pairs. Numbered list.

   For continuity-check: Flag timeline inconsistencies, character detail contradictions, unresolved threads, and logic gaps. Be specific (scene numbers and exact details).

   Be concise. This is a working document, not a literary analysis.
   ```

   Use model: haiku (fast and cheap for summarization).

4. **Save output** to `summaries/`:
   - Single scene: `summaries/summary-scene-NNN.md`
   - Range/All: `summaries/reverse-outline-[date].md`
   - Continuity: `summaries/continuity-check-[date].md`

   Include header:
   ```
   # [Type] — [scope]
   Generated: [date]
   Scenes analyzed: [N]
   ```

5. **Confirm**: "Saved to summaries/[filename]"
