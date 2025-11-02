# Generate Story Blurb

Create compelling back cover copy and story descriptions for marketing your story.

## Task

1. **Gather context**:
   - Read project.json for genre and premise
   - Read latest reverse outline or summaries
   - Check codex for main characters and conflicts
   - Ask user: What makes this story unique/compelling?

2. **Blurb types** (generate multiple):

   **Short hook** (1-2 sentences):
   - For social media, email subject lines
   - Pure intrigue and stakes

   **Short blurb** (50-75 words):
   - For Amazon description first paragraph
   - Hook + protagonist + problem + stakes
   - Genre-appropriate tone

   **Full blurb** (150-200 words):
   - Complete back cover copy
   - Character + situation + conflict + stakes + question
   - Emotional pull
   - Genre promise

   **Long description** (300+ words):
   - For website, press releases
   - More detail, multiple characters
   - Subplot hints
   - Author's note possible

3. **Genre-specific formulas**:

   **Thriller/Mystery**:
   - Inciting incident
   - What's at stake
   - Race against time
   - Twist hint

   **Romance**:
   - Who are they
   - What's keeping them apart
   - Why this matters
   - Emotional stakes

   **Science Fiction/Fantasy**:
   - World/concept hook
   - Protagonist and their challenge
   - What's unique about this world
   - High stakes

   **Literary**:
   - Character depth
   - Thematic question
   - Emotional journey
   - Voice/prose style hint

4. **Generate multiple options**:
   - Create 3-4 different versions of each blurb type
   - Different angles, tones, hooks
   - Test different opening lines
   - User can mix and match

5. **Save blurbs**:

Create `manuscript/blurbs-[date].md`:

```markdown
# Story Blurbs - [Project Name]

Generated: [date]
Genre: [genre]

## Short Hook Options

### Version 1
[hook text]

### Version 2
[hook text]

### Version 3
[hook text]

---

## Short Blurb Options (50-75 words)

### Version 1
[blurb text]

### Version 2
[blurb text]

### Version 3
[blurb text]

---

## Full Blurb Options (150-200 words)

### Version 1
[full blurb]

### Version 2
[full blurb]

### Version 3
[full blurb]

---

## Long Description (300+ words)

[detailed description]

---

## Keywords/Comp Titles

Similar to: [comparable titles]
Keywords: [genre keywords]
Tropes: [story tropes]

---

## Notes

[User notes on what works, what doesn't]
```

6. **Blurb writing principles**:
   - No spoilers (stop before midpoint)
   - Focus on main character and central conflict
   - Raise story questions, don't answer them
   - Genre-appropriate tone and voice
   - Active voice, present tense usually
   - Emotional stakes over plot details
   - End with tension/question

7. **Test and refine**:
   - Ask user which version resonates
   - Offer to combine best elements
   - Check for clichés or overused phrases
   - Ensure clarity and intrigue balance

8. **Output**:
   - Present all blurb options
   - Highlight recommended version for each type
   - Save to manuscript folder
   - Offer to refine based on feedback

## Integration

- Pull character names and traits from codex
- Reference genre from project.json
- Use summaries to identify key conflicts
- Match tone to actual story voice

## Comparison Analysis

Optionally offer to:
- Analyze blurbs from successful books in the genre
- Compare user's blurb to genre conventions
- Suggest improvements based on market research
