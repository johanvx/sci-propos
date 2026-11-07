// Three heading levels (sections, subsections, slides) with the thesis-style
// outline. Build: typst compile --root . gallery/subsections.typ
// Variants: --input outline=parts  --input numbering=off  --input titles=on
#import "../lib.typ": *

#let opt(key, default) = sys.inputs.at(key, default: default)
#let num = opt("numbering", "on")

#show: presentation-theme.with(
  config-info(
    title: [Monte Carlo neutron transport],
    subtitle: [A three-level deck: sections, subsections, slides],
    author: [#ph[Presenter name]],
    institution: [#ph[Department] · #ph[University]],
    date: datetime(year: 2026, month: 10, day: 30),
  ),
  style: opt("style", "sans"),
  slide-level: 3,
  outline-style: opt("outline", "thesis"),
  numbering: (if num == "off" { (section: false, subsection: false) }
    else if num == "sections" { (section: true, subsection: false) }
    else { (section: true, subsection: true) }) + (title: opt("titles", "off") == "on"),
  files: p => path(p),
)

#title-slide()
#outline-slide()

= Physics
cross sections and the transport equation

== Interactions
=== Cross sections
#lead[Each reaction has a probability per unit path length.]
#aside(
  [
    - Scattering, capture, fission
    - Macroscopic: $Sigma = N sigma$
  ],
  term[Cross section][Effective target area of a nucleus, in barns.],
)

=== Mean free path
$ lambda = 1 / Sigma_t $
#credit[Illustrative.]

== Transport
=== The transport equation
#lead[Neutrons stream, collide and are born.]
- Streaming and collisions
- Sources: fission, external

= Method
sampling histories

== Sampling
=== Free flight
$ s = -ln(xi) / Sigma_t $

=== Collision type
- Absorbed with probability $Sigma_a \/ Sigma_t$
- Otherwise scattered

== Tallies
=== Estimators
- Collision estimator
- Track-length estimator

= Results
what the code gives

== Verification
=== Against benchmarks
#table(
  columns: 3,
  [Case], [$k_"eff"$ (MC)], [Reference],
  [Godiva], [0.9995], [1.0000],
  [Jezebel], [1.0003], [1.0000],
)
#credit[Illustrative values.]

// Two closing pages: the resources, then a thank-you page with no heading.
#resources-slide(qr: "https://typst.app/universe")[
  - Typst Universe — #link("https://typst.app/universe")[typst.app/universe]
  - Touying — #link("https://touying-typ.github.io")[touying-typ.github.io]
]

#thanks-slide()
