// A new report with sci-propos-writing.
// Build: typst compile main.typ
// Other document types (letter, memo, paper): see the package README.
#import "@preview/sci-propos-writing:0.1.0": *

#show: report.with(
  kind: [#ph[Laboratory report]],          // or Design report, Technical report; none to omit
  title: [A Specific Title: Name the Field, Then What Sets the Work Apart],
  authors: ([#ph[Author one]], [#ph[Author two]]),
  affiliation: [#ph[Course or department] · #ph[University]],
  date: datetime.today(),
  lang: "en",                               // "fr", "zh-Hans", "zh-Hant"
  style: "serif",                           // or "sans"
  paper: "a4",                              // or "us-letter"
  // An informative summary: scope, method, the main results with their numbers,
  // and what they mean. It must stand on its own; write it last.
  summary: [#ph[What was done, how, what was found (with numbers), and what it means.]],
)

= Introduction

// What the work is (scope and limits), why it matters, the background a reader
// needs, the objectives (the conclusions will check them), and a map of the report.
#ph[The first sentence orients the reader and takes a step: what was studied and why it matters.]

= Procedures

// A first-person narrative of what was done, enough for someone to repeat it.
#ph[Apparatus, conditions, and the steps that could change the result.]

= Results and Discussion

// Results with their analysis, errors and their effect on the conclusions.
// Refer to every figure and table in the text before it appears.
#ph[The main result first, then its evidence:] see @fig:main.

#figure(
  rect(width: 70%, height: 4cm, fill: luma(240)),
  caption: [#ph[An identifying phrase.] #ph[One or two sentences on what to notice.]],
) <fig:main>

= Conclusions

// The results in the context of the whole work; check each objective.
// No new evidence. Next steps, if any.
#ph[Each objective, and whether it was met.]

#show: appendix

= Raw Data

// Each appendix has a beginning, a middle and an end, and the text points to it.
#ph[What this appendix holds and why.]

// #bibliography("refs.bib", style: "chicago-author-date")   // or "ieee"
