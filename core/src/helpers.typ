// Internal helpers: argument checks and localized words.

#import "config.typ": cfg
#import "strings.typ": word, lang-key

/// Fail on misspelled or unknown named arguments instead of ignoring them.
#let reject-unknown(args, allowed, fn) = {
  let unknown = args.named().keys().filter(k => k not in allowed)
  assert(unknown == (), message: fn + ": unknown argument: " + unknown.join(", ")
    + ". Allowed: " + allowed.join(", "))
}

/// The first value that is not `auto`.
#let or-auto(..values) = {
  for v in values.pos() { if v != auto { return v } }
  auto
}

/// A word the theme writes itself, in the deck's language (inside context).
#let tr(name) = word(lang-key(cfg().lang), name)

/// Same, as content usable anywhere.
#let localized(name) = context tr(name)
