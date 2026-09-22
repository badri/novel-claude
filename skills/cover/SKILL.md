---
name: cover
description: Use when the user needs a cover brief for a finished story — the concept, type hierarchy, and one image prompt or designer brief. Trigger on: "cover concept", "cover brief", "cover design", "what should the cover look like", "cover prompt".
---

# Cover brief

One brief, one concept, genre-branded. The cover's job is step 1 of the
four-step sale: **branded author name + genre-branded image**. Dean's review
of the *Partners in Crime* cover said the layout would lose readers before
they reached the blurb. The hierarchy below is his fix; it is not optional.

## The hierarchy (top to bottom)

1. **Author name, huge, at the top.** `SAROJ ANAND`. The brand readers
   look for on the next book.
2. **Optional credential line** above or under the name: *"Author of
   Partners in Crime"* (once there is a book to name).
3. **Image** — one strong genre image. A reader must name the genre in one
   second at thumbnail size.
4. **Title, smaller, at the bottom.**
5. **Tagline under the title** — the one from the `blurb` skill.

**Thumbnail test:** at 100 px tall the author name and the genre must still
read. If the title is what reads first, the hierarchy is wrong.

## Task

1. **Read** `project.json`, the blurb file in `manuscript/` if one exists
   (use its tagline), and the project `CLAUDE.md` Story Rules — the cover
   respects the same spoiler rule as the blurb (Divya: no doubled faces).
2. **Name the genre shelf** the book sits on and what its covers look like
   right now (palette, type, image conventions). One paragraph, from
   looking at the current top 20 in that category, not from memory of what
   covers used to be.
3. **Write one concept** — not three to five. Discovery writing does not
   extend to art direction; pick and move on:
   - The image (one sentence), and why a reader files it under this genre.
   - Palette: two colours plus one accent.
   - Type: author name (weight, case, width), title, tagline.
   - Where the text goes, so the image leaves that space empty.
4. **Write the prompts**: one AI image prompt for the front art (with
   explicit empty space top and bottom for the type, no text in the image),
   and one alternate. Portrait, 2:3 ratio, described at 1600×2560.
5. **Save** to `manuscript/cover-brief-[date].md`.

## Specs and hand-offs

- **Ebook**: 1600 × 2560 JPG, under 50 MB. The `publish` skill's
  `build-epub.py` embeds it.
- **Print**: not this skill. The `publish` skill builds the print cover from
  the front art, the back-cover blurb and the Notion Press template
  (`build-cover.py`), which sets trim, spine and bleed per page count.
- **Two rounds maximum** on a commissioned or generated cover. If the second
  round misses, license a premade in the genre and move on. The book is not
  an event; the cover on book 7 is what readers will discover book 1 through.
