// The same content on every size: compile with --input size=… for each of
// a0, a0-landscape, a1, 48x36, 36x48, 16:9. Expect 1 page each.
#import "../../lib.typ": *
#let size = sys.inputs.at("size", default: "a0")

#show: poster.with(
  size: size,
  title: [The type scales with the page, so every size reads alike],
  authors: [#ph[Ada Author]],
  affiliation: [#ph[University]],
  graphic: rect(width: 100%, height: 80mm, fill: luma(225)),
  points: ([First result.], [Second result.]),
  qr: "https://example.org",
  contact: [#ph[email\@example.org]],
)

= The first section states its message

#lorem(25)
#figure(rect(width: 100%, height: 90mm, fill: luma(235)), caption: [A caption.])

= The second section states its message

#lorem(25)
#figure(rect(width: 100%, height: 90mm, fill: luma(235)), caption: [A caption.])

= The third section states its message

#lorem(25)
