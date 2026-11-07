// A two-page letter in each language would be long; one page in English,
// with every field, is enough here (the gallery covers the languages).
#import "../../lib.typ": *
#show: letter.with(sender: [S], recipient: [R], subject: [About this], salutation: [Dear R:],
  signature: [N], enclosures: [CV], cc: [C], date: datetime(year: 2026, month: 1, day: 2),
  signature-image: rect(width: 3cm, height: 1cm))
#lorem(60)

#lorem(40)
