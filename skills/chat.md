---
name: chat
description: Use for open-ended story discussion — characters, themes, world, decisions — that doesn't fit a specific action. General creative conversation about the project when the user isn't ready to write yet.
---

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

## Output

- Provide thoughtful, context-aware responses
- Reference specific story elements
- Ask probing questions
- Offer to save important insights
- Suggest follow-up actions (brainstorm, codex update, etc.)
