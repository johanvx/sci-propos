// Every element on an A0 poster: band, sections, message figures, a table,
// a list, call-outs, code, and the full bottom band. Expect 1 page.
#import "../../lib.typ": *

#show: poster.with(
  title: [Every element of the poster fits on one A0 page],
  authors: [#ph[Ada Author]#inst(1), #ph[Bo Author]#inst(1, 2)],
  affiliation: [#inst(1)#ph[Department, University] · #inst(2)#ph[Laboratory]],
  graphic: rect(width: 100%, height: 120mm, fill: luma(225)),
  points: [A free-form highlight block also works.],
  qr: "https://example.org/poster",
  contact: [#ph[email\@example.org]],
  references: [[1] #ph[Reference one.] \ [2] #ph[Reference two.]],
  acknowledgments: [#ph[Funding.]],
  logos: box(width: 120mm, height: 30mm, stroke: 1pt + luma(150)),
)

= A section heading is a sentence that can run to two lines

#lorem(30)

#figure(rect(width: 100%, height: 150mm, fill: luma(235)), caption: [A caption under the figure.])

= Two figures can each carry their own message

#grid(columns: (1fr, 1fr), column-gutter: 15mm,
  message[The left one rises][#rect(width: 100%, height: 90mm, fill: luma(235))],
  message[The right one falls][#rect(width: 100%, height: 90mm, fill: luma(235))])

= A short table compares three cases

#figure(table(columns: 3, [Case], [Value], [Unit], [A], [1.00], [--], [B], [0.98], [--]),
  caption: [Tables get their caption above.])

#colbreak()

= Call-outs name the parts of a picture

#align(center, annotate(rect(width: 300mm, height: 160mm, fill: luma(235)),
  (x: 30%, y: 40%, dx: 60mm, dy: -30mm, label: [inlet]),
  (x: 70%, y: 70%, dx: -80mm, dy: 25mm, label: [outlet])))

= Lists stay short

- First point, one line.
- Second point, one line.
- Third point, one line.

= Code can sit beside its output

#code-panel("#show: poster.with(size: \"a0\")", lang: "typst")
