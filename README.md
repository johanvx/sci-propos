# sci-propos

Typst packages, and PowerPoint and Word templates, for scientific and
engineering communication, built on the assertion-evidence approach of
Michael Alley
(*The Craft of Scientific Presentations*, *The Craft of Scientific Writing*):
state each point as a sentence, then show the evidence.

| Folder | Package | Status |
|---|---|---|
| `core/` | `sci-propos-core` 0.1.0: the shared style (palette, fonts, four languages, cards, code panels, tables, call-outs, QR codes) | ready |
| `presentation/` | `sci-propos-presentation` 0.1.0: slides on Touying | ready |
| `writing/` | `sci-propos-writing` 0.1.0: letters, memo reports, laboratory and formal reports, research papers | ready |
| `poster/` | `sci-propos-poster` 0.1.0: assertion-evidence posters (A0, A1, 48 × 36 in, 16:9 e-poster) | ready |
| `powerpoint/` | `presentation-sans.potx`, `presentation-serif.potx`, and poster templates in `posters/`: PowerPoint templates in the same look, and the sources that generate them | ready |
| `word/` | `sci-propos-report.dotx` (A4, US Letter): a Word report template in the same look, and its generator | ready |
| `examples/` | Work done with the skills: `river-sensor/`, a 10-minute conference talk in Typst and PowerPoint with its notes handout, and its poster in three sizes; `proofreading/`, a Word draft reviewed with comments | ready |

Languages: English, French, Simplified and Traditional Chinese. Default
style: sans for slides and posters, serif for documents.

The matching agent skills (`scientific-presentation`, `scientific-writing`,
`scientific-poster`) live in the `agentic` repository.

## Installing before publication

The packages aren't on Typst Universe yet. Typst looks for packages in its
local package folder before downloading, so copying each package folder
there makes the `@preview` imports work offline:

| System | Package folder |
|---|---|
| macOS | `~/Library/Application Support/typst/packages/preview/` |
| Linux | `~/.local/share/typst/packages/preview/` (or under `$XDG_DATA_HOME`) |
| Windows | `%APPDATA%\typst\packages\preview\` |

Copy `core/` to `<package folder>/sci-propos-core/0.1.0/`,
`presentation/` to `<package folder>/sci-propos-presentation/0.1.0/`,
`writing/` to `<package folder>/sci-propos-writing/0.1.0/` and `poster/` to
`<package folder>/sci-propos-poster/0.1.0/`.
Touying 0.8 still downloads on the first compile, and tiaoma 0.3 the first
time a document draws a QR code.

While developing, a symbolic link instead of a copy keeps Typst reading the
repository itself (macOS, Linux):

```sh
P="$HOME/Library/Application Support/typst/packages/preview"   # Linux: ~/.local/share/typst/packages/preview
mkdir -p "$P/sci-propos-core" "$P/sci-propos-presentation" "$P/sci-propos-writing" "$P/sci-propos-poster"
ln -s "$PWD/core" "$P/sci-propos-core/0.1.0"
ln -s "$PWD/presentation" "$P/sci-propos-presentation/0.1.0"
ln -s "$PWD/writing" "$P/sci-propos-writing/0.1.0"
ln -s "$PWD/poster" "$P/sci-propos-poster/0.1.0"
```

On Windows, `mklink /D` does the same from an administrator prompt.
Remove the copies or links once the packages are published.

## Checking a change

1. Compile every test deck and gallery deck of the package you changed
   (their READMEs list them and the expected page counts).
2. Render every page to PNG and look at contact sheets; compare with
   `previews/` page by page.
3. Regenerate `previews/` when the look changes on purpose.

No build scripts: each step is a `typst compile` (or, for PowerPoint and
Word, the commands in `powerpoint/README.md` and `word/README.md`).

## License

MIT, see `LICENSE`; the starter files in each package's `template/` folder
are MIT-0 (`LICENSE-MIT-0`), so documents made from them carry no notice.
The assertion-evidence rules are paraphrased from
Michael Alley's books and websites (craftscicom.org, assertion-evidence.com),
which remain his; no text, slides or templates of his are included.
