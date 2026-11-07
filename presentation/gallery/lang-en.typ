// Language sample: en. Build: typst compile --root . gallery/lang-en.typ
#import "../lib.typ": *
#show: presentation-theme.with(
  config-info(title: [Diapos in English], subtitle: [An academic theme for Touying], author: [#ph[Presenter]], date: datetime(year: 2026, month: 10, day: 30)),
  lang: "en",
  style: sys.inputs.at("style", default: "sans"),
  files: p => path(p),
)
#title-slide()
#outline-slide()

= Background
why this matters

== One idea per slide
#lead[The lead line states the point of the slide.]
#aside(
  [
    - Lists of three or more are vertical
    - At most two columns
    - _Fluence_ / *Fluence*
  ],
  card-deck(term[Fluence][Flux integrated over time.], card(kind: "reminder")[Units: cm⁻².], card(kind: "recap")[At most two columns]),
)

= Method
what we did

== A table
#table(columns: 3, [A], [B], [C], [1], [2], [3], [4], [5], [6])

= Summary
takeaways and questions

#thanks-slide()
