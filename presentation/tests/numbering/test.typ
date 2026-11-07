// numbering: (title: true) puts the heading's number before slide titles.
#import "../../lib.typ": *
#show: presentation-theme.with(config-info(title: [Numbering]), logo: none, numbering: (title: true))

= First
== Scoped settings
Title reads "1.1 Scoped settings".
== Second slide
Title reads "1.2 Second slide".
#pause
Same number on the second step.

#slide(title: [Explicit title])[No number: the title isn't a heading.]

= Second
== Back to one
Title reads "2.1 Back to one".

#thanks-slide(title: [Resources])[No number on the closing slide.]
