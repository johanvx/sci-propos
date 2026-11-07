# Tests

Each file must compile without errors or warnings (given the installed
fonts with `--input fonts=…`). Compile from the package folder with
`--root .`, render every page and look at it. Expected page counts:

| File | Pages |
|---|---|
| `smoke/test.typ` (report with every element, two appendices) | 4 |
| `smoke/letter.typ` | 1 |
| `smoke/memo.typ` | 2 |
| `smoke/paper.typ` | 1 |
| `options/test.typ` (sans, US Letter, title page, unnumbered, red accent) | 2 |
| `options/lang.typ` (Chinese, sans) | 1 |

The gallery (`gallery/`) holds the full samples: a letter (`--input
lang=…`), and a memo report, a laboratory report and a research paper in
each language (`*-en.typ`, `*-fr.typ`, `*-zh-Hans.typ`, `*-zh-Hant.typ`).
