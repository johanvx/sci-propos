// Closing slides: one page (Resources + QR + thank-you line), or two
// (Resources + QR, then a thank-you page with no heading and no label).
#import "../../lib.typ": *
#show: presentation-theme.with(config-info(title: [Closing slides]), logo: none)

= Last section
== A content slide
Its label reads "1. Last section".

#thanks-slide(title: [Resources], qr: "https://typst.app/universe")[
  - Typst — #link("https://typst.app")[typst.app]
  - Touying — #link("https://touying-typ.github.io")[touying-typ.github.io]
]

#resources-slide(qr: "https://touying-typ.github.io", qr-caption: [Slides and links])[
  - Typst — #link("https://typst.app")[typst.app]
  - Touying — #link("https://touying-typ.github.io")[touying-typ.github.io]
]

#thanks-slide()

#thanks-slide(qr: "https://typst.app")

#resources-slide(qr: image(bytes("<svg xmlns='http://www.w3.org/2000/svg' width='10' height='10'><rect width='10' height='10' fill='gray'/></svg>"), width: 2cm))[
  Your own picture instead of a generated code.
]
