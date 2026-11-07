// Words the theme writes itself, per language. Keys missing from a language
// fall back to English. Languages: en, fr, zh-Hans, zh-Hant.

#let strings = (
  en: (
    conclusion: [Conclusion],
    contact: [Contact],
    lead-too-long: [lead longer than two lines: shorten the sentence],
    contents: [Outline],
    thanks: [Thank you],
    questions: [Questions?],
    references: [References],
    resources: [Resources],
    step: [Step],
    note: [Note],
    definition: [Definition],
    intro: [In short],
    recap: [Recap],
    reminder: [Reminder],
    screenshot: [Screenshot],
    logo: [Logo],
    figure: [Figure],
    algorithm: [Algorithm],
    months: ("January", "February", "March", "April", "May", "June", "July",
      "August", "September", "October", "November", "December"),
    date: (d, m, y) => d + " " + m + " " + y,
    sep: [ · ],
  ),
  fr: (
    conclusion: [Conclusion],
    contact: [Contact],
    lead-too-long: [phrase de plus de deux lignes : à raccourcir],
    contents: [Plan],
    thanks: [Merci],
    questions: [Des questions ?],
    references: [Références],
    resources: [Ressources],
    step: [Étape],
    note: [Remarque],
    definition: [Définition],
    intro: [En bref],
    recap: [Récapitulatif],
    reminder: [Rappel],
    screenshot: [Capture d’écran],
    logo: [Logo],
    figure: [Figure],
    algorithm: [Algorithme],
    months: ("janvier", "février", "mars", "avril", "mai", "juin", "juillet",
      "août", "septembre", "octobre", "novembre", "décembre"),
    date: (d, m, y) => d + " " + m + " " + y,
    sep: [ · ],
  ),
  zh-Hans: (
    conclusion: [结论],
    contact: [联系方式],
    lead-too-long: [引导句超过两行：请缩短],
    contents: [目录],
    thanks: [谢谢],
    questions: [欢迎提问],
    references: [参考文献],
    resources: [资源],
    step: [步骤],
    note: [注],
    definition: [定义],
    intro: [简介],
    recap: [回顾],
    reminder: [提醒],
    screenshot: [截图],
    logo: [标志],
    figure: [图],
    algorithm: [算法],
    months: none,
    date: (d, m, y) => y + "年" + m + "月" + d + "日",
    sep: [ · ],
  ),
  zh-Hant: (
    conclusion: [結論],
    contact: [聯絡方式],
    lead-too-long: [引導句超過兩行：請縮短],
    contents: [目錄],
    thanks: [謝謝],
    questions: [歡迎提問],
    references: [參考文獻],
    resources: [資源],
    step: [步驟],
    note: [註],
    definition: [定義],
    intro: [簡介],
    recap: [回顧],
    reminder: [提醒],
    screenshot: [截圖],
    logo: [標誌],
    figure: [圖],
    algorithm: [演算法],
    months: none,
    date: (d, m, y) => y + "年" + m + "月" + d + "日",
    sep: [ · ],
  ),
)

/// Normalize a language tag to one of the keys above.
/// Accepts "en", "fr", "zh", "zh-Hans", "zh-CN", "zh-Hant", "zh-TW", "zh-HK".
#let lang-key(lang) = {
  let l = lower(lang)
  if l in ("zh", "zh-hans", "zh-cn", "zh-sg", "zh-sc") { "zh-Hans" }
  else if l in ("zh-hant", "zh-tw", "zh-hk", "zh-mo", "zh-tc") { "zh-Hant" }
  else if l.starts-with("fr") { "fr" }
  else if l.starts-with("en") { "en" }
  else { panic("sci-propos: lang must be \"en\", \"fr\", \"zh-Hans\" or \"zh-Hant\", got " + repr(lang)) }
}

/// The `text` settings (lang, region) for a language key.
#let text-lang(key) = (
  en: (lang: "en"),
  fr: (lang: "fr"),
  zh-Hans: (lang: "zh", region: "cn"),
  zh-Hant: (lang: "zh", region: "tw"),
).at(key)

/// One string for a language key, falling back to English.
#let word(key, name) = strings.at(key, default: strings.en).at(name, default: strings.en.at(name))

/// Format a date in the deck's language. Content passes through unchanged.
#let format-date(key, date) = {
  if type(date) != datetime { return date }
  let months = word(key, "months")
  let m = if months == none { str(date.month()) } else { months.at(date.month() - 1) }
  (word(key, "date"))(str(date.day()), m, str(date.year()))
}
