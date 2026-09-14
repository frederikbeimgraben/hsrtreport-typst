// Heading levels, their spacing and the counters bound to them.

#import "fonts.typ": *

#let _heading-sizes = (sizes.LARGE, sizes.Large, sizes.large, sizes.large)

// Space above and below a heading, as a factor of the body font size. The
// values reproduce the KOMA beforeskip/afterskip of the LaTeX class, measured
// against its output.
#let _heading-space = (
  (above: 2.645, below: 1.722),
  (above: 3.967, below: 1.722),
  (above: 3.091, below: 1.596),
  (above: 1.766, below: 1.550),
)

#let sections(chapter-pagebreak: false, font-size: sizes.normal, body) = {
  set heading(numbering: "1.1")

  show heading: set text(font: heading-font, weight: "bold")
  show heading: it => {
    let level = calc.min(it.level, 4)
    let space = _heading-space.at(level - 1)
    set text(size: _heading-sizes.at(level - 1))
    set block(above: font-size * space.above, below: font-size * space.below)
    it
  }

  show heading.where(level: 1): set heading(supplement: [Kapitel])
  show heading.where(level: 1): it => {
    if chapter-pagebreak { pagebreak(weak: true) }
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  // Sub-figures are labelled (a), (b), ... and restart in every figure.
  show figure.where(kind: "subfigure"): set figure.caption(separator: [ ])
  show figure.where(kind: image): it => {
    counter(figure.where(kind: "subfigure")).update(0)
    it
  }

  // Figures and tables are numbered per chapter, equations are not.
  set figure(numbering: n => context numbering(
    "1.1",
    counter(heading).get().at(0, default: 0),
    n,
  ))
  set math.equation(numbering: "(1)")

  body
}

// Unnumbered heading that stays out of the outline (LaTeX `\section*`).
#let unnumbered(level: 2, body) = heading(
  level: level,
  numbering: none,
  outlined: false,
  bookmarked: false,
  body,
)

// Sub-figure inside a figure, labelled (a), (b), ...
#let subfigure(body, caption: none) = figure(
  body,
  kind: "subfigure",
  supplement: [],
  numbering: "(a)",
  caption: caption,
)
