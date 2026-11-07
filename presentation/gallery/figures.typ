// Small figures drawn in plain Typst, so the gallery needs no image files.
// Illustrative data only.

#let green = rgb("#00561F")

/// A 3-period sine wave (gray) and its samples joined by straight lines.
#let wave(samples, w: 300pt, h: 120pt, label: none) = {
  let f(x) = calc.sin(x * 2 * calc.pi * 3)
  let pts = range(0, 241).map(k => k / 240)
  let P(x) = (x * w, h / 2 - f(x) * h * 0.42)
  box(width: w, height: h + if label == none { 0pt } else { 24pt }, {
    place(line(start: (0pt, h / 2), end: (w, h / 2), stroke: 0.5pt + luma(205)))
    place(curve(curve.move(P(0)), ..pts.slice(1).map(x => curve.line(P(x))), stroke: 1.4pt + luma(150)))
    let sp = range(0, samples + 1).map(k => k / samples)
    place(curve(curve.move(P(0)), ..sp.slice(1).map(x => curve.line(P(x))), stroke: 1.6pt + green))
    for x in sp { let (px, py) = P(x); place(dx: px - 3pt, dy: py - 3pt, circle(radius: 3pt, fill: green)) }
    if label != none { place(bottom + center, text(size: 15pt, label)) }
  })
}

/// Bars with value labels and a dashed reference line; the last bar is highlighted.
#let bars(data, reference: 1.0, w: 470pt, h: 160pt, floor: 0.9, ref-label: [correlation], small: false) = {
  let base = if small { 0pt } else { 26pt }
  let top = h - base - if small { 4pt } else { 24pt }
  let hi = calc.max(..data.map(d => d.at(2)))
  let H(v) = (v - floor) / (hi - floor) * top
  let n = data.len()
  let bw = w / n * 0.6
  let step = w / n
  box(width: w + if small { 0pt } else { 90pt }, height: h, {
    place(bottom + left, dy: -base, line(length: w, stroke: 0.8pt + luma(150)))
    for (k, (name, lab, v)) in data.enumerate() {
      let x = k * step + (step - bw) / 2
      let last = k == n - 1
      place(bottom + left, dx: x, dy: -base, rect(width: bw, height: H(v), fill: if last { green } else { luma(195) }))
      if not small {
        place(bottom + left, dx: x - 10pt, dy: -base - H(v) - 6pt, box(width: bw + 20pt, align(center,
          text(size: 16pt, fill: if last { green } else { luma(20) }, weight: if last { "bold" } else { "regular" }, lab))))
        place(bottom + left, dx: x - 20pt, box(width: bw + 40pt, height: base, align(center + horizon, text(size: 15pt, name))))
      }
    }
    if reference != none {
      place(bottom + left, dy: -base - H(reference),
        line(length: w, stroke: (paint: luma(90), thickness: if small { 0.8pt } else { 1.2pt }, dash: "dashed")))
      if not small {
        place(bottom + left, dx: w + 10pt, dy: -base - H(reference) + 9pt, text(size: 14pt, fill: luma(90), ref-label))
      }
    }
  })
}

// The test-section drawing at its native size (340 × 190 pt).
#let _rig = box(width: 340pt, height: 190pt, {
  let (w, h) = (340pt, 190pt)
  place(rect(width: w, height: h, fill: green.lighten(92%), radius: 4pt))
  // flow arrows
  for k in range(4) {
    let y = 30pt + k * 40pt
    place(line(start: (20pt, y), end: (110pt, y), stroke: 1.4pt + green.lighten(30%)))
    place(dx: 110pt, dy: y - 5pt, polygon(fill: green.lighten(30%), (0pt, 0pt), (10pt, 5pt), (0pt, 10pt)))
  }
  // grid generating turbulence
  for k in range(7) { place(dx: 140pt, dy: 18pt + k * 24pt, rect(width: 8pt, height: 14pt, fill: luma(120))) }
  // airfoil leading edge
  place(dx: 230pt, dy: 60pt, ellipse(width: 90pt, height: 70pt, fill: white, stroke: 1.6pt + luma(60)))
  place(dx: 275pt, dy: 60pt, rect(width: 60pt, height: 70pt, fill: green.lighten(92%)))
  place(dx: 272pt, dy: 60pt, line(start: (0pt, 0pt), end: (60pt, 0pt), stroke: 1.6pt + luma(60)))
  place(dx: 272pt, dy: 130pt, line(start: (0pt, 0pt), end: (60pt, 0pt), stroke: 1.6pt + luma(60)))
})

/// A schematic "test section" drawing used as an orienting picture.
#let rig(w: 340pt, h: auto) = {
  let f = w / 340pt
  scale(f * 100%, reflow: true, _rig)
}

/// A plain tile picture with one large symbol, for section pictures.
#let tile(symbol, fill: green.lighten(85%)) = box(width: 100%, height: 100%, fill: fill, radius: 4pt,
  align(center + horizon, text(size: 56pt, fill: green, symbol)))
