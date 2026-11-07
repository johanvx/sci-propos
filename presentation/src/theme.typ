// The theme function.

#import "@preview/touying:0.8.0": *
#import "@preview/sci-propos-core:0.1.0": defaults, sp-style, lang-key, resolve-fonts, reject-unknown
#import "slides.typ": slide, section-slide

// The notes half of a notes handout: white, a hairline, then the notes in
// body type. Equations, figures and references work in notes too.
#let _handout-notes(self: none, note: none, slide-preview: none) = {
  let m = self.store.margin-x
  block(width: 100%, height: 100%, inset: (x: m, top: 24pt, bottom: 34pt), fill: white, {
    set align(left + top)
    set text(fill: luma(20), weight: "regular")
    line(length: 100%, stroke: 0.6pt + luma(205))
    v(14pt)
    set text(size: 17pt)
    set par(leading: 0.65em, spacing: 0.9em)
    if note != none { note }
  })
}

/// The presentation theme. Use once at the top of the deck:
///
/// ```
/// #show: presentation-theme.with(
///   config-info(title: [Talk title], author: [Name], date: datetime.today()),
///   files: p => path(p),   // lets the theme find logo.svg and shots/ in your folder
/// )
/// ```
///
/// Structure comes from headings: `= Section` (text right after it is the
/// section's description in the outline), `== Slide title`. With
/// `slide-level: 3`: `= Section`, `== Subsection`, `=== Slide title`.
///
/// - lang (str): "en", "fr", "zh-Hans" or "zh-Hant". Sets the text language
///   and the words the theme writes ("Outline", "Conclusion", card labels…).
/// - style (str): "sans" (Noto Sans, the default for slides) or "serif" (Noto Serif).
/// - font, cjk-font, code-font, math-font (str, array, auto): override a role.
/// - math-align (alignment): display equations, `left` (default) or `center`.
/// - primary (color): the accent color.
/// - base-size (length): body text size; other sizes follow.
/// - lead-size (length, auto), lead-weight (str): the lead line (22 pt, medium).
/// - slide-level (int): 2 (sections, slides) or 3 (sections, subsections, slides).
/// - outline-style (str): "parts" (sections with descriptions), "thesis"
///   (sections and subsections with dotted leaders and slide numbers) or
///   "map" (one picture per section).
/// - descriptions (bool): show section descriptions in the outline and on
///   section pages.
/// - numbering (dictionary): `(section: bool, subsection: bool, title: bool)`.
///   `title: true` writes the heading's number before slide titles ("1.2 Title").
/// - section-label (str, none): "footer" (the locator "2 Results · 5 / 7" at the
///   bottom right, default), "top" (above the title) or none.
/// - logo-on (str): "all" (every content slide) or "title-closing" (title,
///   conclusion, contact and closing slides only).
/// - contact (dictionary, none): `(photo:, lines:, qr:)` for the contact band
///   of the conclusion slide.
/// - count-title (bool): count the title page (its number stays hidden), so
///   the outline is slide 2, as in Beamer and PowerPoint.
/// - title-rule (bool): the hairline under slide titles.
/// - title-color (color, auto): `auto` uses `primary`.
/// - content-align (alignment): default alignment of slide bodies; `horizon`
///   centers content between the lead and the credit lines.
/// - checks (bool): flag lead lines longer than two lines.
/// - files (function, none): `p => path(p)`, written in your deck, so the theme
///   can open your logo and screenshots.
/// - logo (content, auto, none): `image("logo.svg")`, `auto` (the file found by
///   `--input logo`, else a placeholder) or `none`.
/// - shots (array, auto): screenshot names that exist; `auto` reads `--input shots=a,b,c`.
/// - frame-images (bool): thin border around real screenshots.
/// - handout (bool, str, auto): `true` (one page per slide), `"notes"` (each
///   slide above its speaker notes) or `false`; `auto` reads `--input handout=...`.
/// - ..args: Touying config dicts (`config-info`, `config-common`, …), applied last.
#let presentation-theme(
  aspect-ratio: "16-9",
  lang: "en",
  style: "sans",
  font: auto,
  cjk-font: auto,
  code-font: auto,
  math-font: auto,
  math-align: left,
  primary: defaults.primary,
  base-size: defaults.base-size,
  title-size: auto,
  lead-size: auto,
  lead-weight: defaults.lead-weight,
  code-size: auto,
  slide-level: 2,
  outline-style: "parts",
  descriptions: true,
  numbering: (section: true, subsection: true, title: false),
  section-label: "footer",
  logo-on: "all",
  contact: none,
  count-title: true,
  title-rule: true,
  title-color: auto,
  content-align: horizon,
  checks: true,
  files: none,
  logo: auto,
  shots: auto,
  frame-images: false,
  handout: auto,
  ..args,
  body,
) = {
  reject-unknown(args, (), "presentation-theme")
  assert(slide-level in (2, 3), message: "presentation-theme: slide-level must be 2 or 3")
  assert(outline-style in ("parts", "thesis", "map"),
    message: "presentation-theme: outline-style must be \"parts\", \"thesis\" or \"map\"")
  assert(section-label in ("footer", "top", none),
    message: "presentation-theme: section-label must be \"footer\", \"top\" or none")
  assert(logo-on in ("all", "title-closing"),
    message: "presentation-theme: logo-on must be \"all\" or \"title-closing\"")
  assert(math-align in (left, center, right), message: "presentation-theme: math-align must be left, center or right")
  assert(type(numbering) == dictionary and numbering.keys().all(k => k in ("section", "subsection", "title")),
    message: "presentation-theme: numbering takes (section:, subsection:, title:)")
  let key = lang-key(lang)
  let fonts = resolve-fonts(style, key, font: font, cjk-font: cjk-font, code-font: code-font, math-font: math-font)
  let scale = base-size / defaults.base-size
  let conf = defaults + (
    primary: primary,
    lang: lang,
    style: style,
    math-align: math-align,
    base-size: base-size,
    title-size: if title-size == auto { defaults.title-size * scale } else { title-size },
    lead-size: if lead-size == auto { defaults.lead-size * scale } else { lead-size },
    lead-weight: lead-weight,
    code-size: if code-size == auto { defaults.code-size * scale } else { code-size },
    card-size: defaults.card-size * scale,
    // Slides are magnified on screen: heavier table rules than in documents.
    table-rule: 2pt * scale,
    table-midrule: 0.6pt * scale,
    slide-level: slide-level,
    outline-style: outline-style,
    descriptions: descriptions,
    numbering: defaults.numbering + numbering,
    section-label: section-label,
    logo-on: logo-on,
    contact: contact,
    title-rule: title-rule,
    title-color: title-color,
    content-align: content-align,
    checks: checks,
    files: files,
    logo: logo,
    shots: shots,
    frame-images: frame-images,
  )
  let handout = if handout == auto { sys.inputs.at("handout", default: "false") } else { handout }
  let notes-handout = handout == "notes"
  let plain-handout = handout == true or handout == "true"

  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      margin: (x: conf.margin-x, top: if section-label == "top" { conf.margin-top-label } else { conf.margin-top }, bottom: conf.margin-bottom),
      header-ascent: conf.header-ascent,
      footer-descent: 10pt,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: section-slide,
      receive-body-for-new-section-slide-fn: true,
      slide-level: slide-level,
      zero-margin-header: false,
      zero-margin-footer: false,
      handout: plain-handout or notes-handout,
      show-notes-on-second-screen: if notes-handout { bottom } else { none },
      notes-fn: if notes-handout { _handout-notes } else { touying-notes },
    ),
    config-colors(primary: primary),
    config-store(
      primary: primary,
      section-label: section-label,
      logo-on: logo-on,
      count-title: count-title,
      content-align: content-align,
      margin-x: conf.margin-x,
      margin-top: conf.margin-top,
      margin-top-label: conf.margin-top-label,
      margin-bottom: conf.margin-bottom,
    ),
    config-methods(init: (self: none, body) => {
      show heading: set text(size: 1em, fill: primary)
      sp-style(conf, fonts, key, body)
    }),
    ..args.pos(),
  )
  body
}
