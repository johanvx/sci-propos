// The outline styles, used by the outline slide and by section pages.
//
//   "parts"  — numbered sections, each with its optional description
//              underneath, aligned with the section name (not the number).
//   "thesis" — sections and subsections with dotted leaders and slide numbers.
//   "map"    — one picture per section (from `#section-image`), side by side:
//              the mapping slide of the assertion-evidence approach.
//
// `current` (1-based) highlights one section and grays the others.

#import "@preview/sci-propos-core:0.1.0": cfg
#import "sections.typ": sections, section-number, subsection-number

/// Shrink `body` uniformly when it is taller than the space left.
#let shrink-to-fit(body) = layout(size => {
  let m = measure(width: size.width, body)
  if m.height <= size.height { body } else {
    let f = size.height / m.height * 100%
    block(height: size.height, above: 0pt, below: 0pt,
      scale(f, origin: top + left, reflow: true, block(width: size.width / f * 100%, body)))
  }
})

#let _parts(secs, current, c, name-size, desc-size, gap) = {
  let numbered = c.numbering.section
  let cells = ()
  for s in secs {
    let active = current == none or current == s.number
    let accent = if active { c.primary } else { c.muted }
    let desc-color = if current == none { c.muted } else if active { c.text-color } else { c.muted }
    let name = text(size: name-size, weight: "bold", fill: accent, s.body)
    if numbered {
      cells.push(text(size: name-size, weight: "bold", fill: accent, section-number(s.number)))
    }
    cells.push(block(above: 0pt, below: 0pt, {
      name
      if s.description != none and c.descriptions {
        block(above: 0.4em, below: 0pt,
          text(size: desc-size, fill: desc-color, s.description))
      }
    }))
  }
  grid(
    columns: if numbered { (auto, 1fr) } else { (1fr,) },
    column-gutter: 0.5em,
    row-gutter: gap,
    align: left + top,
    ..cells,
  )
}

#let _thesis(secs, current, c, sec-size, sub-size, gap) = {
  let leaders(color) = box(width: 1fr, text(fill: c.faint.darken(20%), repeat(gap: 0.3em)[.]))
  let cells = ()
  for s in secs {
    let active = current == none or current == s.number
    let accent = if active { c.primary } else { c.muted }
    let sub-color = if active { c.text-color } else { c.muted }
    cells.push(if c.numbering.section { text(size: sec-size, weight: "bold", fill: accent, str(s.number)) } else { [] })
    cells.push(text(size: sec-size, weight: "bold", fill: accent)[#s.body #leaders(accent) #s.slide])
    for sub in s.subs {
      let sn = subsection-number(s.number, sub.number)
      cells.push(none)
      cells.push(text(size: sub-size, fill: sub-color)[#if sn != none [#box(width: 2.2em, sn)]#sub.body #leaders(sub-color) #sub.slide])
    }
  }
  grid(
    columns: (if c.numbering.section { 1.8em } else { 0pt }, 1fr),
    row-gutter: gap,
    align: left + bottom,
    ..cells,
  )
}


#let _map(secs, current, c, name-size, desc-size) = layout(size => {
  let n = secs.len()
  let gap = 24pt
  let w = (size.width - (n - 1) * gap) / n
  let pic-h = calc.min(w * 0.62, 170pt)
  let tile(s) = {
    let active = current == none or current == s.number
    let pic = if s.image != none {
      block(width: w, height: pic-h, clip: true, above: 0pt, below: 0pt, align(center + horizon, s.image))
    } else {
      block(width: w, height: pic-h, above: 0pt, below: 0pt, fill: c.primary.lighten(90%),
        align(center + horizon, text(size: 2.4em, weight: "bold", fill: c.primary.lighten(40%), str(s.number))))
    }
    let tile-body = stack(dir: ttb, spacing: 10pt,
      pic,
      text(size: name-size, weight: "bold", fill: if active { c.primary } else { c.muted },
        [#if c.numbering.section [#s.number. ]#s.body]),
      if s.description != none and c.descriptions {
        text(size: desc-size, fill: if current != none and active { c.text-color } else { c.muted }, s.description)
      },
    )
    if active { tile-body } else {
      // Inactive parts fade behind a translucent white veil.
      box({ tile-body; place(top + left, box(width: w, height: pic-h, fill: white.transparentize(30%))) })
    }
  }
  grid(columns: (w,) * n, column-gutter: gap, align: left + top, ..secs.map(tile))
})

/// The outline in the deck's style. `current: none` shows every section active.
#let propos-outline(current: none, style: auto) = context {
  let c = cfg()
  let st = if style == auto { c.outline-style } else { style }
  let secs = sections()
  if secs.len() == 0 { return none }
  if st == "parts" {
    _parts(secs, current, c, 1.3em, 0.9em, 0.9em)
  } else if st == "thesis" {
    _thesis(secs, current, c, 1.1em, 0.9em, 0.55em)
  } else if st == "map" {
    _map(secs, current, c, 1.05em, 0.8em)
  } else {
    panic("sci-propos: outline-style must be \"parts\", \"thesis\" or \"map\", got " + repr(st))
  }
}
