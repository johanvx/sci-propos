// Font choice. Typst bundles only Libertinus Serif, New Computer Modern and
// DejaVu Sans Mono, and warns once for every listed family that is not
// installed. So each role has a list of candidates, and:
//   * given the installed families (`--input fonts=a,b,c`, e.g. from
//     `typst fonts`), the theme uses the first installed candidate, with no
//     warnings;
//   * otherwise, or when no candidate is installed, it uses the first
//     candidate only (one warning if missing).
// Noto CJK fonts are named "Noto Sans SC" on Windows and macOS and
// "Noto Sans CJK SC" on Linux; both are candidates.

#let candidates = (
  sans: ("Noto Sans", "Arial"),
  serif: ("Noto Serif", "Libertinus Serif"),
  mono: ("Noto Sans Mono", "DejaVu Sans Mono"),
  math: ("New Computer Modern Math",),
  cjk: (
    sans: (
      zh-Hans: ("Noto Sans SC", "Noto Sans CJK SC", "Source Han Sans SC", "PingFang SC", "Microsoft YaHei"),
      zh-Hant: ("Noto Sans TC", "Noto Sans CJK TC", "Source Han Sans TC", "PingFang TC", "Microsoft JhengHei"),
    ),
    serif: (
      zh-Hans: ("Noto Serif SC", "Noto Serif CJK SC", "Source Han Serif SC", "Songti SC", "SimSun"),
      zh-Hant: ("Noto Serif TC", "Noto Serif CJK TC", "Source Han Serif TC", "Songti TC", "PMingLiU"),
    ),
  ),
)

/// Installed families passed with `--input fonts=a,b,c` (lowercase), or none.
#let installed() = {
  let s = sys.inputs.at("fonts", default: none)
  if s == none { none } else { s.split(",").map(f => lower(f.trim())).filter(f => f != "") }
}

/// The families to use for one role: a user value wins; otherwise the first
/// installed candidate, or the first candidate when nothing is known.
/// Bundled fonts (Libertinus Serif, DejaVu Sans Mono, New Computer Modern Math)
/// count as installed.
#let pick(user, options) = {
  if user != auto {
    return if type(user) == array { user } else { (user,) }
  }
  let bundled = ("libertinus serif", "dejavu sans mono", "new computer modern math", "new computer modern")
  let have = installed()
  if have == none { return (options.first(),) }
  let found = options.filter(f => lower(f) in have or lower(f) in bundled)
  // Nothing installed: keep the first candidate, so Typst warns once and
  // falls back (an empty list would be an error).
  if found.len() > 0 { (found.first(),) } else { (options.first(),) }
}

/// The resolved font settings for a style ("sans" or "serif") and language.
#let resolve-fonts(style, key, font: auto, cjk-font: auto, code-font: auto, math-font: auto) = {
  assert(style in ("sans", "serif"), message: "sci-propos: style must be \"sans\" or \"serif\", got " + repr(style))
  let latin = pick(font, candidates.at(style))
  let cjk = if key in ("zh-Hans", "zh-Hant") { pick(cjk-font, candidates.cjk.at(style).at(key)) } else { () }
  // In Chinese text, Latin letters come from the Latin font and everything else
  // (including CJK punctuation) from the CJK font.
  let text-font = if cjk.len() > 0 {
    latin.map(f => (name: f, covers: "latin-in-cjk")) + cjk
  } else { latin }
  (
    text: text-font,
    code: pick(code-font, candidates.mono) + cjk,
    math: pick(math-font, candidates.math),
    cjk: cjk.len() > 0,
  )
}
