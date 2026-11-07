// sci-propos-writing: letters, memo reports, formal and laboratory reports,
// and research papers for science and engineering, in the style of Michael
// Alley's The Craft of Scientific Writing: serif text, bold sans-serif
// headings, informative summaries, captions below figures and above tables.
//
// The shared helpers of sci-propos-core are re-exported, so one import is
// enough. Emails are plain text and have no template here.

#import "@preview/sci-propos-core:0.1.0": (
  ph, pkg, citet, citep, footcite, TeX, LaTeX, two-columns, code-panel, labelled, demo,
  shot, qr-code, inst, annotate,
)
#import "src/letter.typ": letter
#import "src/memo.typ": memo
#import "src/report.typ": report, paper, appendix
