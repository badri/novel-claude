# Codex Management

Add, update, or query the story codex (characters, locations, worldbuilding, timeline, lore).

## Task

1. **Determine action** (ask user):
   - **Add**: New character, location, lore, etc.
   - **Update**: Modify existing entry
   - **Search**: Find information in codex
   - **Extract**: Pull codex entries from recent scenes
   - **View**: Show specific codex file(s)

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

**Timeline entry**:
```markdown
## [Event/Period]

**When**: [date/time/era]
**What Happened**: [description]
**Story Time**: [when this is revealed in narrative]
**Scenes**: [which scenes cover this]

---
```

### Update Entry

- Read the codex file
- Find the relevant entry
- Ask user what to change
- Update using Edit tool
- Preserve formatting

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

## Integration

- When writing scenes: auto-suggest relevant codex entries
- When brainstorming: pull from codex for consistency
- When summarizing: flag new elements for codex
- Cross-reference: link scenes to codex entries

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
