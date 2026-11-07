// Title color, title rule off, math font override; title slide not counted.
#import "../../lib.typ": *
#show: presentation-theme.with(
  config-info(title: [Options test]),
  title-color: rgb("#8a4b08"),
  title-rule: false,
  math-font: "Noto Sans Math",
)
#title-slide()
#outline-slide()
= One
== A slide
$ integral_0^oo e^(-x) dif x = 1 $
