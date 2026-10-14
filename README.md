# HSRTReport

[![Build](https://github.com/frederikbeimgraben/hsrtreport-typst/actions/workflows/continuous-release.yml/badge.svg)](https://github.com/frederikbeimgraben/hsrtreport-typst/actions/workflows/continuous-release.yml)

Typst report template for academic work at Reutlingen University. It is the
port of the [HSRTReport LaTeX class](https://github.com/frederikbeimgraben/HSRT-Report)
and keeps the same layout.

## Install

Run the two commands one time:

```sh
nix run github:frederikbeimgraben/hsrtreport-typst#install         # the template
nix run github:frederikbeimgraben/hsrtreport-typst#install-fonts   # all template fonts
```

The first command makes `@local/hsrtreport:1.1.0` available to Typst. The
second command copies the fonts into `~/.local/share/fonts`, because Typst does
not load fonts from a package. After this, `typst compile report.typ` needs no
flag.

Without Nix, clone the repository and do the same by hand:

```sh
ln -s "$PWD" ~/.local/share/typst/packages/local/hsrtreport/1.1.0
cp src/assets/fonts/*/*.ttf src/assets/fonts/*/*.otf ~/.local/share/fonts/ && fc-cache -f
```

## Use the template

One import and one show rule make a complete document:

```typ
#import "@local/hsrtreport:1.1.0": *

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
typst init @local/hsrtreport:1.1.0 my-report
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
| `variant` | `"inf"` | Logo set: `inf`, `hsrt`, `stupa`, `asta`, `echo`, `makers` |
| `logos` | `auto` | Title page logos, see below |
| `footer-logos` | `auto` | Footer logos, `false` turns them off |
| `logos-scale` | `1.0` | Scale of every logo |
| `show-toc` | `true` | Print the table of contents |
| `show-figure-list`, `show-table-list` | `false` | Print the list of figures or tables |
| `show-listing-list`, `show-equation-list` | `false` | Print the list of listings or equations |
| `terms`, `acronyms` | `(:)` | Glossary entries |
| `show-glossary`, `show-acronyms` | `auto` | Print the lists if entries exist |
| `bib` | `none` | A `bibliography(...)` element |
| `watermark` | `none` | Watermark text |
| `show-word-count` | `false` | Add the row "Wortanzahl" |
| `chapter-pagebreak` | `false` | Start each chapter on a new page |
| `line-stretch` | `1.0` | Line spacing, `1.5` gives the wide setting |
| `paper`, `margin`, `font-size`, `lang` | A4, 2cm, 11pt, de | Page layout |
| `layout` | `"default"` | Select the layout, see "Layout sat-meti" |

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

**Logos.** The template carries the logos `HSRT`, `INF`, `INF-Simple`,
`STUPA`, `ASTA`, `ECHO`, `MAKERS`, `MAKERS-RAlign` and `MAKERS-Icon`. The
variant selects a set for the title page and a set for the footer. The MAKERS
variant, for example, puts the right-aligned logo into the footer, so the icon
faces the corner of the page. Override a set with a list:

```typ
  logos: ("MAKERS", ("HSRT", 0.8), read("logo.svg", encoding: none)),
  footer-logos: ("MAKERS-Icon",),
```

A list item is a name, a `(name, scale)` pair, or the bytes of your own image
file.

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

## Layout "sat-meti"

The layout `"sat-meti"` sets the seminar paper (SAT) of the course meTI. It
follows the Word template "Dokumentvorlage Seminararbeit" 7.4. Select it with
one option:

```typ
#show: hsrtreport.with(
  layout: "sat-meti",
  title: [Titel der Arbeit],
  footer-id: "MTIB6.3:SAT-W2026",
  keywords: "Fünf, deutsche, Schlüsselwörter, durch, Kommas",
  keywords-en: ("five", "English", "keywords", "as", "array"),
  // the title page fields as above
)
```

| Option | Default | Function |
| --- | --- | --- |
| `layout` | `"default"` | `"default"` or `"sat-meti"` |
| `keywords-en` | `none` | English keywords on page 2, a string or an array |
| `footer-id` | `none` | Left part of the footer |
| `sat-labels` | `(:)` | Replace fixed texts, see `sat-labels` in `src/layouts/sat-meti.typ` |

The layout uses these fields: `title`, `author`, `email`, `semester-count`,
`submitted-on`, `course`, `module` (the last item is the seminar name),
`supervisor`, `semester`, `abstract`, `keywords`, `terms`, `acronyms` and
`watermark`. It ignores the logo options, `topic` and the `show-*` options.

The layout does these steps:

- Margins 4/3/3/2 cm. Libre Franklin 12pt for the text, TeX Gyre Termes
  italic for captions and the abstract. Justified text with hyphenation.
- The title page is page 0. Page 2 of the file holds the abstract and the
  keywords, without a page number. The first list page is page 1.
- It always prints six lists: contents (3 levels), figures, tables,
  equations, acronyms and glossary.
- Each level-1 heading starts a new page. Level-4 headings have no number
  and stay out of the contents.
- The word count on the title page starts at the first level-1 heading. It
  stops before the heading "Literaturverzeichnis".

Write the bibliography and the declaration as chapters in the body:

```typ
= Literaturverzeichnis
#bibliography("main.bib", style: "apa-6th-edition.csl", title: none)

= Danksagungen
...

= Eidesstattliche Erklärung
#declaration()
```

**Equations.** Every block equation gets a number. To give an equation a
title for the list of equations, use `formula`. Put the label inside:

```typ
#formula(title: [Polstellenberechnung])[
  $ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a) $ <eq:pol>
]
```

The caption below the equation reads "Formel 1 : Polstellenberechnung".
`@eq:pol` gives "Formel 1".

Compile with the template fonts:

```sh
typst compile --font-path src/assets/fonts example-sat/main.typ
```

## Repository

```sh
src/         # the template
example/     # the example document, also the start point of `typst init`
example-sat/ # the example document of the layout "sat-meti"
```

Build the example:

```sh
nix run .#install   # link the working tree as @local/hsrtreport:1.1.0
nix run .#build     # write build/main.pdf
nix run .#build-sat # write build/main-sat.pdf
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

The fonts Libre Franklin (SIL Open Font License 1.1) and TeX Gyre Termes
(GUST Font License) have their own licenses. The license files are next to
the font files.

The fonts Blender and DIN and the logos of Reutlingen University, of the
student parliament and of its groups are **not** covered by the licenses
above. They belong to their owners. The corporate design of Reutlingen
University states the terms for the logos. Use them only for work at
Reutlingen University.
