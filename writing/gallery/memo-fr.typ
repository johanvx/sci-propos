// Rapport sous forme de note : premier livrable d’un projet de conception
// (besoins du client et spécifications). Noms, client et cours sont des
// emplacements à remplir.
// Compilation (depuis le dossier du paquet) : typst compile --root . gallery/memo-fr.typ

#import "../lib.typ": *

#show: memo.with(
  lang: "fr",
  date: datetime(year: 2026, month: 11, day: 7),
  to: [#ph[Nom du client], #ph[Association de bassin versant]],
  from: [Équipe #ph[4] : #ph[Membre un], #ph[Membre deux], #ph[Membre trois]],
  subject: [Besoins des utilisateurs et spécifications d’un capteur de turbidité à bas coût],
  note: [#ph[Cours] · #ph[Semestre]],
)

= Introduction

Une eau boueuse est plus qu’une gêne pour une petite rivière. Les sédiments en suspension
transportent nutriments et polluants vers l’aval, colmatent les graviers où fraient les
poissons et renchérissent le traitement de l’eau potable. L’essentiel de ces sédiments circule
pendant quelques crues par an. Or les associations de bénévoles ne peuvent financer que des
prélèvements hebdomadaires, qui tombent rarement pendant une crue.

L’#ph[Association de bassin versant] a demandé à notre équipe de concevoir un capteur de
turbidité que ses bénévoles puissent fabriquer, installer et entretenir pour moins de 150~€ par
site. Dans ce rapport, l’_utilisateur_ est le bénévole qui installe et entretient le capteur ;
les salariés de l’association, qui analysent les données, sont des utilisateurs secondaires.

La section suivante présente les besoins que nous avons recensés. La section d’après traduit
chaque besoin principal en un critère, une valeur cible et un essai. L’annexe A donne notre
calendrier pour la suite du projet.

= Besoins des utilisateurs

Nous avons recensé les besoins au cours d’entretiens avec quatre bénévoles et deux salariés, de
visites de deux sites de mesure et de la lecture du cahier des charges @project. Nous les avons
ensuite classés en besoins principaux, que la conception doit satisfaire, et en besoins
secondaires, qui l’amélioreraient.

== Besoins principaux

*Le capteur doit rester exact pendant les crues.* Les salariés veulent des mesures comparables à
celles du laboratoire, faites selon la norme ISO~7027 @iso7027. Comme la turbidité peut passer
de moins de 20~NTU à plusieurs centaines de NTU en quelques heures, le capteur doit couvrir
toute cette plage.

*Le capteur doit coûter moins de 150~€ par site.* À ce prix, la subvention de l’association
couvre quarante sites ; au prix d’un seul instrument de laboratoire, elle n’en couvrirait qu’un.

*Les bénévoles doivent pouvoir entretenir le capteur sur le terrain.* La plupart n’ont aucune
formation en électronique et visitent chaque site environ une fois par mois. Nettoyer la
fenêtre optique et changer la pile doivent donc prendre quelques minutes, sans outil.

== Besoins secondaires

Les bénévoles aimeraient aussi que le capteur transmette ses mesures par le réseau mobile, pour
ne pas avoir à les relever sur place, et qu’il reste discret, pour limiter les vols et les
dégradations.

= Critères et spécifications

Le @tab:specs relie chaque besoin principal à un critère, une valeur cible, l’origine de cette
cible et l’essai qui montrera si un prototype la respecte.

#figure(
  table(
    columns: (0.9fr, 1.3fr, 1fr, 1.3fr, 1.1fr),
    align: left,
    [Besoin], [Critère], [Cible], [Origine de la cible], [Essai],
    [Exact en crue], [Écart avec un turbidimètre de laboratoire], [≤ 5~% de 0 à 1~000~NTU],
      [Entretiens avec les salariés ; plage de la norme ISO~7027 @iso7027], [Étalons de formazine à huit niveaux],
    [Bas coût], [Coût des pièces par site], [≤ 150~€], [Budget de la subvention pour quarante sites], [Nomenclature chiffrée],
    [Entretien sur le terrain], [Durée du nettoyage de la fenêtre et du changement de pile],
      [≤ 10~min, sans outil], [Entretiens avec les bénévoles], [Trois bénévoles, chronométrés],
  ),
  caption: [Critères et valeurs cibles des besoins principaux],
) <tab:specs>

La cible d’exactitude demande le plus de soin. Un écart de 5~% correspond à peu près à la
dispersion entre deux instruments de laboratoire qui mesurent le même échantillon. Une cible
plus serrée éprouverait donc l’instrument de référence plutôt que notre capteur.

= Conclusion

Les bénévoles ont besoin d’un capteur qui reste exact pendant les crues, coûte moins de 150~€ et
s’entretient sans outil ; les salariés, de données comparables aux mesures de laboratoire.
Dans la phase suivante, nous proposerons des concepts pour l’optique et le boîtier, puis nous
en choisirons un au regard des cibles du @tab:specs. L’annexe A indique la fin de chaque phase.

#show: appendix

= Calendrier du projet

Le @tab:schedule donne les phases du projet et leur date de fin. Nous avons confié chaque
phase selon l’expérience de chacun : #ph[Membre un] a déjà réalisé des circuits optiques,
#ph[Membre deux] a travaillé avec des enregistreurs de données et #ph[Membre trois] a mené des
campagnes de terrain.

#figure(
  table(
    columns: 3,
    align: (left, left, right),
    [Phase], [Responsable], [Fin],
    [Besoins et spécifications], [#ph[Membre trois]], [Semaine 4],
    [Recherche et choix de concepts], [#ph[Membre un]], [Semaine 7],
    [Prototype et essais en laboratoire], [#ph[Membre deux]], [Semaine 11],
    [Essai sur le terrain et rapport final], [#ph[Membre trois]], [Semaine 15],
  ),
  caption: [Phases du projet, avec leur responsable et leur date de fin],
) <tab:schedule>

#bibliography("refs.bib", style: "ieee")
