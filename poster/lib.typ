// sci-propos-poster: assertion-evidence posters for science and engineering.
// A sentence title states the main finding; each section is headed by its
// message and shows large evidence; a bottom band holds the QR code,
// contact, references, acknowledgments and logos. Sizes: A0 (portrait or
// landscape), A1, 48 x 36 in, 36 x 48 in, and a 16:9 e-poster.
//
// The shared helpers of sci-propos-core are re-exported, so one import is
// enough.

#import "@preview/sci-propos-core:0.1.0": (
  ph, pkg, credit, citet, citep, footcite, TeX, LaTeX, two-columns, scale-to-fit, pipeline,
  annotate, code-panel, labelled, demo, shot, qr-code, inst, card, term, aside,
)
#import "src/poster.typ": poster, highlights, message, sizes, ladder
