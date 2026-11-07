// A laboratory report (illustrative data). Authors and the course are placeholders.
// Build (from the package folder): typst compile --root . gallery/lab-en.typ

#import "../lib.typ": *
#import "lab-figures.typ": nu-plot, runs, cb, f1, grouped

#show: report.with(
  kind: [Laboratory report],
  title: [Heat Transfer from a Heated Cylinder in Cross-Flow],
  authors: ([#ph[Author one]], [#ph[Author two]]),
  affiliation: [#ph[Course] · #ph[University]],
  date: datetime(year: 2026, month: 11, day: 7),
  summary: [
    This report presents measurements of the heat transfer from a heated copper cylinder,
    25 mm in diameter, placed across the air flow of a wind tunnel. We measured the average
    Nusselt number at six Reynolds numbers between 2 000 and 40 000 and compared it with the
    correlation of Churchill and Bernstein. Over this range, the measured values lie 3 to 7 %
    above the correlation, well inside the 20 % that textbooks give as its uncertainty. The
    largest source of error is the heat lost by conduction through the cylinder's supports,
    which we estimate at 2 % of the heater power. These results support using the correlation
    to size the cooling fins of the #ph[project] heat exchanger.
  ],
)

= Introduction

Engineers size heat exchangers, sensors and electronic coolers with correlations for the heat
transfer from a cylinder in cross-flow. The most widely used, that of Churchill and Bernstein
@churchill1977, covers every Reynolds number for which data exist. Textbooks caution, however,
that such correlations can be in error by as much as 20 % @bergman2011. Before we use it to
size the cooling fins of #ph[project], we need to know how well it predicts the heat transfer
in our own wind tunnel.

This experiment had two objectives: to measure the average Nusselt number of a heated cylinder
at Reynolds numbers from 2 000 to 40 000, and to compare the measurements with the
correlation, which gives

$ overline("Nu")_D = 0.3 + (0.62 thin "Re"_D^(1 slash 2) "Pr"^(1 slash 3))
  / [1 + (0.4 slash "Pr")^(2 slash 3)]^(1 slash 4)
  [1 + ("Re"_D / (282 thin 000))^(5 slash 8)]^(4 slash 5) $ <eq:cb>

where $"Re"_D = V D slash nu$ is the Reynolds number based on the diameter $D$ and Pr is the
Prandtl number of air, 0.71. Section 2 describes the apparatus and the procedure, Section 3
presents and discusses the results, and Section 4 states our conclusions. Appendix A lists the
raw data.

= Procedures

We placed a copper cylinder, 25 mm in diameter and 150 mm long, across the test section of the
laboratory's open-circuit wind tunnel. A cartridge heater inside the cylinder supplied a steady
power, which we measured with a wattmeter, and two thermocouples embedded in the copper gave
its surface temperature. A Pitot tube upstream of the cylinder gave the air speed.

For each of six air speeds between 1.3 and 25.6 m/s, we waited until the surface temperature
changed by less than 0.1 K in five minutes. We then recorded the heater power, the surface
temperature and the air temperature. From these, Newton's law of cooling gives the average heat
transfer coefficient

$ h = P / (A (T_s - T_infinity)) $ <eq:newton>

where $P$ is the heater power less the estimated conduction loss, $A$ the surface area of the
cylinder, $T_s$ the surface temperature and $T_infinity$ the air temperature. The Nusselt number
is then $h D slash k$, with the thermal conductivity $k$ of air at the film temperature.

= Results and Discussion

The measured Nusselt numbers follow the trend of the correlation closely. @fig:nu shows that
they lie 3 to 7 % above it over the whole range, with the largest differences at the lowest
Reynolds numbers.

#figure(
  nu-plot(),
  caption: [Average Nusselt number of the cylinder against the Reynolds number. The bars show
    the scatter of repeated runs (±1.5 %); the line is @eq:cb.],
) <fig:nu>

These differences are much smaller than the uncertainty of the correlation, but they all have
the same sign, which points to a bias rather than random scatter. The most likely source is
the conduction loss through the supports. We estimated this loss at 2 % of the heater power
from the temperature of the supports; if the true loss were twice as large, the measured values
would fall by another 2 %. A second source is the blockage of the test section. Because the
cylinder fills 8 % of its height, the flow speeds up around it, which raises the heat transfer
slightly.

The precision of the measurements is better than their accuracy. Repeated runs at the same
speed agreed within 1.5 %, so random scatter cannot explain the differences from the
correlation.

= Conclusions

Both objectives were met. As the Reynolds number rose from 2 000 to 40 000, the average Nusselt
number rose from about 24 to about 123, and it stayed 3 to 7 % above the Churchill–Bernstein
correlation. This agreement is well inside the correlation's uncertainty. We therefore
recommend using the correlation, with a margin of 10 %, to size the cooling fins of
#ph[project]. A test with insulated supports would show how much of the remaining bias comes
from conduction.

#show: appendix

= Raw Data

@tab:raw lists the measurements of each run and the Nusselt number that @eq:cb predicts. The
air temperature stayed at 22.0 °C throughout; run 1 took the longest to reach a steady state,
about 40 minutes.

#figure(
  table(
    columns: 8,
    align: (center,) + (right,) * 7,
    [Run], [$V$ (m/s)], [$P$ (W)], [$T_s$ (°C)], [$T_infinity$ (°C)], [$"Re"_D$], [$overline("Nu")_D$], [@eq:cb],
    ..runs.map(r => (
      str(r.at(0)), f1(r.at(1)), f1(r.at(2)), f1(r.at(3)), f1(r.at(4)),
      grouped(r.at(5)), f1(r.at(6)), f1(cb(r.at(5))),
    )).flatten(),
  ),
  caption: [Measurements and the Nusselt numbers they give],
) <tab:raw>

#bibliography("refs.bib", style: "chicago-author-date")
