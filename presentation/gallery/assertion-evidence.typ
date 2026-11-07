// The assertion-evidence features of sci-propos-presentation, as a short
// research talk with illustrative data.
//
// Build (from the package folder):
//   typst compile --root . gallery/assertion-evidence.typ
// Variants: --input lang=fr|zh-Hans|zh-Hant   --input outline=map
//           --input handout=notes             (each slide above its notes)

#import "../lib.typ": *
#import "figures.typ": wave, bars, rig, tile, green

#let lang = sys.inputs.at("lang", default: "en")
#let T(en, fr, hans, hant) = (en: en, fr: fr, zh-Hans: hans, zh-Hant: hant).at(lang)

#show: presentation-theme.with(
  config-info(
    title: T([Turbulence and leading-edge heat transfer], [Turbulence et transfert thermique au bord d’attaque],
      [湍流与前缘传热], [紊流與前緣熱傳]),
    subtitle: T([Why the standard correlations miss high turbulence], [Pourquoi les corrélations usuelles sous-estiment la forte turbulence],
      [为什么标准关联式低估了强湍流], [為什麼標準關聯式低估了強紊流]),
    author: [#ph[Presenter name]],
    institution: [#ph[Department] · #ph[University]],
    date: datetime(year: 2026, month: 11, day: 7),
  ),
  lang: lang,
  outline-style: sys.inputs.at("outline", default: "parts"),
  contact: (
    photo: box(width: 54pt, height: 54pt, fill: green.lighten(80%), radius: 3pt,
      align(center + horizon, text(size: 9pt, fill: green)[#ph[Photo]])),
    lines: [#ph[Group name] · #ph[email\@example.org]],
    qr: "https://example.org",
  ),
)

// The title page with an orienting picture: what the talk is about.
#title-slide(image: rig())

#outline-slide()

= #T([Question], [Question], [问题], [問題])
#T([what the correlations assume], [ce que supposent les corrélations], [关联式的假设], [關聯式的假設])
#section-image(tile(sym.quest))

== #T([The gap], [La lacune], [研究空白], [研究空白])
#lead[#T(
  [Gas-turbine vanes see 20 % turbulence; the correlations stop at 5 %],
  [Les aubes de turbine voient 20 % de turbulence, mais les corrélations ont été ajustées sous 5 %],
  [燃气轮机导叶面对 20% 的湍流，而关联式只在 5% 以下拟合],
  [燃氣渦輪導葉面對 20% 的紊流，而關聯式只在 5% 以下擬合],
)]
#align(center, bars(((T([correlations], [corrélations], [关联式], [關聯式]), [5 %], 5), (T([engine vanes], [aubes de moteur], [发动机导叶], [發動機導葉]), [20 %], 20)),
  reference: none, floor: 0.0, w: 300pt, h: 180pt))
#credit[#T([Illustrative: highest turbulence intensity in the data behind the correlations (gray) and at engine vanes (green).],
  [Illustratif : turbulence maximale des données des corrélations (gris) et sur les aubes de moteur (vert).],
  [示意：关联式数据（灰）与发动机导叶（绿）的最高湍流度。], [示意：關聯式資料（灰）與發動機導葉（綠）的最高紊流度。])]

= #T([Method], [Méthode], [方法], [方法])
#T([a grid upstream of a large-scale leading edge], [une grille en amont d’un bord d’attaque à grande échelle],
  [大尺度前缘上游的格栅], [大尺度前緣上游的格柵])
#section-image(rig())

== #T([Test section], [Veine d’essai], [试验段], [試驗段])
#lead[#T(
  [A grid of bars sets the turbulence level ahead of the leading edge],
  [Une grille de barreaux fixe le taux de turbulence devant le bord d’attaque],
  [前缘之前的格栅决定了湍流度], [前緣之前的格柵決定了紊流度],
)]
#align(center, annotate(rig(w: 420pt),
  (x: 12%, y: 15%, dx: 30pt, dy: -36pt, label: T([flow], [écoulement], [来流], [來流])),
  (x: 43%, y: 85%, dx: -60pt, dy: 40pt, label: T([turbulence grid], [grille de turbulence], [湍流格栅], [紊流格柵])),
  (x: 70%, y: 50%, dx: 130pt, dy: -60pt, label: T([heated leading edge], [bord d’attaque chauffé], [加热前缘], [加熱前緣])),
))
#speaker-note[Rehearsal script: point at the grid first, then follow the flow to the leading edge.]

== #T([Sampling], [Échantillonnage], [采样], [採樣])
#lead[#T(
  [Sampling at twice the highest frequency keeps the shape of the signal],
  [Échantillonner au double de la plus haute fréquence conserve la forme du signal],
  [以最高频率的两倍采样可保留信号形状], [以最高頻率的兩倍採樣可保留訊號形狀],
)]
#align(center, grid(columns: 2, column-gutter: 40pt,
  wave(9, label: T([3 samples per period], [3 points par période], [每周期 3 个点], [每週期 3 個點])),
  wave(30, label: T([10 samples per period], [10 points par période], [每周期 10 个点], [每週期 10 個點]))))
#credit[#T([Illustrative signal.], [Signal illustratif.], [示意信号。], [示意訊號。])]

= #T([Results], [Résultats], [结果], [結果])
#T([what the measurements show], [ce que montrent les mesures], [测量结果], [量測結果])
#section-image(box(width: 100%, height: 100%, align(center + horizon,
  bars((("", "", 1.0), ("", "", 1.08), ("", "", 1.17), ("", "", 1.35)), small: true, w: 220pt, h: 150pt))))

== #T([Heat transfer], [Transfert thermique], [传热], [熱傳])
#lead[#T(
  [At 20 % turbulence, heat transfer at the leading edge rises by 35 %, which the correlations miss],
  [À 20 % de turbulence, le transfert au bord d’attaque augmente de 35 %, ce que les corrélations ignorent],
  [湍流度为 20% 时，前缘传热提高 35%，而关联式未能反映],
  [紊流度為 20% 時，前緣熱傳提高 35%，而關聯式未能反映],
)]
#align(center, bars((("Tu 0.5 %", "1.00", 1.00), ("Tu 5 %", "1.08", 1.08), ("Tu 10 %", "1.17", 1.17), ("Tu 20 %", "1.35", 1.35)),
  ref-label: T([correlation], [corrélation], [关联式], [關聯式])))
#credit[#T([Illustrative data: normalised Stanton number.], [Données illustratives : nombre de Stanton normalisé.],
  [示意数据：归一化斯坦顿数。], [示意資料：歸一化史坦頓數。])]

== #T([Solver choice], [Choix du solveur], [求解器选择], [求解器選擇])
#lead[#T(
  [The implicit solver needs four times fewer steps for the same error],
  [Le solveur implicite demande quatre fois moins de pas pour la même erreur],
  [隐式求解器在相同误差下所需步数少四倍], [隱式求解器在相同誤差下所需步數少四倍],
)]
#align(center, table(columns: 4, align: (left, right, right, right),
  table.header(T([Solver], [Solveur], [求解器], [求解器]), T([Steps], [Pas], [步数], [步數]),
    T([Error], [Erreur], [误差], [誤差]), T([Time (s)], [Temps (s)], [时间 (s)], [時間 (s)])),
  [Explicit Euler], [12 800], [1.0 × 10#super[−3]], [4.1],
  [Runge–Kutta 4], [6 400], [0.9 × 10#super[−3]], [3.2],
  [Implicit (BDF2)], [3 200], [1.0 × 10#super[−3]], [1.9],
))
#credit[#T([Illustrative data.], [Données illustratives.], [示意数据。], [示意資料。])]

// A lead that runs past two lines gets a red flag (theme option `checks`).
== #T([Two-line check], [Contrôle des deux lignes], [两行检查], [兩行檢查])
#lead[#T(
  [This sentence is far too long for a lead line, because it keeps adding clauses, qualifications and details that belong in the speaker notes, not on the slide],
  [Cette phrase est bien trop longue pour une ligne d’accroche, car elle ajoute sans cesse des propositions, des nuances et des détails qui relèvent des notes de l’orateur],
  [这句话作为引导句太长了，因为它不断添加从句、限定和细节，而这些内容应当写进讲稿而不是放在幻灯片上，否则观众会来不及阅读],
  [這句話作為引導句太長了，因為它不斷添加子句、限定和細節，而這些內容應當寫進講稿而不是放在投影片上，否則觀眾會來不及閱讀],
)]
#align(center, text(fill: luma(110), T([The flag tells the author to cut the sentence; the type is never shrunk.],
  [Le repère invite à couper la phrase ; le texte n’est jamais réduit.],
  [红色标记提醒作者删减句子；字号从不缩小。], [紅色標記提醒作者刪減句子；字級從不縮小。])))

#conclusion-slide(
  lead: T(
    [In summary, high turbulence raises leading-edge heat transfer well beyond the correlations],
    [En résumé, la forte turbulence accroît le transfert au bord d’attaque bien au-delà des corrélations],
    [总之，强湍流使前缘传热远超关联式的预测], [總之，強紊流使前緣熱傳遠超關聯式的預測],
  ),
  points: (
    T([The correlations were fitted below 5 % turbulence], [Les corrélations ont été ajustées sous 5 % de turbulence],
      [关联式在 5% 湍流度以下拟合], [關聯式在 5% 紊流度以下擬合]),
    T([A grid sets 0.5–20 % turbulence ahead of the leading edge], [Une grille fixe 0,5 à 20 % de turbulence devant le bord d’attaque],
      [格栅在前缘前产生 0.5–20% 的湍流度], [格柵在前緣前產生 0.5–20% 的紊流度]),
    T([At 20 %, heat transfer rises by 35 %], [À 20 %, le transfert augmente de 35 %], [在 20% 时传热提高 35%], [在 20% 時熱傳提高 35%]),
  ),
  figures: (
    bars((("", "", 5), ("", "", 20)), reference: none, floor: 0.0, small: true, w: 100pt, h: 60pt),
    rig(w: 100pt),
    bars((("", "", 1.0), ("", "", 1.08), ("", "", 1.17), ("", "", 1.35)), small: true, w: 100pt, h: 60pt),
  ),
)

// For promotional talks: an affiliation page that still carries the takeaway.
#contact-slide(
  lead: T([High turbulence raises leading-edge heat transfer by up to 35 %],
    [La forte turbulence accroît le transfert au bord d’attaque jusqu’à 35 %],
    [强湍流使前缘传热最多提高 35%], [強紊流使前緣熱傳最多提高 35%]),
  photo: box(width: 100%, height: 100%, fill: green.lighten(85%), align(center + horizon, text(fill: green)[#ph[Group photo]])),
  lines: [
    *#ph[Group name]* \
    #ph[Department] · #ph[University] \
    #ph[email\@example.org]
  ],
  qr: "https://example.org",
)

#black-slide()

#show: appendix

== #T([Backup: uncertainty], [Annexe : incertitude], [备用：不确定度], [備用：不確定度])
#lead[#T([The measured rise exceeds the uncertainty at every turbulence level],
  [La hausse mesurée dépasse l’incertitude à chaque niveau de turbulence],
  [在每个湍流度下，测得的增幅都大于不确定度], [在每個紊流度下，測得的增幅都大於不確定度])]
#align(center, text(fill: luma(110))[#ph[Uncertainty table]])
