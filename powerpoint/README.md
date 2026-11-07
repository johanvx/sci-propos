# sci-propos for PowerPoint

`presentation-sans.potx` and `presentation-serif.potx` are PowerPoint templates
in the look of the `sci-propos-presentation` Typst package. Each has one Slide
Master, 20 layouts and a 21-slide style guide written as a short
assertion-evidence talk (the data are illustrative).

- **Layouts:** Title, Title with Image, Outline, Outline Map, Section, Section
  with Image, Title and Content, Two Content, Picture with Call-outs, Code and
  Output, Content with Aside, Step, Title Only, Conclusion, Contact, Closing,
  Thank You, Focus, Black, Blank.
- **Style guide:** a title page with an orienting picture, the outline in both
  styles, section pages, sentence leads over native charts, a picture with
  call-outs, code beside its output, side cards, a three-line table, a step
  slide, the conclusion and contact slides, a black slide, the course endings
  and a backup slide. Every slide has speaker notes that say which layout it
  uses and how.

Double-click a template to start a new presentation from it. Then:

- **Logo:** replace the `[Logo]` box once, in View › Slide Master. It sits top
  right on every layout; the title layouts have their own.
- **Short title and lead:** each content slide has a short title (to find the
  slide) and a lead line under it: the slide's point as one full sentence with
  a verb, at most two lines, in sentence case, with no final period. The lead
  doesn't shrink: if it runs to three lines, shorten the sentence.
- **Evidence:** below the lead, a chart, a picture with call-outs, a short
  table, an equation or code. Bullets are allowed when no stronger form fits.
- **Charts:** the style guide's charts are native: double-click one to edit
  its data. Gray bars, the bar that matters in green.
- **Call-outs:** copy a label and its line from the Picture with Call-outs
  slide. Keep labels to a few words.
- **Footer locator:** Insert › Header & Footer › Footer, then type the part,
  for instance `2 Results ·`, and tick "Don't show on title slide". The text
  sits before the slide number, in green at 14 pt; the number is dark gray.
  Set it per slide (Apply) when the part changes.
- **Outline and section pages:** copy the outline from the style guide. The
  current section green with its description black, the others gray.
  Descriptions are optional. Outline Map is the mapping slide: one picture per
  part, repeated on the first slide of that part.
- **Conclusion:** the last slide of a research talk, kept up during questions.
  The lead starts with "In summary,"; up to three points, each beside a
  miniature of a figure shown earlier; a band with a photo, contact line, QR
  code and "Questions?". Leave the band's placeholders empty to drop it.
- **Contact:** for promotional talks, a page whose lead repeats the takeaway,
  with a photo, the group's details and a QR code.
- **Black:** a black page for a stretch of talk where no visual helps.
- **Course endings:** Closing (links, an optional QR code, the thank-you line),
  or Closing with its thank-you line left empty and then Thank You.
- **Cards:** copy one from the style guide and edit its text. The frame style
  is under Shape Outline › Dashes (solid, dashed, dotted). At most 25 words.
- **Handout:** the second slide is hidden in the slide show and tells readers
  to look at the notes. Print the deck as File › Print › Notes Pages.
- **QR codes:** PowerPoint can't draw them. Make one elsewhere (for instance
  with Typst's tiaoma package) and insert it as a picture.
- **Fonts:** fonts that come with Office on Windows and Mac, so nothing needs
  installing: Calibri (sans) or Cambria (serif), Consolas for code, and
  DengXian (sans) or SimSun (serif) for Chinese. For Traditional Chinese, pick
  Microsoft JhengHei or PMingLiU in Design › Variants › Fonts › Customize
  Fonts, or rebuild with `SP_CJK=Hant`.

Empty placeholders don't show in the slide show. Titles typed in PowerPoint
shrink when they overflow, so they stay on one line. The thesis-style outline
(dotted leaders) isn't available in PowerPoint.

## Posters

`posters/` holds poster templates in the look of the `sci-propos-poster`
Typst package, in sans and serif:

| File | Size | Columns |
|---|---|---|
| `poster-a0-*.potx` | A0 portrait, 841 × 1189 mm | 2 |
| `poster-48x36-*.potx` | 48 × 36 in landscape | 3 |
| `poster-16x9-*.potx` | 16:9 e-poster, 48 × 27 in | 4 |

Each has one slide at the poster's real size, so its type sizes are the
printed ones: title 84 pt, section messages 44 pt, body 30 pt, captions
24 pt, bottom band 21 pt on A0 (scaled with the page area on the other
sizes). The title, authors and affiliation are placeholders; the sections,
gray picture boxes, highlights and bottom band are ordinary shapes to edit,
move or delete. The speaker notes repeat the rules. Replace the QR code
(it points to example.org) and the logo box. Print at 100 %.

`previews/sheet-posters-sans.png` shows the three sizes.

## Rebuilding

`source/` rebuilds the templates (pptxgenjs 4.0.1, Python 3). From `source/`,
with pptxgenjs installed (`npm install pptxgenjs@4.0.1`):

```sh
SP_STYLE=sans node -e 'process.stdout.write(JSON.stringify(require("./style.js").THEME))' > theme.json
SP_STYLE=sans node build_template.js assets raw.pptx
python3 finish.py raw.pptx ../presentation-sans.potx --theme theme.json
```

Repeat with `SP_STYLE=serif` and `../presentation-serif.potx`.

The posters, from `source/` (for each size `a0`, `48x36`, `16:9`, and each
style):

```sh
SP_STYLE=sans node build_poster.js a0 assets raw.pptx
python3 finish.py raw.pptx ../posters/poster-a0-sans.potx --theme theme.json --no-logo
```

Then check the
result: convert a copy saved as `.pptx` to PDF (`soffice --headless
--convert-to pdf`) and look at every page.

Build variables: `SP_STYLE=sans|serif`; `SP_FONTS=office|noto` (`noto` uses
the Typst package's Noto fonts, which Office doesn't ship: install them where
you present, or embed them via File › Options › Save › Embed fonts in the
file); `SP_CJK=Hans|Hant`.

`finish.py` options for decks built from `style.js`:

- `--total`: write " / N" after the slide numbers. N stops before the first
  section named "Appendix" or "Backup" (or set it with `--total-n N`), so
  backup slides show their number alone. Templates are built without it.
- `--no-logo`: no logo box on the master or the title layouts.
- The `locator` placeholder of each layout becomes a footer, so Insert ›
  Header & Footer fills it. In a built deck, give the text with
  `s.addText("2 Results ·", { placeholder: "locator" })`.
- SVG pictures get a real PNG fallback (pptxgenjs writes a broken one in
  Node), rendered with `rsvg-convert`, Inkscape or Node's `sharp`, whichever
  is installed.

Helpers in `style.js` for decks built in code: `addTitle(slide, text)` sizes a
long title so it stays on one line; `addCallout(slide, [px, py], [lx, ly],
text)` draws a dot at the point, a line and the label; `addCard`, `addCode`,
`outlineRuns`, `paras`, `rich` and `pkgRun` build the style guide's other
elements. (A `fontSize` in a placeholder's options is ignored by pptxgenjs; it
has to be on the run.)
