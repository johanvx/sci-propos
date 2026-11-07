// Simplified Chinese: fonts, the poster's own words, first-line indent. Expect 1 page.
#import "../../lib.typ": *
#show: poster.with(
  lang: "zh-Hans",
  title: [一台 120 美元的光学传感器测量暴雨期河流浊度，误差在 5% 以内],
  authors: [#ph[作者一]#inst(1)、#ph[作者二]#inst(2)],
  affiliation: [#inst(1)#ph[院系，大学，城市] · #inst(2)#ph[流域保护协会]],
  points: ([每周采样会错过暴雨], [散射光与透射光之比呈线性], [六个月内与参考仪器相差不到 5%]),
  qr: "https://example.org",
  contact: [#ph[电子邮箱]],
  references: [[1] #ph[作者，题名，期刊，年份。]],
  acknowledgments: [#ph[资助项目。]],
)
= 一年中的大部分泥沙在几场暴雨中输送
两场暴雨之间，河水浊度约为 20 NTU；暴雨期间可升至数百 NTU。每周一次的人工采样往往落在平静的日子。
= 两只光电二极管分别测量散射光和透射光
两路信号之比随浊度增大，并抵消发光二极管的缓慢漂移。
