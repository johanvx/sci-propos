// Complete showcase of sci-propos-presentation.
//
// Every feature is marked with where it comes from:
//   [theme]   this theme          [Touying]  the Touying framework
//   [Typst]   built into Typst
//
// Build (from the package folder):
//   typst compile --root . gallery/complete.typ
// Variants used for the comparison sheets:
//   --input style=serif   --input outline=thesis

#import "../lib.typ": *

#let opt(key, default) = sys.inputs.at(key, default: default)

// [theme]  One theme call. config-info fills the title slide and the PDF metadata.
#show: presentation-theme.with(
  config-info(
    title: [sci-propos-presentation],
    subtitle: [A complete tour of the theme],
    author: [#ph[Presenter name]],
    institution: [#ph[Department] · #ph[University]],
    date: datetime(year: 2026, month: 10, day: 30),
  ),
  style: opt("style", "sans"),          // "sans" (default) or "serif"
  outline-style: opt("outline", "parts"), // "parts" (default) or "thesis"
  files: p => path(p),                   // lets the theme open logo.svg and shots/
)

// [theme]  Title page, then the outline. Sections come from `=` headings.
#title-slide()
#speaker-note[Every slide can carry a word-for-word script.]

#outline-slide()

// [theme]  A section page appears at every `= Section`, the first included.
// The line under the heading is the section's description in the outline.
= Slide types
the building blocks of a deck

// [theme]  `== Title` makes a content slide: section label, title, rule.
== Text formatting
#lead[The lead line states the point of the slide in one sentence.]

- *Bold* and _emphasis_ use the primary color
- #link("https://typst.app")[Links] too; `inline code` matches the text
- Package names stand out: #pkg("touying"), #pkg("fletcher")
- Footnotes work as usual#footnote[Like this one.]

#credit[Credit line: sources, versions, "illustrative data".]

== Lists
#lead[Bullets, numbers and terms share one rhythm.]

#two-columns[
  - A bullet list
    - with a second level
  - and a third item

  + First step
  + Second step
][
  / Flux: path length per volume and time
  / Fluence: flux integrated over time
  / Dose: energy absorbed per mass
]

== Content stays balanced
#lead[`#lead` goes to the top, `#credit` to the bottom, content in between.]

Whatever the order in the source, the content block is centered in the
space between the lead line and the credit line.

#credit[Use `#slide(align: top)[...]` to pin content to the top instead.]

= Layout
two columns, side cards, tables, figures

== Two columns
#lead[At most two columns; both start at the same top.]

#two-columns(ratio: (1.2fr, 1fr))[
  *Left column*

  Text, code or a picture. `two-columns(ratio: (1.2fr, 1fr))` sets the widths.
][
  *Right column*

  Captions sit right under their picture, never floating away.
]

== Side cards
#lead[A deck of cards beside the content holds side material.]

#aside(
  [
    - The main points of the slide go here
    - Definitions, reminders and recaps go in the cards
    - Cards have a frame on one side only
  ],
  card-deck(
    term[Fluence][Flux integrated over time.],
    card(kind: "reminder")[Units: cm#super[−2].],
    card(kind: "recap")[Flux → fluence → dose.],
  ),
)

== Card kinds
#lead[Five kinds: solid, dashed or dotted frame, on any side.]

#two-columns[
  #card-deck(
    card(kind: "note")[A side note in a solid frame.],
    term[Neutron flux][Path length per volume and time.],
    card(kind: "intro", title: [Typst])[A markup language with scripting.],
  )
][
  #card-deck(
    card(kind: "recap")[Dashed frame: what we just saw.],
    card(kind: "reminder")[Dotted frame: don't forget this.],
    card(kind: (label: [Custom], frame: "dashed"), accent: rgb("#8a4b08"), side: right)[
      Any label, frame, color and side.
    ],
  )
]

== Tables and math
#lead[Tables get the three-line style without asking.]

#two-columns[
  #table(
    columns: 3,
    [Nuclide], [Half-life], [Unit],
    [Xe-133], [5.25], [d],
    [I-131], [8.02], [d],
    [Ba-140], [12.75], [d],
  )
][
  Decay of a single nuclide:
  $ N(t) = N_0 dot 2^(-t \/ T_(1\/2)) $
  with half-life $T_(1\/2)$.
]
#credit[Illustrative values.]

== Figures and quotes
#two-columns[
  #figure(
    rect(width: 80%, height: 90pt, fill: luma(240), stroke: none, align(center + horizon)[a figure]),
    caption: [A captioned figure],
  )
][
  #quote(block: true, attribution: [G. E. P. Box])[
    All models are wrong, but some are useful.
  ]
]

== A pipeline
#lead[One row of boxes is the usual exception to two columns.]

#pipeline(([Write], [.typ source]), ([Export], [PDF · SVG · PNG]), ([Place], [LaTeX, Word, PowerPoint]))

= Code
code beside its output

== Code beside its output
#lead[#pkg("demo") evaluates the very string it displays.]

#let src = ```typst
#let half = 8.02
$ N(t) = N_0 dot 2^(-t \/ #half) $
```.text
#demo(src)
#credit[The output on the right is produced from the code on the left.]

== Labelled panels
#lead[Labels sit 6 pt above their panel.]

#two-columns(
  labelled([Shell], code-panel("typst compile deck.typ\ntypst watch deck.typ", lang: "sh")),
  labelled([Python], code-panel("import typst\ntypst.compile(\"deck.typ\")", lang: "python")),
)

= Procedures
one step per slide, full-window screenshots

== Windows · 1/2 · Open the settings
#step("win-1")[Open *File › Options*, then click *Trust Center*.]

== Windows · 2/2 · Add the catalog
#step("win-2")[Paste the share path into *Catalog Url* and click *Add catalog*.]

= Animations
Touying's reveals work unchanged

== Incremental reveals
#lead[`#pause` shows one point per click.]

- Visible from the start
#pause
- Appears on the second click
#pause
- Appears on the third click

#credit[The slide number stays the same across clicks.]

= Options
switches of the theme and of single slides

== Theme options
#code-panel(```typst
#show: presentation-theme.with(
  lang: "en",              // "fr", "zh-Hans", "zh-Hant"
  style: "sans",           // or "serif"
  slide-level: 2,          // 3 adds subsections
  outline-style: "parts",  // or "thesis"
  numbering: (section: true, subsection: true, title: false),
  section-label: "top",
  title-rule: true,
  files: p => path(p),
)
```.text)

#slide(title: [Per-slide options], align: top, section-label: none)[
  This slide is pinned to the top and hides its section label:

  #code-panel(```typst
  #slide(title: [...], align: top, section-label: none)[...]
  ```.text)
]

#focus-slide[One sentence on the primary color.]

// One closing page: links, a QR code and the thank-you line. (Or two pages:
// `#resources-slide(qr: ...)[links]`, then `#thanks-slide()`.)
#thanks-slide(title: [Resources], qr: "https://touying-typ.github.io")[
  - Touying — #link("https://touying-typ.github.io")[touying-typ.github.io]
  - Typst — #link("https://typst.app")[typst.app]
]

// [Touying] Backup slides: they keep counting, but the total stops at the
// last regular slide, and their footer shows the number alone.
#show: appendix

== Backup: more details
#lead[Appendix slides don't inflate the total in the footer.]
