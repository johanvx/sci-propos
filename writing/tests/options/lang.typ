// Chinese report with a sans style; French memo strings checked in the gallery.
#import "../../lib.typ": *
#show: report.with(title: [测试], lang: "zh-Hans", style: "sans", summary: [摘要文字。])
= 引言
中文段落首行缩进两字。#lorem(10)
#figure(rect(width: 2cm, height: 1cm), caption: [图题]) <f>
见@f。
