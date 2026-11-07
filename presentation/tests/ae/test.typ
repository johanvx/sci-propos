// The assertion-evidence options: section label at the top, logo only on the
// title and closing slides, no descriptions, no lead check, a conclusion with
// one picture and no contact band, a counted black slide.
// Expected: 7 pages; footers show numbers only (label at the top); the
// three-line lead has no red flag; the black slide is page 6 and counted, so
// the conclusion shows 7 / 7 with neither band nor rule at the bottom.
#import "../../lib.typ": *

#show: presentation-theme.with(
  config-info(title: [AE options], author: [#ph[Presenter name]]),
  section-label: "top",
  logo-on: "title-closing",
  descriptions: false,
  checks: false,
)

#title-slide()
#outline-slide()

= First part
a description that must not show

== A sentence lead
#lead[This lead is far too long for two lines, but the check is switched off, so no flag appears on this slide at all, even though the sentence keeps going well past the second line of the slide]
#align(center, rect(width: 300pt, height: 120pt, fill: luma(230)))

== Without lead
Content only.

#black-slide(count: true)

#conclusion-slide(
  lead: [In summary, the options work],
  points: ([Label at the top], [Logo on title and closing only]),
  image: rect(width: 200pt, height: 120pt, fill: luma(230)),
  contact: none,
  questions: none,
)
