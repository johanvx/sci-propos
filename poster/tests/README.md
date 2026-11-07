# Tests

Compile each file from the package folder with `--root .` (and the installed
fonts with `--input fonts=…`), render every page and look at it. Expected
page counts:

| File | Pages |
|---|---|
| `smoke/test.typ` (A0: every element) | 1 |
| `sizes/test.typ` with `--input size=` `a0`, `a0-landscape`, `a1`, `48x36`, `36x48`, `16:9` | 1 each |
| `lang/fr.typ`, `lang/zh-Hans.typ`, `lang/zh-Hant.typ` | 1 each |
| `overflow/test.typ` (too much text: the second page carries a red flag) | 2 |

The repository's `examples/river-sensor/poster.typ` must also give one page
with `--input size=` `a0`, `48x36` and `16:9`.
