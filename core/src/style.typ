// The shared look: text, lists, emphasis, code, three-line tables, quotes and
// captions. Each theme (presentation, poster, document) applies it once.

#import "config.typ": sp-config
#import "strings.typ": text-lang
#import "text.typ": LaTeX

/// Apply the shared rules and store `conf` for the helpers.
///
/// - conf (dictionary): the theme's configuration (defaults + options).
/// - fonts (dictionary): from `resolve-fonts`.
/// - key (str): a language key from `lang-key`.
#let sp-style(conf, fonts, key, body) = {
  let primary = conf.primary
  set text(font: fonts.text, size: conf.base-size, fill: conf.text-color, ..text-lang(key))
  set par(leading: 0.6em, spacing: 1em, justify: false)
  show math.equation: set text(font: fonts.math)
  show math.equation.where(block: true): set align(conf.at("math-align", default: left))
  // lists: colored markers, steady line boxes, numbers that don't shift on #pause
  set list(marker: (text(fill: primary)[•], text(fill: primary)[‣], [–]), spacing: 0.8em, indent: 0.2em)
  set enum(spacing: 0.8em, indent: 0.2em)
  set terms(spacing: 0.8em)
  show enum: set text(number-width: "tabular")
  show list: it => { set list(spacing: 0.5em); it }
  show enum: it => { set enum(spacing: 0.5em); it }
  // emphasis: primary color; Chinese has no italics
  show emph: it => text(fill: primary, style: if fonts.cjk { "normal" } else { "italic" }, it.body)
  show strong: it => text(fill: primary, weight: "bold", it.body)
  show link: set text(fill: primary)
  // code
  show raw: set text(font: fonts.code)
  show raw.where(block: true): set text(size: conf.code-size)
  show raw.where(block: false): set text(size: 1.2em)
  // tables: three-line style by default
  set table(stroke: none, inset: (x: 0.7em, y: 0.45em))
  show table: it => {
    if it.has("label") and it.label == <sp-table> { it } else {
      [#table(
        columns: it.columns, align: it.align, inset: it.inset, stroke: none, fill: it.fill,
        table.hline(y: 0, stroke: conf.at("table-rule", default: 1.5pt)),
        table.hline(y: 1, stroke: conf.at("table-midrule", default: 0.5pt)),
        ..it.children,
        table.hline(stroke: conf.at("table-rule", default: 1.5pt)),
      )<sp-table>]
    }
  }
  show table.cell.where(y: 0): set text(weight: "bold")
  // quotes, captions, footnotes
  show quote.where(block: true): it => block(width: 100%,
    stroke: (left: 2pt + primary.lighten(40%)), inset: (left: 1em, y: 0.3em))[
    #it.body
    #if it.attribution != none { block(above: 0.5em, text(size: 0.8em, fill: primary)[— #it.attribution]) }
  ]
  show figure.caption: set text(size: 0.8em)
  show footnote.entry: set text(size: 0.65em)
  show "LaTeX": LaTeX
  sp-config.update(conf)
  body
}
