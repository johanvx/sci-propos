// Example: a 10-minute conference talk built with the scientific-presentation
// skill (assertion-evidence slides). The data are illustrative.
//
// Build:    typst compile talk.typ
// Handout:  typst compile --input handout=notes talk.typ talk-handout.pdf
// Needs sci-propos-presentation 0.1.0 installed (see the repository README).

#import "@preview/sci-propos-presentation:0.1.0": *
#import "figures.typ": *

#show: presentation-theme.with(
  config-info(
    title: [A low-cost optical sensor for storm-driven river turbidity],
    subtitle: [Continuous readings within 5 % of a laboratory instrument],
    author: [#ph[Presenter name]],
    institution: [#ph[Department] · #ph[University]],
    date: [#ph[Conference] · #ph[Date]],
  ),
  outline-style: "map",
  descriptions: false,
  contact: (
    photo: box(width: 54pt, height: 54pt, fill: green.lighten(85%), radius: 3pt,
      align(center + horizon, text(size: 9pt, fill: green)[#ph[Photo]])),
    lines: [#ph[Group name] · #ph[email\@example.org]],
    qr: "https://example.org",
  ),
)

#title-slide(image: storms(w: 300pt, h: 150pt))
#speaker-note[
  *0:00–0:45 (0:45).* Learn by heart: "Most of the mud a river carries in a year passes in a few days, and we usually aren't there to measure it." This graph is one month of turbidity on a small river: three storms, and the green dots are the weekly samples we normally take. Today I'll show a sensor that catches the storms for about a hundred and twenty dollars.

  Key phrases: most sediment in a few days · weekly samples miss storms · \$120 sensor.
]

#outline-slide()
#speaker-note[
  *0:45–1:05 (0:20).* The talk has three parts: why grab samples miss the storms, how the sensor works, and what six months in the river showed.

  Key phrases: need · sensor · field test.
]

= Need
#section-image(storms(small: true, w: 200pt, h: 110pt))

== Storm loads
#lead[Storms carry most of the sediment, yet weekly samples miss them]
#align(center, storms())
#credit[Illustrative record; sediment share after #ph[Author, year].]
#speaker-note[
  *1:05–2:20 (1:15).* Here is the month again, larger. Time runs left to right; turbidity goes up the side. Between storms the river sits near 20 NTU. During the three storms it jumps to between 130 and 330. Integrated over the month, those few days carry most of the sediment. Now look at the green dots: the weekly visits land on quiet days, so the samples report a clean river.

  Key phrases: quiet near 20 NTU · storms in the hundreds · samples land on quiet days.

  Reference: #ph[Author, title, journal, volume, pages, year] (share of annual load carried by storms).
]

== Cost
#lead[A laboratory turbidimeter costs about 40 times the parts of our sensor]
#align(center, block(width: 420pt, {
  set text(size: 18pt)
  let bar(label, v, value, c) = grid(columns: (150pt, 1fr), align: (right + horizon, left + horizon), gutter: 12pt,
    label, box(width: v * 250pt, height: 34pt, fill: c, inset: (left: 8pt), align(horizon, text(fill: white, weight: "bold", value))))
  bar([laboratory unit], 1.0, [\$4 800], luma(170))
  v(16pt)
  bar([our sensor], 0.04, [], green)
  place(dx: 172pt + 0.04 * 250pt, dy: -27pt, text(fill: green, weight: "bold")[\$120])
}))
#credit[Illustrative prices for one site, #ph[year].]
#speaker-note[
  *2:20–3:05 (0:45).* Continuous monitoring exists, but a laboratory-grade turbidimeter costs about four thousand eight hundred dollars a site. The parts of our sensor cost a hundred and twenty. That difference decides whether a watershed group can afford one site or forty.

  Key phrases: \$4 800 against \$120 · one site or forty.
]

= Sensor
#section-image(sensor(w: 200pt))

== Optics
#lead[An infrared LED and two photodiodes measure scattered and transmitted light]
#align(center, annotate(sensor(w: 420pt),
  (x: 16%, y: 50%, dx: -10pt, dy: -70pt, label: [infrared LED]),
  (x: 50%, y: 28%, dx: 40pt, dy: -50pt, label: [river water]),
  (x: 87%, y: 50%, dx: 30pt, dy: -70pt, label: [transmitted]),
  (x: 50%, y: 92%, dx: 140pt, dy: 10pt, label: [scattered, at 90°]),
))
#speaker-note[
  *3:05–4:20 (1:15).* The sensor is a short tube with river water flowing through it. An infrared LED shines across the water. One photodiode, straight ahead, sees the light that gets through. The other, at ninety degrees, sees the light that particles scatter. Their ratio rises with turbidity and cancels slow drift of the LED.

  Key phrases: LED across the water · straight through · scattered at 90° · ratio cancels drift.
]

== Calibration
#lead[The output is linear against formazin standards up to 1000 NTU]
#align(center, calibration())
#credit[Illustrative calibration, eight standards.]
#speaker-note[
  *4:20–5:20 (1:00).* We calibrated against formazin standards, the usual reference for turbidity. Across the axis, the standard; up the side, the sensor's output. The points sit on one straight line up to a thousand NTU, with R squared of 0.999. So one slope converts volts to NTU.

  Key phrases: formazin standards · straight to 1000 NTU · one slope.

  Reference: #ph[ISO 7027-1, year] (formazin standards).
]

= Field test
#section-image(fieldplot(small: true, w: 200pt, h: 110pt))

== Agreement
#lead[Over six months, daily means stayed within 5 % of the reference]
#align(center, fieldplot())
#credit[Illustrative record, #ph[River name], #ph[dates].]
#speaker-note[
  *5:20–6:50 (1:30).* We then installed the sensor beside a laboratory-grade instrument for six months. The thick gray line is the reference instrument, the thin green line is our sensor, both as daily means. They track each other through every storm season; the largest difference was under five percent.

  Key phrases: beside a reference · six months · within 5 %.
]

== Fouling
#lead[Algae raised readings by 8 % a week until a wiper cleared the window]
#align(center, fouling())
#credit[Illustrative data, first deployment.]
#speaker-note[
  *6:50–8:00 (1:10).* That agreement needed one change. In the first month, algae grew on the window, and readings climbed about eight percent a week. After week four we fitted a small wiper that sweeps the window every hour. From then on, the error stayed near one percent.

  Key phrases: algae on the window · 8 % a week · hourly wiper · near 1 %.
]

#conclusion-slide(
  lead: [In summary, a \$120 sensor records storm-driven turbidity within 5 % of a laboratory instrument],
  points: (
    [Weekly samples miss the storms that carry most sediment],
    [Scattered and transmitted light give a linear, drift-free reading],
    [With a wiper, six months stayed within 5 % of the reference],
  ),
  figures: (storms(small: true, w: 90pt, h: 50pt), sensor(w: 90pt), fieldplot(small: true, w: 90pt, h: 50pt)),
)
#speaker-note[
  *8:00–9:00 (1:00).* So, three points. Weekly samples miss the storms. Two photodiodes give a reading that is linear and doesn't drift. And with a wiper, six months in the river stayed within five percent of the reference. Learn by heart: "For the price of one laboratory instrument, a watershed can now watch forty sites through every storm." Pause; thank the audience; invite questions.

  Key phrases: miss the storms · linear, drift-free · within 5 % · forty sites.
]

#show: appendix

== Power budget
#lead[The wiper uses 2 % of the battery budget]
#align(center, table(
  columns: 3,
  [Load], [Energy per day (Wh)], [Share],
  [Optics and logger], [1.90], [93 %],
  [Radio], [0.10], [5 %],
  [Wiper], [0.04], [2 %],
))
#credit[Illustrative values.]
#speaker-note[For questions on battery life: the wiper adds two percent; a 20 Wh battery lasts about ten days without the solar panel.]
