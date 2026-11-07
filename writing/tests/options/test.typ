// Options: sans style, US Letter, justified English, unnumbered headings,
// separate title page, custom summary title, a larger size, and a red accent.
#import "../../lib.typ": *
#show: report.with(title: [Options], style: "sans", paper: "us-letter", justify: true,
  numbered: false, title-page: true, summary: [S.], summary-title: [Executive Summary], size: 12pt,
  primary: rgb("#B31B1B"))
= Unnumbered
A placeholder in the accent color: #ph[name].
#lorem(80)
$ a = b $
