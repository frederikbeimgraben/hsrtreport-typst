# HSRTReport

Typst report template for academic work at Reutlingen University. It is the
port of the [HSRTReport LaTeX class](https://github.com/frederikbeimgraben/HSRT-Report)
and keeps the same layout.

## Install

Run the two commands one time:

```sh
nix run github:frederikbeimgraben/hsrtreport-typst#install         # the template
nix run github:frederikbeimgraben/hsrtreport-typst#install-fonts   # Blender and DIN
```

The first command makes `@local/hsrtreport:1.0.0` available to Typst. The
second command copies the fonts into `~/.local/share/fonts`, because Typst does
not load fonts from a package. After this, `typst compile report.typ` needs no
flag.

Without Nix, clone the repository and do the same by hand:

```sh
ln -s "$PWD" ~/.local/share/typst/packages/local/hsrtreport/1.0.0
cp src/assets/fonts/*/*.ttf ~/.local/share/fonts/ && fc-cache -f
```

## Use the template

One import and one show rule make a complete document:

```typ
#import "@local/hsrtreport:1.0.0": *

#show: hsrtreport.with(
  title: [Titel der Arbeit],
  author: "Hans Maria Muster",
  email: "hans-maria.muster@student.hs-reutlingen.de",
  semester-count: 5,
  submitted-on: "01.02.2026",
  course: "Medizinisch Technische Informatik B.Sc.",
  module: ("METI1.2", "Mustermodul"),
  supervisor: "Prof. Dr. Max Mustermann",
  semester: "Wintersemester 2025/2026",
  abstract: [Ziel, Methode und Ergebnis der Arbeit.],
  keywords: "Seminararbeit, Studium",
)

= Einleitung
Text des Kapitels.
```

Every field is optional. A field that you leave out drops its row from the
title page.

To start from the example document instead, run:

```sh
typst init @local/hsrtreport:1.0.0 my-report
```

## Fonts

The name tables of the files in `src/assets/fonts/` carry a correction. The
vendor files declare one family per file, for example "Blender-Bold". Typst
selects a face by family, weight and style, so it cannot find a bold or an
italic in such a set. The files here declare one family per typeface.

## Options

| Option | Default | Function |
| --- | --- | --- |
| `title`, `author`, `email` | — | Title page and PDF metadata |
| `semester-count`, `submitted-on` | `none` | Rows of the title page table |
| `course`, `module`, `supervisor`, `semester` | `none` | Rows of the title page table |
| `topic` | `none` | Row "Thema" |
| `abstract`, `keywords` | `none` | Abstract block on the title page |
| `data`, `extra-data` | `auto`, `()` | Replace or extend the table rows |
| `variant` | `"meti"` | Logo set: `"meti"`, `"mki"` or `"huc"` |
| `logos` | `auto` | Logo names, for example `("HSRT", "INF/Simple")` |
| `footer-logos` | `true` | Repeat the logos in the page footer |
| `show-toc` | `true` | Print the table of contents |
| `show-figure-list`, `show-table-list` | `false` | Print the list of figures or tables |
| `show-listing-list`, `show-equation-list` | `false` | Print the list of listings or equations |
| `terms`, `acronyms` | `(:)` | Glossary entries |
| `show-glossary`, `show-acronyms` | `auto` | Print the lists if entries exist |
| `bib` | `none` | A `bibliography(...)` element |
| `watermark` | `none` | Watermark text |
| `show-word-count` | `false` | Add the row "Wortanzahl" |
| `chapter-pagebreak` | `false` | Start each chapter on a new page |
| `paper`, `margin`, `font-size`, `lang` | A4, 2cm, 11pt, de | Page layout |

## Content

**Glossary.** Give the entries to the template. The first use of an acronym
prints the long form. Each later use prints the short form.

```typ
  terms: ("Textkörper": [Bereich der Arbeit, der die Ausarbeitung enthält.]),
  acronyms: ("MPG": "Medizinproduktegesetz"),
```

Write `#gls("MPG")` in the text. `#glspl`, `#glsgen` and `#glsdat` print the
plural, the genitive and the dative of a term.

**Bibliography.** Keep `title: none`. The template prints the heading itself.

```typ
  bib: bibliography("main.bib", style: "ieee", title: none),
```

**Info boxes.** `#info-box`, `#warning-box`, `#success-box`, `#important-box`,
`#discussion-box` and `#custom-box(icon, color)`. A box can contain another
box. `#voting-results(12, 3, 2)[Antrag]` prints the result of a vote.

**Code.** A code block gets a frame and line numbers. `#listing(caption: [...])`
adds a caption and a number.

**Figures.** Figures and tables count per chapter. `#subfigure` places figures
side by side and labels them (a), (b).

**References.** `@label` gives the German name: "Kapitel 1", "Abschnitt 1.2",
"Abbildung 1.1".

**Other.** `#unnumbered(level: 3)[...]` makes a heading without a number.
`#compact-list[...]` removes the space between list items. `#word-count()`
counts the words of the document.

## Repository

```sh
src/         # the template
example/     # the example document, also the start point of `typst init`
```

Build the example:

```sh
nix run .#install   # link the working tree as @local/hsrtreport:1.0.0
nix run .#build     # write build/main.pdf
nix run .#watch     # rebuild on every change
nix develop         # shell with typst and tinymist
```

The package is not on Typst Universe. It bundles the fonts and the logos of
Reutlingen University, and Typst Universe takes third-party assets only with a
policy of the owner that clears the distribution.

## Differences from the LaTeX class

| Item | LaTeX | Typst |
| --- | --- | --- |
| Icons of the info boxes | FontAwesome | Drawn in the template |
| Word count | `texcount` | Counted in the document |
| Glossary | `glossaries` | Part of the template |
| Bibliography | BibLaTeX | Typst bibliography |
| Long code lines | Broken at the frame | Not broken |
| Space between two headings | Small | Larger, Typst has no `\addvspace` |

## License

| Files | License |
| --- | --- |
| `src/*.typ`, `src/**/*.typ` | CC BY-SA 4.0, see [LICENSE](LICENSE) |
| `example/` | MIT-0, see [LICENSE-MIT-0](LICENSE-MIT-0) |
| `src/assets/fonts/`, `src/assets/images/` | Not covered, see below |

The template is a modified version of the ZHAWReport class by Martin Oswald
(ZHAW). Your own document, written from `example/`, carries no condition from
this repository.

The fonts Blender and DIN and the logos of Reutlingen University are **not**
covered by the licenses above. They belong to their owners. The corporate
design of Reutlingen University states the terms for the logos. Use them only
for work at Reutlingen University.
