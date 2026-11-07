// The figure and data of the sample laboratory report (illustrative data),
// drawn in plain Typst so the gallery needs no image files.

#let Pr = 0.71
#let cb(re) = 0.3 + 0.62 * calc.pow(re, 0.5) * calc.pow(Pr, 1 / 3) / calc.pow(1 + calc.pow(0.4 / Pr, 2 / 3), 0.25) * calc.pow(1 + calc.pow(re / 282000, 5 / 8), 4 / 5)

// Run, air speed (m/s), heater power (W), surface temperature (°C), air
// temperature (°C), Reynolds number, measured Nusselt number.
#let runs = (
  (1, 1.3, 16.2, 74.0, 22.0, 2000, 24.4),
  (2, 3.2, 22.4, 67.0, 22.0, 5000, 39.0),
  (3, 6.4, 27.3, 60.0, 22.0, 10000, 56.3),
  (4, 12.8, 33.6, 54.0, 22.0, 20000, 82.5),
  (5, 19.2, 38.5, 51.0, 22.0, 30000, 104.2),
  (6, 25.6, 42.4, 49.0, 22.0, 40000, 123.3),
)

/// Log-log plot of the measured Nusselt numbers (dots with ±1.5 % bars) and
/// the Churchill–Bernstein correlation (line).
#let nu-plot(xlabel: [Reynolds number], ylabel: [Nusselt number], measured: [measured],
  correlation: [Churchill–Bernstein correlation], w: 300pt, h: 190pt) = {
  let (x0, x1, y0, y1) = (calc.log(1000), calc.log(60000), calc.log(10), calc.log(200))
  let X(re) = (calc.log(re) - x0) / (x1 - x0) * w
  let Y(nu) = h - (calc.log(nu) - y0) / (y1 - y0) * h
  let gray = luma(110)
  set text(size: 9pt)
  box(width: w + 50pt, height: h + 40pt, inset: (left: 42pt, top: 4pt), {
    place(rect(width: w, height: h, stroke: 0.6pt + luma(150)))
    for (v, t) in ((1000, [10#super[3]]), (10000, [10#super[4]])) {
      place(dx: X(v) - 20pt, dy: h + 4pt, box(width: 40pt, align(center, t)))
      place(line(start: (X(v), h), end: (X(v), h - 4pt), stroke: 0.6pt + luma(150)))
    }
    for v in (10, 20, 50, 100, 200) {
      place(dx: -30pt, dy: Y(v) - 5pt, box(width: 26pt, align(right, str(v))))
      place(line(start: (0pt, Y(v)), end: (4pt, Y(v)), stroke: 0.6pt + luma(150)))
    }
    place(dx: 0pt, dy: h + 20pt, box(width: w, align(center, xlabel)))
    place(dx: 6pt, dy: 6pt, ylabel)
    let pts = range(0, 61).map(i => calc.pow(10, x0 + (x1 - x0) * i / 60))
    place(curve(curve.move((X(pts.first()), Y(cb(pts.first())))),
      ..pts.slice(1).map(re => curve.line((X(re), Y(cb(re))))), stroke: 1.2pt + gray))
    for r in runs {
      let (re, nu) = (r.at(5), r.at(6))
      place(line(start: (X(re), Y(nu * 1.015)), end: (X(re), Y(nu * 0.985)), stroke: 0.8pt + black))
      place(dx: X(re) - 3pt, dy: Y(nu) - 3pt, circle(radius: 3pt, fill: black))
    }
    // legend, clear of the data
    place(dx: w - 165pt, dy: h - 38pt, {
      place(dx: 0pt, dy: 3pt, circle(radius: 3pt, fill: black))
      place(dx: 12pt, dy: 0pt, measured)
      place(line(start: (-3pt, 22pt), end: (9pt, 22pt), stroke: 1.2pt + gray))
      place(dx: 12pt, dy: 16pt, correlation)
    })
  })
}

/// One decimal, with the document's decimal separator ("." or ",").
#let f1(x, sep: ".") = {
  let s = str(calc.round(x, digits: 1))
  if "." not in s { s += ".0" }
  s.replace(".", sep)
}

/// An integer with thin-space groups of three: 40 000.
#let grouped(n) = {
  let s = str(n)
  let out = ""
  for (i, c) in s.clusters().enumerate() {
    if i > 0 and calc.rem(s.len() - i, 3) == 0 { out += "\u{2009}" }
    out += c
  }
  out
}
