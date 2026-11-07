// Slide functions: the content slide (title band, footer locator), title,
// outline, section, conclusion, contact, focus, black, empty, thanks and
// references slides.

#import "@preview/touying:0.8.0": (
  touying-slide, touying-slide-wrapper, config-common, config-page, utils,
)
#import "@preview/sci-propos-core:0.1.0": (
  cfg, reject-unknown, tr, format-date, lang-key, logo-slot, qr-code,
)
#import "sections.typ": (
  sections, current-section, current-subsection,
  section-number, subsection-number, title-number, format-title-number,
)
#import "outline.typ": propos-outline, shrink-to-fit
#import "lead.typ": lead as lead-line

// ------------------------------------------------------------------ chrome

// "2. Method · 2.1 Setup" (top label) or "2 Method · 2.1 Setup" (footer).
#let _section-parts(plain) = {
  let c = cfg()
  let i = current-section()
  if i == none { return () }
  let secs = sections()
  if secs.len() < i { return () }
  let s = secs.at(i - 1)
  let n = if not c.numbering.section { none } else if plain { str(i) } else { section-number(i) }
  let parts = ([#if n != none [#n ]#s.body],)
  if c.slide-level >= 3 {
    let j = current-subsection(secs)
    if j != none {
      let sn = subsection-number(i, j)
      parts.push([#if sn != none [#sn ]#s.subs.at(j - 1).body])
    }
  }
  parts
}

/// The section label: "2. Method · 2.1 Setup".
#let section-label() = context {
  let c = cfg()
  let parts = _section-parts(false)
  if parts.len() == 0 { return none }
  text(size: c.label-size, fill: c.muted, parts.join(tr("sep")))
}

// The label mode of a slide: "footer", "top" or none.
#let _label-mode(value) = {
  if value == true { "top" } else if value == false or value == none { none } else { value }
}

/// Shrink a one-line title until it fits (down to 72 %), then let it wrap.
#let _fit-title(body, size, width) = {
  let natural = measure(text(size: size, body)).width
  let s = if natural > width { calc.max(size * (width / natural), size * 0.72) } else { size }
  text(size: s, body)
}

#let _header(title, mode) = context {
  let c = cfg()
  let width = page.width - 2 * c.margin-x
  // The band keeps room for the label in decks that use it, so titles don't move.
  let band = if mode == "top" or c.section-label == "top" { c.margin-top-label } else { c.margin-top }
  block(width: 100%, height: band - c.header-ascent, above: 0pt, below: 0pt, {
    if mode == "top" { place(top + left, dy: 14pt, section-label()) }
    if title != none {
      place(bottom + left, block(width: 100%, {
        set par(leading: 0.3em)
        block(above: 0pt, below: if c.title-rule { 9pt } else { 0pt },
          text(weight: "bold", fill: if c.title-color == auto { c.primary } else { c.title-color },
            _fit-title(title, c.title-size, width)))
        if c.title-rule { line(length: 100%, stroke: 0.6pt + c.faint) }
      }))
    }
  })
}

// The footer: the locator "2 Results · 5 / 7" at the bottom right. After the
// total stops growing (appendix), slides show their number alone.
#let _footer(show-number, mode) = context {
  let c = cfg()
  set text(size: c.footer-size, fill: c.footer-color)
  // The section in the primary color, so it reads at a glance from the back of the room.
  let parts = if mode == "footer" {
    _section-parts(true).map(x => text(fill: c.primary, weight: "medium", x))
  } else { () }
  let number = if show-number {
    let n = utils.slide-counter.get().first()
    let total = utils.last-slide-counter.final().first()
    if n <= total [#n / #total] else [#n]
  }
  if number != none { parts.push(number) }
  if parts.len() > 0 { align(right, parts.join(tr("sep"))) }
}

#let _background(show-logo) = context {
  let c = cfg()
  if show-logo and c.logo != none {
    place(top + right, dx: -c.margin-x, dy: 12pt, logo-slot())
  }
}

/// Lay out a slide body: lead lines on top, content aligned (`horizon`
/// centers it between the lead and the credit), credit lines at the bottom.
/// Only top-level `#lead` / `#credit` are moved; nested ones stay in place.
#let compose(body, align: horizon) = {
  let kids = if body == none { () } else if body.func() == [].func() { body.children } else { (body,) }
  let has-label(k, l) = k.has("label") and k.label == l
  let leads = kids.filter(k => has-label(k, <sp-lead>))
  let credits = kids.filter(k => has-label(k, <sp-credit>))
  let rest = kids.filter(k => not has-label(k, <sp-lead>) and not has-label(k, <sp-credit>))
  let v-align = if align == none { top } else if align.y == none { top } else { align.y }
  let h-align = if align == none or align.x == none { left } else { align.x }
  // The spacers are tiny fractions: alone they still share the free space
  // evenly (centering), but a `remaining(...)` block (height 1fr) takes it all.
  leads.join()
  if leads.len() > 0 { v(18pt, weak: true) }
  if v-align in (horizon, bottom) { v(0.001fr) }
  if h-align == left { rest.join() } else { std.align(h-align, rest.join()) }
  if v-align in (horizon, top) { v(0.001fr) }
  if credits.len() > 0 { v(10pt, weak: true); credits.join() }
}

// ------------------------------------------------------------------ slides

/// The content slide. With headings, `== Title` makes one; call it directly
/// for options:
///
/// ```
/// #slide(title: [Results], align: top, section-label: none)[ ... ]
/// ```
///
/// - title (content, auto, none): `auto` uses the slide's heading.
/// - align (alignment, auto): content alignment; `auto` uses the theme's
///   `content-align` (default `horizon`: centered between lead and credit).
/// - section-label (str, none, auto): "footer", "top" or none; `auto` uses the theme's.
/// - text-size (length, auto): body text size for this slide only. (A
///   top-level `#set text(..)` in a slide body would apply to every later
///   slide too: see the README, "Settings for one slide".)
/// - show-logo (bool, auto): `auto` follows the theme's `logo-on`.
/// - page-number (bool): show the number in the footer.
/// - count (bool): `false` keeps this slide out of the numbering.
/// - config, repeat, setting, composer: passed to Touying.
#let slide(
  title: auto,
  align: auto,
  section-label: auto,
  text-size: auto,
  show-logo: auto,
  page-number: true,
  count: true,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  reject-unknown(bodies, (), "slide")
  let title = if title == auto {
    let hs = self.at("headings", default: ()).filter(h => h.depth == self.slide-level)
    if hs.len() > 0 {
      // With `numbering: (title: true)`, the heading's number goes first: "1.2 Title".
      let body = hs.last().body
      [#context {
        let n = if cfg().numbering.title { title-number() } else { none }
        if n != none [#format-title-number(n)#h(0.45em)]
      }#body]
    } else { none }
  } else { title }
  let store = self.store
  let mode = _label-mode(if section-label == auto { store.section-label } else { section-label })
  let content-align = if align == auto { store.content-align } else { align }
  let logo = if show-logo == auto { store.logo-on == "all" } else { show-logo }
  touying-slide(
    self: self,
    config: utils.merge-dicts(
      config-common(freeze-slide-counter: not count),
      config-page(
        // The title band is shorter unless the section label sits above the title.
        margin: (x: store.margin-x, bottom: store.margin-bottom,
          top: if mode == "top" or store.section-label == "top" { store.margin-top-label } else { store.margin-top }),
        header: _header(title, mode),
        footer: _footer(page-number and count, mode),
        background: _background(logo),
      ),
      config,
    ),
    repeat: repeat,
    setting: body => {
      set text(size: text-size) if text-size != auto
      setting(compose(body, align: content-align))
    },
    composer: composer,
    ..bodies.pos(),
  )
})

/// The title page. Values default to `config-info(...)` given to the theme.
///
/// - authors (array): several authors, e.g. `([A#inst(1)], [B#inst(2)])`.
/// - institutions (array): numbered affiliations matching `inst(...)`.
/// - extra (content): one more line, e.g. the course or the occasion.
/// - image (content, none): an orienting picture (scope, setting or why it
///   matters), shown on the right; the text block then sits on the left.
#let title-slide(
  title: auto,
  subtitle: auto,
  author: auto,
  authors: none,
  institution: auto,
  institutions: none,
  date: auto,
  extra: auto,
  image: none,
  logo: true,
  config: (:),
) = touying-slide-wrapper(self => {
  let info = self.info
  let pick(v, key) = if v == auto { info.at(key, default: none) } else { v }
  let title = pick(title, "title")
  let subtitle = pick(subtitle, "subtitle")
  let author = pick(author, "author")
  let institution = pick(institution, "institution")
  let date = pick(date, "date")
  let extra = pick(extra, "extra")
  if type(extra) not in (content, str) { extra = none }
  let text-block(c, key, width) = {
    if title != none {
      block(width: width, text(size: 1.7em, weight: "bold",
        fill: if c.title-color == auto { c.primary } else { c.title-color }, title))
    }
    if subtitle != none { v(0.7em); block(width: width, text(size: 1.1em, subtitle)) }
    v(1fr)
    if authors != none { authors.join(h(1.2em)) } else if author != none { author }
    if institutions != none {
      v(0.5em)
      text(size: 0.85em, fill: c.muted.darken(30%),
        institutions.enumerate().map(((i, x)) => [#super[#(i + 1)]#x]).join(linebreak()))
    } else if institution != none { v(0.5em); text(size: 0.9em, institution) }
    if extra != none { v(0.5em); text(size: 0.9em, extra) }
    if date != none { v(0.5em); text(size: 0.85em, fill: c.muted.darken(30%), format-date(key, date)) }
  }
  let body = context {
    let c = cfg()
    let key = lang-key(c.lang)
    if image == none {
      set std.align(center)
      if logo { logo-slot(height: 1.3 * c.logo-height) }
      v(1fr)
      text-block(c, key, 88%)
    } else {
      // Text on the left (logo above it), orienting picture on the right.
      grid(columns: (1fr, 1.1fr), column-gutter: 32pt, align: (left + horizon, center + horizon),
        block(height: 100%, {
          if logo { logo-slot(height: 1.3 * c.logo-height) }
          v(1fr)
          text-block(c, key, 100%)
        }),
        block(height: 100%, width: 100%, std.align(center + horizon, image)),
      )
    }
  }
  touying-slide(
    self: self,
    config: utils.merge-dicts(
      // Counted by default (its number is hidden), so the outline is slide 2,
      // as in Beamer and PowerPoint. With `count-title: false` it is slide 1.
      config-common(freeze-slide-counter: not self.store.count-title),
      config-page(header: none, footer: none, background: none,
        margin: (x: self.store.margin-x, top: 28pt, bottom: 34pt)),
      config,
    ),
    body,
  )
})

/// The outline page, in the theme's `outline-style`.
#let outline-slide(title: auto, style: auto, config: (:)) = slide(
  title: if title == auto { context tr("contents") } else { title },
  section-label: none,
  align: horizon,
  config: config,
  propos-outline(style: style),
)

/// A picture for the section, written right after `= Section`: shown on the
/// section page beside the outline, and as the section's tile in the "map"
/// outline style.
///
/// ```
/// = Results
/// what the tests showed        // the section's description
/// #section-image(image("results.png"))
/// ```
#let section-image(body) = [#metadata(body)<sp-section-image>]

/// The section page, shown at every `= Section` (the first one included):
/// the outline with this section highlighted, and the section's picture on
/// the right when it has one. Text written right after the `= Section`
/// heading becomes the section's description in the outline.
#let section-slide(config: (:), body) = touying-slide-wrapper(self => {
  // Split the text under `= Section` into the description (shown in the
  // outline), the picture, and Touying marks such as `#speaker-note[...]`.
  let kids = if body == none { () } else if body.func() == [].func() { body.children } else { (body,) }
  let is-mark(k) = k.func() == metadata and type(k.value) == dictionary and "kind" in k.value
  let is-image(k) = k.has("label") and k.label == <sp-section-image>
  let marks = kids.filter(is-mark)
  let images = kids.filter(is-image)
  let text-kids = kids.filter(k => not is-mark(k) and not is-image(k))
  let blank(k) = k == [ ] or k == parbreak() or k == linebreak()
  let desc = if text-kids.all(blank) { none } else { text-kids.join() }
  let pic = if images.len() > 0 { images.first().value } else { none }
  touying-slide(
    self: self,
    config: utils.merge-dicts(
      config-page(header: none, footer: _footer(true, none), background: _background(self.store.logo-on == "all"),
        margin: (x: self.store.margin-x, top: 48pt, bottom: 48pt)),
      config,
    ),
    {
      if desc != none [#metadata(desc)<sp-section-description>]
      images.join()
      marks.join()
      v(1fr)
      context {
        let c = cfg()
        let o = propos-outline(current: current-section())
        if pic == none or c.outline-style == "map" { o } else {
          grid(columns: (1.25fr, 1fr), column-gutter: 36pt, align: (left + horizon, center + horizon),
            o, block(width: 100%, height: 300pt, std.align(center + horizon, pic)))
        }
      }
      v(1fr)
    },
  )
})

/// A slide with no title band. `count: false` keeps it out of the numbering.
#let empty-slide(count: true, show-logo: false, page-number: false, align: horizon + center, config: (:), ..bodies) = slide(
  title: none, section-label: none, show-logo: show-logo, page-number: page-number,
  count: count, align: align, config: config, ..bodies,
)

/// A black page with nothing on it, for a stretch of the talk where no visual
/// helps: the audience then looks at you. Leave it up at least 30 seconds, or
/// people think the projector failed. Not counted by default.
#let black-slide(count: false, config: (:)) = touying-slide-wrapper(self => {
  touying-slide(
    self: self,
    config: utils.merge-dicts(
      config-common(freeze-slide-counter: not count),
      config-page(header: none, footer: none, background: none, fill: black),
      config,
    ),
    [],
  )
})

/// One sentence on the primary color, for emphasis.
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  touying-slide(
    self: self,
    config: utils.merge-dicts(
      config-page(header: none, footer: none, background: none, fill: self.store.primary, margin: 48pt),
      config,
    ),
    setting: it => std.align(center + horizon, text(fill: white, size: 1.6em, weight: "bold", it)),
    body,
  )
})

// `qr:` of the closing slides: a link (made into a code) or your own content.
#let _qr(qr, size, caption) = if qr == none { none } else if type(qr) == str {
  qr-code(qr, size: size, caption: caption)
} else { qr }

// The contact band: photo or logo, contact lines, small QR code, "Questions?".
#let _contact-band(contact, questions) = context {
  let c = cfg()
  let info = if contact == auto { c.contact } else { contact }
  let cells = ()
  let cols = ()
  if info != none and info.at("photo", default: none) != none {
    cols.push(auto); cells.push(box(height: 54pt, info.photo))
  }
  if info != none and info.at("lines", default: none) != none {
    cols.push(1fr); cells.push(text(size: c.credit-size * 1.25, fill: c.muted.darken(35%), info.lines))
  } else { cols.push(1fr); cells.push([]) }
  if info != none and info.at("qr", default: none) != none {
    cols.push(auto); cells.push(_qr(info.qr, 54pt, none))
  }
  if questions != none {
    cols.push(auto)
    cells.push(text(size: 1.2em, fill: c.muted, if questions == auto { tr("questions") } else { questions }))
  }
  block(width: 100%, above: 0pt, below: 0pt, {
    line(length: 100%, stroke: 0.6pt + c.faint)
    v(8pt)
    grid(columns: cols, column-gutter: 18pt, align: left + horizon, ..cells)
  })
}

/// The conclusion: the last slide of a research talk, which stays up during
/// the questions. The lead states the talk's main takeaway ("In summary, …");
/// up to three supporting points follow, each optionally with a miniature of
/// a figure shown earlier; an optional picture sits on the right; a contact
/// band (theme option `contact`) and "Questions?" close the slide.
///
/// ```
/// #conclusion-slide(
///   lead: [In summary, sampling at twice the highest frequency keeps the signal],
///   points: ([Point one], [Point two], [Point three]),
///   figures: (mini-1, mini-2, mini-3),   // optional, one per point
/// )
/// ```
///
/// - title (content, auto): `auto` writes "Conclusion" in the deck's language.
/// - lead (content): the main takeaway, one sentence.
/// - points (array): 1–3 supporting assertions, parallel in form.
/// - figures (array, none): miniatures, one per point.
/// - image (content, none): one picture on the right instead of miniatures.
/// - contact (dictionary, auto, none): `(photo:, lines:, qr:)`; `auto` uses the theme's.
/// - questions (content, auto, none): `auto` writes "Questions?".
#let conclusion-slide(
  title: auto,
  lead: none,
  points: (),
  figures: none,
  image: none,
  contact: auto,
  questions: auto,
  show-logo: true,
  config: (:),
) = {
  assert(points.len() <= 3, message: "conclusion-slide: at most three points (MIT CommKit; Alley)")
  assert(figures == none or figures.len() == points.len(),
    message: "conclusion-slide: give one figure per point, or none")
  slide(
    title: if title == auto { context tr("conclusion") } else { title },
    align: top,
    section-label: none,
    show-logo: show-logo,
    config: config,
    {
      if lead != none { lead-line(lead) }
      v(18pt, weak: true)
      block(width: 100%, height: 1fr, above: 0pt, below: 0pt, context {
        let c = cfg()
        let item(i, p) = grid(columns: (auto, 1fr), column-gutter: 0.6em,
          text(weight: "bold", fill: c.primary)[#(i + 1).], p)
        let list-part = if figures != none {
          grid(columns: (auto, 1fr), column-gutter: 20pt, row-gutter: 14pt, align: (center + horizon, left + horizon),
            ..points.enumerate().map(((i, p)) => (block(height: 60pt, above: 0pt, below: 0pt, std.align(center + horizon, figures.at(i))), item(i, p))).flatten())
        } else {
          stack(dir: ttb, spacing: 0.9em, ..points.enumerate().map(((i, p)) => item(i, p)))
        }
        let body = if image == none { list-part } else {
          grid(columns: (1fr, 1fr), column-gutter: 28pt, align: (left + horizon, center + horizon),
            list-part, image)
        }
        std.align(horizon, body)
      })
      if not (contact == none and questions == none) {
        v(16pt)
        _contact-band(contact, questions)
      }
    },
  )
}

/// An affiliation page for promotional talks (a seminar elsewhere, a
/// recruitment talk, outreach): a photo of the group or the place, contact
/// details and a QR code to the website. Its lead repeats the talk's
/// takeaway, so the page still carries the message; for the questions, go
/// back to the conclusion slide.
///
/// - lead (content): the talk's takeaway.
/// - photo (content, none): a photo of the group, the building, the lab.
/// - lines (content): name of the group, address, email, website.
/// - qr (str, content, none): a link to the website, drawn as a QR code.
#let contact-slide(title: auto, lead: none, photo: none, lines: none, qr: none,
    qr-size: auto, show-logo: true, config: (:)) = slide(
  title: if title == auto { context tr("contact") } else { title },
  section-label: none,
  show-logo: show-logo,
  config: config,
  {
    if lead != none { lead-line(lead) }
    let code = _qr(qr, qr-size, auto)
    let side = stack(dir: ttb, spacing: 18pt, lines, code)
    if photo == none { side } else {
      grid(columns: (1.35fr, 1fr), column-gutter: 32pt, align: (center + horizon, left + horizon),
        block(width: 100%, height: 280pt, clip: true, std.align(center + horizon, photo)), side)
    }
  },
)

/// The closing slides of a course or seminar deck, either as one page or as
/// two (research talks end on `conclusion-slide` instead):
///
/// ```
/// #thanks-slide(title: [Resources], qr: "https://example.org")[- links]  // one page
///
/// #resources-slide(qr: "https://example.org")[- links]                  // two pages:
/// #thanks-slide()                                                        // then the thank-you page
/// ```
///
/// Without a title, a centered "Thank you / Questions?" page with no heading
/// and no section label. With a title (e.g. "Resources"), `body` first, then
/// the thank-you line at the bottom (`thanks: none` leaves it out).
///
/// - qr (str, content, none): a link, drawn as a QR code (beside the body, or
///   under the thank-you line), or your own content such as an image.
/// - qr-size (length, auto), qr-caption (content, auto, none): see `qr-code`.
#let thanks-slide(
  title: none,
  thanks: auto,
  questions: auto,
  qr: none,
  qr-size: auto,
  qr-caption: auto,
  section-label: none,
  config: (:),
  ..body,
) = {
  reject-unknown(body, (), "thanks-slide")
  let line = if thanks == none { none } else {
    context {
      let c = cfg()
      text(size: 1.5em, weight: "bold", fill: c.primary, if thanks == auto { tr("thanks") } else { thanks })
      if questions != none {
        h(0.6em)
        text(size: 1.5em, fill: c.muted, if questions == auto { tr("questions") } else { questions })
      }
    }
  }
  let code = _qr(qr, qr-size, qr-caption)
  if title == none {
    empty-slide(show-logo: true, page-number: true, config: config, {
      line
      if code != none {
        if line != none { v(1.4em) }
        code
      }
      body.pos().join()
    })
  } else {
    slide(title: title, config: config, align: horizon, section-label: section-label, show-logo: true, {
      v(1fr)
      if code == none { body.pos().join() } else {
        grid(columns: (1fr, auto), column-gutter: 32pt, align: (left + horizon, center + horizon),
          body.pos().join(), code)
      }
      v(1fr)
      line
    })
  }
}

/// A "Resources" page without the thank-you line, to put before a separate
/// `#thanks-slide()`. Takes the options of `thanks-slide`; the title defaults
/// to "Resources" in the deck's language.
#let resources-slide(title: auto, ..args) = thanks-slide(
  title: if title == auto { context tr("resources") } else { title },
  thanks: none,
  ..args,
)

/// A references slide. Pass `read("refs.bib")` (read in your deck, so the path
/// resolves there), or your own `bibliography(...)` as the body.
#let bibliography-slide(title: auto, bib: none, style: "ieee", full: false, size: 0.8em, section-label: none, ..body) = slide(
  title: if title == auto { context tr("references") } else { title },
  align: top,
  section-label: section-label,
  {
    set text(size: size)
    if bib != none {
      bibliography(if type(bib) == str { bytes(bib) } else { bib }, title: none, style: style, full: full)
    } else { body.pos().join() }
  },
)
