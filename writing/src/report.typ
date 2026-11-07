// Formal reports (design, laboratory, technical) and research papers.

#import "@preview/sci-propos-core:0.1.0": format-date, lang-key, cfg
#import "base.typ": document-setup, doc-defaults
#import "strings.typ": wword

#let _fmt-date(key, date) = if date == auto { format-date(key, datetime.today()) } else { format-date(key, date) }

#let _people(authors, key) = if type(authors) == array {
  if key in ("zh-Hans", "zh-Hant") { authors.join([、]) }
  else { authors.join([, ], last: if key == "fr" [ et ] else [ and ]) }
} else { authors }

/// A summary or abstract block: a bold sans label, then the text.
#let _summary-block(label, body, keywords: none, key: "en") = context {
  let c = cfg()
  block(width: 100%, above: 1.6em, below: 1.8em, {
    set par(first-line-indent: 0pt)
    block(below: 0.6em, text(font: c.heading-font, weight: "bold", size: 1.05em, label))
    body
    if keywords != none {
      block(above: 0.9em, [#text(font: c.heading-font, weight: "bold", wword(key, "keywords")) #h(0.3em) #keywords])
    }
  })
}

/// A report: design report, laboratory report, technical report.
///
/// ```
/// #show: report.with(
///   kind: [Laboratory report],
///   title: [Heat transfer from a heated cylinder in cross-flow],
///   authors: ([#ph[Author one]], [#ph[Author two]]),
///   affiliation: [#ph[Course] · #ph[University]],
///   summary: [An informative summary: scope, method, results with numbers, meaning.],
/// )
/// ```
///
/// - kind (content, none): the document type, shown above the title.
/// - summary (content, none): the informative summary (results with numbers).
/// - summary-title (content, auto): `auto` = "Summary" in the document's language.
/// - toc (bool): a table of contents after the summary (long reports).
/// - title-page (bool): title block alone on the first page.
#let report(
  title: none,
  subtitle: none,
  kind: none,
  authors: none,
  affiliation: none,
  date: auto,
  summary: none,
  summary-title: auto,
  keywords: none,
  toc: false,
  title-page: false,
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
  body,
) = {
  let key = lang-key(lang)
  set document(title: if type(title) == content { title } else { none })
  show: document-setup.with(kind: "report", lang: lang, style: style, paper: paper, size: size,
    justify: justify, numbered: numbered, primary: primary, font: font, heading-font: heading-font, cjk-font: cjk-font,
    code-font: code-font, math-font: math-font)
  context {
    let c = cfg()
    let head = c.heading-font
    block(width: 100%, below: if title-page { 0pt } else { 1.2em }, {
      set par(first-line-indent: 0pt, justify: false)
      set text(hyphenate: false)
      if kind != none {
        block(below: 0.8em, text(font: head, size: 0.95em, weight: "bold", fill: c.primary, kind))
      }
      if title != none {
        block(below: 0.6em, text(font: head, size: doc-defaults.title-size * (c.base-size / doc-defaults.base-size),
          weight: "bold", title))
      }
      if subtitle != none { block(below: 1em, text(font: head, size: 1.2em, subtitle)) }
      v(0.4em)
      if authors != none { block(below: 0.35em, _people(authors, key)) }
      if affiliation != none { block(below: 0.35em, affiliation) }
      if date != none { block(below: 0.35em, text(fill: luma(80), _fmt-date(key, date))) }
      v(0.6em)
      line(length: 100%, stroke: 0.6pt + luma(160))
    })
  }
  if title-page { pagebreak() }
  if summary != none {
    _summary-block(if summary-title == auto { wword(key, "summary") } else { summary-title }, summary,
      keywords: keywords, key: key)
  }
  if toc { outline(); pagebreak(weak: true) }
  body
}

/// A research paper (a single-column manuscript or preprint).
///
/// - authors (array): `([Ada Lovelace#inst(1)], [Alan Turing#inst(1, 2)])`.
/// - affiliations (array): `([Dept., University], [Lab, Institute])`, numbered in order.
/// - correspondence (content): e.g. `[#ph[email\@example.org]]`.
#let paper(
  title: none,
  authors: (),
  affiliations: (),
  correspondence: none,
  date: none,
  abstract: none,
  keywords: none,
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
  body,
) = {
  let key = lang-key(lang)
  set document(title: if type(title) == content { title } else { none })
  show: document-setup.with(kind: "paper", lang: lang, style: style, paper: paper, size: size,
    justify: justify, numbered: numbered, primary: primary, font: font, heading-font: heading-font, cjk-font: cjk-font,
    code-font: code-font, math-font: math-font)
  context {
    let c = cfg()
    block(width: 100%, below: 0.6em, {
      set par(first-line-indent: 0pt, justify: false)
      set text(hyphenate: false)
      block(below: 1em, text(font: c.heading-font, size: 18pt * (c.base-size / doc-defaults.base-size),
        weight: "bold", title))
      if authors.len() > 0 { block(below: 0.6em, authors.join([, ])) }
      set text(size: 0.9em, fill: luma(60))
      for (i, a) in affiliations.enumerate() {
        block(above: 0.25em, below: 0.25em, [#super[#(i + 1)]#a])
      }
      if correspondence != none { block(above: 0.5em, correspondence) }
      if date != none { block(above: 0.5em, _fmt-date(key, date)) }
    })
  }
  if abstract != none { _summary-block(wword(key, "abstract"), abstract, keywords: keywords, key: key) }
  body
}

/// Appendices: `#show: appendix` before the first one. Each starts on a new
/// page as "Appendix A: Title"; its figures, tables and equations are
/// numbered A-1, A-2, (A-1).
#let appendix(body) = {
  counter(heading).update(0)
  let letter(n) = numbering("A", n)
  let prefix() = letter(counter(heading).get().first())
  set heading(supplement: context wword(cfg().lang, "appendix"), numbering: (..n) => {
    let n = n.pos()
    if n.len() == 1 { letter(n.first()) } else { numbering("A.1", ..n) }
  })
  show heading.where(level: 1): it => {
    // Unnumbered headings (the references after the appendices) stay as they are.
    if it.numbering == none { return it }
    pagebreak(weak: true)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    counter(math.equation).update(0)
    context {
      let c = cfg()
      let key = c.lang
      block(above: 0pt, below: 1em, sticky: true, text(font: c.heading-font, weight: "bold",
        size: doc-defaults.heading-sizes.at(0) * (c.base-size / doc-defaults.base-size),
        [#wword(key, "appendix") #counter(heading).display(it.numbering)#if key in ("zh-Hans", "zh-Hant") [　] else if key == "fr" [~: ] else [: ]#it.body]))
    }
  }
  set figure(numbering: n => context [#prefix()-#n])
  set math.equation(numbering: n => context [(#prefix()-#n)])
  body
}
