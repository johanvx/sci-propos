// A research paper in manuscript form (illustrative data). Authors,
// affiliations and some references are placeholders.
// Build (from the package folder): typst compile --root . gallery/paper-en.typ

#import "../lib.typ": *
#import "paper-figures.typ": calibration-plot

#show: paper.with(
  title: [A Low-Cost Optical Sensor for Continuous Monitoring of Storm-Driven River Turbidity],
  authors: ([#ph[First Author]#inst(1)], [#ph[Second Author]#inst(1)], [#ph[Third Author]#inst(2)]),
  affiliations: ([#ph[Department], #ph[University], #ph[City], #ph[Country]],
    [#ph[Watershed association], #ph[City], #ph[Country]]),
  correspondence: [Corresponding author: #ph[email\@example.org]],
  abstract: [
    Most of the sediment that a small river carries in a year passes during a few storms, which
    weekly grab samples seldom catch. We present an optical turbidity sensor that volunteers can
    build for about \$120 in parts and service without tools. An infrared LED shines across a
    flow-through tube; one photodiode measures the transmitted light and a second, at 90°, the
    scattered light, and their ratio cancels the drift of the LED. Against formazin standards,
    the output was linear up to 1000 NTU ($R^2 = 0.999$). Installed beside a laboratory-grade
    instrument for six months, the sensor's daily means stayed within 5 % of the reference once
    an hourly wiper kept algae off the window. Such sensors could let a watershed group monitor
    forty sites for the price of one commercial instrument.
  ],
  keywords: [turbidity; suspended sediment; low-cost sensor; citizen science; storm events],
)

= Introduction

Suspended sediment carries nutrients and pollutants downstream, buries spawning gravel, and
raises the cost of treating drinking water. In small rivers, most of the annual load moves
during a few storms, when turbidity can rise from below 20 NTU to several hundred NTU within
hours. Measuring these events requires continuous records, yet the instruments that provide
them cost several thousand dollars a site, and volunteer groups therefore rely on weekly grab
samples.

Low-cost turbidity sensors have been built before, but most measure only transmitted light,
which saturates at high turbidity, or only scattered light, which drifts as the light source
ages #ph[(Author, year; Author, year)]. Few have been tested against a reference instrument
through a full season of storms.

This paper presents a sensor that combines both measurements, describes its calibration, and
reports a six-month comparison with a laboratory-grade instrument. Section 2 describes the
design and the tests, Section 3 the results, and Section 4 their limits and uses.

= Methods

== Sensor design

The sensor is a 40 mm tube through which river water flows. An 860 nm LED shines across the
tube; a photodiode opposite the LED measures the transmitted light, and a second photodiode at
90° measures the light scattered by particles. The ratio of the two signals rises with
turbidity and does not depend on the brightness of the LED. A wiper sweeps the optical windows
once an hour.

== Calibration and field test

We calibrated three sensors against formazin standards at eight levels from 0 to 1000 NTU, as
specified by ISO 7027 @iso7027. We then installed one sensor beside a laboratory-grade
turbidimeter at #ph[site] for six months and compared the daily means of the two records.

= Results

== The output is linear up to 1000 NTU

@fig:cal shows the output of one sensor against the formazin standards. A straight line through
the origin fits all eight points with $R^2 = 0.999$, so a single slope converts the output to
turbidity. The slopes of the three sensors differed by less than 4 %.

#figure(
  calibration-plot(),
  caption: [Output of one sensor against formazin standards. The line is a least-squares fit
    through the origin.],
) <fig:cal>

== Algae on the window caused the only drift

During the first month, before the wiper was fitted, readings rose by about 8 % a week relative
to the reference as algae grew on the windows. After the wiper was fitted, the difference
stayed near 1 %, and over the remaining five months the daily means of the two instruments
agreed within 5 % (@tab:field).

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    [Period], [Days], [Mean difference], [Largest difference],
    [Without wiper], [28], [+17 %], [+32 %],
    [With wiper], [152], [+0.8 %], [+4.6 %],
  ),
  caption: [Difference between the daily means of the sensor and the reference instrument],
) <tab:field>

= Discussion

Agreement within 5 % is about the spread between two laboratory instruments measuring the
same sample, so the sensor is as close to the reference as a second reference would be. The
test covered one river and one season; rivers with coarser or darker sediment may need their
own calibration. The cost of parts, about \$120, would let a watershed group monitor forty
sites for the price of one commercial instrument.

= Conclusions

A sensor that measures both transmitted and scattered light, and wipes its own window, can
record storm-driven turbidity within 5 % of a laboratory instrument. Tests on rivers with other
sediments, and over winter, are the next step.

#bibliography("refs.bib", style: "chicago-author-date")
