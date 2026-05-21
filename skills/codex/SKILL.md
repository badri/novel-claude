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

Detect codex-worthy elements in one or more scenes and offer to save them.
Ask which scene(s) to analyze, read them, then follow the
"Detecting Codex Elements from Content" workflow below.

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

## Detecting Codex Elements from Content

The shared workflow for spotting codex-worthy elements in a scene or in
brainstorm discussion and offering to save them. The `new-scene`,
`edit-scene`, and `brainstorm` skills invoke this workflow.

### 1. Scan for elements

In the content, look for:
- **New characters** — proper names in narrative, dialogue attribution
  (`"Hello," Yuki said`), explicit descriptions ("a woman named X"), the POV
  character if not yet in the codex
- **New locations** — named places with atmosphere ("Jade Dragon restaurant",
  "Kings Valley")
- **Worldbuilding** — organizations ("the Network", "the Order"), systems
  ("quantum communicators", "blood magic"), rules ("vampires can't cross
  running water"), unique tech/magic items
- **Demonstrated skills** — abilities a character uses ("Martha picked the
  lock" → lockpicking) that were not previously established
- **Timeline events** and **lore** references

### 2. Cross-reference before flagging

Before flagging anything as new, search the codex:
- `codex/characters.md` for character names
- `codex/locations.md` for location names
- `codex/worldbuilding.md` and `codex/lore.md` for concepts
- `codex/timeline.md` for timeline events

Only flag elements NOT already present.

### 3. Filter

Don't flag:
- Generic, unnamed roles (guard, waiter, bartender)
- Common unnamed places (a street, a building)
- Throwaway mentions with no development

Do flag:
- Named characters with dialogue or description
- Named locations with atmosphere/description
- Organizations, systems, unique tech/magic
- Skills demonstrated but never established
- Significant timeline events and lore references

### 4. Present all detections together

Show everything in one batch, never one at a time:

```
✨ New elements detected:

👤 **New Character**: Yuki (informant)
   Not in codex. Add now? [y/n/later]

📍 **New Location**: Jade Dragon restaurant (Tokyo)
   Not in codex. Add now? [y/n/later]

🌍 **Worldbuilding**: Network operations in Tokyo
   Expand worldbuilding codex? [y/n/later]

🔧 **Character Skill**: Martha — lockpicking
   Not established before. Options:
   a) Add to codex only
   b) Add to codex + cycle back to plant the skill earlier
   c) Skip
```

The user can also answer for all at once ("all yes", "all later").

### 5. Process choices

- **[y]** — extract details from the content, generate an entry using the
  Character/Location templates above, show a preview, let the user confirm or
  edit, then append to the right codex file.
- **[n]** — skip (minor character, one-time location).
- **[later]** — append to `notes/codex-todo.md` for the Review TODO action.

### 6. Skill → cycle integration

When a demonstrated skill was never established and the user picks **(b)**:
- Add the skill to the character's codex entry
- Trigger the `cycle` skill to plant the skill earlier — suggest a likely
  scene, let the user confirm or choose another, then cycle back and add the
  setup

This makes the discovery → setup workflow seamless.

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
