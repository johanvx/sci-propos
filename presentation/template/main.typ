// A new talk with sci-propos-presentation (assertion-evidence slides).
// Build: typst compile main.typ
// Screenshots and logo show as placeholders until you list them:
//   shots: ("step-1",) and logo: image("logo.svg") below, or
//   typst compile --input shots=step-1 --input logo=logo.svg main.typ
// Handout with each slide above its notes: --input handout=notes
// See the README ("Building") for fonts.
#import "@preview/sci-propos-presentation:0.1.0": *

#show: presentation-theme.with(
  config-info(
    title: [A specific title: field, then what sets the work apart],
    subtitle: [One line that says what the talk shows],
    author: [#ph[Presenter name]],
    institution: [#ph[Department] · #ph[University]],
    date: datetime.today(),
  ),
  lang: "en",              // "fr", "zh-Hans", "zh-Hant"
  style: "sans",           // or "serif"
  section-label: "footer", // "2 Results · 5 / 7"; or "top", none
  contact: (lines: [#ph[Group name] · #ph[email\@example.org]], qr: "https://example.org"),
  files: p => path(p),     // lets the theme open your logo and screenshots
)

// An orienting picture on the title slide: the scope, the setting, or why it matters.
#title-slide(image: rect(width: 100%, height: 200pt, fill: luma(235),
  align(center + horizon)[#ph[Orienting picture]]))
#speaker-note[First sentence of the talk, learnt by heart.]

#outline-slide()

= Question
why this matters

// Every content slide: a short title (for finding the slide), a lead line
// that states its point as one full sentence (at most two lines), and the
// evidence: a figure, a table, an equation, code beside its output.
== The gap
#lead[The measured quantity varies by a factor of two across conditions that the models treat as one]
#align(center, rect(width: 420pt, height: 200pt, fill: luma(235),
  align(center + horizon)[#ph[Graph that shows the gap]]))
#credit[Source: #ph[Author, year].]
#speaker-note[Rehearsal script for this slide. Key phrases: …]

= Method
what we did

== Code beside its output
#lead[The output on the right comes from the code on the left]
#demo(```typst
$ k_"eff" = (nu Sigma_f) / Sigma_a $
```.text)

== A table
#lead[Case B stays within 2 % of case A]
#align(center, table(
  columns: 3,
  [Case], [Value], [Unit],
  [A], [1.00], [–],
  [B], [0.98], [–],
))
#credit[Illustrative values.]

= Results
what the measurements show

== Main result
#lead[State the main result as one sentence with its key number]
#align(center, annotate(rect(width: 380pt, height: 200pt, fill: luma(235)),
  (x: 70%, y: 30%, dx: 80pt, dy: -40pt, label: [#ph[call-out]])))

// The last slide of a research talk: it stays up while people ask questions.
#conclusion-slide(
  lead: [In summary, restate the talk's main takeaway in one sentence],
  points: ([First supporting assertion], [Second supporting assertion], [Third supporting assertion]),
)
#speaker-note[Last sentence of the talk, learnt by heart. Pause, thank the audience, then invite questions.]

// Backup slides for the questions don't increase the total.
#show: appendix

== Backup: details
#lead[Details that the committee or audience may ask about]
