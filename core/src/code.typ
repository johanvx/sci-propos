// Code panels, labels, code beside its output, numbered figures in slides.

#import "config.typ": cfg
#import "helpers.typ": tr

/// A highlighted listing on a light panel. Lines never wrap.
///
/// - code (str): the source, e.g. ```` ```typst ...```.text ````.
/// - lang (str): highlighting language ("typst", "latex", "sh", "python", …).
#let code-panel(code, lang: "typst", size: auto, leading: auto) = context {
  let c = cfg()
  block(width: 100%, above: 0.9em, below: 0.9em, fill: luma(246), inset: (x: 10pt, y: 8pt), radius: 4pt)[
    // A show-set on raw (not a plain `set text`): the theme sets the code size
    // with `show raw.where(block: true): set text(..)`, which a surrounding
    // `set text` cannot override.
    #show raw.where(block: true): set text(size: if size == auto { c.code-size } else { size })
    #show raw.where(block: true): set block(above: 0pt, below: 0pt)
    #show raw.line: it => box(it.body)
    #set par(leading: if leading == auto { c.code-leading } else { leading }, spacing: 0pt)
    #raw(code, lang: lang, block: true)
  ]
}

/// A small bold gray label above a panel or an output.
#let labelled(label, body) = context stack(dir: ttb, spacing: 6pt,
  text(size: 0.8em, weight: "bold", fill: cfg().muted.darken(25%), label),
  { set block(above: 0pt, below: 0pt); body },
)

/// Split a source into its first line (an import: shown, not evaluated) and the rest.
#let split-import(code) = (
  prefix: code.split("\n").first() + "\n",
  body: code.split("\n").slice(1).join("\n"),
)

/// Typst code on the left, its evaluated output on the right: the output is
/// produced from the very string that is displayed.
///
/// - scope (dictionary): names the code uses (imported functions, data).
/// - display-prefix (str): shown above the code, not evaluated (import lines).
/// - output (function): wraps the evaluated output (size, numbering, scaling).
#let demo(
  code,
  scope: (:),
  display-prefix: "",
  columns: (1.2fr, 1fr),
  gutter: 18pt,
  code-size: auto,
  code-leading: auto,
  output: body => body,
) = grid(
  columns: columns, column-gutter: gutter, align: left + horizon,
  code-panel(display-prefix + code, size: code-size, leading: code-leading),
  output(eval(code, mode: "markup", scope: scope)),
)

/// Number the `figure`s inside `body` from 1 with a supplement, e.g.
/// `output: numbered()` → "Figure 1: …" in the deck's language.
#let numbered(kind: "sp-figure", supplement: auto, size: 0.8em) = body => context {
  set text(size: size)
  set figure(kind: kind, supplement: if supplement == auto { tr("figure") } else { supplement }, numbering: "1")
  counter(figure.where(kind: kind)).update(0)
  body
}

/// Wrap a lovelace `pseudocode-list(numbered-title: …)` so its title reads
/// "Algorithm 1: …" inside slides.
#let algorithm-figure(body, supplement: auto) = context {
  show figure.caption: none
  counter(figure.where(kind: "algorithm")).update(0)
  figure(body, kind: "algorithm", supplement: if supplement == auto { tr("algorithm") } else { supplement },
    numbering: "1", caption: [], gap: 0pt)
}
