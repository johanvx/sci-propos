// Side cards: short notes framed on one side only (solid, dashed or dotted),
// for definitions, reminders, quick recaps, short intros and side notes.
// A "deck" is a stack of cards; `aside` puts a deck next to the main content.

#import "config.typ": cfg
#import "helpers.typ": tr

/// Built-in card kinds: default label and frame style. Override any of them
/// per card (`label:`, `frame:`), or pass your own `kind` dictionary.
/// Labels default to the deck's language.
#let card-kinds = (
  note: (label: auto, frame: "solid"),
  definition: (label: auto, frame: "solid"),
  intro: (label: auto, frame: "solid"),
  recap: (label: auto, frame: "dashed"),
  reminder: (label: auto, frame: "dotted"),
)

#let _side-key(side) = {
  if side == left { "left" } else if side == right { "right" } else if side == top { "top" } else if side == bottom { "bottom" } else {
    panic("card side must be left, right, top or bottom")
  }
}

/// One card.
///
/// ```
/// #card(kind: "definition", title: [Neutron flux])[
///   Total path length travelled by all neutrons per unit volume and time.
/// ]
/// #card(kind: "reminder", side: right)[Pin package versions.]
/// #card(frame: "dashed", label: [Aside])[Any text.]
/// ```
///
/// - kind (str, dictionary): "note", "definition", "intro", "recap", "reminder",
///   or a dictionary `(label: …, frame: …)`.
/// - title (content, none): bold title under the label (e.g. the defined term).
/// - label (content, auto, none): small uppercase label; `auto` uses the kind's.
/// - side (alignment): which side carries the frame: left, right, top, bottom.
/// - frame (str, auto): "solid", "dashed" or "dotted"; `auto` uses the kind's.
/// - accent (color, auto): frame and label color; `auto` = theme primary.
/// - fill (color, auto, none): background; `auto` = accent at 95% lightness.
#let card(
  body,
  kind: "note",
  title: none,
  label: auto,
  side: left,
  frame: auto,
  accent: auto,
  fill: auto,
  thickness: 2.5pt,
  size: auto,
  width: 100%,
) = context {
  let c = cfg()
  let k = if type(kind) == dictionary { kind } else { card-kinds.at(kind) }
  let size = if size == auto { c.card-size } else { size }
  let color = if accent == auto { c.primary } else { accent }
  let dash = if frame == auto { k.at("frame", default: "solid") } else { frame }
  let lab = if label == auto { k.at("label", default: none) } else { label }
  if lab == auto { lab = if type(kind) == str { tr(kind) } else { none } }
  let key = _side-key(side)
  // Distinct patterns at any thickness: long butt-capped dashes vs round dots.
  let line = if dash == "dashed" {
    (paint: color, thickness: thickness, dash: (array: (3.2 * thickness, 2.2 * thickness), phase: 0pt), cap: "butt")
  } else if dash == "dotted" {
    (paint: color, thickness: thickness, dash: (array: (0pt, 2.2 * thickness), phase: 0pt), cap: "round")
  } else {
    (paint: color, thickness: thickness, cap: "butt")
  }
  let inset = (left: 12pt, right: 12pt, top: 10pt, bottom: 10pt)
  inset.insert(key, 16pt)
  // The frame is a single grid rule on one side: it spans the whole card and
  // keeps clean ends for dashed and dotted patterns.
  let rule = if key == "left" { grid.vline(x: 0, stroke: line) }
    else if key == "right" { grid.vline(x: 1, stroke: line) }
    else if key == "top" { grid.hline(y: 0, stroke: line) }
    else { grid.hline(y: 1, stroke: line) }
  block(width: width, above: 0pt, below: 0pt, breakable: false, grid(
    columns: (1fr,),
    inset: inset,
    fill: if fill == auto { color.lighten(95%) } else { fill },
    stroke: none,
    rule,
    {
      set text(size: size)
      set par(leading: 0.55em, spacing: 0.7em)
      if lab != none {
        block(above: 0pt, below: 6pt,
          {
            let cjk = c.lang.starts-with("zh")
            text(size: if cjk { 0.82em } else { 0.72em }, weight: "bold",
              tracking: if cjk { 0.1em } else { 0.06em }, fill: color, upper(lab))
          })
      }
      if title != none { block(above: 0pt, below: 6pt, text(weight: "bold", title)) }
      body
    },
  ))
}

/// Shorthand for a definition card: `#term[Fluence][∫ flux dt.]`.
#let term(name, body, ..args) = card(kind: "definition", title: name, ..args, body)

/// A deck: several cards stacked (`dir: ttb`) or side by side (`dir: ltr`).
/// An optional `title` sits above the deck.
#let card-deck(..cards, dir: ttb, spacing: 10pt, title: none) = {
  let items = cards.pos()
  let deck = if dir == ltr {
    grid(columns: (1fr,) * items.len(), column-gutter: spacing, align: top, ..items)
  } else {
    stack(dir: dir, spacing: spacing, ..items)
  }
  if title == none { deck } else {
    block(above: 0pt, below: 0pt)[
      #block(above: 0pt, below: 6pt, text(size: 16pt, weight: "bold", fill: luma(110), title))
      #deck
    ]
  }
}

/// Main content with a narrow side column (a card or a deck) next to it.
/// Both columns start at the same top.
#let aside(main, side-content, position: right, ratio: (2.2fr, 1fr), gutter: 20pt) = {
  let cells = if position == left { (side-content, main) } else { (main, side-content) }
  let cols = if position == left { ratio.rev() } else { ratio }
  grid(columns: cols, column-gutter: gutter, align: left + top, ..cells)
}
