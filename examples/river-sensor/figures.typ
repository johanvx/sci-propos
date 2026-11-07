// Figures for the example talk, drawn in plain Typst (illustrative data).

#let green = rgb("#00561F")
#let gray = luma(150)

// A frame with x and y axes; `plot` receives (X, Y) mapping data to points.
#let axes(w: 460pt, h: 200pt, xmax: 1, ymax: 1, xlabel: none, ylabel: none, xticks: (), yticks: (), small: false, plot) = {
  let X(x) = x / xmax * w
  let Y(y) = h - y / ymax * h
  let s = if small { 0pt } else { 1pt }
  box(width: w + if small { 0pt } else { 60pt }, height: h + if small { 0pt } else { 44pt }, inset: (left: if small { 0pt } else { 50pt }), {
    place(line(start: (0pt, h), end: (w, h), stroke: 0.8pt + gray))
    place(line(start: (0pt, 0pt), end: (0pt, h), stroke: 0.8pt + gray))
    if not small {
      for (v, t) in xticks { place(dx: X(v) - 30pt, dy: h + 4pt, box(width: 60pt, align(center, text(size: 14pt, t)))) }
      for (v, t) in yticks { place(dx: -46pt, dy: Y(v) - 8pt, box(width: 40pt, align(right, text(size: 14pt, t)))) }
      if xlabel != none { place(dx: 0pt, dy: h + 22pt, box(width: w, align(center, text(size: 14pt, fill: luma(90), xlabel)))) }
      if ylabel != none { place(dx: 0pt, dy: -22pt, text(size: 14pt, fill: luma(90), ylabel)) }
    }
    plot(X, Y)
  })
}

#let polyline(pts, X, Y, stroke) = place(curve(curve.move((X(pts.at(0).at(0)), Y(pts.at(0).at(1)))),
  ..pts.slice(1).map(((x, y)) => curve.line((X(x), Y(y)))), stroke: stroke))

#let dot(x, y, X, Y, r: 4pt, fill: green) = place(dx: X(x) - r, dy: Y(y) - r, circle(radius: r, fill: fill))

// One month of turbidity (NTU) with three storms, and four weekly grab samples.
#let month = {
  let base = 18
  let storm(t, t0, peak, w) = if t < t0 { 0 } else { peak * calc.exp(-(t - t0) / w) * calc.min(1, (t - t0) / 0.4) }
  range(0, 301).map(k => {
    let t = k / 10
    (t, base + storm(t, 4.2, 310, 1.2) + storm(t, 13.5, 180, 1.0) + storm(t, 22.8, 420, 1.4))
  })
}
#let samples = (2, 9, 16, 27)

#let storms(small: false, w: 460pt, h: 190pt) = axes(w: w, h: h, xmax: 30, ymax: 450, small: small,
  xlabel: [day of the month], ylabel: [turbidity (NTU)],
  xticks: ((0, [0]), (10, [10]), (20, [20]), (30, [30])),
  yticks: ((0, [0]), (200, [200]), (400, [400])),
  (X, Y) => {
    polyline(month, X, Y, (if small { 1pt } else { 1.6pt }) + gray)
    for d in samples {
      let v = month.at(d * 10).at(1)
      dot(d, v, X, Y, r: if small { 2.5pt } else { 5pt })
    }
    if not small {
      place(dx: X(6.5), dy: Y(250), box(width: 180pt, text(size: 15pt, fill: green)[weekly grab samples]))
      place(line(start: (X(8.6), Y(222)), end: (X(9), Y(30)), stroke: 0.7pt + green))
    }
  })

// The sensor: an LED, a sample window, two photodiodes (native 360 × 180 pt).
#let _sensor = box(width: 360pt, height: 180pt, {
  place(rect(width: 360pt, height: 180pt, fill: green.lighten(92%), radius: 4pt))
  // water channel
  place(dx: 130pt, dy: 20pt, rect(width: 100pt, height: 140pt, fill: rgb("#d8e6ef"), stroke: 1pt + luma(120)))
  for (x, y) in ((150, 50), (190, 70), (165, 100), (205, 120), (175, 135), (200, 40)) {
    place(dx: x * 1pt, dy: y * 1pt, circle(radius: 3pt, fill: luma(120)))
  }
  // LED
  place(dx: 40pt, dy: 75pt, rect(width: 40pt, height: 30pt, fill: luma(60), radius: 3pt))
  place(line(start: (80pt, 90pt), end: (300pt, 90pt), stroke: (paint: rgb("#b2182b"), thickness: 1.4pt, dash: "dashed")))
  // transmitted detector
  place(dx: 300pt, dy: 75pt, rect(width: 24pt, height: 30pt, fill: green))
  // scattered detector at 90°
  place(line(start: (180pt, 90pt), end: (180pt, 165pt), stroke: (paint: rgb("#b2182b"), thickness: 1.2pt, dash: "dotted")))
  place(dx: 168pt, dy: 160pt, rect(width: 24pt, height: 16pt, fill: green))
})
#let sensor(w: 360pt) = scale(w / 360pt * 100%, reflow: true, _sensor)

// Calibration: sensor output against formazin standards.
#let cal-pts = ((0, 0.02), (50, 0.26), (100, 0.51), (200, 1.0), (400, 2.03), (600, 3.0), (800, 3.98), (1000, 5.01))
#let calibration(small: false, w: 420pt, h: 190pt) = axes(w: w, h: h, xmax: 1000, ymax: 5.2, small: small,
  xlabel: [formazin standard (NTU)], ylabel: [sensor output (V)],
  xticks: ((0, [0]), (500, [500]), (1000, [1000])), yticks: ((0, [0]), (2.5, [2.5]), (5, [5])),
  (X, Y) => {
    polyline(((0, 0), (1000, 5.0)), X, Y, (if small { 0.8pt } else { 1.2pt }) + gray)
    for (x, y) in cal-pts { dot(x, y, X, Y, r: if small { 2pt } else { 4.5pt }) }
    if not small { place(dx: X(560), dy: Y(1.6), text(size: 15pt)[$R^2 = 0.999$]) }
  })

// Field record: daily means of the sensor (green) and the reference (gray) over 180 days.
#let field = range(0, 181, step: 3).map(d => {
  let v = 25 + 60 * calc.pow(calc.sin(d / 180 * 3.1416 * 3), 8) + 10 * calc.sin(d / 7)
  (d, v)
})
#let fieldplot(small: false, w: 460pt, h: 180pt) = axes(w: w, h: h, xmax: 180, ymax: 110, small: small,
  xlabel: [day of the deployment], ylabel: [daily mean turbidity (NTU)],
  xticks: ((0, [0]), (60, [60]), (120, [120]), (180, [180])), yticks: ((0, [0]), (50, [50]), (100, [100])),
  (X, Y) => {
    polyline(field, X, Y, (if small { 1.2pt } else { 4.5pt }) + luma(190))
    polyline(field.enumerate().map(((k, (d, v))) => (d, v * (1 + 0.03 * calc.sin(k * 1.7)))), X, Y, (if small { 0.8pt } else { 1.4pt }) + green)
    if not small {
      place(dx: X(4), dy: Y(110), text(size: 15pt, fill: green)[sensor (thin)])
      place(dx: X(4), dy: Y(98), text(size: 15pt, fill: luma(110))[reference (thick)])
    }
  })

// Fouling: error growing each week until a wiper is fitted (week 4).
#let fouling(w: 420pt, h: 180pt) = axes(w: w, h: h, xmax: 8, ymax: 35,
  xlabel: [week], ylabel: [reading above reference (%)],
  xticks: range(0, 9, step: 2).map(k => (k, [#k])), yticks: ((0, [0]), (15, [15]), (30, [30])),
  (X, Y) => {
    let pts = ((0, 0), (1, 8), (2, 16), (3, 25), (4, 32), (4.01, 1), (5, 1.5), (6, 1), (7, 2), (8, 1.5))
    polyline(pts.slice(0, 5), X, Y, 1.6pt + gray)
    polyline(pts.slice(5), X, Y, 1.6pt + green)
    for (x, y) in pts.slice(0, 5) { dot(x, y, X, Y, fill: gray) }
    for (x, y) in pts.slice(5) { dot(x, y, X, Y) }
    place(line(start: (X(4), 0pt), end: (X(4), h), stroke: (paint: luma(90), thickness: 1pt, dash: "dashed")))
    place(dx: X(4.15), dy: Y(30), text(size: 15pt, fill: luma(60))[wiper fitted])
  })
