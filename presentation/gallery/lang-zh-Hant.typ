// Language sample: zh-Hant. Build: typst compile --root . gallery/lang-zh-Hant.typ
#import "../lib.typ": *
#show: presentation-theme.with(
  config-info(title: [Diapos 中文範例], subtitle: [Touying 的學術主題], author: [#ph[報告人]], date: datetime(year: 2026, month: 10, day: 30)),
  lang: "zh-Hant",
  style: sys.inputs.at("style", default: "sans"),
  files: p => path(p),
)
#title-slide()
#outline-slide()

= 背景
為什麼重要

== 一頁一個觀點
#lead[導語用一句話說明本頁的重點。]
#aside(
  [
    - 列表縱向排列
    - 最多兩欄並排
    - _注量_ / *注量*
  ],
  card-deck(term[注量][通量對時間的積分。], card(kind: "reminder")[單位：cm⁻²。], card(kind: "recap")[最多兩欄並排]),
)

= 方法
我們做了什麼

== 表格
#table(columns: 3, [A], [B], [C], [1], [2], [3], [4], [5], [6])

= 總結
重點與討論

#thanks-slide()
