#import "../../lib.typ": *
#show: paper.with(title: [T], authors: ([A#inst(1)], [B#inst(2)]), affiliations: ([X], [Y]),
  correspondence: [c\@example.org], date: datetime(year: 2026, month: 1, day: 2),
  abstract: [Abstract.], keywords: [k])
= Intro
#lorem(50)
== The result is a sentence
#lorem(50)
