// Traditional Chinese: fonts, the poster's own words, first-line indent. Expect 1 page.
#import "../../lib.typ": *
#show: poster.with(
  lang: "zh-Hant",
  title: [一台 120 美元的光學感測器量測豪雨期河川濁度，誤差在 5% 以內],
  authors: [#ph[作者一]#inst(1)、#ph[作者二]#inst(2)],
  affiliation: [#inst(1)#ph[系所，大學，城市] · #inst(2)#ph[流域保育協會]],
  points: ([每週採樣會錯過豪雨], [散射光與透射光之比呈線性], [六個月內與參考儀器相差不到 5%]),
  qr: "https://example.org",
  contact: [#ph[電子郵件]],
  references: [[1] #ph[作者，題名，期刊，年份。]],
  acknowledgments: [#ph[補助計畫。]],
)
= 一年中的大部分泥沙在幾場豪雨中輸送
兩場豪雨之間，河水濁度約為 20 NTU；豪雨期間可升至數百 NTU。每週一次的人工採樣往往落在平靜的日子。
= 兩只光電二極體分別量測散射光與透射光
兩路訊號之比隨濁度增大，並抵銷發光二極體的緩慢漂移。
