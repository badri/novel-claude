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
   - Examples of effective covers

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

**Comp Covers**:
Similar to: [existing book covers in genre]

**AI Image Prompt** (for Midjourney/DALL-E/Stable Diffusion):
[Detailed prompt for generating this cover concept]
```

4. **Cover specifications**:

Provide technical requirements:

```markdown
## Technical Specifications

### Dimensions
- **eBook**: 1600 x 2560 pixels (minimum)
- **Print**: 6" x 9" + spine + bleed (depends on page count)
- **KDP**: 2560 x 1600 pixels recommended

### File Formats
- eBook: JPEG or PNG (RGB color)
- Print: PDF (CMYK color, 300 DPI)

### Text Requirements
- Title clearly readable at thumbnail size
- Author name visible
- Subtitle (if applicable)

### Safe Zones
- Keep text 0.25" from edges
- Account for spine width (print)
- Test readability at small sizes
```

5. **Save cover concepts**:

Create `manuscript/cover-concepts-[date].md`:

```markdown
# Cover Concepts - [Project Name]

Generated: [date]
Genre: [genre]

## Genre Analysis

Current trends in [genre]:
- [trend 1]
- [trend 2]
- [trend 3]

Successful [genre] covers typically feature:
- [element 1]
- [element 2]
- [element 3]

---

[Individual concept sections]

---

## Resources

### Stock Image Sites
- Adobe Stock
- Shutterstock
- Depositphotos
- Unsplash (free)
- Pexels (free)

### Cover Designers
- Reedsy Marketplace
- 99designs
- Fiverr
- The Book Cover Designer

### DIY Tools
- Canva (templates)
- GIMP (free Photoshop alternative)
- Affinity Publisher
- Book Brush

### AI Image Generation
- Midjourney
- DALL-E
- Stable Diffusion
- Leonardo.ai

---

## Testing Checklist

- [ ] Readable at thumbnail size (test at 100px wide)
- [ ] Title and author clearly visible
- [ ] Genre immediately recognizable
- [ ] Stands out in genre (not too generic)
- [ ] Professional quality
- [ ] Evokes the right mood
- [ ] No stock photo clichés
- [ ] Text not touching edges
```

6. **AI image generation prompts**:
   - Craft detailed prompts for each concept
   - Include style, mood, composition, colors
   - Account for text space (negative space)
   - Genre-appropriate aesthetics

7. **Output to user**:
   - Present all concepts with visuals descriptions
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

## Integration

- Pull visual elements from codex (settings, symbols)
- Match tone to story blurb
- Align with genre from project.json
- Reference key scenes or themes from summaries

## Next Steps

After concepts are chosen:
- Generate AI images with provided prompts
- Hire designer with concept brief
- DIY using templates and stock images
- Test cover with target readers
- Finalize for publication
