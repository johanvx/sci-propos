# Example: a conference talk and its poster

A test of the `scientific-presentation` and `scientific-poster` skills: a
short research talk built with the assertion-evidence approach, first in
Typst, then ported to PowerPoint, and the same work as a poster in three
sizes. The topic is invented and the data are illustrative.

| File | |
|---|---|
| `talk.typ`, `figures.typ` | The deck, on `sci-propos-presentation`; the figures are drawn in plain Typst |
| `talk.pptx` | The PowerPoint port, on `presentation-sans.potx` |
| `previews/talk.pdf` | The Typst slides |
| `previews/talk-handout.pdf` | The notes handout: each slide above its script, key phrases and references |
| `previews/talk-pptx.pdf` | The PowerPoint port, rendered by LibreOffice |
| `previews/sheet-typst.png`, `sheet-pptx.png` | Contact sheets of both |
| `poster.typ` | The poster, on `sci-propos-poster`, reusing the talk's figures |
| `previews/poster-a0.pdf`, `poster-48x36.pdf`, `poster-16x9.pdf` | The poster in A0 portrait, 48 × 36 in landscape and as a 16:9 e-poster |
| `previews/sheet-posters.png` | The three posters side by side |

## What the talk shows

It follows the skill's conference-talk recipe:

- a title slide with an orienting graph, then the `"map"` outline (one
  picture per part) and section pages without descriptions;
- six content slides, each with a short title, a one-sentence lead and one
  piece of evidence (graph, bar comparison, drawing with call-outs,
  calibration plot, field record, fouling record);
- the conclusion slide as the last regular slide, with three points beside
  miniatures of earlier figures and the contact band;
- one backup slide with a three-line table, outside the total.

Read the leads alone and they tell the story. Each slide's notes hold a
timed rehearsal script (9 minutes in all), three or four key phrases, and
placeholders for full references; the first and last sentences are marked
to learn by heart.

## Building

```sh
typst compile talk.typ
typst compile --input handout=notes talk.typ talk-handout.pdf
typst compile poster.typ                         # A0 portrait
typst compile --input size=48x36 poster.typ      # landscape
typst compile --input size=16:9 poster.typ       # e-poster
```

`sci-propos-presentation` and `sci-propos-poster` must be installed first
(see the repository README).

## What the poster shows

- The title is the talk's conclusion as one sentence.
- An orienting picture with three highlights sits under the title on the
  portrait poster and at the top of the first column on the landscape ones.
- Each section is headed by its message, the same sentences as the slide
  leads, over the slide figures enlarged 1.4–1.65 times so their labels
  read at poster distance.
- The bottom band has the QR code, contact, references, acknowledgments and
  logos.
- The same source gives one page in all three sizes: columns fill in order,
  and each section stays in one column.

## How the PowerPoint port was made

The port follows the skill's porting rules. With python-pptx:

1. Copy `presentation-sans.potx`, change its main content type back to
   `presentation.main+xml`, and delete the style-guide slides.
2. Add one slide per Typst slide by layout name: Title with Image, Outline
   Map, Section with Image, Title Only, Conclusion.
3. Fill the title, lead and credit placeholders with the same text, and copy
   each speaker note as plain text.
4. For the figures, compile a copy of the deck with
   `#show <sp-lead>: hide` and `#show <sp-credit>: hide`, render it at
   300 dpi, crop each figure, and insert it at its native size, centered in
   the body area. The miniatures, map tiles and QR code are cropped the same
   way.
5. Rebuild the backup table as a native three-line table.
6. python-pptx doesn't copy footer and slide-number placeholders from a
   layout: copy them from the layout into each slide, write the locator
   text ("1 Need ·"), and add " / 12" after the number field on the regular
   slides.

Deviations from the Typst deck: Office fonts (Calibri), figures and
call-outs as pictures rather than native shapes, a static total, and a
footer locator that sits a little apart from the number.
