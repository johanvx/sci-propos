# sci-propos-core

The shared style of the sci-propos packages:
[`sci-propos-presentation`](https://typst.app/universe/package/sci-propos-presentation) (slides),
[`sci-propos-writing`](https://typst.app/universe/package/sci-propos-writing) (letters, reports, papers)
and [`sci-propos-poster`](https://typst.app/universe/package/sci-propos-poster) (posters). You rarely import it yourself; the other
packages import it and re-export what a document needs.

It holds:

| | |
|---|---|
| Palette and sizes | `defaults`: primary `#00561f`, near-black text, grays with at least 4.5:1 contrast on white (labels `#6E6E6E`, credits `#505050`, numbers `#3C3C3C`); sizes on the 16:9 slide page, which the themes scale; three-line table rules `table-rule` 1.5 pt and `table-midrule` 0.5 pt (slides 2 pt and 0.6 pt, posters scaled). |
| Fonts | `resolve-fonts(style, lang)`: Noto Sans or Noto Serif, Noto CJK for Chinese, Noto Sans Mono, New Computer Modern Math, with fallbacks. |
| Languages | `strings`, `lang-key`, `word`, `format-date`: English, French, Simplified and Traditional Chinese. |
| The shared look | `sp-style(conf, fonts, key, body)`: text, colored list markers, emphasis in the primary color (no italics in Chinese), code, three-line tables, quotes, captions. A theme applies it once and stores its configuration for the helpers. |
| Helpers | `credit`, `ph` (placeholders), `pkg`, `small`, `tiny`, `large`, `compact`, `citet`, `citep`, `footcite`, `LaTeX`, `TeX`, `inst`. |
| Layout | `two-columns`, `remaining`, `scale-to-fit`, `pipeline`, `annotate` (call-outs on a picture). |
| Code | `code-panel`, `labelled`, `demo` (code beside its output), `split-import`, `numbered`, `algorithm-figure`. |
| Pictures | `shot` (screenshot or a placeholder showing the expected path), `logo-slot`, `qr-code`. |
| Side cards | `card`, `term`, `card-deck`, `aside`. |

Helpers read the configuration with `cfg()` inside `context`. The
configuration lives in one state, `sp-config`, so a document that uses
several sci-propos packages shares it.

Requires Typst 0.15. QR codes use tiaoma 0.3, which Typst downloads and
loads only when a document draws one. Source, tests and
development notes: [the repository](https://github.com/johanvx/sci-propos).

## License

MIT
