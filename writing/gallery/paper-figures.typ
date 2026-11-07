// The figure of the sample research paper (illustrative data), in plain Typst.

#let cal = ((0, 0.02), (50, 0.26), (100, 0.51), (200, 1.0), (400, 2.03), (600, 3.0), (800, 3.98), (1000, 5.01))

/// Sensor output against formazin standards, with the fitted line.
#let calibration-plot(xlabel: [Formazin standard (NTU)], ylabel: [Sensor output (V)], w: 280pt, h: 170pt, sep: ".") = {
  let X(x) = x / 1050 * w
  let Y(y) = h - y / 5.4 * h
  let f(x) = str(x).replace(".", sep)
  set text(size: 9pt)
  box(width: w + 50pt, height: h + 36pt, inset: (left: 36pt, top: 4pt), {
    place(line(start: (0pt, h), end: (w, h), stroke: 0.6pt + luma(110)))
    place(line(start: (0pt, 0pt), end: (0pt, h), stroke: 0.6pt + luma(110)))
    for v in (0, 250, 500, 750, 1000) {
      place(dx: X(v) - 20pt, dy: h + 4pt, box(width: 40pt, align(center, str(v))))
    }
    for v in (0, 1, 2, 3, 4, 5) {
      place(dx: -30pt, dy: Y(v) - 5pt, box(width: 26pt, align(right, f(v))))
    }
    place(dx: 0pt, dy: h + 18pt, box(width: w, align(center, xlabel)))
    place(dx: 6pt, dy: 0pt, ylabel)
    place(line(start: (X(0), Y(0)), end: (X(1000), Y(5.0)), stroke: 1pt + luma(110)))
    for (x, y) in cal { place(dx: X(x) - 3pt, dy: Y(y) - 3pt, circle(radius: 3pt, fill: black)) }
  })
}
