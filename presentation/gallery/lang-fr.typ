// Language sample: fr. Build: typst compile --root . gallery/lang-fr.typ
#import "../lib.typ": *
#show: presentation-theme.with(
  config-info(title: [Diapos en français], subtitle: [Un thème académique pour Touying], author: [#ph[Présentation]], date: datetime(year: 2026, month: 10, day: 30)),
  lang: "fr",
  style: sys.inputs.at("style", default: "sans"),
  files: p => path(p),
)
#title-slide()
#outline-slide()

= Contexte
pourquoi c'est important

== Une idée par diapositive
#lead[La phrase d'accroche résume la diapositive.]
#aside(
  [
    - Une liste verticale
    - Deux colonnes au plus
    - _Fluence_ / *Fluence*
  ],
  card-deck(term[Fluence][Flux intégré dans le temps.], card(kind: "reminder")[Unités : cm⁻².], card(kind: "recap")[Deux colonnes au plus]),
)

= Méthode
ce que nous avons fait

== Un tableau
#table(columns: 3, [A], [B], [C], [1], [2], [3], [4], [5], [6])

= Bilan
à retenir

#thanks-slide()
