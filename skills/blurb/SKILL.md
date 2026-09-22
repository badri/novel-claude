---
name: blurb
description: Use when the user needs sales copy for a finished story — the back-cover blurb, the KDP/D2D/Notion Press description, keywords, categories, or a tagline. Trigger on: "write a blurb", "sales copy", "book description", "back cover copy", "Amazon description", "keywords for KDP", "tagline".
---

# Sales copy

One blurb, about **100 words**, used everywhere: back cover, KDP, D2D, Notion
Press. Dean Wesley Smith's structure, learned the hard way on *Partners in
Crime* (his verdict on the first draft: "half good, half bad — passive, too
much plot, too long"; the fix cut 189 words to 102).

## The shape

1. **Setup** — what the protagonist has and expects. Two or three sentences,
   present tense, active voice, the actor named.
2. **The turn** — one short sentence. *"But the island has other plans."*
3. **The stakes** — what is coming, without saying what it is. Tease that a
   secret exists; never explain it.
4. **One genre line** — *"A taut psychological mystery about…"* This is
   where the subgenre lives, not in the story.

Nothing else. No symptom paragraph, no backstory paragraph, no second
character's arc, no twist hint. If a sentence describes plot the reader will
watch happen, cut it.

## Task

1. **Read** `project.json` (premise, genre), `ORDER.md` (the first ten
   reading positions are what the blurb may draw on), and the project
   `CLAUDE.md` **Story Rules** — a book's spoiler rule outranks the blurb.
   The Divya blurb could not hint at clones; the categories carried the SF
   signal instead. Ask the author what the book's *one* secret is only if the
   Story Rules don't say.
2. **Draft the blurb** (~100 words). Then write **three alternative opening
   sentences** — the first line is the only part worth A/B-ing.
3. **Write the metadata** in the same file:
   - **Tagline** (under ten words) for the cover, under the title.
   - **7 KDP keyword phrases** — reader search terms, not adjectives
     ("Indian crime thriller", "police procedural India", not "gripping").
   - **3 KDP categories** and **3 BISAC codes** (e.g. `FIC031080 Thrillers /
     Technological`). The categories are where a genre signal the blurb must
     hide can go.
   - **Notion Press line**: five keywords in **≤100 characters** (the field
     silently truncates).
   - **Comps**: two or three "for readers of" titles.
4. **Save** to `manuscript/blurb-[date].md`. This is the file the `publish`
   skill pastes from.
5. **Read it back against the checklist** before showing it:
   - Under 110 words? Present tense? Actor named in every sentence?
   - Does any sentence explain the secret or the ending? Cut it.
   - Does the setup make the reader love what the turn takes away?
   - Would Dean call any of it passive?

Show the blurb, the three openings, and the metadata. Offer one revision
round; then it ships. Polishing a blurb is critical voice with a marketing
hat.

## Not this skill

- **Author bio** — third person, lives on the author site's About page, reused
  verbatim on every book. Don't write a new one per book.
- **Long descriptions, press releases, query letters** — not part of a
  wide-from-day-one indie release. The store page gets the same 100 words.
- **The blurb after publication** — Heinlein's Rule 5. Leave it on the market.
