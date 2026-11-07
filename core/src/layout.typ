// Layout helpers: two columns, remaining space, scale-to-fit, pipeline,
// call-outs on a picture.

#import "config.typ": cfg

/// Two columns that start at the same top. At most two columns per slide.
#let two-columns(left-body, right-body, ratio: (1fr, 1fr), gutter: 24pt, align: left + top) = grid(
  columns: ratio, column-gutter: gutter, align: align, left-body, right-body,
)

/// Fill the space left on the slide. `fn` receives that space's size, e.g.
/// `#remaining(size => shot("x", height: size.height))`. (Typst's `layout`
/// alone gives the whole slide body, not what is left of it.)
#let remaining(fn) = block(width: 100%, height: 1fr, above: 0pt, below: 0pt, layout(fn))

/// Scale `body` uniformly to fit `width` × `height`, keeping its aspect ratio.
#let scale-to-fit(body, width: 100%, height: 100%) = layout(size => {
  let w = if type(width) in (relative, ratio) { size.width * width } else { width }
  let h = if type(height) in (relative, ratio) { size.height * height } else { height }
  let natural = measure(body)
  let factor = calc.min(w / natural.width, h / natural.height)
  block(width: w, height: h, above: 0pt, below: 0pt,
    align(center + horizon, scale(factor * 100%, reflow: true, body)))
})

/// A row of boxes joined by arrows, e.g. Write → Export → Place.
/// Each step is `(name, detail)`. Boxes share the height of the tallest.
#let pipeline(..steps, height: auto, gap: 28pt, arrow: sym.arrow.r) = context {
  let c = cfg()
  let items = steps.pos()
  let n = items.len()
  let inner(s) = align(center + horizon)[
    #text(size: 1.2em, weight: "bold", fill: c.primary, s.at(0))
    #v(0.3em)
    #s.at(1)
  ]
  layout(size => {
    let w = (size.width - (n - 1) * gap) / n
    let h = if height == auto {
      calc.max(..items.map(s => measure(block(width: w, inset: 14pt, inner(s))).height), 80pt)
    } else { height }
    let cells = ()
    let cols = ()
    for (i, s) in items.enumerate() {
      cols.push(w)
      cells.push(rect(width: w, height: h, inset: 14pt, stroke: 0.8pt + c.primary, inner(s)))
      if i < n - 1 { cols.push(gap); cells.push(text(fill: c.muted, arrow)) }
    }
    grid(columns: cols, align: center + horizon, ..cells)
  })
}

/// Call-outs on a picture: each one is a short label joined by a thin line to
/// a point of the picture. Points are fractions of the picture's size, from
/// its top-left corner; labels are offset from their point.
///
/// ```
/// #annotate(image("nose.jpg", height: 220pt),
///   (x: 42%, y: 55%, dx: 120pt, dy: -60pt, label: [fold]),
///   (x: 30%, y: 70%, dx: -110pt, dy: 30pt, label: [slit]))
/// ```
///
/// - body (content): the picture (give it a width or height).
/// - ..notes (dictionary): `(x:, y:, dx:, dy:, label:)`; at most four.
/// - accent (color, auto): line and dot color; `auto` = theme primary.
/// - size (length, auto): label text size; `auto` = 0.85 em.
#let annotate(body, ..notes, accent: auto, size: auto) = context {
  let c = cfg()
  let color = if accent == auto { c.primary } else { accent }
  let m = measure(body)
  box(width: m.width, height: m.height, {
    body
    for n in notes.pos() {
      let px = m.width * n.x
      let py = m.height * n.y
      let dx = n.at("dx", default: 80pt)
      let dy = n.at("dy", default: -40pt)
      let lx = px + dx
      let ly = py + dy
      // Posters set a heavier line (`annotate-stroke`); slides use 1 pt.
      let w = c.at("annotate-stroke", default: 1pt)
      place(top + left, line(start: (px, py), end: (lx, ly), stroke: w + color))
      place(top + left, dx: px - 3 * w, dy: py - 3 * w, circle(radius: 3 * w, fill: color))
      let lab = box(fill: white, inset: (x: 4pt, y: 2pt),
        text(size: if size == auto { 0.85em } else { size }, n.label))
      let lm = measure(lab)
      // Put the label on the far side of its line end.
      let ox = if dx >= 0pt { 0pt } else { -lm.width }
      let oy = if dy >= 0pt { 0pt } else { -lm.height }
      place(top + left, dx: lx + ox, dy: ly + oy, lab)
    }
  })
}
