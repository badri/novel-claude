# Chat with Your Story

Have a conversation about your story, characters, plot, or writing decisions with full project context.

## Task

1. **Load full context**:
   - Read project.json
   - Load recent scenes (last 3-5 or user-specified)
   - Load all summaries
   - Load all codex files
   - Load recent brainstorms

2. **Chat modes** (ask user or infer from question):

   **Story discussion**:
   - "What's happening with [character]?"
   - "Where is the story going?"
   - "What are the main conflicts?"
   - "How does [scene X] connect to [scene Y]?"

   **Character exploration**:
   - "What motivates [character]?"
   - "Why did [character] do [action]?"
   - "How has [character] changed?"
   - "What does [character] want?"

   **Plot analysis**:
   - "What are the active plot threads?"
   - "Is this plot point resolved?"
   - "What's the central conflict?"
   - "How do these subplots connect?"

   **Writing problems**:
   - "I'm stuck after scene X"
   - "This doesn't feel right"
   - "Does this make sense?"
   - "Is this character consistent?"

   **Continuity check**:
   - "Did I already establish [detail]?"
   - "When did [event] happen?"
   - "What color are [character's] eyes?"
   - "Have they been to [location] before?"

   **Thematic exploration**:
   - "What themes are emerging?"
   - "What is this story really about?"
   - "What questions am I asking?"

3. **Context-aware responses**:
   - Reference specific scenes by number
   - Quote from codex when relevant
   - Point to summaries for evidence
   - Cite brainstorm sessions
   - Maintain consistency with established facts

4. **Discovery writing philosophy**:
   - Help user discover the story, not dictate it
   - Ask questions that prompt insight
   - Explore possibilities without forcing outcomes
   - Trust the character's voice
   - Follow the emerging story logic

5. **Save chat sessions** (optional):

If the conversation is valuable, offer to save:

`notes/chat-[date]-[topic].md`:

```markdown
# Story Chat: [Topic]

Date: [timestamp]
Scenes Discussed: [numbers]

## Question/Discussion

[User's question or topic]

## Context Reviewed

- Scenes: [list]
- Characters: [list]
- Summaries: [which ones]

## Key Points

[Summary of insights, decisions, or discoveries]

## Action Items

- [ ] [Things to do based on discussion]

## Notes

[Additional thoughts to remember]
```

6. **Smart context loading**:
   - If question is about a character: load their codex entry and scenes
   - If about a specific scene: load that scene and adjacent ones
   - If about plot: load all summaries
   - If about setting: load location codex and relevant scenes

7. **Response style**:
   - Conversational but insightful
   - Reference specific moments from the story
   - Ask clarifying questions
   - Offer observations, not prescriptions
   - Support the user's creative vision

8. **Multiple rounds**:
   - This is a conversation, not a single Q&A
   - Follow-up questions welcome
   - Build on previous chat context
   - Help think through complex story issues

## Examples

User: "Why did Marcus leave the city in scene 7?"

Response:
"Looking at scene 7 and Marcus's codex entry... He left after the confrontation with Elena, where she revealed she knew about his past. From his character goals (wanting a fresh start) and the threat she represented (could expose him), leaving makes sense as a flight response.

But here's what's interesting: in scene 5, you established that Marcus hates running from problems - it's his core conflict. So this decision contradicts his self-image, which creates great internal tension.

What was going through his mind when he made this choice? Was it pure survival instinct overriding his principles?"

---

User: "I'm stuck. I don't know what happens after scene 12."

Response:
"Let me look at where we are... Scene 12 ends with Sarah finding the letter. Before I suggest anything, what does Sarah want to do? Not what the plot needs - what would she actually do in this moment based on who she is?

Looking at her codex entry, she's impulsive and loyal. The letter implicates her brother. That's a powerful conflict. Where does her loyalty pull her?

Maybe we should brainstorm a few different reactions she might have? What feels true to you?"

## Output

- Provide thoughtful, context-aware responses
- Reference specific story elements
- Ask probing questions
- Offer to save important insights
- Suggest follow-up actions (/brainstorm, /codex update, etc.)

## Integration

- Can trigger other commands based on discussion
- Updates codex if new insights emerge
- Can lead to brainstorm sessions
- Helps with story continuity and consistency
