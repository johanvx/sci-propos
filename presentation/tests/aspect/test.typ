#import "../../lib.typ": *
#show: presentation-theme.with(
  aspect-ratio: "4-3",
  config-info(title: [Smoke test], subtitle: [Does it compile?], author: [#ph[Presenter]], date: datetime(year: 2026, month: 10, day: 30)),
  files: p => path(p),
)
#title-slide()
#outline-slide()

= Background
why this matters

== First slide
#lead[The point of the slide.]
- one
- two
#credit[Source: nowhere]

== Second slide
Plain text.

= Method
what we did

== Third
#pause
After pause.

= Summary
== Takeaways
+ A
+ B
