// Rapport de travaux pratiques (données illustratives). Auteurs et cours sont
// des emplacements à remplir.
// Compilation (depuis le dossier du paquet) : typst compile --root . gallery/lab-fr.typ

#import "../lib.typ": *
#import "lab-figures.typ": nu-plot, runs, cb, f1, grouped

#show: report.with(
  lang: "fr",
  kind: [Rapport de travaux pratiques],
  title: [Transfert thermique d’un cylindre chauffé en écoulement transversal],
  authors: ([#ph[Auteur un]], [#ph[Auteur deux]]),
  affiliation: [#ph[Cours] · #ph[Établissement]],
  date: datetime(year: 2026, month: 11, day: 7),
  summary: [
    Ce rapport présente des mesures du transfert thermique d’un cylindre de cuivre chauffé, de
    25~mm de diamètre, placé en travers de l’écoulement d’une soufflerie. Nous avons mesuré le
    nombre de Nusselt moyen pour six nombres de Reynolds compris entre 2~000 et 40~000, puis
    nous l’avons comparé à la corrélation de Churchill et Bernstein. Sur cette plage, les
    valeurs mesurées dépassent la corrélation de 3 à 7~%, bien en deçà des 20~% d’incertitude
    que lui attribuent les manuels. La principale source d’erreur est la chaleur perdue par
    conduction dans les supports du cylindre, que nous estimons à 2~% de la puissance de
    chauffe. Ces résultats justifient l’emploi de la corrélation pour dimensionner les ailettes
    de l’échangeur du #ph[projet].
  ],
)

= Introduction

Les ingénieurs dimensionnent échangeurs, capteurs et refroidisseurs électroniques à l’aide de
corrélations du transfert thermique autour d’un cylindre en écoulement transversal. La plus
utilisée, celle de Churchill et Bernstein @churchill1977, couvre tous les nombres de Reynolds
pour lesquels on dispose de données. Les manuels préviennent toutefois que de telles
corrélations peuvent se tromper de 20~% @bergman2011. Avant de l’utiliser pour dimensionner
les ailettes du #ph[projet], nous devons savoir si elle prédit bien le transfert thermique dans
notre propre soufflerie.

Cette expérience avait deux objectifs : mesurer le nombre de Nusselt moyen d’un cylindre
chauffé pour des nombres de Reynolds de 2~000 à 40~000, et comparer ces mesures à la
corrélation, qui s’écrit

$ overline("Nu")_D = "0,3" + ("0,62" thin "Re"_D^(1 slash 2) "Pr"^(1 slash 3))
  / [1 + ("0,4" slash "Pr")^(2 slash 3)]^(1 slash 4)
  [1 + ("Re"_D / (282 thin 000))^(5 slash 8)]^(4 slash 5) $ <eq:cb>

où $"Re"_D = V D slash nu$ est le nombre de Reynolds rapporté au diamètre $D$ et Pr le nombre
de Prandtl de l’air, 0,71. La section 2 décrit le montage et le protocole, la section 3
présente et discute les résultats, et la section 4 donne nos conclusions. L’annexe A rassemble
les données brutes.

= Protocole

Nous avons placé un cylindre de cuivre de 25~mm de diamètre et 150~mm de long en travers de la
veine d’essai de la soufflerie à circuit ouvert du laboratoire. Une cartouche chauffante logée
dans le cylindre fournissait une puissance constante, mesurée au wattmètre, et deux
thermocouples noyés dans le cuivre donnaient sa température de surface. Un tube de Pitot placé
en amont donnait la vitesse de l’air.

Pour chacune des six vitesses, de 1,3 à 25,6~m/s, nous avons attendu que la température de
surface varie de moins de 0,1~K en cinq minutes. Nous avons alors relevé la puissance de
chauffe, la température de surface et celle de l’air. La loi de Newton donne ensuite le
coefficient d’échange moyen

$ h = P / (A (T_s - T_infinity)) $ <eq:newton>

où $P$ est la puissance de chauffe diminuée des pertes estimées par conduction, $A$ la surface
du cylindre, $T_s$ la température de surface et $T_infinity$ celle de l’air. Le nombre de
Nusselt vaut alors $h D slash k$, où $k$ est la conductivité thermique de l’air à la
température de film.

= Résultats et discussion

Les nombres de Nusselt mesurés suivent de près la tendance de la corrélation. La @fig:nu
montre qu’ils la dépassent de 3 à 7~% sur toute la plage, l’écart le plus grand se situant aux
plus faibles nombres de Reynolds.

#figure(
  nu-plot(xlabel: [Nombre de Reynolds], ylabel: [Nombre de Nusselt], measured: [mesures],
    correlation: [Churchill et Bernstein]),
  caption: [Nombre de Nusselt moyen du cylindre en fonction du nombre de Reynolds. Les barres
    indiquent la dispersion des essais répétés (±1,5~%) ; la courbe est l’@eq:cb.],
) <fig:nu>

Ces écarts sont bien plus faibles que l’incertitude de la corrélation, mais ils ont tous le
même signe, ce qui indique un biais plutôt qu’une dispersion aléatoire. La source la plus
probable en est la perte par conduction dans les supports. Nous l’avons estimée à 2~% de la
puissance de chauffe d’après la température des supports ; si la perte réelle était deux fois
plus grande, les valeurs mesurées baisseraient encore de 2~%. Une seconde source est
l’obstruction de la veine : le cylindre en occupe 8~% de la hauteur, si bien que l’écoulement
accélère autour de lui et augmente légèrement le transfert.

Les mesures sont plus fidèles que justes. Des essais répétés à la même vitesse concordaient à
1,5~% près ; la dispersion aléatoire ne peut donc pas expliquer les écarts avec la corrélation.

= Conclusions

Les deux objectifs ont été atteints. Quand le nombre de Reynolds passe de 2~000 à 40~000, le
nombre de Nusselt moyen passe d’environ 24 à environ 123, et il reste de 3 à 7~% au-dessus de
la corrélation de Churchill et Bernstein. Cet accord se situe bien à l’intérieur de
l’incertitude de la corrélation. Nous recommandons donc de l’utiliser, avec une marge de 10~%,
pour dimensionner les ailettes du #ph[projet]. Un essai avec des supports isolés montrerait
quelle part du biais restant vient de la conduction.

#show: appendix

= Données brutes

Le @tab:raw donne les mesures de chaque essai et le nombre de Nusselt prédit par l’@eq:cb. La
température de l’air est restée à 22,0~°C ; l’essai 1 a mis le plus de temps à se stabiliser,
environ 40 minutes.

#figure(
  table(
    columns: 8,
    align: (center,) + (right,) * 7,
    [Essai], [$V$ (m/s)], [$P$ (W)], [$T_s$ (°C)], [$T_infinity$ (°C)], [$"Re"_D$], [$overline("Nu")_D$], [Éq. 1],
    ..runs.map(r => (
      str(r.at(0)), f1(r.at(1), sep: ","), f1(r.at(2), sep: ","), f1(r.at(3), sep: ","),
      f1(r.at(4), sep: ","), grouped(r.at(5)), f1(r.at(6), sep: ","), f1(cb(r.at(5)), sep: ","),
    )).flatten(),
  ),
  caption: [Mesures et nombres de Nusselt correspondants],
) <tab:raw>

#bibliography("refs.bib", style: "chicago-author-date")
