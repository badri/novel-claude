# Importing Existing Work - Complete Guide

This guide shows you how to import a partial draft, half-finished manuscript, or existing story into the Pulp Fiction Writing System.

## Why Import?

You have an existing draft (10k, 50k, or 100k+ words) and want to:
- ✅ Continue writing with AI assistance
- ✅ Build a codex from your existing world
- ✅ Create reverse outlines (summaries) of what you've written
- ✅ Use scene management, cycling, and reordering tools
- ✅ Leverage multi-model AI (Claude + Gemini)

## The Challenge

**You can't just paste 50,000 words into Claude's context.** That would:
- ❌ Consume massive tokens (expensive, slow)
- ❌ Exceed context limits
- ❌ Make every operation expensive

## The Solution: Context-Economical Import

The `/import` command:
1. **Processes in chunks** (never loads full draft at once)
2. **Uses Gemini for summarization** (saves Claude tokens)
3. **Minimal codex upfront** (you provide brief info, expand later)
4. **Splits into manageable scenes** (1-2k words each)
5. **Creates reverse outline** (summaries, not full text)

**Result**: You can continue writing from scene 25 without loading scenes 1-24 into context!

---

## Import Workflow Example

### Starting Point

You have: `~/drafts/my-thriller.md` (45,000 words, partial draft)

```markdown
# My Thriller

Martha woke to the sound of rain...

[45,000 words of story]

...she drove into the night.
```

### Step 1: Prepare

Navigate to your writing folder:

```bash
cd ~/writing
claude
```

### Step 2: Run Import

```bash
/import
```

**System asks for source file:**
```
What file do you want to import?
```

**You provide:**
```
~/drafts/my-thriller.md
```

### Step 3: Minimal Codex Setup

**System analyzes file size:**
```
This is a 45,000 word draft.

To understand your story without loading the whole thing into context,
I need some basic information. This will only take a few minutes.

Main characters (just names and one-line descriptions):
```

**You provide (3-5 minutes of typing):**
```
Martha Chen - burned-out detective, protagonist
Jack Hayes - Martha's former partner, now rival
Elena Vasquez - mysterious informant
Carlos - border guard, minor character
```

**System continues:**
```
Key locations (2-3 sentences):
```

**You provide:**
```
Border town in Texas, Martha's apartment, safehouse in Mexico City
```

**System asks:**
```
World/setting basics (2-3 sentences):
```

**You provide:**
```
Contemporary thriller, 2024, realistic world. Underground network
of informants and smugglers along the US-Mexico border.
```

**System asks:**
```
POV structure:
```

**You provide:**
```
Multiple POV, third person - mostly Martha with some Jack chapters
```

**Done!** You've given the AI just enough context (took 5 minutes, not 5 hours).

### Step 4: Scene Detection Strategy

**System asks:**
```
How should I split your draft into scenes?

Options:
A) Auto-detect (look for scene breaks, chapter markers, POV switches)
B) Every N words (specify word count)
C) Manual guidance (you specify where breaks should be)
```

**You choose:**
```
A - Auto-detect
```

**System processes in chunks:**
```
Processing your draft...

[Reading 5000 words at a time, identifying scene breaks]

Found 24 potential scene breaks:

Scene 001: Lines 1-87 (1,234 words) - "Martha woke to the sound..."
Scene 002: Lines 88-165 (1,456 words) - "The diner was crowded..."
Scene 003: Lines 166-234 (1,123 words) - "Jack paced his office..."
...
Scene 024: Lines 1832-1901 (1,876 words) - "Martha drove into the night..."

Looks good? [y/n/adjust]
```

**You confirm:**
```
y
```

### Step 5: Scene Splitting & Summarization

**System works (this happens automatically):**

```
Creating project structure...
✓ Created: my-thriller/scenes/
✓ Created: my-thriller/codex/
✓ Created: my-thriller/summaries/
✓ Created: my-thriller/brainstorms/
✓ Created: my-thriller/manuscript/
✓ Created: my-thriller/notes/

Splitting draft into scenes...
✓ Created: scenes/scene-001.md (1,234 words)
✓ Created: scenes/scene-002.md (1,456 words)
...
✓ Created: scenes/scene-024.md (1,876 words)

Initializing minimal codex...
✓ Created: codex/characters.md (4 characters)
✓ Created: codex/locations.md (3 locations)
✓ Created: codex/worldbuilding.md (basic info)

Summarizing scenes with Gemini...
[This is the key step - uses Gemini, not Claude!]

✓ Summarized: scene-001.md → summaries/summary-scene-001.md
✓ Summarized: scene-002.md → summaries/summary-scene-002.md
...
✓ Summarized: scene-024.md → summaries/summary-scene-024.md

Generating import report...
✓ Created: notes/import-report.md

Import complete!
```

### Step 6: Review Import Results

**System shows summary:**

```
✅ Import Complete!

📦 Created Project: my-thriller

📊 Statistics:
- Scenes created: 24
- Total words: 45,000
- Summaries generated: 24 (via Gemini)
- Codex entries: 7 (4 characters, 3 locations)

📁 Files Created:
- scenes/*.md (24 scene files)
- summaries/*.md (24 summaries)
- codex/*.md (minimal codex initialized)
- project.json (project tracking)
- notes/import-report.md (full details)

🔍 Import Report: my-thriller/notes/import-report.md

Next Steps:
1. Review scene splits: /scenes list
2. Check a few scenes: /scenes read 1
3. Expand codex as needed: /codex
4. Continue writing: /new-scene (will create scene-025)
```

### Step 7: Review & Verify

Enter your project:

```bash
cd my-thriller
claude
```

**Check the scene splits:**
```bash
/scenes list
```

**Output:**
```
# Scene Index - My Thriller

Total Scenes: 24
Total Words: 45,000

| # | POV | Location | Words | Status | Summary |
|---|-----|----------|-------|--------|---------|
| 001 | Martha | Apartment | 1,234 | ✓ | Martha wakes to find letter... |
| 002 | Martha | Diner | 1,456 | ✓ | Meeting with informant... |
| 003 | Jack | Office | 1,123 | ✓ | Jack discovers files... |
...
| 024 | Martha | Highway | 1,876 | ✓ | Martha drives into night... |

Legend:
✓ = Summarized (via Gemini)
```

**Read a specific scene to verify:**
```bash
/scenes read 12
```

**Output:**
```
# Scene 012

**POV**: Martha
**Location**: Border checkpoint
**Time**: Night

---

[Full scene content from your original draft]

---

**Notes**:
- Word count: 1,456
- Status: imported
- Source: original-draft.md
- Summary: summaries/summary-scene-012.md
```

Looks good!

### Step 8: Check the Codex

```bash
/codex view characters
```

**Output:**
```
# Characters

## Martha Chen

**Role**: Protagonist
**Description**: Burned-out detective
**First Appearance**: Scene 001

[Minimal entry - expand as needed]

---

## Jack Hayes

**Role**: Supporting (Former partner, now rival)
**Description**: Martha's former partner
**First Appearance**: Scene 003

[Minimal entry - expand as needed]

---

## Elena Vasquez

**Role**: Supporting (Mysterious informant)
**Description**: Provides intel to Martha
**First Appearance**: Scene 005

---

*Note: Imported from existing draft. Expand entries using /codex*
```

**Expand a character:**
```bash
/codex update Martha Chen

Add: Age 38, divorced, drinks too much coffee, haunted by
unsolved case from 5 years ago. Skills: interrogation,
pattern recognition. Relationships: tense with Jack (old
betrayal), trusts Elena cautiously.
```

### Step 9: Continue Writing!

You're now set up to continue from where you left off:

```bash
/new-scene
```

**System asks:**
```
What happens in scene 025?

[Loads context from:
 - scenes/scene-023.md and scene-024.md (last 2 scenes)
 - summaries/summary-scene-022.md, 023, 024 (recent summaries)
 - codex/characters.md, locations.md (worldbuilding)
]
```

**You describe next scene:**
```
Martha arrives in Mexico City, meets Elena at the safehouse.
Elena reveals crucial information about the Network's operations.
Add 5 senses description of Mexico City from Martha's POV.
End with unexpected visitor - don't reveal who yet.
```

**AI generates scene 025** using:
- Your 24 existing scenes (via summaries, not full text!)
- Codex (characters, locations, world)
- Your instructions

**Result:**
Scene 025 feels continuous with your existing draft!

---

## What Makes This Context-Economical?

### Without Import System ❌

```
Load entire 45,000 word draft into context
↓
Massive token usage for every operation
↓
Expensive, slow, context limit issues
```

### With Import System ✅

```
Process draft in 5,000 word chunks
↓
Gemini summarizes each scene (uses Gemini tokens, not Claude)
↓
Claude only sees: summaries + codex + last 2 scenes
↓
Fast, cheap, context-efficient!
```

### Token Comparison

**Writing scene 025 without import:**
- Full draft: 45,000 words ≈ 60,000 tokens
- Claude context used: ~60k tokens
- Cost: High

**Writing scene 025 with import:**
- Summaries: 24 scenes × 200 words ≈ 6,400 tokens
- Last 2 scenes: 3,000 words ≈ 4,000 tokens
- Codex: 1,000 words ≈ 1,300 tokens
- Total context: ~11,700 tokens
- Cost: **80% less!**

---

## Import Report Example

After import, check `notes/import-report.md`:

```markdown
# Import Report

Date: 2025-10-26 14:30:00
Source: ~/drafts/my-thriller.md

## Summary

- **Scenes created**: 24
- **Total words**: 45,000
- **Summaries generated**: 24 (via Gemini)
- **Codex initialized**: Minimal (4 characters, 3 locations)
- **Original preserved**: manuscript/original-draft.md

## Scene Breakdown

| Scene | Words | POV | Status | Summary |
|-------|-------|-----|--------|---------|
| 001 | 1,234 | Martha | ✓ Summarized | Martha receives letter |
| 002 | 1,456 | Martha | ✓ Summarized | Diner meeting |
| 003 | 1,123 | Jack | ✓ Summarized | Jack finds files |
...

## Codex Status

**Characters**: 4 minimal entries
- Martha Chen
- Jack Hayes
- Elena Vasquez
- Carlos

**Locations**: 3 entries
- Border town, Texas
- Safehouse, Mexico City
- Martha's apartment

**Worldbuilding**: Basic contemporary thriller setup

**Recommendation**: Expand codex entries as you continue writing using `/codex`

## Next Steps

- [x] Import completed
- [ ] Review scene splits (/scenes list)
- [ ] Read a few scenes to verify (/scenes read X)
- [ ] Expand codex entries (/codex)
- [ ] Continue writing (/new-scene for scene 025)

## Technical Details

- Scene detection: Auto-detect (24 breaks found)
- Summarization: Gemini CLI (all 24 scenes)
- Context efficiency: Summaries only, not full scenes
- Original backup: manuscript/original-draft.md
```

---

## Different Import Scenarios

### Scenario 1: Very Long Draft (100k+ words)

```bash
/import ~/drafts/my-epic-novel.md

System: This is a 120,000 word draft. This will take longer
        but I'll process it in batches.

[Processes in 10k word chunks]
[Creates 60+ scenes]
[Summarizes in batches via Gemini]

✓ Import complete: 62 scenes, all summarized
```

**Still context-efficient!** Claude never sees the full 120k words.

### Scenario 2: Multiple Chapter Files

You have:
```
chapter-01.md
chapter-02.md
chapter-03.md
...
```

```bash
/import

System: I see multiple files. Import all chapters?

You: Yes

System: [Processes each chapter file sequentially]
        [Creates continuous scene numbering across all files]

✓ Scenes 001-045 created from 8 chapter files
```

### Scenario 3: Word Document

You have: `my-novel.docx`

```bash
/import ~/drafts/my-novel.docx

System: Converting DOCX to markdown...
        [Uses pandoc to convert]

        Converted: 52,000 words

        [Continues with normal import process]
```

### Scenario 4: Incomplete Draft

You wrote 15,000 words and got stuck:

```bash
/import ~/drafts/stuck-story.md

System: 15,000 words, 8 scenes detected

[Import completes]

You: /scenes list
> 8 scenes imported

You: /brainstorm
> What happens next?

[Brainstorm using context from imported scenes]

You: /new-scene
> Continue from scene 9!
```

---

## After Import: Gradual Codex Building

You don't need a complete codex upfront. Build it as you write:

### Week 1: Import + Basic Writing

```bash
# Imported with minimal codex
/codex view characters
> 4 minimal entries

# Write a few new scenes
/new-scene
/new-scene

# AI suggests codex additions
New character detected: Dr. Chen
Add to codex? [y/n/later]
> later
```

### Week 2: Expand Codex

```bash
# Review TODO items
/codex review-todo

> Pending additions:
  - Dr. Chen (character, mentioned in scene 26)
  - Tokyo safehouse (location, scene 28)

Add Dr. Chen now? [y/n]
> y

[Generates entry from scene 26]
✓ Added Dr. Chen to codex
```

### Month 1: Full Codex

Your codex grows organically as you write!

---

## Common Questions

### Q: Do I need to summarize before importing?

**A: No!** The import process automatically summarizes via Gemini.

### Q: What if scene splits are wrong?

**A: Use `/reorder` or manually edit scene files.** They're just markdown files.

### Q: Can I import multiple times?

**A: Yes**, but create different projects or merge manually.

### Q: Will this work with my genre?

**A: Yes!** Works with any fiction: thriller, romance, fantasy, sci-fi, literary, etc.

### Q: What about non-linear narratives?

**A: Import in narrative order, then use `/reorder` to adjust sequence.**

### Q: Do I lose my original file?

**A: No!** Original is preserved in `manuscript/original-draft.md`

---

## Best Practices

### Before Import

✅ **Back up your original file**
✅ **Know your main characters (3-5)**
✅ **Have basic world info ready**
✅ **Choose a consistent naming scheme**

### During Import

✅ **Provide minimal but accurate codex info**
✅ **Review scene split preview before confirming**
✅ **Let auto-detect work (it's pretty smart)**

### After Import

✅ **Review first few scenes to verify quality**
✅ **Spot-check scene splits**
✅ **Expand codex gradually as you write**
✅ **Continue forward, don't get stuck editing old scenes**

---

## The Big Picture

```
Existing Draft (45k words)
         ↓
    /import
         ↓
   [Chunked Processing]
         ↓
   24 Scenes Created
         ↓
   Gemini Summarizes (saves Claude tokens!)
         ↓
   Minimal Codex (your 5-min input)
         ↓
   Ready to Write Scene 25
         ↓
   Context: Summaries + Codex + Last 2 Scenes
         ↓
   Write Forward with AI Assistance!
```

**You went from:**
- 45,000 word blob → Organized, navigable, AI-ready project
- No context economy → Efficient token usage
- Stuck/alone → Ready to continue with AI help

**In about 15-20 minutes of import time!**

---

## Success Story Example

**Before Import:**
- 60,000 word draft sitting in Google Docs
- Stuck at chapter 15
- No outline (discovery writer)
- Want AI help but can't paste 60k words

**After Import:**
- 32 scenes with summaries
- Codex with 8 characters, 5 locations
- Full context available (via summaries)
- Continue writing scene 33 with AI
- Use `/brainstorm` to unstick
- Use `/cycle` to plant missing setups
- Use `/reorder` to fix structure

**Result:**
- Finished the novel (85k words)
- Used AI throughout
- Never exceeded context limits
- Compiled to publishable manuscript
- **Published!**

---

## Ready to Import?

```bash
cd ~/writing
claude
/import ~/drafts/your-story.md
```

**The system will guide you through the rest!**

Your existing work + AI assistance + discovery writing = Published novel 🎉
