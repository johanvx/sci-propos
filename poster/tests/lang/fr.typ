// French: words written by the poster, spacing before : ; ? !. Expect 1 page.
#import "../../lib.typ": *
#show: poster.with(
  lang: "fr",
  title: [Un capteur optique à 120 \$ suit la turbidité des crues à 5 % près],
  authors: [#ph[Prénom Nom]#inst(1)],
  affiliation: [#inst(1)#ph[Laboratoire, Université, Ville]],
  points: ([Les prélèvements hebdomadaires manquent les crues ;], [la mesure reste linéaire jusqu’à 1 000 NTU.]),
  qr: "https://example.org",
  contact: [#ph[prenom.nom\@exemple.fr]],
  references: [[1] #ph[Auteur, titre, revue (année).]],
  acknowledgments: [#ph[Financement.]],
)
= Les crues transportent l’essentiel des sédiments
Entre deux crues, la rivière reste près de 20 NTU ; pendant une crue, elle dépasse plusieurs centaines de NTU.
= Deux photodiodes mesurent la lumière diffusée et transmise
Le rapport des deux signaux augmente avec la turbidité : il compense la dérive de la LED.
