# Semantic Search Across Project

Search your entire fiction project using natural language queries. Powered by DevRag vector search for fast, context-aware results.

## Task

### Search Query

User provides a natural language search query. Examples:
- "Where did I mention the magic system?"
- "Which scenes feature Marcus?"
- "What decisions did I make about the ending?"
- "Find all references to the ancient prophecy"
- "When did we discuss character motivation?"

### Execution

1. **Check DevRag is configured**:
   - Verify `.devrag/config.json` exists
   - If not, suggest running `/setup-devrag` first

2. **Perform semantic search**:
   - Use DevRag MCP to search across all indexed markdown files:
     - `scenes/**/*.md`
     - `codex/**/*.md`
     - `notes/**/*.md`
     - `notes/session-interactions/**/*.md`
     - `brainstorms/**/*.md`
     - `summaries/**/*.md`
   - Return top 5-10 most relevant results

3. **Format results**:
   ```
   🔍 Search: "magic system"

   Found 8 results across your project:

   📝 scenes/scene-003.md
   ...Marcus explains that magic costs physical stamina, not mental energy.
   The more powerful the spell, the more exhausted the caster becomes...

   📚 codex/worldbuilding.md
   ...Magic System: Energy-based, requires physical stamina. Advanced users
   can draw from their life force for emergency casting...

   💭 notes/session-interactions/session-20251101-143000.md
   [14:45] User: Can you help me brainstorm what happens next in the story?
   [14:47] Discussion about magic limitations and how they create tension...

   🧠 brainstorms/magic-rules.md
   ...Decided that magic must have real costs. No mana bars - actual
   physical consequences that affect the plot...
   ```

4. **Provide context**:
   - Show snippet of matching content
   - Include file path for reference
   - Group by type (scenes, codex, sessions, brainstorms)

### Search Options

Support different search modes:

**Basic search** (default):
```
/search magic system
```

**Search specific type**:
```
/search "character development" in:scenes
/search "plot decisions" in:sessions
/search "worldbuilding" in:codex
```

**Recent only**:
```
/search "ending" recent:7d    # Last 7 days
/search "villain" recent:30d   # Last 30 days
```

## Benefits

- **40x fewer tokens** than reading all files
- **260x faster** than sequential file reads
- **Semantic understanding** - finds related concepts, not just exact matches
- **Session memory** - search past conversations and decisions
- **Cross-reference** - find connections between scenes, codex, and discussions

## Examples

### Find where you discussed a topic
```
/search When did I decide to kill off Marcus?

💭 notes/session-interactions/session-20251028-140000.md
[15:23] User: I'm thinking of killing Marcus in chapter 12 instead
of letting him escape. This would raise stakes and give Devika stronger
motivation for revenge. What do you think?
```

### Find scenes with a character
```
/search scenes with Devika and Marcus together

📝 scenes/scene-012.md
Devika confronts Marcus in the warehouse. Their argument reveals...

📝 scenes/scene-023.md
Marcus and Devika's final confrontation. She discovers his betrayal...
```

### Find worldbuilding details
```
/search rules of magic

📚 codex/worldbuilding.md
Magic System: Physical stamina-based. Advanced users can draw from
life force...

📝 scenes/scene-007.md
Marcus collapsed after the spell, barely conscious. "That's why we
don't use high-level magic carelessly," Devika muttered...
```

### Search brainstorming sessions
```
/search brainstorm villain motivation

🧠 brainstorms/villain-arc.md
Discussed making the villain sympathetic - they're trying to save
their dying child, not just evil for evil's sake...
```

## Notes

- DevRag automatically indexes files when they're created/modified
- No manual reindexing needed
- Search works across all markdown in your project
- Session interactions are fully searchable (your full conversation history)
- Results are ranked by semantic relevance, not just keyword matching

## Philosophy

**Discovery Writing Compatible:**
- No need to manually organize or tag content
- Natural language queries reflect how you think
- Find forgotten details from past sessions
- Rediscover connections you didn't realize you made
- Let the system remember so you can focus on writing

Search your story like you'd search your memory - naturally and intuitively.
