// sci-propos-core: the shared style of the sci-propos packages (presentation,
// writing, poster): palette, fonts, the four languages, credit lines,
// placeholders, side cards, code panels, three-line tables, screenshots,
// call-outs and QR codes. The other packages import it; you rarely need it
// directly.

#import "src/config.typ": defaults, sp-config, cfg
#import "src/fonts.typ": resolve-fonts, candidates
#import "src/strings.typ": strings, lang-key, text-lang, word, format-date
#import "src/helpers.typ": reject-unknown, or-auto, tr, localized
#import "src/style.typ": sp-style
#import "src/text.typ": credit, ph, pkg, large, small, tiny, compact, vfill, hfill, citet, citep, footcite, TeX, LaTeX
#import "src/layout.typ": two-columns, scale-to-fit, pipeline, remaining, annotate
#import "src/code.typ": code-panel, labelled, split-import, demo, numbered, algorithm-figure
#import "src/media.typ": shot, logo-slot, available-shots
#import "src/cards.typ": card, card-kinds, term, card-deck, aside
#import "src/qr.typ": qr-code

/// Superscript affiliation marks: `[Ada#inst(1, 2)]`.
#let inst(..n) = super(n.pos().map(str).join(","))
