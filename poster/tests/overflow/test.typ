// Too much content: the poster runs onto a second page, which carries a red
// flag. Expect 2 pages.
#import "../../lib.typ": *
#show: poster.with(title: [Too much text never fits], size: "a1")
= A section with far too much text
#lorem(3000)
