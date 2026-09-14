// Table of contents and the lists of figures, tables and equations.

#import "../config/fonts.typ": *
#import "../config/colors.typ": *

// The LaTeX class leaves more room below the title of a list than below a
// chapter heading.
#let _title-skip = 18.94pt

#let _list-title(body) = {
  heading(level: 1, numbering: none, outlined: false, body)
  v(_title-skip)
}

#let toc(title: [Inhaltsverzeichnis], depth: 3) = {
  // Space below the title and between the entries, as in the LaTeX class.
  show outline.entry: set block(above: 11.07pt)
  show outline.entry: it => link(it.element.location(), it.indented(it.prefix(), it.inner()))
  show outline.entry.where(level: 1): set text(weight: "bold", fill: link-color)
  show outline.entry.where(level: 1): set outline.entry(fill: none)

  set outline.entry(fill: repeat(gap: 0.35em)[.])
  set text(font: heading-font, fill: link-color)

  set outline(indent: 1.5em)
  outline(title: _list-title(title), depth: depth)
}

#let figure-list(title: [Abbildungsverzeichnis]) = {
  set text(font: heading-font, fill: link-color)
  outline(title: _list-title(title), target: figure.where(kind: image))
}

#let table-list(title: [Tabellenverzeichnis]) = {
  set text(font: heading-font, fill: link-color)
  outline(title: _list-title(title), target: figure.where(kind: table))
}

#let listing-list(title: [Listings]) = {
  set text(font: heading-font, fill: link-color)
  outline(title: _list-title(title), target: figure.where(kind: raw))
}

#let equation-list(title: [Gleichungsverzeichnis]) = {
  set text(font: heading-font, fill: link-color)
  outline(title: _list-title(title), target: math.equation)
}
