// Every document type in one file would mix page setups, so this test
// checks the report with every element; letter.typ, memo.typ and paper.typ
// check the others. Expected pages: see tests/README.md.
#import "../../lib.typ": *

#show: report.with(
  kind: [Test report], title: [Smoke Test of the Report], subtitle: [Every element once],
  authors: ([A], [B], [C]), affiliation: [Lab], date: datetime(year: 2026, month: 1, day: 2),
  summary: [A summary.], keywords: [one; two], toc: true,
)

= First Section
Text with *strong*, _emphasis_, `code`, a link #link("https://typst.app")[here], a footnote#footnote[A note.] and @fig:one, @tab:one, @eq:one, @app.

$ E = m c^2 $ <eq:one>

#figure(rect(width: 3cm, height: 1cm), caption: [Short.]) <fig:one>
#figure(rect(width: 3cm, height: 1cm), caption: [A long caption that runs over more than one line so that it is set flush left instead of centered under the figure, as the rule says.])

== Second Level
- a
  - b
+ one
+ two
/ Term: definition

=== Third Level
#figure(table(columns: 2, [H1], [H2], [a], [b]), caption: [A table.]) <tab:one>

```python
print("code block")
```

#show: appendix
= First Appendix <app>
#figure(rect(width: 2cm, height: 1cm), caption: [In the appendix.]) <fig:app>
See @fig:app and $ x = 1 $ <eq:app> @eq:app.
== Sub-appendix
= Second Appendix
#figure(table(columns: 1, [X], [y]), caption: [Second.])
