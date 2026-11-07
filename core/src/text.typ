// Text helpers: credit lines, placeholders, package names, sizes, citations,
// and the TeX/LaTeX logos.

#import "config.typ": cfg

/// A small gray line for sources, versions and notes ("Illustrative data").
/// On a slide, at the top level of its body, it is moved to the bottom.
#let credit(body) = [#context block(width: 100%, above: 0pt, below: 0pt,
  text(size: cfg().credit-size, fill: cfg().credit-color, body))<sp-credit>]

/// Placeholder text the author must replace: `#ph[Presenter name]`.
#let ph(body) = context text(fill: cfg().primary)[\[#body\]]

/// A package or tool name in running text.
#let pkg(name) = context box(
  fill: cfg().primary.lighten(88%), inset: (x: 0.2em, y: 0.12em), outset: (y: 0.08em), radius: 0.15em,
  text(fill: cfg().primary, raw(name)),
)

/// Relative text sizes.
#let large(body) = text(size: 1.2em, body)
#let small(body) = text(size: 0.8em, body)
#let tiny(body) = text(size: 0.65em, body)

/// Tighter lists for dense slides.
#let compact(spacing: 0.45em, body) = {
  set list(spacing: spacing)
  set enum(spacing: spacing)
  set terms(spacing: spacing)
  body
}

/// Push what follows to the bottom (vertical) or right (horizontal).
#let vfill = v(1fr)
#let hfill = h(1fr)

/// Citations: "Author (Year)", "(Author, Year)", in a footnote.
#let citet(key) = cite(key, form: "prose")
#let citep(key) = cite(key, form: "normal")
#let footcite(key) = footnote(cite(key, form: "prose"))

/// The TeX logo; em-based, so it works at any size.
#let TeX = box[T#h(-0.12em)#text(baseline: 0.22em)[E]#h(-0.1em)X]

/// The LaTeX logo; em-based, so it works at any size.
#let LaTeX = box[L#h(-0.26em)#text(size: 0.7em, baseline: -0.3em)[A]#h(-0.1em)#TeX]
