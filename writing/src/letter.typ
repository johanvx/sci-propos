// Formal letters, each language in its own convention:
//   en: modified block style (Alley's model): sender's address and date to the
//       right, inside address on the left, "Dear …:", indented paragraphs,
//       "Sincerely," and the name aligned with the date, Enclosure and cc.
//   fr: expéditeur en haut à gauche, destinataire à droite, « Lieu, le date »,
//       Objet, P. J., civilité, formule de politesse, signature à droite.
//   zh: 称呼顶格，正文首行缩进两字，「此致／敬礼」（繁體「敬祝／研安」），
//       署名与日期在右下。

#import "@preview/sci-propos-core:0.1.0": format-date, lang-key, cfg
#import "base.typ": document-setup
#import "strings.typ": wword

#let _col = 55%   // where the right-hand blocks start (modified block style)

/// A formal letter.
///
/// ```
/// #show: letter.with(
///   sender: [#ph[Street address] \ #ph[City, postcode]],
///   recipient: [#ph[Dr. Recipient Name] \ #ph[Title] \ #ph[Organization] \ #ph[Address]],
///   salutation: [Dear Dr. #ph[Name]:],
///   signature: [#ph[Your name]],
///   enclosures: [Résumé],
/// )
/// ```
///
/// - sender (content): your address (en), or name and address (fr); contact
///   details under the signature (zh).
/// - place (content, none): French only: "Paris" gives "Paris, le 7 novembre 2026".
/// - subject (content, none): "Objet :" line (fr), a centered title (zh), a
///   bold line before the salutation (en).
/// - closing (auto, content, array): `auto` uses the language's convention; in
///   Chinese, an array of two lines, e.g. `([此致], [敬礼！])`.
/// - signature (content): the typed name (zh: e.g. `[学生　#ph[姓名]]`).
/// - signature-image (content, none): a scanned signature; otherwise blank space.
#let letter(
  sender: none,
  recipient: none,
  date: auto,
  place: none,
  subject: none,
  salutation: none,
  closing: auto,
  signature: none,
  signature-image: none,
  enclosures: none,
  cc: none,
  lang: "en",
  style: "serif",
  paper: "a4",
  size: auto,
  justify: auto,
  primary: auto,
  font: auto,
  heading-font: auto,
  cjk-font: auto,
  code-font: auto,
  math-font: auto,
  body,
) = {
  let key = lang-key(lang)
  let cjk = key in ("zh-Hans", "zh-Hant")
  show: document-setup.with(kind: "letter", lang: lang, style: style, paper: paper, size: size,
    justify: justify, numbered: false, primary: primary, font: font, heading-font: heading-font, cjk-font: cjk-font,
    code-font: code-font, math-font: math-font)
  let the-date = if date == auto { format-date(key, datetime.today()) } else { format-date(key, date) }
  let closing = if closing == auto { wword(key, "closing") } else { closing }
  let plain(it) = { set par(first-line-indent: 0pt); it }
  let right-col(it) = plain(pad(left: _col, align(left, it)))
  let sign-space = if signature-image != none { block(above: 0.4em, below: 0.4em, signature-image) } else { v(3.2em) }

  if key == "en" {
    right-col[#sender #if sender != none { v(1em) } #the-date]
    v(2.2em)
    plain(recipient)
    v(1.2em)
    if subject != none { plain(block(below: 1.2em, text(weight: "bold", subject))) }
    plain(block(below: 1.1em, salutation))
    set par(first-line-indent: (amount: 1.5em, all: true))
    body
    v(1em)
    right-col[#closing #sign-space #signature]
    v(1.6em)
    if enclosures != none { plain[#wword(key, "enclosure"): #enclosures] }
    if cc != none { plain[#wword(key, "cc"): #cc] }
  } else if key == "fr" {
    plain(sender)
    v(1.6em)
    right-col(recipient)
    v(1.6em)
    right-col[#if place != none [#place, le ]#the-date]
    v(1.8em)
    if subject != none { plain[#text(weight: "bold")[#wword(key, "subject") :] #subject] }
    if enclosures != none { plain[#text(weight: "bold")[#wword(key, "enclosure") :] #enclosures] }
    v(1.6em)
    plain(block(below: 1.1em, salutation))
    set par(first-line-indent: (amount: 1.5em, all: true))
    body
    if closing != none { parbreak(); closing }
    v(1.4em)
    right-col[#sign-space #signature]
    if cc != none { v(1.2em); plain[#wword(key, "cc") : #cc] }
  } else {
    // Chinese
    if subject != none {
      context plain(align(center, block(below: 1.6em, text(font: cfg().heading-font, size: 1.4em, weight: "bold", subject))))
    }
    plain(salutation)
    body
    if closing != none {
      let (a, b) = if type(closing) == array { closing } else { (closing, none) }
      parbreak()
      a
      if b != none { plain(block(above: 0.85em, b)) }
    }
    v(1.6em)
    plain(align(right, block(align(left, [#sign-space #signature \ #the-date]))))
    if sender != none { v(0.8em); plain(align(right, block(align(left, text(size: 0.9em, sender))))) }
    if enclosures != none { v(1.2em); plain[#wword(key, "enclosure")：#enclosures] }
    if cc != none { plain[#wword(key, "cc")：#cc] }
  }
}
