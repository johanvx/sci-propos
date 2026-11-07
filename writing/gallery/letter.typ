// A cover letter for a research internship, in each language's convention.
// Build (from the package folder):
//   typst compile --root . gallery/letter.typ
//   --input lang=fr|zh-Hans|zh-Hant      --input paper=us-letter
// Names, addresses and the details of the applicant are placeholders.

#import "../lib.typ": *

#let lang = sys.inputs.at("lang", default: "en")
#let paper = sys.inputs.at("paper", default: "a4")
#let date = datetime(year: 2026, month: 11, day: 7)

#let args = (
  en: (
    sender: [#ph[Street address] \ #ph[City, State ZIP]],
    recipient: [#ph[Dr. First Last] \ #ph[Director, Thermal Sciences Laboratory] \ #ph[Organization] \
      #ph[Street address] \ #ph[City, State ZIP]],
    salutation: [Dear Dr. #ph[Last]:],
    signature: [#ph[Your name]],
    enclosures: [Résumé],
  ),
  fr: (
    sender: [#ph[Prénom Nom] \ #ph[Adresse] \ #ph[Code postal Ville] \ #ph[Téléphone] · #ph[courriel\@exemple.fr]],
    recipient: [#ph[Madame Prénom Nom] \ #ph[Responsable du laboratoire] \ #ph[Organisme] \
      #ph[Adresse] \ #ph[Code postal Ville]],
    place: [#ph[Ville]],
    subject: [Candidature à un stage de recherche en transferts thermiques],
    enclosures: [curriculum vitæ],
    salutation: [Madame,],
    closing: [Je vous prie d’agréer, Madame, l’expression de mes salutations distinguées.],
    signature: [#ph[Prénom Nom]],
  ),
  zh-Hans: (
    subject: [暑期科研实习申请],
    salutation: [尊敬的#ph[王]教授：],
    signature: [学生　#ph[姓名]],
    sender: [#ph[电话]　#ph[电子邮箱]],
    enclosures: [个人简历],
  ),
  zh-Hant: (
    subject: [暑期研究實習申請],
    salutation: [#ph[王]教授鈞鑑：],
    signature: [學生　#ph[姓名]　敬上],
    sender: [#ph[電話]　#ph[電子郵件]],
    enclosures: [個人履歷],
  ),
).at(lang)

#show: letter.with(lang: lang, paper: paper, date: date, ..args)

#if lang == "en" [
  Please consider me for the summer research internship in your laboratory's heat-transfer
  group. I am a third-year mechanical engineering student at #ph[University], and I would like
  to spend next summer measuring how free-stream turbulence affects the cooling of gas turbines.

  My coursework and laboratory work match the needs that your posting lists. In Heat Transfer
  and in Fluid Mechanics, I earned the top mark of my class. In our junior laboratory, I built a
  hot-wire rig that measured turbulence intensity to within 3 % of a reference probe. I also
  wrote its data-acquisition code and documented it for the next class. The enclosed résumé
  lists these projects and the tools I used.

  Your group's recent work on leading-edge cooling is why I am writing to you. Last spring, I
  read your paper on turbulence grids, and its method shaped the design of my rig. Working
  beside its authors would teach me how such experiments are planned at full scale. In return,
  I can offer careful measurements and clear records of them.

  Thank you for considering my application. I am available for an interview at any time and can
  be reached at #ph[phone number] or #ph[email address].
] else if lang == "fr" [
  Je souhaite effectuer un stage de recherche de trois mois dans votre équipe de transferts
  thermiques, de juin à août prochain. Élève en troisième année d’école d’ingénieurs à
  #ph[établissement], je m’intéresse en particulier à l’effet de la turbulence sur le
  refroidissement des turbines à gaz.

  Ma formation correspond aux compétences que vous recherchez. En transferts thermiques comme
  en mécanique des fluides, j’ai obtenu la meilleure note de ma promotion. En projet, j’ai
  construit un banc à fil chaud qui mesure l’intensité de turbulence à 3 % près d’une sonde de
  référence ; j’en ai aussi écrit et documenté le logiciel d’acquisition. Mon curriculum vitæ
  détaille ces projets et les outils utilisés.

  C’est la lecture de vos travaux récents sur le refroidissement des bords d’attaque qui m’a
  conduit à vous écrire. Leur méthode a guidé la conception de mon propre banc. Auprès de votre
  équipe, j’apprendrais à préparer de telles expériences à grande échelle ; en retour, je vous
  apporterais des mesures soignées et documentées.

  Je me tiens à votre disposition pour un entretien, à la date qui vous conviendra.
] else if lang == "zh-Hans" [
  您好！

  我是#ph[大学]机械工程专业三年级学生#ph[姓名]，希望申请明年暑期到您的传热实验室参加为期三个月的科研实习，研究来流湍流对燃气轮机冷却的影响。

  我的课程和实践经历与实验室的要求相符。我的传热学和流体力学成绩均为专业第一。在课程设计中，我搭建了一套热线风速测量装置，测得的湍流度与参考探头相差不到 3%；我还编写了它的数据采集程序，并整理了说明文档。随信附上的简历列出了这些项目和所用工具。

  我之所以写信给您，是因为读到了您课题组关于前缘冷却的最新论文。论文中的格栅方法直接影响了我的装置设计。如能在您的指导下工作，我将学会如何规划全尺寸实验；我也会认真测量，并完整记录每一组数据。

  感谢您在百忙之中阅读此信。如需面谈，我随时可以安排。
] else [
  您好！

  我是#ph[大學]機械工程學系三年級學生#ph[姓名]，希望明年暑假到您的熱傳實驗室進行為期三個月的研究實習，探討來流紊流對燃氣渦輪冷卻的影響。

  我的修課與實作經驗符合實驗室的需求。我的熱傳學與流體力學成績皆為系上第一。在專題中，我架設了一套熱線風速量測裝置，量得的紊流強度與參考探針相差不到 3%；我也撰寫了它的資料擷取程式，並整理了說明文件。隨信附上的履歷列出了這些專題與使用的工具。

  我寫信給您，是因為拜讀了您研究團隊關於前緣冷卻的最新論文。論文中的格柵方法直接影響了我的裝置設計。若能在您的指導下工作，我將學到如何規劃全尺寸實驗；我也會仔細量測，並完整記錄每一組數據。

  感謝您撥冗閱讀此信。如需面談，我隨時可以配合。
]
