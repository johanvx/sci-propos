// Screenshots and the logo, with automatic placeholders.
//
// Typst cannot test whether a file exists, and a path written inside a
// package resolves inside the package. So:
//   * the deck gives the theme `files: p => path(p)` (one line; `path`
//     then resolves in the deck's folder), and
//   * the deck says which files exist: `shots: (...)` in the theme, or
//     `--input shots=a,b,c --input logo=logo.svg` on the command line.
// Anything not listed shows as a placeholder, so a deck always compiles.

#import "config.typ": cfg
#import "helpers.typ": tr

#let _input-list(name) = sys.inputs.at(name, default: "").split(",").map(s => s.trim()).filter(s => s != "")

/// Names of the screenshots that exist (theme option `shots`, or `--input shots`).
#let available-shots() = {
  let c = cfg()
  if c.shots == auto { _input-list("shots") } else { c.shots }
}

#let _placeholder(kind, detail, height, width) = context {
  let c = cfg()
  rect(width: width, height: height, stroke: 0.6pt + c.primary, inset: 6pt,
    align(center + horizon, stack(dir: ttb, spacing: 0.5em,
      text(fill: c.primary)[\[#kind\]],
      text(size: 0.8em, fill: c.primary, raw(detail)),
    )))
}

/// A screenshot by name (`shots/<name>.png`), or a placeholder showing the
/// exact path it expects. Real images have no border unless
/// `frame-images: true`.
#let shot(name, height: auto, width: 100%) = context {
  let c = cfg()
  let file = c.shots-dir + name + c.shot-ext
  if name in available-shots() and c.files != none {
    let img = image((c.files)(file), width: 100%, height: if height == auto { auto } else { 100% }, fit: "contain")
    rect(width: width, height: height, inset: 0pt,
      stroke: if c.frame-images { 0.6pt + c.muted } else { none }, img)
  } else {
    _placeholder(tr("screenshot"), file, if height == auto { 120pt } else { height }, width)
  }
}

/// The logo: the theme's `logo` content, the file named by `--input logo`,
/// or a small placeholder.
#let logo-slot(height: auto) = context {
  let c = cfg()
  let lh = if height == auto { c.logo-height } else { height }
  if c.logo == none { return none }
  if type(c.logo) == content { return box(height: lh, c.logo) }
  let file = sys.inputs.at("logo", default: "")
  if file != "" and c.files != none {
    image((c.files)(file), height: lh)
  } else {
    box(height: lh, stroke: 0.5pt + c.primary, inset: (x: 5pt),
      align(horizon, text(size: 0.5 * lh, fill: c.primary)[\[#tr("logo")\] #h(0.3em) #text(size: 0.75em, raw("logo.svg"))]))
  }
}
