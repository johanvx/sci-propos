# Tests

Each folder holds a small deck that must compile without errors or warnings
(given the fonts it names). From the package folder, with `sci-propos-core`
installed (see the repository README):

```sh
typst compile --root . tests/smoke/test.typ        # title, outline, sections, lead/credit, #pause
typst compile --root . tests/options/test.typ      # title-color, title-rule: false, math-font
typst compile --root . tests/aspect/test.typ       # aspect-ratio: "4-3"
typst compile --root . tests/regressions/test.typ  # reported bugs: code-panel size, scoped settings,
                                                   # math-align, no label on the closing slide
typst compile --root . tests/closing/test.typ      # closing slides: one page or two, QR codes
typst compile --root . tests/numbering/test.typ    # numbering: (title: true); also level3.typ, nosection.typ
typst compile --root . tests/ae/test.typ           # section label on top, logo on title and closing only,
                                                   # no descriptions, no lead check, black slide counted
```

Expected page counts: smoke 10, options 4, aspect 10, regressions 8,
closing 7, numbering 8 (level3 4, nosection 5), ae 7. An extra page means
a slide overflowed.

The gallery decks (`gallery/*.typ`) are the visual tests: render them and
compare page by page with the previous version before releasing.
`gallery/assertion-evidence.typ` (15 pages) takes `--input lang=fr|zh-Hans|zh-Hant`,
`--input outline=map` and `--input handout=notes`.
