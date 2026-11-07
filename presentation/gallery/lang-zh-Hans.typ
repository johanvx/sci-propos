// Language sample: zh-Hans. Build: typst compile --root . gallery/lang-zh-Hans.typ
#import "../lib.typ": *
#show: presentation-theme.with(
  config-info(title: [Diapos 中文示例], subtitle: [Touying 的学术主题], author: [#ph[汇报人]], date: datetime(year: 2026, month: 10, day: 30)),
  lang: "zh-Hans",
  style: sys.inputs.at("style", default: "sans"),
  files: p => path(p),
)
#title-slide()
#outline-slide()

= 背景
为什么重要

== 一页一个观点
#lead[导语用一句话说明本页的要点。]
#aside(
  [
    - 列表纵向排列
    - 最多两栏并排
    - _注量_ / *注量*
  ],
  card-deck(term[注量][通量对时间的积分。], card(kind: "reminder")[单位：cm⁻²。], card(kind: "recap")[最多两栏并排]),
)

= 方法
我们做了什么

== 表格
#table(columns: 3, [A], [B], [C], [1], [2], [3], [4], [5], [6])

= 总结
要点与讨论

#thanks-slide()
