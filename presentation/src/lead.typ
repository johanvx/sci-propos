// The lead line: the slide's assertion, one full sentence under the title.
// Assertion-evidence rules (Alley, The Craft of Scientific Presentations,
// ch. 4): a sentence with a verb, at most two lines, never shrunk to fit.

#import "@preview/sci-propos-core:0.1.0": cfg, tr

/// The slide's point in one sentence, under the title. At the top level of a
/// slide body it is moved to the top, whatever its position in the source.
/// A lead longer than two lines gets a red flag in the margin (theme option
/// `checks: false` turns the flag off); shorten the sentence rather than the
/// type.
#let lead(body) = [#block(width: 100%, above: 0pt, below: 0pt, context {
  let c = cfg()
  set text(size: c.lead-size, weight: c.lead-weight)
  set par(leading: 0.45em)
  if not c.checks { return body }
  layout(size => {
    let h = measure(block(width: size.width, body)).height
    let two = measure(block(width: size.width)[x \ x]).height
    body
    if h > two + 0.5pt {
      place(top + right, dx: 0pt, dy: -1.1em,
        box(fill: rgb("#c62828"), inset: (x: 5pt, y: 2pt), radius: 2pt,
          text(size: 10pt, weight: "bold", fill: white, tr("lead-too-long"))))
    }
  })
})<sp-lead>]
