// The section tree read back from the document, for the outline, the section
// pages and the footer locator.

#import "@preview/touying:0.8.0": utils
#import "@preview/sci-propos-core:0.1.0": cfg

#let _before(a, b) = a.page() < b.page() or (a.page() == b.page() and a.position().y <= b.position().y)

/// Every section of the deck, in order:
/// `(body, number, description, image, loc, page, slide, subs: ((body, number, loc, page, slide), ...))`.
/// Sections are level-1 headings; subsections are level-2 headings when the
/// deck uses `slide-level: 3`. The description is the text written right
/// after `= Section`; the image comes from `#section-image(..)` there.
#let sections() = {
  let c = cfg()
  let h1 = query(heading.where(level: 1)).filter(h => h.outlined)
  let h2 = if c.slide-level >= 3 { query(heading.where(level: 2)).filter(h => h.outlined) } else { () }
  let notes = query(<sp-section-description>)
  let images = query(<sp-section-image>)
  let slide-no(loc) = utils.slide-counter.at(loc).first()
  h1.enumerate().map(((i, h)) => {
    let loc = h.location()
    let next = h1.at(i + 1, default: none)
    let inside(l) = _before(loc, l) and (next == none or not _before(next.location(), l))
    let note = notes.filter(n => n.location().page() == loc.page())
    let img = images.filter(n => n.location().page() == loc.page())
    let subs = h2.filter(s => inside(s.location()))
    (
      body: h.body,
      number: i + 1,
      description: if note.len() > 0 { note.first().value } else { none },
      image: if img.len() > 0 { img.first().value } else { none },
      loc: loc,
      page: loc.page(),
      slide: slide-no(loc),
      subs: subs.enumerate().map(((j, s)) => (
        body: s.body,
        number: j + 1,
        loc: s.location(),
        page: s.location().page(),
        slide: slide-no(s.location()),
      )),
    )
  })
}

/// Index (1-based) of the section the current page belongs to, or none.
#let current-section() = {
  let p = here().page()
  let n = query(heading.where(level: 1)).filter(h => h.outlined and h.location().page() <= p).len()
  if n == 0 { none } else { n }
}

/// The current subsection (1-based, within its section), or none.
#let current-subsection(secs) = {
  let i = current-section()
  if i == none { return none }
  let p = here().page()
  let subs = secs.at(i - 1).subs.filter(s => s.page <= p)
  if subs.len() == 0 { none } else { subs.len() }
}

/// The number of the slide heading shown on this page, as an array such as
/// `(1, 2)` (section 1, its 2nd slide) or `(1, 2, 3)` with `slide-level: 3`;
/// none on pages that don't come from a slide heading. (Touying doesn't step
/// Typst's heading counter, so the headings are counted here.)
#let title-number() = {
  let depth = cfg().slide-level
  let p = here().page()
  let hs = query(heading).filter(h => h.depth <= depth and h.location().page() <= p)
  if hs.len() == 0 or hs.last().depth != depth { return none }
  let counts = (0,) * depth
  for h in hs {
    counts.at(h.depth - 1) += 1
    for k in range(h.depth, depth) { counts.at(k) = 0 }
  }
  counts
}

/// "1.2" for a slide title, following the `numbering` switches: without
/// section numbers the section part is left out ("2").
#let format-title-number(counts) = {
  let parts = if cfg().numbering.section { counts } else { counts.slice(1) }
  parts.map(str).join(".")
}

/// "2." / "2.1" style numbers, or none when that numbering is switched off.
#let section-number(n) = if cfg().numbering.section { [#n.] } else { none }
#let subsection-number(sec, sub) = if cfg().numbering.subsection {
  if cfg().numbering.section { [#sec.#sub] } else { [#sub] }
} else { none }
