// sci-propos-presentation: assertion-evidence slides for scientific and
// engineering talks, on Touying.
//
// Touying's own API (#pause, #only, #uncover, #speaker-note, config-*,
// utils, components) and the shared helpers of sci-propos-core are
// re-exported, so one import is enough.

#import "@preview/touying:0.8.0": *
#import "@preview/sci-propos-core:0.1.0": (
  credit, ph, pkg, large, small, tiny, compact, vfill, hfill, citet, citep, footcite, TeX, LaTeX,
  two-columns, scale-to-fit, pipeline, remaining, annotate,
  code-panel, labelled, split-import, demo, numbered, algorithm-figure,
  shot, logo-slot, card, card-kinds, term, card-deck, aside, qr-code, inst,
)
#import "src/theme.typ": presentation-theme
#import "src/lead.typ": lead
#import "src/slides.typ": (
  slide, title-slide, outline-slide, section-slide, section-image, empty-slide, black-slide,
  focus-slide, conclusion-slide, contact-slide, thanks-slide, resources-slide,
  bibliography-slide, section-label, compose,
)
#import "src/outline.typ": propos-outline
#import "src/steps.typ": step
