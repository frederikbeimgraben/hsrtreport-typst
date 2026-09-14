// Text, paragraph and list rules.

#import "fonts.typ": *
#import "colors.typ": *

#let typography(font-size: sizes.normal, lang: "de", body) = {
  let leading = leading-for(font-size)

  set text(
    font: body-font,
    size: font-size,
    lang: lang,
    hyphenate: true,
    top-edge: "ascender",
    bottom-edge: "descender",
  )
  set par(
    justify: true,
    leading: leading,
    spacing: leading + 0.5em,
    first-line-indent: 0pt,
    linebreaks: "optimized",
  )
  set list(indent: 1.45em, spacing: leading + 0.5em, marker: ([•], [--], [·]))
  set enum(indent: 1.45em, spacing: leading + 0.5em)
  set terms(spacing: leading + 0.5em)

  show link: set text(fill: url-color)
  show ref: set text(fill: link-color)
  show cite: set text(fill: cite-color)
  show terms.item: it => par[#blender(weight: "bold", it.term)#h(0.75em)#it.description]
  show raw: set text(font: mono-font)
  show table: set par(leading: leading-for(font-size, stretch: 1.0), justify: false)
  set table(stroke: 0.5pt + black, inset: (x: 6pt, y: 1.5pt))
  show footnote.entry: set text(size: sizes.footnote)
  set footnote.entry(indent: 0.5em)

  body
}

// Compact list without spacing between the items (LaTeX `listenabsatz`).
#let compact-list(body) = {
  set list(indent: 0pt, tight: true)
  set enum(indent: 0pt, tight: true)
  body
}
