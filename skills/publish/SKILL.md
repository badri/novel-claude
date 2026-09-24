---
name: publish
description: Use when a finished book needs to go out the door — building the ebook and print files, writing the sales copy, and filling the KDP, Draft2Digital and Notion Press forms. Trigger on "publish", "get this ready for KDP", "D2D upload", "Notion Press", "print edition", "paperback", "upload sheet", "back cover", "format for submission".
---

# Publish a finished book

The post-writing pipeline, from a finished manuscript to three live storefronts. Scripts live next to this file in `scripts/` (run them by that full path from the book's project root). It encodes what was learned shipping *Partners in Crime* (May 2026) and *Divya* (Sept 2026). Each book gets **paste-ready upload sheets** in its `manuscript/` folder, and the scripts in `scripts/` build every file.

**Standing rules — never break these:**
- **Wide from day one.** Never KDP Select, never any exclusivity.
- **One distributor per store.** KDP delivers Amazon, so **uncheck Amazon inside D2D**. Double-listing splits reviews and can get both listings pulled.
- **Print is split by market.** **Notion Press is the India paperback, India-only** (Amazon.in, Flipkart, their store; International MRP left blank). **KDP Print is the paperback for everywhere else.** Every novel gets both; one interior PDF serves both. Never try to reach Indian print buyers through KDP (its Amazon.in listing is an overpriced import) or the rest of the world through Notion Press.
- **No DRM.**
- **Pricing for the first 10 books is reach.** Price at or near each platform's floor, report what it earns per copy, and let the author pick the final figure.
- **The human does:** every payment, every terms/agreement checkbox, every **Submit/Publish** click, and any upload the site only accepts from a real click (see Notion Press). Fill forms, save drafts, stop.

## Short stories — the ebook-only path

A Personal Sales Help story or any standalone short goes out as a **KDP
single + D2D**, ebook only, priced at each platform's floor ($0.99 on KDP
at 35%; free where a store allows it). No print, no Notion Press, no ISBN
beyond D2D's free one. Steps 1–3 below, then stop. Same 100-word blurb
shape, same cover hierarchy, same "Amazon unchecked in D2D".

Every five to seven shorts, build a **collection** as a normal book (all
steps): a new door to the bakery, and the print edition the singles never
get. Track which shorts are in which collection in the author site's book
list.

## Order of work

1. **Publication master** — `manuscript/<book>-publication.md`: front matter (title page, copyright), numbered chapters from `ORDER.md` (use `compile`), THE END, back matter (Author's Note, newsletter line). No annotation tags, no `scene-NNN` IDs, no Notes. Scene breaks as `<p class="scenebreak">&#42; &#42; &#42;</p>` so they survive Kindle; the print build converts them.
2. **Sales copy** (below). Needed by every later step.
3. **Ebook** → KDP → D2D.
4. **Print** → one interior PDF, two covers: **KDP paperback** (rest of the world) and **Notion Press** (India only). Neither waits on the other.
5. **Record** every ID and link in the book's sheets and on the author site.

## Sales copy — one blurb everywhere

Dean Wesley Smith's structure, about **100 words**, the same text on the back cover and every store page:

**setup** (what the protagonist has and expects) → **the turn** ("But the island has other plans.") → **the stakes** (what is coming) → **one genre line** ("A taut psychological mystery about…").

- Cut plot. Tease that a secret exists; never explain it. Delete symptom and backstory paragraphs; those are exactly what Dean cut from *Partners in Crime* (189 → 102 words).
- Active voice. Name the actor.
- Respect the book's own spoiler rules (the Divya blurb could not hint at clones; the categories carried the SF signal instead).
- Also produce: 7 KDP keyword phrases, and a ≤100-character, 5-keyword version for Notion Press.
- Author bio (third person) lives on the author site's About page; reuse it verbatim across books.

The `blurb` skill can generate options; its long formats are not what ships.

## Ebook

```bash
python3 scripts/build-epub.py manuscript/<book>-publication.md manuscript/<Book>-ebook.epub \
  manuscript/cover-art/<Book>-ebook-cover-1600x2560.jpg "<Title>"
```

It uses `epub-kindle.css` (pandoc's default CSS sets a grey background that shows on e-ink and breaks dark mode), patches pandoc's malformed cover meta, and runs **epubcheck — must be 0 errors** before any upload. YAML `description:` with a colon needs `>-`.

Before upload: open it on a real device or Kindle Previewer; check scene breaks survived, no `[LINK]` placeholders remain, and the cover is embedded.

## KDP ebook — upload sheet fields

Write `manuscript/upload-kdp.md` in the order KDP asks:

- **Details:** Language · Title · Subtitle (empty unless it earns its place) · Series (empty for standalones; easier to add than remove) · Edition 1 · Author `Saroj Anand` · Description as **HTML** (`<p>`, bold first line) plus a plain-text fallback · "I own the copyright" · Sexually explicit: No · **Primary marketplace Amazon.com** · 3 categories · 7 keywords · Pre-order: No.
- **Content:** EPUB + 1600×2560 JPG cover · **AI-generated content** declared honestly (three dropdowns: text / images / translations; tool names) · ISBN blank · **DRM off**.
- **Pricing:** **KDP Select NO** · all territories · 70% royalty ($2.99–$9.99 band) · set each marketplace by hand (INR is its own market; check it stays in the 70% band).
- **Cover gotchas (Divya, Sept 2026 — KDP support blamed "the cover upload"):** the cover section's radio must be on **"Upload a cover you already have"**. It can sit on "Use Cover Creator" with your JPG shown as uploaded, and Publish then fails with "Please fix the highlighted error(s)" and nothing highlighted. Export the JPG with **72 dpi set in the file** (`im.save(..., dpi=(72, 72), quality=95)`; an unset DPI is one more thing for their checker to reject). Any new cover or manuscript upload brings back two **"I confirm that my answers are accurate"** boxes (AI content, accessibility); tick both or Save does nothing.
- **Gotchas:** KDP once silently dropped manual price overrides — re-check the pricing tab before Publish. "Please fix the highlighted error(s)" with nothing highlighted has been a **KDP outage** (Contact Us page banner), not your form.
- After live: check description formatting, Look Inside, buy one copy and read chapter 1 on a real Kindle, record the ASIN.

## Draft2Digital — upload sheet fields

Write `manuscript/upload-d2d.md`. Run after KDP is live.

- Same title/author/description/keywords. Imprint `Saroj Anand`. **Take D2D's free ISBN** (library systems need one).
- 3 **BISAC** categories (codes, e.g. `FIC031080 Thrillers / Technological`).
- Prices by hand per currency.
- **Sales channels: Amazon UNCHECKED.** Everything else on: Kobo (+ **Kobo Plus**, no exclusivity), Apple, B&N, Everand/Scribd, Smashwords, the libraries (OverDrive, Bibliotheca, Baker & Taylor, Palace), long tail.
- Keep the **Books2Read universal link**; it goes on the site and in the newsletter. "Also by" end matter needs an EPUB 2 upload; skip with EPUB 3.

## Print interior (5.5 × 8.5, shared by KDP and Notion Press)

```bash
python3 scripts/build-print.py manuscript/<book>-publication.md \
  manuscript/<Book>-print-interior-5.5x8.5.pdf "<Title>" "<first chapter heading, e.g. # 1>" [ISBN]
```

- Everything before the first chapter heading is replaced by print front matter (half-title, title, copyright). Leave the ISBN argument off: each edition has its own ISBN (Notion Press's, KDP's), so an ISBN printed inside would make the PDF single-use. The ISBN lives on the back-cover barcode and the store listing.
- Page size = trim exactly, no bleed. Margins are Notion Press's Word template: top/bottom 1.93 cm, inside 1.93 cm + 0.36 cm gutter, outside 1.52 cm, mirrored. EB Garamond 11 pt (bundled, OFL), running heads title/author, chapter openers without page numbers, all-caps datelines under chapter heads become small caps.
- Check: every page is 396 × 612 pt (`pdfinfo -f 1 -l N -box`), page count even, fonts embedded (`pdffonts`). Render a few spreads and look.
- **Page count sets the floor price** (Divya 298 pp → ₹405; *Partners in Crime* 134 pp → ₹205). A tighter layout lowers it; decide before the cover.
- **The same PDF goes to KDP unchanged.** No ISBN is printed in it, so it isn't tied to either edition's ISBN, and Notion Press's margins (inside 0.9 in, outside 0.6 in) clear KDP's minimums (inside 0.375–0.875 in by page count, outside 0.25 in) up to ~700 pages.

## Print cover

1. Upload the interior on Notion Press first, then in step 2 → Cover Design → *Upload Print Ready file* → **Download Template**. It is per book and per page count (spine = pages × ~0.057 mm on cream; their bleed is **0.139 in**, not 0.125). Save it as `manuscript/notionpress-cover-template-<N>pp.pdf`. **New page count → new template.**
2. Back-cover text: the ~100-word blurb in `manuscript/print-back-cover.txt`, paragraphs separated by blank lines.
3. Measure where the front art's own lettering sits (fractions of the art: x0,y0,x1,y1).
4. Build:

```bash
python3 scripts/build-cover.py <front-art.jpg> manuscript/print-back-cover.txt \
  manuscript/<Book>-print-cover.pdf "<Title>" manuscript/notionpress-cover-template-<N>pp.pdf x0,y0,x1,y1
```

It reads page size, trim/spine lines, the pink safe zones and the blue barcode box straight off the template. Front art is scaled so its lettering sits 0.12 in inside the safe zone; uncovered edges are filled by smearing the art's own edge pixels (mirroring showed reversed letters). Back and spine are one flat dark colour from the art (a blurred photo posterised into blotches in their preview). Output is a lossless PNG in a PDF at the template's exact size. The barcode and MRP go in the blue box; Notion Press adds them.

Render the result and look at the front edges and the back before uploading.

**KDP cover:** same builder, KDP geometry. KDP's spine is thicker than Notion Press's (cream: 0.0025 in/page vs ~0.0022), so the two covers are separate files.

```bash
python3 scripts/kdp-cover-template.py <pages> manuscript/kdp-cover-template-<N>pp.pdf cream
python3 scripts/build-cover.py <front-art> manuscript/print-back-cover.txt \
  manuscript/<Book>-kdp-cover.pdf "<Title>" manuscript/kdp-cover-template-<N>pp.pdf x0,y0,x1,y1
```

The template script draws KDP's published spec in Notion Press's template colours (0.125 in bleed, text 0.125 in inside trim, a 2 × 1.2 in barcode box 0.25 in from spine and bottom), so `build-cover.py` reads it unchanged. Use the same front art and lettering box as the Notion Press cover. Leave the barcode to KDP ("Does your cover include a barcode?" unchecked).

## KDP paperback — upload sheet fields

Write `manuscript/upload-kdp-paperback.md`. Create it from the Bookshelf's **"+ Create paperback"** under the ebook so the two formats link; Details copy over from the ebook.

- **Details:** check title, author, description, keywords carried over. **Categories do not carry over**: print uses the *Books ›* tree, which differs from *Kindle Books ›*. Pick the nearest three (Divya: SF › Genetic Engineering, Thrillers › Technothrillers, Mystery › International Mystery & Crime; *Partners in Crime*: Thrillers › Psychological, Literature & Fiction › Literary, Mystery, Thriller & Suspense › Crime).
- **ISBN:** the author's call, before anything else on the Content tab, because KDP won't process the files until one is set and it can't be changed after. Free KDP ISBN = imprint "Independently published", usable only on KDP. Own ISBN (free from India's government ISBN agency, isbn.gov.in; takes days to weeks) = imprint `Saroj Anand`, portable to IngramSpark later.
- **Print options:** B&W, **cream**, 5.5 × 8.5, **No Bleed**, lamination as on Notion Press (**gloss for dark covers, matte for light**). Groundwood paper is cheaper but its spine width differs; the template script only knows cream and white.
- **Files:** interior PDF; then select **"Upload a cover you already have"** *before* uploading the cover PDF (same trap as the ebook).
- **AI content:** copy the ebook's three answers exactly.
- **Rights & Pricing:** all territories (the Amazon.in import listing is a harmless ghost SKU; Notion Press wins there on price and delivery). Floor = print cost ÷ 0.6; the Pricing tab shows the minimum per marketplace once the interior is processed — read it there rather than computing it. **Royalty is 50% below $9.99 and 60% at or above** (thresholds £7.99, €9.99, CA/AU $13.99, ¥1,000, 40 zł, 110 kr), so when the floor sits just under a threshold, price at the threshold (Divya: floor $9.15 → $9.99 earns $1.42 instead of ~$0). Otherwise reach pricing: at or just above the floor, round local prices set by hand per store (auto-conversion gives £7.41-style figures). Typing into the price boxes works; setting them by script doesn't register. **Expanded Distribution: off** (it sends the book to Ingram under KDP's terms; with an own ISBN it collides with a later IngramSpark listing of that ISBN).
- **Before Publish:** Launch Previewer and fix anything it flags. **Proofs come from Notion Press, not KDP** — KDP won't ship proof copies to the author in India, and both editions print the same interior PDF, so the Notion Press copy is the proof. Publish is the human's click (or on explicit request). The Publish button's first click often doesn't register; screenshot and click again.
- **The Content page's dropdowns (new look, Sept 2026)** are custom widgets: `form_input` can't set them, scripted mouse events hang the tab. Click the box (sometimes twice), read the option positions from the DOM, click the option. Radios and file inputs behave normally.

## Notion Press — the site's quirks

- **Choose "Upload Print Ready file" for both interior and cover.** That path is print only (no Notion Press ebook, which would duplicate Kindle) and takes ~7 days of human review. The 2-day formatting tool re-typesets the book and adds an ebook.
- Step 1: language, title (capitalised exactly), author, Fiction.
- Step 2: size 5.5 × 8.5 · B&W · **cream** · lamination **gloss for dark covers, matte for light**. Their size clicks don't always register; uploading the PDF offers "Change to 5.5 × 8.5" — accept it. A size change **clears the interior and cover**; re-upload both. Re-check paper type after any change (it has flipped to White).
- **Upload the cover by hand.** The page only treats a file as a cover when "Upload & Preview" is clicked by a person; an automated file upload lands in the interior slot and breaks the page count ("page extent must be 18–750"). If that appears, re-upload the interior, then have the human do the cover. A "text outside safe area" warning is advisory.
- Step 3: select the **Global Distribution** plan (₹4,290 one-time, Sept 2026) or earnings show 70% instead of 80% · paperback MRP at/near the floor · **Hardcase 0 · International 0 (India-only; confirmed by their support)** · the human clicks **Pay and Continue**. The "Upgrade to Amazon and Flipkart" button after payment is an upsell anchor; the plan already includes them.
- Step 4: description (the blurb), author bio, **5 keywords in ≤100 characters** (the field silently truncates), **one** category from their tree (Trade/General › Fiction › …). Save as Draft, then verify by reloading in a new tab. The three Terms checkboxes and **Submit Book** are the human's.
- Imprint: their ISBN lists Publisher: Notion Press. Ask support whether an author-supplied Indian ISBN is accepted.

## After everything is live

- Record IDs, links, ASIN, Books2Read link in the sheets; put store links and the final blurb on the author site (`~/sarojanand/public/books.html`, push deploys). Keep the store descriptions and the site in sync with the back cover.
- Commit the book's `manuscript/` changes after each stage.
