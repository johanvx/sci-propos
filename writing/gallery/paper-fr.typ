// Article de recherche sous forme de manuscrit (données illustratives). Auteurs,
// affiliations et certaines références sont des emplacements à remplir.
// Compilation (depuis le dossier du paquet) : typst compile --root . gallery/paper-fr.typ

#import "../lib.typ": *
#import "paper-figures.typ": calibration-plot

#show: paper.with(
  lang: "fr",
  title: [Un capteur optique à bas coût pour le suivi continu de la turbidité des rivières en crue],
  authors: ([#ph[Premier Auteur]#inst(1)], [#ph[Deuxième Auteur]#inst(1)], [#ph[Troisième Auteur]#inst(2)]),
  affiliations: ([#ph[Département], #ph[Université], #ph[Ville], #ph[Pays]],
    [#ph[Association de bassin versant], #ph[Ville], #ph[Pays]]),
  correspondence: [Auteur correspondant : #ph[courriel\@exemple.fr]],
  abstract: [
    L’essentiel des sédiments qu’une petite rivière transporte en un an passe pendant quelques
    crues, que les prélèvements hebdomadaires saisissent rarement. Nous présentons un capteur
    optique de turbidité que des bénévoles peuvent fabriquer pour environ 110~€ de pièces et
    entretenir sans outil. Une diode infrarouge éclaire un tube traversé par l’eau ; une
    photodiode mesure la lumière transmise, une seconde, à 90°, la lumière diffusée, et leur
    rapport compense la dérive de la diode. Sur des étalons de formazine, la réponse est linéaire
    jusqu’à 1~000~NTU ($R^2 = "0,999"$). Installé six mois à côté d’un instrument de laboratoire,
    le capteur a donné des moyennes journalières à 5~% près de la référence dès qu’un essuie-glace
    horaire a tenu les algues éloignées de la fenêtre. De tels capteurs permettraient à une
    association de suivre quarante sites pour le prix d’un seul instrument commercial.
  ],
  keywords: [turbidité ; sédiments en suspension ; capteur à bas coût ; sciences participatives ; crues],
)

= Introduction

Les sédiments en suspension transportent nutriments et polluants, colmatent les frayères et
renchérissent le traitement de l’eau potable. Dans les petites rivières, l’essentiel de la charge
annuelle circule pendant quelques crues, lorsque la turbidité passe de moins de 20~NTU à
plusieurs centaines de NTU en quelques heures. Mesurer ces épisodes exige des enregistrements
continus ; or les instruments qui les fournissent coûtent plusieurs milliers d’euros par site, si
bien que les associations s’en tiennent à des prélèvements hebdomadaires.

Des capteurs de turbidité à bas coût existent déjà, mais la plupart ne mesurent que la lumière
transmise, qui sature aux fortes turbidités, ou que la lumière diffusée, qui dérive avec le
vieillissement de la source #ph[(Auteur, année ; Auteur, année)]. Peu ont été comparés à un
instrument de référence pendant toute une saison de crues.

Cet article présente un capteur qui combine les deux mesures, décrit son étalonnage et rend
compte d’une comparaison de six mois avec un instrument de laboratoire. La section 2 décrit la
conception et les essais, la section 3 les résultats, la section 4 leurs limites et leurs usages.

= Méthodes

== Conception du capteur

Le capteur est un tube de 40~mm traversé par l’eau de la rivière. Une diode de 860~nm éclaire le
tube ; une photodiode placée en face mesure la lumière transmise, une seconde, à 90°, la lumière
diffusée par les particules. Le rapport des deux signaux croît avec la turbidité et ne dépend pas
de la luminosité de la diode. Un essuie-glace balaie les fenêtres optiques toutes les heures.

== Étalonnage et essai sur le terrain

Nous avons étalonné trois capteurs sur des étalons de formazine à huit niveaux, de 0 à
1~000~NTU, comme le prévoit la norme ISO~7027 @iso7027. Nous avons ensuite installé un capteur à
côté d’un turbidimètre de laboratoire à #ph[site] pendant six mois et comparé les moyennes
journalières des deux enregistrements.

= Résultats

== La réponse est linéaire jusqu’à 1 000 NTU

La @fig:cal montre la réponse d’un capteur en fonction des étalons de formazine. Une droite
passant par l’origine ajuste les huit points avec $R^2 = "0,999"$ ; une seule pente suffit donc
à convertir le signal en turbidité. Les pentes des trois capteurs diffèrent de moins de 4~%.

#figure(
  calibration-plot(xlabel: [Étalon de formazine (NTU)], ylabel: [Signal du capteur (V)], sep: ","),
  caption: [Signal d’un capteur en fonction des étalons de formazine. La droite est un ajustement
    par moindres carrés passant par l’origine.],
) <fig:cal>

== Les algues sur la fenêtre ont causé la seule dérive

Pendant le premier mois, avant la pose de l’essuie-glace, les mesures ont augmenté d’environ
8~% par semaine par rapport à la référence, à mesure que les algues colonisaient les fenêtres.
Après la pose, l’écart est resté proche de 1~%, et sur les cinq mois suivants les moyennes
journalières des deux instruments ont concordé à 5~% près (@tab:field).

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    [Période], [Jours], [Écart moyen], [Écart maximal],
    [Sans essuie-glace], [28], [+17~%], [+32~%],
    [Avec essuie-glace], [152], [+0,8~%], [+4,6~%],
  ),
  caption: [Écart entre les moyennes journalières du capteur et de l’instrument de référence],
) <tab:field>

= Discussion

Un accord à 5~% près correspond à peu près à la dispersion entre deux instruments de laboratoire
qui mesurent le même échantillon : le capteur est aussi proche de la référence qu’une seconde
référence le serait. L’essai ne porte que sur une rivière et une saison ; des rivières aux
sédiments plus grossiers ou plus sombres demanderont peut-être leur propre étalonnage. Le coût
des pièces, environ 110~€, permettrait à une association de suivre quarante sites pour le prix
d’un seul instrument commercial.

= Conclusions

Un capteur qui mesure à la fois la lumière transmise et la lumière diffusée, et qui nettoie
lui-même sa fenêtre, peut enregistrer la turbidité des crues à 5~% près d’un instrument de
laboratoire. La prochaine étape consiste à l’éprouver sur d’autres sédiments et pendant l’hiver.

#bibliography("refs.bib", style: "chicago-author-date")
