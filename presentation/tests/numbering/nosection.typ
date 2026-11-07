#import "../../lib.typ": *
#show: presentation-theme.with(config-info(title: [Numbering]), logo: none, numbering: (section: false, title: true))
= First
== Alpha
Title reads "1 Alpha".
= Second
== Beta
Title reads "1 Beta" (numbers restart in each section).
== Gamma
Title reads "2 Gamma".
