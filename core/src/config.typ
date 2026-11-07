// Defaults and the shared configuration state. A theme (presentation,
// poster, document) fills the state once; helpers read it inside `context`.

#let defaults = (
  primary: rgb("#00561f"),
  text-color: luma(20),
  muted: luma(110),          // gray for de-emphasized text (inactive sections, labels): #6E6E6E, 5:1 on white
  credit-color: luma(80),    // credit lines: #505050, 8:1
  footer-color: luma(60),    // slide numbers: #3C3C3C, 11:1; the footer's section is in the primary color
  faint: luma(205),          // hairlines
  table-rule: 1.5pt,         // three-line tables: top and bottom rules
  table-midrule: 0.5pt,      // the rule under the header: a third as thick, so the
                             // difference shows on screen too
  lang: "en",
  style: "sans",
  // sizes (16:9 page, 474 pt high)
  base-size: 20pt,
  title-size: 28pt,
  lead-size: 22pt,           // the slide's sentence (assertion) under the title
  lead-weight: "medium",
  label-size: 13pt,
  code-size: 15pt,
  code-leading: 0.5em,
  card-size: 17pt,
  credit-size: 13pt,
  footer-size: 14pt,
  // geometry
  margin-x: 40pt,
  margin-top: 72pt,        // title band; 94pt when the section label sits above the title
  margin-top-label: 94pt,
  margin-bottom: 34pt,
  header-ascent: 14pt,
  logo-height: 26pt,
  qr-size: 136pt,            // QR codes on the closing slides (about 4.8 cm)
  // switches
  slide-level: 2,
  outline-style: "parts",
  numbering: (section: true, subsection: true, title: false),
  section-label: "footer",   // "footer" (2 Results · 5 / 7), "top" or none
  descriptions: true,        // lines under section names in outlines and section pages
  logo-on: "all",            // "all" or "title-closing"
  contact: none,             // (photo:, lines:, qr:) for the conclusion band and contact slide
  checks: true,              // flag leads longer than two lines
  title-rule: true,
  title-color: auto,
  content-align: horizon,
  frame-images: false,
  // files
  files: none,               // p => path(p), defined in the deck
  logo: auto,
  shots: auto,
  shots-dir: "shots/",
  shot-ext: ".png",
)

#let sp-config = state("sci-propos-config", defaults)

/// The current configuration (call inside `context`).
#let cfg() = sp-config.get()
