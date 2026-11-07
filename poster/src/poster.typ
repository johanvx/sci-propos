// The assertion-evidence poster: a sentence title that states the main
// finding, an optional orienting band, columns of sections headed by their
// messages over large evidence, and a band at the bottom with the QR code,
// contact, references, acknowledgments and logos.

#import "@preview/sci-propos-core:0.1.0": defaults, sp-style, resolve-fonts, lang-key, cfg, qr-code

/// Words the poster writes itself.
#let _words = (
  en: (references: [References], acknowledgments: [Acknowledgments], contact: [Contact]),
  fr: (references: [Références], acknowledgments: [Remerciements], contact: [Contact]),
  zh-Hans: (references: [参考文献], acknowledgments: [致谢], contact: [联系方式]),
  zh-Hant: (references: [參考文獻], acknowledgments: [致謝], contact: [聯絡方式]),
)

/// Paper sizes: page, default number of columns. The type sizes scale with
/// the square root of the page area, relative to A0.
#let sizes = (
  "a0": (width: 841mm, height: 1189mm, columns: 2),
  "a0-landscape": (width: 1189mm, height: 841mm, columns: 3),
  "a1": (width: 594mm, height: 841mm, columns: 2),
  "48x36": (width: 48in, height: 36in, columns: 3),
  "36x48": (width: 36in, height: 48in, columns: 2),
  "16:9": (width: 48in, height: 27in, columns: 4),
)

/// The type ladder on an A0 page (pt). Reading distances, for body text of
/// this size: about 2 m for the title band, 1–1.5 m for the body.
#let ladder = (
  title: 84pt,
  authors: 38pt,
  affiliation: 30pt,
  highlight: 40pt,
  heading: 44pt,
  subheading: 34pt,
  body: 30pt,
  caption: 24pt,
  small: 21pt,
)

#let _scale(page) = calc.sqrt((page.width / 1mm) * (page.height / 1mm) / (841 * 1189))

/// A highlight list under the title: two or three sentences, the key results.
#let highlights(..items) = context {
  let c = cfg()
  set par(justify: false)
  stack(dir: ttb, spacing: 0.7em, ..items.pos().map(it => grid(columns: (auto, 1fr), column-gutter: 0.5em,
    // top: the arrow stays on the first line of a wrapped highlight
    align: left + top, text(fill: c.primary, weight: "bold", sym.arrow.r), it)))
}

/// A figure headed by its message, for posters whose sections hold several
/// figures: the message (a sentence) in bold above the evidence.
#let message(msg, body) = context block(breakable: false, width: 100%, {
  block(below: 0.5em, text(weight: "bold", fill: cfg().primary, msg))
  body
})

/// The poster. Write the body as sections: `= A sentence that states the
/// section's message`, then its evidence. `#colbreak()` moves to the next
/// column.
#let poster(
  title: [A sentence that states the main finding],
  authors: none,
  affiliation: none,
  size: "a0",
  columns: auto,
  // An orienting figure and a few highlights, across the page under the title.
  graphic: none,
  points: none,
  // "band": across the page under the title (default on portrait pages);
  // "column": at the top of the first column (default on landscape pages,
  // where height is scarce).
  orient: auto,
  // Keep each section (a level-1 heading and what follows it) in one column.
  keep-sections: true,
  // The bottom band.
  qr: none,
  qr-caption: auto,
  contact: none,
  references: none,
  acknowledgments: none,
  logos: none,
  // Look.
  lang: "en",
  style: "sans",
  primary: defaults.primary,
  scale: auto,
  font: auto,
  cjk-font: auto,
  code-font: auto,
  math-font: auto,
  body,
) = {
  assert(type(size) == dictionary or size in sizes,
    message: "poster: size must be one of " + sizes.keys().join(", ") + ", or (width:, height:)")
  let pg = if type(size) == dictionary { (columns: 2) + size } else { sizes.at(size) }
  let key = lang-key(lang)
  let cjk = key in ("zh-Hans", "zh-Hant")
  let words = _words.at(key)
  let s = if scale == auto { _scale(pg) } else { scale }
  let z = ladder.pairs().map(((k, v)) => (k, v * s)).to-dict()
  let fonts = resolve-fonts(style, key, font: font, cjk-font: cjk-font, code-font: code-font, math-font: math-font)
  let ncols = if columns == auto { pg.columns } else { columns }
  let margin = 40mm * s
  let gutter = 30mm * s
  let conf = defaults + (
    primary: primary, lang: key, style: style, base-size: z.body,
    code-size: z.body * 0.8, credit-size: z.small, card-size: z.body * 0.9,
    qr-size: 70mm * s, label-size: z.caption, annotate-stroke: 2.5pt * s,
    table-rule: 3pt * s, table-midrule: 1pt * s,
  )

  set document(title: title)
  // From the second page on, a red flag in the top margin (over no content):
  // a poster is one page.
  let flag = context if counter(page).get().first() > 1 {
    place(top + left, dx: margin, dy: margin * 0.2,
      box(fill: rgb("#c00000"), inset: 10pt * s, text(size: z.caption, fill: white, weight: "bold",
        [The poster runs past one page: cut text or shrink figures.])))
  }
  set page(width: pg.width, height: pg.height, margin: margin, columns: ncols, foreground: flag)
  show: sp-style.with(conf, fonts, key)
  set text(size: z.body, hyphenate: false)
  set par(leading: 0.55em, spacing: 0.9em, justify: false,
    first-line-indent: if cjk { (amount: 2em, all: false) } else { 0pt })
  // Section headings are the section's message: a sentence, sentence case,
  // bold, in the primary color. Subheadings are bold body text.
  set heading(numbering: none)
  show heading: set par(first-line-indent: 0pt)
  show heading: set text(hyphenate: false)
  show heading.where(level: 1): it => block(above: 0pt, below: 0.6em, sticky: true,
    text(size: z.heading, weight: "bold", fill: primary, it.body))
  show heading.where(level: 2): it => block(above: 1em, below: 0.4em, sticky: true,
    text(size: z.subheading, weight: "bold", it.body))
  // Figures: no numbers by default; a short caption under the evidence.
  set figure(numbering: none, gap: 0.5em)
  show figure.caption: set text(size: z.caption, fill: luma(60))
  show figure.caption: set par(justify: false)
  show figure: set block(above: 0.8em, below: 1em)
  show figure.where(kind: table): set figure.caption(position: top)
  show list: set par(first-line-indent: 0pt)
  show enum: set par(first-line-indent: 0pt)

  // Title band.
  let title-band = {
    set par(first-line-indent: 0pt)
    // Gaps in absolute sizes: an em here would be the body's, not the title's.
    block(below: 0.4 * z.title, text(size: z.title, weight: "bold", fill: luma(20), hyphenate: false,
      par(leading: 0.35em, title)))
    if authors != none { block(below: 0.3 * z.authors, text(size: z.authors, weight: "bold", authors)) }
    if affiliation != none { block(text(size: z.affiliation, fill: luma(60), affiliation)) }
  }
  // Orienting block: a figure beside (band) or above (column) two or three
  // highlights.
  let mode = if orient == auto { if pg.width > pg.height { "column" } else { "band" } } else { orient }
  assert(mode in ("band", "column"), message: "poster: orient must be \"band\" or \"column\"")
  let orient = if graphic != none or points != none {
    set par(first-line-indent: 0pt)
    let p = if points == none { none } else if type(points) == array { highlights(..points) } else { points }
    let inner = if graphic == none { p } else if p == none { align(center, graphic) } else if mode == "band" {
      grid(columns: (1.1fr, 1fr), column-gutter: gutter * 1.5, align: (center + horizon, left + horizon), graphic, p)
    } else {
      stack(dir: ttb, spacing: gutter * 0.8, align(center, graphic), p)
    }
    block(width: 100%, above: 0pt, below: if mode == "band" { 0pt } else { gutter }, breakable: false,
      fill: primary.lighten(93%), inset: (x: margin * 0.6, y: margin * 0.5), text(size: z.highlight, inner))
  }
  // Bottom band: QR and contact, references and acknowledgments, logos.
  let foot = {
    set par(first-line-indent: 0pt, justify: false)
    set text(size: z.small, fill: luma(40))
    let label(it) = block(below: 0.35em, text(weight: "bold", fill: luma(20), it))
    let cells = ()
    let widths = ()
    if qr != none or contact != none {
      cells.push(grid(columns: (auto, auto), column-gutter: gutter * 0.7, align: horizon,
        if qr != none { qr-code(qr, caption: none) },
        {
          if qr != none and qr-caption != none {
            block(below: 0.6em, text(size: z.caption, weight: "bold", fill: primary,
              if qr-caption == auto { qr.replace(regex("^https?://"), "").trim("/", at: end) } else { qr-caption }))
          }
          if contact != none { label(words.contact); contact }
        }))
      widths.push(auto)
    }
    if references != none or acknowledgments != none {
      cells.push({
        if references != none { label(words.references); references }
        if acknowledgments != none { v(0.6em); label(words.acknowledgments); acknowledgments }
      })
      widths.push(1fr)
    }
    if logos != none {
      cells.push(align(right + horizon, logos))
      widths.push(auto)
    }
    if cells.len() > 0 {
      line(length: 100%, stroke: 1.2pt * s + luma(190))
      v(0.8em)
      grid(columns: widths, column-gutter: gutter * 1.3, align: (left + horizon), ..cells)
    }
  }

  // The title band and the bottom band float across all columns; the
  // sections flow in the columns between them. Too much content spills onto
  // a second page, which carries a red flag: a poster is one page.

  set std.columns(gutter: gutter)
  place(top, float: true, scope: "parent", clearance: gutter * 1.1, {
    title-band
    if orient != none and mode == "band" { v(gutter * 0.9); orient }
  })
  place(bottom, float: true, scope: "parent", clearance: gutter, foot)
  if orient != none and mode == "column" { orient }
  if keep-sections and body.has("children") {
    // Group the body into sections that start at each level-1 heading; a
    // section never breaks across columns. Column breaks stay between them.
    let groups = ((),)
    for child in body.children {
      if child.func() == heading and child.depth == 1 { groups.push((child,)) }
      else if child.func() == colbreak { groups.push((child,)); groups.push(()) }
      else { groups.last().push(child) }
    }
    for g in groups {
      if g.len() == 1 and g.first().func() == colbreak { g.first() }
      // Skip groups of white space only (between the show rule and the first heading).
      else if g.filter(c => c.func() not in (parbreak, linebreak) and c != [ ]).len() > 0 {
        // A section taller than a column may break, so that too much content
        // still shows up as a second page instead of running off the first.
        let sec = g.join()
        block(width: 100%, above: 0pt, below: z.heading * 1.1, layout(size => {
          let h = measure(block(width: size.width, sec)).height
          block(breakable: h > size.height, width: 100%, above: 0pt, below: 0pt, sec)
        }))
      }
    }
  } else { body }
}
