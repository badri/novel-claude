---
name: codex
description: Use when the user wants to add, view, or update worldbuilding information — characters, locations, timeline, lore. Trigger on: "add to codex", "who is X", "where is Y", "update character Z", "what do I know about", "codex entry for", "add this character".
---

# Codex Management

Add, update, delete, or query the story codex (characters, locations, worldbuilding, timeline, lore).

## Natural Language Support

This skill accepts both structured and natural language input:

**Natural Language**:
```
add character Devika Menon - red herring suspect
create location Forbidden Vault from our discussion
update Marcus - add relationship with Elena
delete character John Smith
from discussion - add the Tokyo safehouse
```

When using natural language, the skill will:
- Parse your intent (add/update/delete/search)
- Extract element type (character/location/etc.)
- Pull details from your description OR recent conversation context
- Generate entry and ask for confirmation

## Task

1. **Determine action** (parse from natural language or ask user):
   - **Add**: New character, location, lore, etc.
   - **Update**: Modify existing entry
   - **Delete**: Remove an entry completely
   - **Search**: Find information in codex
   - **Extract**: Pull codex entries from recent scenes
   - **View**: Show specific codex file(s)
   - **Review TODO**: Process items from codex-todo.md

2. **Codex files**:
   - `codex/characters.md` - Characters, their traits, arcs, relationships
   - `codex/locations.md` - Settings, places, atmosphere
   - `codex/timeline.md` - When events happen, chronology
   - `codex/worldbuilding.md` - Rules, systems, culture, society
   - `codex/lore.md` - History, backstory, myths, legends

## Actions

### Add Entry

Ask user:
- Which codex file? (character/location/worldbuilding/timeline/lore)
- What to add?

Then append formatted entry to the appropriate file.

**Character template**:
```markdown
## [Character Name]

**Role**: Protagonist/Antagonist/Supporting
**Age**: [if relevant]
**Appearance**: [brief description]
**Personality**: [key traits]
**Background**: [relevant history]
**Goals**: [what they want]
**Conflicts**: [internal/external]
**Relationships**: [key connections]
**Arc Notes**: [character growth tracking]
**First Appearance**: Scene XXX

---
```

**Location template**:
```markdown
## [Location Name]

**Type**: City/Building/Landscape/etc.
**Description**: [key features, atmosphere]
**Significance**: [why it matters to story]
**Sensory Details**: [sights, sounds, smells]
**History**: [if relevant]
**First Appearance**: Scene XXX

---
```

### Update Entry

- Read the codex file
- Find the relevant entry
- Ask user what to change
- Update using Edit tool
- Preserve formatting

### Delete Entry

- Read the codex file
- Find the entry to delete
- Confirm with user (show entry preview)
- Remove entire entry including separator
- Confirm deletion

**Safety**:
- Always preview before deleting
- Require explicit confirmation
- Note: Can recover from git if needed

### Search

- Ask what user is looking for
- Search across all codex files using Grep
- Present results with file locations
- Offer to open specific file

### Extract from Scenes

- Ask which scene(s) to analyze
- Read scene content
- Identify new characters, locations, or world details
- Suggest codex additions
- User confirms what to add

### View

- Display requested codex file(s)
- Format nicely for readability
- Offer to edit

### Review TODO

Process items from `notes/codex-todo.md`:
- Show list of pending codex additions
- Go through each item one by one
- User can: add now, skip, or delete from todo
- Mark completed items in todo file

## Conversation Context Extraction

When user says "from our discussion" or provides minimal info:

1. **Read recent conversation** (last 10-15 messages)
2. **Extract relevant details** for the element type
3. **Generate entry** from extracted context
4. **Show preview** for user confirmation
5. **Allow editing** before finalizing

## Codex Philosophy

The codex should be:
- **Living**: Updated as story unfolds (discovery writing!)
- **Practical**: Only what's useful, not exhaustive
- **Portable**: Easy to copy to new projects (series!)
- **Searchable**: Quick reference during writing
- **Flexible**: Can grow organically with the story

Don't force codex entries before they emerge naturally from the writing.

## Output

- Confirm what was added/updated
- Show file path
- Suggest related entries to review/update
- Return to writing workflow
