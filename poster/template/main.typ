// An assertion-evidence poster. Before filling it in:
//   1. Write the main finding as one sentence: that is the title.
//   2. Write each section's message as a sentence: those are the headings.
//   3. Sketch two or three layouts on paper; keep the one where the evidence
//      is largest.
// Then replace every [placeholder]. Keep paragraphs to four sentences or
// fewer; let the figures carry the argument.
//
// Sizes: "a0" (default, 2 columns), "a0-landscape", "a1", "48x36", "36x48",
// "16:9" (e-poster). Build: typst compile main.typ

#import "@preview/sci-propos-poster:0.1.0": *

#show: poster.with(
  size: "a0",
  title: [#ph[A sentence that states the main finding, in plain words]],
  authors: [#ph[First Author]#inst(1), #ph[Second Author]#inst(2)],
  affiliation: [#inst(1)#ph[Department, University, City] · #inst(2)#ph[Organization, City]],
  // An orienting picture (the system, the site, the question) and the two
  // or three results a passer-by should take away.
  graphic: rect(width: 100%, height: 140mm, fill: luma(225), stroke: none,
    align(center + horizon, text(fill: luma(70))[#ph[Orienting picture]])),
  points: (
    [#ph[First key result, with its number]],
    [#ph[Second key result]],
    [#ph[What it means, or what comes next]],
  ),
  qr: "https://example.org",
  qr-caption: [#ph[Paper, data and code]],
  contact: [#ph[Name] · #ph[email\@example.org]],
  references: [[1] #ph[Author, title, journal volume, pages (year).]],
  acknowledgments: [#ph[Funding agency, grant number.]],
  logos: box(width: 150mm, height: 40mm, stroke: 1pt + luma(150),
    align(center + horizon, text(fill: luma(90))[#ph[Logos]])),
)

= #ph[The question, and why it matters, in one sentence]

#ph[Two or three sentences a non-specialist can follow: the problem, the
gap, and what this work tried.]

#figure(rect(width: 100%, height: 180mm, fill: luma(235), stroke: none,
  align(center + horizon, text(fill: luma(90))[#ph[Figure that shows the problem]])),
  caption: [#ph[What to notice in this figure.]])

= #ph[What was done, stated as a result where possible]

#ph[The method in a few sentences; the details go behind the QR code.]

#figure(rect(width: 100%, height: 160mm, fill: luma(235), stroke: none,
  align(center + horizon, text(fill: luma(90))[#ph[Set-up or method diagram]])),
  caption: [#ph[Call out the parts that matter.]])

#colbreak()

= #ph[The main result, as a sentence with its number]

#figure(rect(width: 100%, height: 260mm, fill: luma(235), stroke: none,
  align(center + horizon, text(fill: luma(90))[#ph[The largest figure: the evidence]])),
  caption: [#ph[Axes, units, and what the reader should see.]])

= #ph[What the result means, or what comes next]

#ph[One short paragraph. End with the next step or an invitation to talk.]
