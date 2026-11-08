// QR codes for links, with the link written under them.
//
// tiaoma is imported inside `qr-code`, not here: Typst fetches a package
// only when an import runs, so documents without a QR code never download
// or load it.

#import "config.typ": cfg

/// A QR code for a link, with the link written under it.
///
/// - url (str): the link to encode.
/// - size (length, auto): width of the code; `auto` is the theme's (about 4.8 cm on slides).
/// - caption (content, str, auto, none): `auto` writes the link without
///   "https://"; `none` writes nothing.
#let qr-code(url, size: auto, caption: auto) = context {
  import "@preview/tiaoma:0.3.0"
  let c = cfg()
  let size = if size == auto { c.qr-size } else { size }
  let caption = if caption == auto {
    url.replace(regex("^https?://"), "").trim("/", at: end)
  } else { caption }
  // The caption may be wider than the code; both are centered.
  box(stack(dir: ttb, spacing: 0.6em,
    align(center, tiaoma.qrcode(url, options: (fg-color: c.text-color), width: size)),
    if caption != none {
      align(center, text(size: c.credit-size, fill: c.credit-color,
        if type(caption) == str { raw(caption) } else { caption }))
    },
  ))
}
