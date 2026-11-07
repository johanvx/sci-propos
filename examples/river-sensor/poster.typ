// Example: the river-sensor work as an assertion-evidence poster, built with
// the scientific-poster skill. The data are illustrative.
//
// Build:  typst compile poster.typ                      (A0 portrait, 2 columns)
//         typst compile --input size=48x36 poster.typ   (landscape, 3 columns)
//         typst compile --input size=16:9 poster.typ    (e-poster, 4 columns)
// Needs sci-propos-poster 0.1.0 installed (see the repository README).

#import "@preview/sci-propos-poster:0.1.0": *
#import "figures.typ": storms, sensor, calibration, fieldplot, fouling

#let size = sys.inputs.at("size", default: "a0")
#let portrait = size == "a0"

// The slide figures, enlarged so that their labels read at poster distance.
// The space above each figure leaves room for its axis title.
#let big(body, f: (a0: 165%, "48x36": 140%, "16:9": 130%).at(size, default: 140%)) = block(above: 2.4em, below: 1.2em, align(center, scale(f, reflow: true, body)))

#show: poster.with(
  size: size,
  title: [A \$120 optical sensor records storm-driven river turbidity within 5 % of a laboratory instrument],
  authors: [#ph[First Author]#inst(1), #ph[Second Author]#inst(1), #ph[Third Author]#inst(2)],
  affiliation: [#inst(1)#ph[Department], #ph[University], #ph[City] · #inst(2)#ph[Watershed association], #ph[City]],
  graphic: rect(width: 100%, height: if portrait { 120mm } else { 110mm }, fill: luma(225), stroke: none,
    align(center + horizon, text(fill: luma(70))[#ph[Photo: the sensor on its river mount]])),
  points: (
    [Weekly samples miss the storms that carry most sediment],
    [Scattered and transmitted light give a linear, drift-free reading],
    [With a wiper, six months stayed within 5 % of the reference],
  ),
  qr: "https://example.org/turbidity",
  qr-caption: [Paper, data and design files],
  contact: [#ph[First Author] · #ph[email\@example.org]],
  references: [
    [1] #ph[Author, title, journal volume, pages (year)]: share of sediment carried by storms. \
    [2] ISO 7027-1:2016, Water quality — Determination of turbidity.
  ],
  acknowledgments: [#ph[Funding agency, grant number]; #ph[the volunteers of the watershed association].],
  logos: box(width: 150mm, height: 40mm, stroke: 1pt + luma(150),
    align(center + horizon, text(fill: luma(90))[#ph[Logos]])),
)

= Weekly samples miss the storms that carry most of the sediment

Between storms, the river runs near 20 NTU; during them, it rises into the
hundreds. Weekly grab samples (green) land on quiet days [1].

#big(storms())

= Two photodiodes measure scattered and transmitted light

An infrared LED shines across the water. The ratio of the two signals rises
with turbidity and cancels the slow drift of the LED.

#align(center, block(above: 2.4em, below: 2.6em, annotate(scale(if portrait { 170% } else { 140% }, reflow: true, sensor(w: 360pt)),
  (x: 16%, y: 50%, dx: -10pt, dy: -90pt, label: [LED]),
  (x: 50%, y: 28%, dx: 60pt, dy: -80pt, label: [river water]),
  (x: 87%, y: 50%, dx: 0pt, dy: -110pt, label: [transmitted]),
  (x: 50%, y: 92%, dx: 160pt, dy: 20pt, label: [scattered, at 90°]),
)))



= The output is linear up to 1000 NTU

Eight formazin standards [2] fall on one straight line ($R^2 = 0.999$), so a
single slope converts volts to NTU.

#big(calibration())


= Over six months, daily means stayed within 5 % of the reference

Beside a laboratory instrument, the sensor tracked every storm season.

#big(fieldplot())



= Algae biased readings by 8 % a week until a wiper cleared the window

An hourly wiper, fitted after week 4, kept the error near 1 %.

#big(fouling())

= Next: forty sites across one watershed

For the price of one laboratory instrument, a watershed group can watch
forty sites through every storm. Winter tests and other rivers come next.
