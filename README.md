# HSRTReport - Typst Template

A report template for academic work at Reutlingen University (Hochschule
Reutlingen). This is the Typst port of the
[HSRTReport LaTeX class](https://github.com/frederikbeimgraben/HSRT-Report).

The template keeps the layout of the LaTeX class: the same title page, the same
running head and footer, the same fonts, the same logos and the same skyline
graphic. It needs no LaTeX installation and no package downloads.

## Contents

- [Prerequisites](#prerequisites)
- [Project structure](#project-structure)
- [Usage](#usage)
- [Template options](#template-options)
- [Features](#features)
- [Building the document](#building-the-document)
- [Fonts](#fonts)
- [Differences from the LaTeX template](#differences-from-the-latex-template)
- [License](#license)

## Prerequisites

You need one of these:

- **Nix** (recommended). All commands run through `nix run` or `nix develop`.
  You install nothing else.
- **Typst 0.15 or later**. Install it from
  [typst.app](https://github.com/typst/typst/releases) or from your package
  manager.

The template uses no Typst packages from the internet. The fonts and the images
are part of the repository, so an offline build is possible.

## Project structure

```sh
hsrtreport-typst/
├── hsrtreport/             # The template ("document class")
│   ├── lib.typ             # Entry point, exports the template function
│   ├── config/             # Fonts, colors, typography, sections, page setup
│   ├── modules/            # Logos, icons, info boxes, listings, glossary
│   ├── pages/              # Title page, table of contents, glossary
│   └── assets/             # Fonts and images
│
├── src/                    # The document
│   ├── main.typ            # Entry point of the document
│   ├── metadata.typ        # Title page data, logos and options
│   ├── glossary.typ        # Glossary and acronym definitions
│   ├── main.bib            # Bibliography
│   └── chapters/           # Your chapters
│
├── tools/patch-fonts.py    # Normalizes the name tables of the fonts
├── flake.nix               # Nix development shell and document build
├── Makefile                # Build directives
└── typst.toml              # Typst package manifest
```

## Usage

### 1. Set the metadata

Open `src/metadata.typ`. It holds all settings of the document: the title, the
author, the abstract, the keywords, the logos and the rows of the title page
table. Each entry has a comment that explains it.

### 2. Write your chapters

Put one file per chapter into `src/chapters/`. Add each file to `src/main.typ`:

```typ
#include "chapters/01_introduction.typ"
#include "chapters/02_method.typ"
```

Every chapter file starts with an import of the template:

```typ
#import "../../hsrtreport/lib.typ": *

= Einleitung <chap:introduction>

Text of the chapter.

== Ein Abschnitt <sec:section>
```

A `=` heading is a chapter, `==` is a section and `===` is a subsection.

### 3. Add literature

Put your BibTeX entries into `src/main.bib` and cite them with `@key`. The
bibliography is passed to the template in `src/main.typ`:

```typ
bib: bibliography("main.bib", style: "ieee", title: none),
```

Keep `title: none`. The template prints the heading "Literaturverzeichnis"
itself.

### 4. Define glossary entries

Open `src/glossary.typ` and add terms and acronyms:

```typ
#let terms = (
  "Textkörper": (
    name: "Textkörper",
    description: [Bereich der Arbeit, der die Ausarbeitung enthält.],
    genitive: "Textkörpers",
    plural: "Textkörper",
  ),
)

#let acronyms = (
  "MPG": (short: "MPG", long: "Medizinproduktegesetz"),
)
```

Use an entry in the text with `#gls("MPG")`. The first use of an acronym prints
the long form and the short form. Each later use prints the short form only.

## Template options

Give the options to `hsrtreport.with(...)` in `src/main.typ`, or put them into
`settings` in `src/metadata.typ`.

| Option | Default | Function |
| --- | --- | --- |
| `title` | — | Title on the title page and in the PDF metadata |
| `author` | `""` | Author, also shown in the page footer |
| `created-on` | `none` | Date of creation for the PDF metadata |
| `abstract` | `none` | Abstract on the title page |
| `keywords` | `none` | Keywords, separated by commas |
| `module-name` | `none` | Module name |
| `data` | `()` | Rows of the title page table |
| `variant` | `"meti"` | Report variant: `"meti"`, `"mki"` or `"huc"` |
| `logos` | `auto` | Logos as `(name, scale)` pairs; `auto` takes the logo of the variant |
| `logos-scale` | `1.0` | Scale of all logos |
| `footer-logos` | `false` | Repeat the logos in the page footer |
| `show-toc` | `true` | Print the table of contents |
| `show-figure-list` | `false` | Print the list of figures |
| `show-table-list` | `false` | Print the list of tables |
| `show-listing-list` | `false` | Print the list of listings |
| `show-equation-list` | `false` | Print the list of equations |
| `show-glossary` | `false` | Print the glossary |
| `show-acronyms` | `false` | Print the list of abbreviations |
| `terms` | `(:)` | Glossary entries |
| `acronyms` | `(:)` | Acronym entries |
| `bib` | `none` | A `bibliography(...)` element |
| `watermark` | `none` | Watermark text |
| `chapter-pagebreak` | `false` | Start each chapter on a new page |
| `paper` | `"a4"` | Paper format |
| `margin` | `2cm` | Page margin |
| `font-size` | `10.909pt` | Base font size (11pt in LaTeX units) |
| `lang` | `"de"` | Document language |

## Features

### Info boxes

```typ
#info-box[Text of the box.]
#warning-box[A warning.]
#success-box[A result.]
#important-box[A note.]
#discussion-box[A discussion.]
#custom-box(icons.check-circle, purple)[Your own box.]
```

Boxes can contain other boxes. Each level gets a stronger background tint.

The voting box prints a result of a vote:

```typ
#voting-results(12, 3, 2)[Antrag auf Anschaffung eines Templates.]
```

### Code listings

A code block gets a frame and line numbers. `listing` adds a caption and makes
the block referenceable:

````typ
#listing(caption: [Fakultätsfunktion])[
```python
def factorial(n):
    return 1 if n <= 1 else n * factorial(n - 1)
```
] <lst:factorial>
````

### Figures and tables

Figures and tables are numbered per chapter, for example "Abbildung 2.1". Use
`subfigure` for figures side by side:

```typ
#figure(
  grid(columns: (1fr, 1fr), column-gutter: 1em,
    subfigure(image("a.png"), caption: [First]),
    subfigure(image("b.png"), caption: [Second]),
  ),
  caption: [Two figures],
) <fig:two>
```

### Cross references

Write `@label` to make a reference. The name is German: `@chap:intro` gives
"Kapitel 1", `@sec:method` gives "Abschnitt 1.2", `@fig:two` gives
"Abbildung 1.1".

### Word count

`#word-count()` gives the number of words in the body. Use it on the title
page:

```typ
data-line("Wortanzahl", [#word-count() Wörter]),
```

### Watermark

Set `watermark: "ENTWURF"` to print a light diagonal texture on every page.

## Building the document

With Nix:

```sh
nix develop          # shell with typst, tinymist and make
make                 # build build/main.pdf
make watch           # rebuild on every change
nix build            # build the PDF into ./result
```

Without Nix:

```sh
typst compile --root . --font-path hsrtreport/assets/fonts src/main.typ build/main.pdf
typst watch   --root . --font-path hsrtreport/assets/fonts src/main.typ build/main.pdf
```

`--root .` is necessary, because the document reads the template and the assets
from the directory above `src/`.

For an editor, use [tinymist](https://github.com/Myriad-Dreamin/tinymist). The
settings in `.vscode/settings.json` and `.zed/settings.json` set the root and
the font path for you.

## Fonts

The template uses two typefaces:

- **Blender** for headings, the running head and the footer.
- **DIN** for the body text.

Both are part of the repository, in `hsrtreport/assets/fonts/`. Typst selects a
face by family, weight and style. The vendor files declare one family per file
("Blender-Bold", "DIN Medium"), so Typst cannot find a bold or an italic in
such a set. `tools/patch-fonts.py` rewrites the name tables and the OS/2 tables,
so that all faces of a typeface become one family. The repository contains the
corrected files. Run `make fonts` again only after you replace a vendor file.

## Differences from the LaTeX template

| Item | LaTeX | Typst |
| --- | --- | --- |
| Icons of the info boxes | FontAwesome glyphs | Drawn with vector primitives |
| Word count | `texcount` through shell escape | Counted in the document |
| Glossary | `glossaries` package | Part of the template |
| Bibliography | BibLaTeX with BibTeX backend | Typst bibliography, IEEE style |
| Listings | `listings` package | Typst `raw` blocks |
| Long code lines | Broken at the frame | Not broken |
| Space between two headings that follow each other | Small | Larger, because Typst has no `\addvspace` |
| Watermark | Not in the text layer | In the text layer |

The colors of the info boxes come from the Typst palette (`blue`, `red`,
`green`, `orange`), which is less saturated than the LaTeX palette.

## License

Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0). See
[LICENSE](LICENSE).

The class is a modified version of the ZHAWReport class by Martin Oswald
(Zurich University of Applied Sciences). The logos and the fonts are property
of Reutlingen University and of their respective owners.
