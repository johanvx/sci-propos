// The shared page and text setup of every document type.
//
// Alley's format rules for documents (The Craft of Scientific Writing,
// Appendix D): serif body text, bold sans-serif headings and call-outs,
// captions below figures and above tables, references author-year or
// numbered, a type-size ladder from title to text.

#import "@preview/sci-propos-core:0.1.0": defaults, sp-style, resolve-fonts, lang-key, format-date, reject-unknown
#import "strings.typ": wword

#let doc-defaults = (
  base-size: 11pt,      // Noto Serif sets larger than Times: 11 pt reads like Times at 12 pt
  code-size: 9.5pt,
  heading-sizes: (15pt, 12.5pt, 11pt, 11pt),
  title-size: 20pt,
)

/// Paper sizes and their margins.
#let _margins(paper) = if paper == "us-letter" {
  (x: 1in, top: 1in, bottom: 1in)
} else {
  (x: 2.5cm, top: 2.5cm, bottom: 2.5cm)
}

/// The fonts of a document: body in `style`, headings always in bold sans.
#let doc-fonts(style, key, font: auto, heading-font: auto, cjk-font: auto, code-font: auto, math-font: auto) = {
  let body = resolve-fonts(style, key, font: font, cjk-font: cjk-font, code-font: code-font, math-font: math-font)
  let head = resolve-fonts("sans", key, font: heading-font, code-font: code-font, math-font: math-font)
  (body: body, head: head.text)
}

/// Apply the document look. `kind` is "letter", "memo", "report" or "paper".
/// Returns the styled body.
#let document-setup(
  kind: "report",
  lang: "en",
  style: "serif",
  paper: "a4",
  size: auto,
  justify: auto,
  numbered: true,
  primary: auto,
  font: auto,
  heading-font: auto,
  cjk-font: auto,
  code-font: auto,
  math-font: auto,
  footer: auto,
  header: none,
  body,
) = {
  assert(style in ("serif", "sans"), message: kind + ": style must be \"serif\" or \"sans\"")
  assert(paper in ("a4", "us-letter"), message: kind + ": paper must be \"a4\" or \"us-letter\"")
  let primary = if primary == auto { defaults.primary } else { primary }
  assert(type(primary) == color, message: kind + ": primary must be a color, e.g. rgb(\"#b31b1b\")")
  let key = lang-key(lang)
  let cjk = key in ("zh-Hans", "zh-Hant")
  let fonts = doc-fonts(style, key, font: font, heading-font: heading-font, cjk-font: cjk-font,
    code-font: code-font, math-font: math-font)
  let base = if size == auto { doc-defaults.base-size } else { size }
  let scale = base / doc-defaults.base-size
  let justify = if justify == auto { key != "en" } else { justify }
  let conf = defaults + (
    primary: primary, lang: key, style: style, base-size: base,
    code-size: doc-defaults.code-size * scale, credit-size: 0.85 * base,
    math-align: center,
    doc-kind: kind, heading-font: fonts.head,
  )
  let hs = doc-defaults.heading-sizes.map(s => s * scale)
  let footer = if footer == auto {
    context {
      let n = counter(page).get().first()
      let total = counter(page).final().first()
      if total > 1 { align(center, text(size: 0.85 * base, fill: luma(80), str(n))) }
    }
  } else { footer }

  set page(paper: paper, margin: _margins(paper), header: header, footer: footer)
  show: sp-style.with(conf, fonts.body, key)
  set text(size: base, hyphenate: not cjk and justify)
  // Paragraphs: block style with space between (English, French); in Chinese,
  // the usual two-character first-line indent.
  set par(justify: justify, leading: if cjk { 0.85em } else { 0.62em },
    spacing: if cjk { 0.85em } else { 1.0em },
    first-line-indent: if cjk { (amount: 2em, all: true) } else { 0pt })
  // Documents are printed: black emphasis, italic (color in Chinese), black list markers.
  show emph: it => if cjk { text(weight: "bold", it.body) } else { text(style: "italic", it.body) }
  show strong: it => text(weight: "bold", it.body)
  set list(marker: ([•], [–], [·]), indent: 0.6em, spacing: 0.65em)
  set enum(indent: 0.6em, spacing: 0.65em)
  show list: set par(first-line-indent: 0pt)
  show enum: set par(first-line-indent: 0pt)
  show link: set text(fill: primary)
  // Headings: bold sans, the size ladder of Alley's Appendix D.
  set heading(numbering: if numbered { "1.1" } else { none })
  show heading: set text(font: fonts.head, weight: "bold", fill: luma(20))
  show heading: set par(first-line-indent: 0pt, justify: false)
  show heading: set text(hyphenate: false)
  show heading.where(level: 1): set text(size: hs.at(0))
  show heading.where(level: 2): set text(size: hs.at(1))
  show heading.where(level: 3): set text(size: hs.at(2))
  show heading: it => {
    let l = calc.min(it.level, 3) - 1
    // Space between the number and the title, as in "2.1  Procedures".
    block(above: (1.7em, 1.4em, 1.2em).at(l), below: (0.8em, 0.7em, 0.6em).at(l), sticky: true,
      if it.numbering == none { it.body } else [#counter(heading).display(it.numbering)#h(0.6em)#it.body])
  }
  // Figures: caption below a figure, above a table; label in bold sans.
  set figure(gap: 0.8em)
  show figure.where(kind: table): set figure.caption(position: top)
  // French reports write "Figure 1" in full, as English ones do.
  show figure.where(kind: image): set figure(supplement: if key == "fr" [Figure] else { auto })
  set figure.caption(separator: wword(key, "caption-sep"))
  show figure.caption: it => {
    set par(first-line-indent: 0pt, justify: false)
    set text(size: 0.9 * base)
    let cap = {
      text(font: fonts.head, weight: "bold", [#it.supplement#if not cjk [ ]#context it.counter.display(it.numbering)])
      it.separator
      it.body
    }
    // A one-line caption is centered under its figure; a longer one is set flush left.
    layout(size => {
      let one-line = measure(cap).width <= size.width
      block(width: 100%, align(if one-line { center } else { left }, cap))
    })
  }
  show figure: set block(above: 1.4em, below: 1.4em)
  set math.equation(numbering: if numbered { "(1)" } else { none })
  // References: a heading in the document's style.
  set bibliography(title: wword(key, "references"))
  show outline.entry.where(level: 1): set text(weight: "bold")
  set outline(title: wword(key, "contents"), indent: auto)
  show footnote.entry: set text(size: 0.85 * base)
  set footnote.entry(indent: 0pt, separator: line(length: 30%, stroke: 0.5pt + luma(110)))
  // Tables a little smaller than the text, never justified.
  show table: set text(size: 0.92 * base)
  show table: set par(justify: false, first-line-indent: 0pt)
  show table: set text(hyphenate: false)
  show raw.where(block: true): set par(justify: false)
  show raw.where(block: true): it => block(width: 100%, fill: luma(246), inset: (x: 10pt, y: 8pt), radius: 3pt, it)
  body
}
