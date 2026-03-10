---
name: cover
description: Use when the user needs a cover design brief, concept, or art direction for the book cover. Trigger on: "cover concept", "cover brief", "cover design", "what should the cover look like", "describe the cover".
---

# Cover Design Assistant

Generate cover concepts, visual descriptions, and specifications for your book cover.

## Task

1. **Gather information**:
   - Read project.json for genre and premise
   - Read codex for key visual elements (characters, settings)
   - Check latest summaries for atmosphere and tone
   - Ask user:
     - Any specific visual ideas?
     - DIY cover or hiring designer?
     - Key symbols/images from story?

2. **Genre research**:
   - Describe current cover trends in the genre
   - Identify visual conventions (fonts, colors, imagery)
   - Note what makes covers in this genre sell

3. **Generate cover concepts** (3-5 options):

For each concept provide:

```markdown
## Concept [Number]: [Title]

**Visual Description**:
[Detailed description of the cover image/composition]

**Color Palette**:
- Primary: [color and mood]
- Secondary: [color and mood]
- Accent: [color and mood]

**Typography**:
- Title font style: [serif/sans-serif/script, tone]
- Author name style: [description]
- Size hierarchy: [title dominant/balanced/subtitle focus]

**Key Elements**:
- Foreground: [what's prominent]
- Background: [setting/atmosphere]
- Symbols: [any meaningful imagery]

**Mood/Atmosphere**:
[What feeling does this cover evoke?]

**Genre Signals**:
[How does this communicate the genre?]

**AI Image Prompt** (for Midjourney/DALL-E/Stable Diffusion):
[Detailed prompt for generating this cover concept]
```

4. **Cover specifications**:

Provide technical requirements:
- **eBook**: 1600 x 2560 pixels (minimum)
- **Print**: 6" x 9" + spine + bleed
- File formats: JPEG/PNG for eBook, PDF (CMYK, 300 DPI) for print

5. **Save cover concepts**:

Create `manuscript/cover-concepts-[date].md` with all concepts, resources, and testing checklist.

6. **AI image generation prompts**:
   - Craft detailed prompts for each concept
   - Include style, mood, composition, colors
   - Account for text space (negative space)
   - Genre-appropriate aesthetics

7. **Output to user**:
   - Present all concepts with visual descriptions
   - Provide AI generation prompts
   - List resources for next steps
   - Offer to refine concepts based on feedback

## Cover Design Principles

- **Thumbnail test**: Must work at tiny sizes
- **Genre clarity**: Instant recognition
- **Professional quality**: Avoid amateur mistakes
- **Unique but familiar**: Stand out within genre expectations
- **Typography matters**: Font choices communicate genre/tone
- **Color psychology**: Colors evoke emotions appropriate to story
- **Less is more**: Simple, bold, clear beats cluttered
