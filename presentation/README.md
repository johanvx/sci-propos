# sci-propos-presentation

Slides for scientific and engineering talks, on [Touying](https://touying-typ.github.io), in the assertion-evidence style (Michael Alley, *The Craft of Scientific Presentations*): each slide has a short title for finding it, a lead line that states its point as one sentence, and evidence (a figure, a table, an equation, code beside its output). Outline and section pages, a conclusion slide that stays up during questions, side cards, and a handout that puts each slide above its notes. English, French, Simplified and Traditional Chinese.

Part of the sci-propos family, with `sci-propos-writing` and `sci-propos-poster`; the shared style lives in `sci-propos-core`. Requires Typst 0.15 or newer, Touying 0.8, `sci-propos-core` 0.1.0 and tiaoma 0.3 (QR codes).

## Start

```typst
#import "@preview/sci-propos-presentation:0.1.0": *

#show: presentation-theme.with(
  config-info(title: [Talk title], author: [Name], date: datetime.today()),
  files: p => path(p),   // lets the theme open your logo and screenshots
)

#title-slide(image: image("setting.jpg"))   // an orienting picture
#outline-slide()

= Results
what the tests showed       // the section's description in the outline

== Heat transfer
#lead[At 20 % turbulence, heat transfer rises by 35 %, which the correlations miss]
#image("stanton.svg", height: 220pt)
#credit[Source: …]

#conclusion-slide(
  lead: [In summary, high turbulence raises heat transfer well beyond the correlations],
  points: ([First point], [Second point], [Third point]),
)
```

No scripts are needed: `typst compile main.typ` builds the deck. A few theme options, or `--input` values on the command line, tell the theme which images and fonts you have (see *Building*).

## Installing before publication

Until the packages are on Typst Universe, copy this folder and `core/` (each with its `typst.toml`, `lib.typ` and `src/`) to Typst's package folder, as `sci-propos-presentation/0.1.0/` and `sci-propos-core/0.1.0/`. Typst looks there before downloading, so the `@preview` imports work. Touying and tiaoma still download on first compile. The folders:

| System | Folder |
|---|---|
| macOS | `~/Library/Application Support/typst/packages/preview/<name>/0.1.0/` |
| Linux | `~/.local/share/typst/packages/preview/<name>/0.1.0/` (or under `$XDG_DATA_HOME`) |
| Windows | `%APPDATA%\typst\packages\preview\<name>\0.1.0\` |

Delete those copies once the packages are published. To start a new deck from the template: `typst init @preview/sci-propos-presentation:0.1.0 my-talk`. The repository README says how to keep the copies in step with the repository while you develop.

## Building

`typst compile main.typ` (or `typst watch`, or your editor's preview) is enough. The theme then shows every screenshot and the logo as placeholders, and asks for the first font candidate only. To tell the theme what you have, use either theme options (they also work in editor previews) or `--input` values:

| What | Theme option | Or on the command line |
|---|---|---|
| Logo | `logo: image("logo.svg")` | `--input logo=logo.svg` |
| Screenshots that exist (`shots/<name>.png`) | `shots: ("win-1", "win-2")` | `--input shots=win-1,win-2` |
| Installed fonts (to pick the right Noto name, with no warnings) | `font:`, `cjk-font:` | `--input fonts=<installed families, comma-separated>` |
| Handout: one page per slide | `handout: true` | `--input handout=true` |
| Handout: each slide above its notes | `handout: "notes"` | `--input handout=notes` |
| Fonts carried with the deck | — | `--font-path fonts` |

The `--input logo` and `--input shots` values need `files: p => path(p)` in the deck (see *Screenshots and logo*).

Example commands, to adapt or wrap in a script of your own:

```sh
# macOS / Linux
typst compile main.typ
typst compile --input shots=win-1,win-2 --input logo=logo.svg main.typ
typst compile --input fonts="$(typst fonts | paste -sd, -)" main.typ
typst compile --font-path fonts --input handout=notes main.typ handout.pdf
```

```powershell
# Windows PowerShell
typst compile main.typ
typst compile --input "fonts=$((typst fonts) -join ',')" main.typ
typst compile --input "shots=$((Get-ChildItem shots\*.png).BaseName -join ',')" main.typ
```

## Structure

The deck's structure comes from headings.

| Markup | `slide-level: 2` (default) | `slide-level: 3` |
|---|---|---|
| `=` | section | section |
| `==` | slide title | subsection |
| `===` | — | slide title |

Each `= Section` gets a **section page**, the first section included. A section page shows the outline with the current section highlighted:
- The current section's name is in the primary color, and its description and subsections are in black.
- Every other section is gray: name, description and subsections.

Text written right after `= Section` (before the first slide) becomes the section's **description** in the outline; `descriptions: false` hides all of them (committees often expect none). `#section-image(...)` written there adds a picture: it shows on the section page, to the right of the outline, and as the section's tile in the `"map"` outline style.

```typst
= Results
what the tests showed
#section-image(image("results.png", width: 100%, height: 100%, fit: "cover"))
```

## Assertion-evidence slides

The theme follows the assertion-evidence approach of Michael Alley (Penn State; see *The Craft of Scientific Presentations*, 2nd ed., Springer, 2013, and assertion-evidence.com), adapted to talks where people find slides by section and title:

- **Title** (`== Title`): a short label, a few words, so people can say "the Heat transfer slide".
- **Lead line** (`#lead[...]`): the slide's point as one full sentence with a verb, at most two lines, 22 pt medium. It is never shrunk; a lead longer than two lines gets a red flag in the margin, so you shorten the sentence (`checks: false` turns the flag off).
- **Evidence**: a figure, a photo with call-outs (`annotate`), a short table, an equation, code beside its output. Bullets are allowed when the items are simply a set; when they are connected by time, place, size or flow, a timeline, call-outs, a chart or a diagram shows more.
- **Locator**: the footer reads "2 Results · 5 / 7" (`section-label: "footer"`); `"top"` puts the section above the title instead.
- **Conclusion** (`conclusion-slide`): the last slide of a research talk. Its lead starts "In summary," and states the main takeaway; up to three supporting points follow, each optionally with a miniature of an earlier figure. A contact band (`contact:`) and "Questions?" close it, so it can stay up while people ask questions.

Other slides that support the approach: `title-slide(image: ...)` with an orienting picture, `black-slide()` for stretches where no visual helps, `contact-slide(...)` for promotional talks, and the `"map"` outline style (one picture per section).

## Theme options

| Option | Default | |
|---|---|---|
| `aspect-ratio` | `"16-9"` | `"4-3"` for old projectors. |
| `lang` | `"en"` | `"fr"`, `"zh-Hans"`, `"zh-Hant"`. Sets the text language and the words the theme writes. |
| `style` | `"sans"` | `"serif"`. See *Fonts*. |
| `font`, `cjk-font`, `code-font`, `math-font` | `auto` | Override one font role (a name or a list). |
| `math-align` | `left` | Display equations: `left` (the house style) or `center` (as in LaTeX). |
| `primary` | `rgb("#00561f")` | Accent color. |
| `base-size` | `20pt` | Body size; titles, code and cards scale with it. |
| `title-size`, `code-size` | `auto` (28 pt, 15 pt) | Set one of them apart from `base-size`. |
| `slide-level` | `2` | `3` adds subsections. |
| `outline-style` | `"parts"` | `"parts"`: sections with descriptions. `"thesis"`: sections and subsections with dotted leaders and slide numbers. `"map"`: one picture per section, side by side. |
| `descriptions` | `true` | Show section descriptions in the outline and on section pages. |
| `numbering` | `(section: true, subsection: true, title: false)` | Section and subsection numbers, switched independently. `title: true` writes the heading's number before slide titles: "1.2 Scoped settings" (with `slide-level: 3`, "1.2.3"). Only titles that come from headings are numbered. |
| `section-label` | `"footer"` | `"footer"`: the locator "2 Results · 5 / 7" at the bottom right. `"top"`: a small "2. Results" label above slide titles; the title band is then 22 pt taller on every slide, to make room for it. `none`: numbers only. |
| `lead-size`, `lead-weight` | `auto` (22 pt), `"medium"` | The lead line. |
| `logo-on` | `"all"` | `"title-closing"` keeps the logo to the title, conclusion, contact and closing slides. |
| `contact` | `none` | `(photo:, lines:, qr:)`: the contact band of the conclusion slide. |
| `checks` | `true` | Flag lead lines longer than two lines. |
| `count-title` | `true` | Count the title page (number hidden), so the outline is slide 2, as in Beamer and PowerPoint. `false`: the outline is slide 1. |
| `title-rule` | `true` | Hairline under slide titles. |
| `title-color` | `auto` | `auto` uses `primary`. |
| `content-align` | `horizon` | Slide bodies are centered between the lead and the credit lines. Use `top` to pin them to the top. |
| `files` | `none` | `p => path(p)`. Lets the theme open files in your folder. |
| `logo` | `auto` | `image("logo.svg")`, `auto` (the file named by `--input logo`, else a placeholder) or `none`. |
| `shots` | `auto` | Names of the screenshots that exist, e.g. `("win-1", "win-2")`; `auto` reads `--input shots`. |
| `frame-images` | `false` | Thin border around real screenshots. |
| `handout` | `auto` | `true`: one page per slide. `"notes"`: each slide above its speaker notes (the handout of the assertion-evidence approach). `auto` reads `--input handout=...`. |

Backup slides: put `#show: appendix` (from Touying) before them. They keep counting, but the total stops at the last regular slide, and they show their number alone.

Touying's own `config-*` dictionaries can be passed too; they are applied last. Misspelled options stop the build with an error rather than being ignored.

## Slides

| Function | |
|---|---|
| `title-slide(image:, ...)` | Title page (counted, number hidden; see `count-title`) from `config-info` (override any field, or pass `authors`/`institutions` with `inst(1)`). `image:` adds an orienting picture on the right. |
| `outline-slide()` | "Outline" (Plan, 目录, 目錄), in the deck's outline style. |
| `section-image(content)` | Under `= Section`: the section's picture. |
| `== Title` or `slide(title:, align:, section-label:, text-size:, show-logo:, page-number:, count:)[...]` | Content slide. `text-size:` changes the body size of that slide only. |
| `conclusion-slide(lead:, points:, figures:, image:, contact:, questions:)` | The last slide of a research talk (above). At most three points; `figures:` gives one miniature per point. |
| `contact-slide(lead:, photo:, lines:, qr:)` | For promotional talks: photo, contact details, QR code, and the takeaway as lead. Go back to the conclusion for the questions. |
| `black-slide(count:)` | A black page; not counted by default. |
| `empty-slide[...]` | No title band. |
| `focus-slide[...]` | One sentence on the primary color. |
| `thanks-slide(title: [Resources], qr:)[links]` | For courses and seminars: one closing page with links, then "Thank you · Questions?". `qr: "https://..."` adds a QR code beside the links. A teaching deck can put it after the summary. |
| `resources-slide(qr:)[links]`, then `thanks-slide(qr:)` | The same as two pages: the links, then a thank-you page with no heading. `qr:` works on either. |
| `bibliography-slide(bib: read("refs.bib"))` | References. |

The closing, conclusion, contact and references slides show no section in the footer. A QR code is drawn from the link (`qr-size:`, `qr-caption:`; the caption is the link by default); `qr:` also takes your own picture, and `qr-code(url)` draws one anywhere. QR codes come from the [tiaoma](https://typst.app/universe/package/tiaoma) package.

## Settings for one slide

A `#set` or `#show` rule written at the top level of a slide applies to **every later slide too**, because Typst applies a rule to the rest of the file. Touying cannot scope it, and neither can the theme. Keep the rule inside the slide in one of these ways:

```typst
== Dense slide
#[
  #set text(17pt)          // only inside the brackets
  #set block(spacing: 0.6em)
  ...
]

#slide(title: [Dense slide], text-size: 17pt)[...]        // the slide's own option
#slide(title: [Dense slide], setting: body => {            // any rule, via Touying's setting
  set block(spacing: 0.6em)
  body
})[...]
```

Rules meant for the whole deck belong right after `#show: presentation-theme.with(...)`, before the first slide.

## Helpers

| | |
|---|---|
| `lead[...]`, `credit[...]` | The slide's sentence (moved to the top), small source line (moved to the bottom). |
| `annotate(picture, (x:, y:, dx:, dy:, label:), ..)` | Call-outs on a picture: short labels joined by lines to points given as fractions of its size. At most four. |
| `two-columns(a, b, ratio:)`, `aside(main, deck)` | At most two columns; content with a narrow side column. |
| `card(kind:, title:, side:, frame:)`, `term[name][def]`, `card-deck(..)` | Side cards (below). |
| `code-panel(code, lang:, size:, leading:)`, `labelled(label, body)`, `demo(code, scope:)` | Code panels; code beside its evaluated output. |
| `numbered()`, `algorithm-figure(body)` | "Figure 1", "Algorithm 1" inside slides, in the deck's language. |
| `shot("name")`, `step("name")[instruction]` | Screenshot or placeholder with its expected path; one step of a procedure. |
| `pipeline((name, detail), ..)` | A row of boxes with arrows. |
| `remaining(size => ...)` | Fill the space left on the slide (e.g. a picture as tall as what is left). |
| `ph[...]`, `pkg("name")`, `small`, `tiny`, `large`, `compact`, `citet`, `citep`, `footcite`, `LaTeX`, `TeX` | Small things. |

Tables get the three-line (booktabs) style automatically.

## Side cards

A card is a short note with a frame on **one side only**.

| `kind` | Label (en) | Frame |
|---|---|---|
| `"note"` | Note | solid |
| `"definition"` | Definition | solid |
| `"intro"` | In short | solid |
| `"recap"` | Recap | dashed |
| `"reminder"` | Reminder | dotted |

Labels follow `lang`. Per card you can set `side: left | right | top | bottom`, `frame:`, `label:`, `accent:` and `fill:`.

## Fonts

Typst itself bundles only Libertinus Serif, New Computer Modern and DejaVu Sans Mono. The theme uses Noto, which has to be installed.

| Style | Latin text | Chinese (`zh-Hans` / `zh-Hant`) | Code |
|---|---|---|---|
| `sans` | Noto Sans → Arial | Noto Sans SC/TC → PingFang (Mac) → Microsoft YaHei/JhengHei (Windows) | Noto Sans Mono → DejaVu Sans Mono |
| `serif` | Noto Serif → Libertinus Serif | Noto Serif SC/TC → Songti (Mac) → SimSun/PMingLiU (Windows) | same |

Noto CJK fonts are named differently by platform:
- **macOS and Windows:** "Noto Sans SC", "Noto Serif TC", and so on.
- **Linux:** "Noto Sans CJK SC", "Noto Serif CJK TC", and so on.

Both spellings are candidates.

**How the font is chosen.** Given the installed families (`--input fonts=…`, see *Building*), the theme picks the first installed candidate, with no warnings. Otherwise it asks for the first candidate only, and Typst warns once if that font is missing. On Linux, for Chinese, set `cjk-font: "Noto Sans CJK SC"` (or `"Noto Serif CJK SC"`, `TC` …) to avoid that warning without any `--input`.

**Installing Noto.** Download Noto Sans, Noto Serif and Noto Sans Mono from Google Fonts. For Chinese, add Noto Sans SC/TC and Noto Serif SC/TC. Then:
- **macOS:** double-click each file and choose *Install*, or use `brew install --cask font-noto-sans font-noto-serif`.
- **Windows:** right-click each file › *Install for all users*.
- **Arch Linux:** `pacman -S noto-fonts noto-fonts-cjk`.

**Fonts that travel with the deck.** Put the `.ttf`/`.otf` files in a `fonts/` folder next to the deck and compile with `--font-path fonts`.

**Your own fonts.** `font: "Source Sans 3"`, `cjk-font: "LXGW WenKai"`, `code-font: "JetBrains Mono"`.

## Screenshots and logo

Typst cannot test whether a file exists, and a path written inside a package resolves inside the package. So:
- **`files: p => path(p)`**, written in your deck, lets the theme open your files (`path` then resolves in your folder).
- **You say which files exist**, with `shots: (...)` or `--input shots=…`, and `--input logo=…` (see *Building*).

Anything not listed shows as a placeholder with the exact path it expects, so a deck always compiles. For the logo, `logo: image("logo.svg")` is the simplest: no `files` and no `--input` needed.

## License

MIT. The assertion-evidence rules are paraphrased from Michael Alley's books and websites, which remain his; no text or templates of his are included.
