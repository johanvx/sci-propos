// Regression tests for reported issues. Each slide says what to check.
#import "../../lib.typ": *
#show: presentation-theme.with(config-info(title: [Regressions]), math-align: center)

= Checks

== code-panel size
// Issue 1: `size:` must set the panel's code size (12 pt here, 15 pt below).
#code-panel("int main() { return 0; } // twelve", lang: "cpp", size: 12pt)
#code-panel("int main() { return 0; } // fifteen", lang: "cpp")

== Scoped settings
// Issue 2: settings for one slide, the two supported ways.
#[
  #set text(17pt)
  Seventeen point text, scoped with a content block.
]

#slide(title: [text-size option], text-size: 16pt)[Sixteen point text, from `text-size`.]

#slide(title: [setting option], setting: body => {
  set text(fill: rgb("#8a4b08"))
  body
})[Brown text, from `setting`; the next slide is black again.]

== After the scoped slides
// Issue 2: this must be back at the 20 pt body size.
Twenty point text.

== Display math
// Issue 7: centered, because of `math-align: center`.
$ sqrt(1 - mu^2) $

// Issue 3: no section label on the closing slide.
#thanks-slide(title: [Resources])[- A link]
