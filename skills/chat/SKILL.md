---
name: chat
description: Use when the user wants open-ended story discussion — characters, themes, world, decisions — that doesn't fit a specific action. General creative conversation about the project, for when the user isn't ready to write yet. Trigger on: "can we talk about", "what do you think about", "I want to think through", or any general creative conversation about the project.
---

# Chat with Your Story

Have a conversation about your story, characters, plot, or writing decisions with full project context.

## Task

1. **Load full context**:
   - Read project.json
   - **Read `ORDER.md`** — reading order + the one-line reverse outline for
     every placed scene. Cheap, and it's how you know what the story looks
     like as a book rather than as files.
   - Load the scenes that read last in `ORDER.md` (or user-specified ones)
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
   - Reference scenes by **stable ID and reading position** ("`scene-019`,
     which reads at position 17")
   - Quote from codex when relevant
   - Point to summaries and `ORDER.md` lines for evidence
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
