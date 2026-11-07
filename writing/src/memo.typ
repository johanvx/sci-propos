// Memos and memo reports: a heading block (Date, To, From, Subject), then
// sections. Alley's model design reports use this form.

#import "@preview/sci-propos-core:0.1.0": format-date, lang-key, cfg
#import "base.typ": document-setup
#import "strings.typ": wword

/// A memo or memo report.
///
/// ```
/// #show: memo.with(
///   to: [#ph[Client name], #ph[Organization]],
///   from: [#ph[Team name]: #ph[Member one], #ph[Member two]],
///   subject: [Initial research for the design of a wheelchair-operated dispenser],
/// )
/// ```
///
/// - subject (content): the document type and its scope, not a one-word label.
/// - kind (content, none): an optional word above the block ("Memorandum").
/// - note (content, none): footer text on the left, e.g. the course and term.
/// - numbered (bool): numbered section headings (off by default in memos).
#let memo(
  to: none,
  from: none,
  cc: none,
  date: auto,
  subject: none,
  kind: none,
  note: none,
  lang: "en",
  style: "serif",
  paper: "a4",
  size: auto,
  justify: auto,
  numbered: false,
  primary: auto,
  font: auto,
  heading-font: auto,
  cjk-font: auto,
  code-font: auto,
  math-font: auto,
  body,
) = {
  let key = lang-key(lang)
  set document(title: if type(subject) == content { subject } else { none })
  let footer = context {
    let n = counter(page).get().first()
    let total = counter(page).final().first()
    set text(size: 0.85 * cfg().base-size, fill: luma(80))
    grid(columns: (1fr, auto), if note != none { note }, if total > 1 [#n / #total])
  }
  show: document-setup.with(kind: "memo", lang: lang, style: style, paper: paper, size: size,
    justify: justify, numbered: numbered, footer: footer, primary: primary, font: font, heading-font: heading-font,
    cjk-font: cjk-font, code-font: code-font, math-font: math-font)
  context {
    let c = cfg()
    let label(name) = text(font: c.heading-font, weight: "bold", wword(key, name))
    let rows = ()
    rows += (label("date"), if date == auto { format-date(key, datetime.today()) } else { format-date(key, date) })
    if to != none { rows += (label("to"), to) }
    if from != none { rows += (label("from"), from) }
    if cc != none { rows += (label("cc"), cc) }
    if subject != none { rows += (label("subject"), text(weight: "bold", subject)) }
    block(width: 100%, below: 1.6em, {
      set par(first-line-indent: 0pt, justify: false)
      if kind != none { block(below: 1em, text(font: c.heading-font, size: 1.6em, weight: "bold", kind)) }
      grid(columns: (auto, 1fr), column-gutter: 1.2em, row-gutter: 0.75em, align: (right, left), ..rows)
      v(0.9em)
      line(length: 100%, stroke: 0.8pt + luma(60))
    })
  }
  body
}
