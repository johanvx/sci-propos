// One step of a procedure: an instruction line, then the screenshot filling
// the rest of the slide.

#import "@preview/sci-propos-core:0.1.0": shot

/// One step of a procedure: an instruction line, then the screenshot
/// filling the rest of the slide. Use under a `== Platform · 1/7 · Step` heading.
///
/// ```
/// #step("win-1")[Open *Settings*, then click *Add-ins*.]
/// ```
#let step(name, instruction, gap: 10pt) = {
  block(width: 100%, above: 0pt, below: 0pt, instruction)
  v(gap)
  block(width: 100%, height: 1fr, above: 0pt, below: 0pt,
    layout(size => shot(name, height: size.height)))
}
