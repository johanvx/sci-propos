// A memo report: the first deliverable of a design project (customer needs
// and specifications). Names, the client and the course are placeholders.
// Build (from the package folder): typst compile --root . gallery/memo-en.typ

#import "../lib.typ": *

#show: memo.with(
  date: datetime(year: 2026, month: 11, day: 7),
  to: [#ph[Client name], #ph[Watershed association]],
  from: [Team #ph[4]: #ph[Member one], #ph[Member two], #ph[Member three]],
  subject: [Customer needs and specifications for a low-cost river turbidity sensor],
  note: [#ph[Course] · #ph[Term]],
)

= Introduction

Muddy water is more than a nuisance in a small river. Suspended sediment carries nutrients and
pollutants downstream, buries the gravel where fish spawn, and raises the cost of treating
drinking water. Most of this sediment moves during a few storms each year. Volunteer groups,
however, can afford only weekly grab samples, and these seldom catch a storm.

The #ph[Watershed association] has asked our team to design a turbidity sensor that its
volunteers can build, install and maintain for less than \$150 a site. In this report, a
_customer_ is a volunteer who installs and services the sensor. The association's staff, who
analyse the data, are secondary customers.

The next section presents the customer needs that we found. The section after it turns each
primary need into a metric with a target value and a test. Appendix A gives our schedule for
the rest of the project.

= Customer Needs

We identified the needs through interviews with four volunteers and two staff members, visits
to two monitoring sites, and the project description @project. We then grouped them into
primary needs, which the design must meet, and secondary needs, which would improve it.

== Primary Needs

*The sensor must stay accurate during storms.* Staff members want readings that they can
compare with laboratory measurements made by the ISO 7027 method @iso7027. Because turbidity
can rise from below 20 NTU to several hundred NTU within hours, the sensor must cover that
whole range.

*The sensor must cost less than \$150 per site.* The association's grant covers forty sites
at that price. At the price of one laboratory instrument, the same grant would cover a single
site.

*Volunteers must be able to service the sensor in the field.* Most volunteers have no training
in electronics, and they visit each site about once a month. Cleaning the optical window and
replacing the battery must therefore take minutes and need no tools.

== Secondary Needs

Volunteers would also like the sensor to send its readings over the phone network, so that
they need not download data on site. They would also like it to be inconspicuous, so that it
is less likely to be stolen or damaged.

= Metrics and Specifications

@tab:specs links each primary need to a metric, a target value, the source of that target, and
the test that will show whether a prototype meets it.

#figure(
  table(
    columns: (0.9fr, 1.3fr, 1fr, 1.3fr, 1.1fr),
    align: left,
    [Need], [Metric], [Target], [Source of target], [Test],
    [Accurate in storms], [Difference from a laboratory turbidimeter], [≤ 5 % over 0–1000 NTU],
      [Staff interviews; range of ISO 7027 @iso7027], [Formazin standards at eight levels],
    [Low cost], [Cost of parts per site], [≤ \$150], [Grant budget for forty sites], [Bill of materials],
    [Field service], [Time to clean the window and change the battery], [≤ 10 min, no tools],
      [Volunteer interviews], [Three volunteers, timed],
  ),
  caption: [Metrics and target values for the primary needs],
) <tab:specs>

The accuracy target needs the most care. A difference of 5 % is about the spread between two
laboratory instruments that measure the same sample. A tighter target would therefore test the
reference instrument rather than our sensor.

= Conclusion

Volunteers need a sensor that stays accurate through storms, costs less than \$150 and can be
serviced without tools; staff members need data that they can compare with laboratory
measurements. In the next phase, we will generate concepts for the optics and the housing and
select one against the targets of @tab:specs. Appendix A shows when each phase ends.

#show: appendix

= Project Schedule

@tab:schedule lists the phases of the project and their end dates. We chose the lead for each
phase by experience: #ph[Member one] has built optical circuits, #ph[Member two] has worked
with data loggers, and #ph[Member three] has run field campaigns.

#figure(
  table(
    columns: 3,
    align: (left, left, right),
    [Phase], [Lead], [Ends],
    [Customer needs and specifications], [#ph[Member three]], [Week 4],
    [Concept generation and selection], [#ph[Member one]], [Week 7],
    [Prototype and laboratory tests], [#ph[Member two]], [Week 11],
    [Field test and final report], [#ph[Member three]], [Week 15],
  ),
  caption: [Phases of the project, with their leads and end dates],
) <tab:schedule>

#bibliography("refs.bib", style: "ieee")
