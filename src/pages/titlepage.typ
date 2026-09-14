// Title page: logo row, title, abstract, keywords and the data table.

#import "../config/fonts.typ": *
#import "../config/colors.typ": *
#import "../modules/logos.typ": title-logos

// One row of the title page table. A length in the row list adds vertical
// space instead of a row.
#let data-line(label, body) = (label, body)

#let _data-table(data, label-width: 30mm) = {
  let rows = ()
  for entry in data {
    if type(entry) == length {
      rows.push(table.cell(colspan: 2, v(entry)))
    } else {
      rows.push(strong(entry.at(0)))
      rows.push(entry.at(1))
    }
  }
  table(
    columns: (label-width, 1fr),
    column-gutter: 12pt,
    row-gutter: 0pt,
    stroke: none,
    inset: (x: 0pt, y: 0.7pt),
    align: (left + top, left + top),
    ..rows,
  )
}

#let titlepage(
  title: none,
  abstract: none,
  keywords: none,
  data: (),
  logos: (),
  logos-scale: 1.0,
  margin: 2cm,
  credit: [Made with #sym.suit.heart in Typst],
  credit-url: "https://github.com/frederikbeimgraben/hsrtreport-typst",
  font-size: sizes.normal,
  background: none,
) = page(header: none, footer: none, numbering: none, background: background, {
  set par(leading: leading-for(font-size, stretch: 1.0), spacing: 0pt, justify: true)

  // The logo row starts 2cm from the left edge and 1.5cm from the top edge.
  if logos.len() > 0 {
    place(
      top + left,
      dy: 1.5cm - margin,
      title-logos(logos, scale: logos-scale),
    )
  }

  place(
    bottom + right,
    dx: margin - 0.1cm,
    dy: margin - 0.1cm,
    text(font: heading-font, size: sizes.script, fill: luma(50%), link(credit-url, credit)),
  )

  v(4cm + 30pt)

  // The title does not hyphenate. A wrapped line then keeps its alignment
  // with the first line and with the rule.
  block(
    below: 5pt,
    text(
      font: heading-font,
      size: sizes.Huge,
      weight: "bold",
      hyphenate: false,
      title,
    ),
  )
  line(length: 100%, stroke: 0.5mm + rule-color)

  if abstract != none {
    block(
      above: font-size * 2 + 63pt,
      below: 1.8pt,
      text(font: heading-font, size: sizes.Large, weight: "bold")[Abstract],
    )
    abstract
  }

  if keywords != none {
    v(1em)
    strong[Keywords]
    linebreak()
    keywords
  }

  v(1fr)
  _data-table(data)
})
