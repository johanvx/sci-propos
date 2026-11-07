# sci-propos for Word

`sci-propos-report.dotx` (A4) and `sci-propos-report-us-letter.dotx` are Word
templates in the look of the `sci-propos-writing` Typst package, for courses
and journals that require Word. Double-click one to start a new document; its
single page is a style guide with placeholders.

The styles:

| Style | Look | Use |
|---|---|---|
| Normal | Cambria 11 pt, ragged right, 8 pt after | Body text (serif, as Alley recommends for documents) |
| Title, Subtitle | Calibri bold 20 pt; Calibri 13 pt | The title block |
| Document Kind | Calibri bold, green | "Laboratory report" above the title |
| Byline | Cambria 11 pt, tight | Authors, affiliation, date |
| Summary Heading | Calibri bold 11.5 pt | "Summary" or "Abstract" |
| Heading 1–3 | Calibri bold 15, 12.5, 11 pt | Sections; type the number ("2.1  Apparatus") |
| Caption, Caption Label | Cambria 9.9 pt; Calibri bold | "Table 1" in Caption Label, then ". " and the phrase |
| Three-Line Table | rules above and below the header and at the end | Every table |
| Bibliography | hanging indent | The reference list |
| Code | Consolas 9.5 pt | Code listings |
| Placeholder | green | Text to replace, in square brackets |

Captions go below figures and above tables. East Asian text uses SimSun
(body) and DengXian (headings), which come with Office; for Traditional
Chinese, change them to PMingLiU and Microsoft JhengHei in the Normal and
Heading styles. The header row of a Three-Line Table is bold in Word; other
viewers may need it set directly.

## Rebuilding

`source/make_template.py` builds both files with python-docx:

```sh
cd source
uv run --with python-docx python make_template.py ../sci-propos-report.dotx
uv run --with python-docx python make_template.py --paper us-letter ../sci-propos-report-us-letter.dotx
```

Check the result by saving a copy as `.docx`, converting it to PDF
(`soffice --headless --convert-to pdf`) and looking at the page;
`previews/report-template.png` shows the expected look.
