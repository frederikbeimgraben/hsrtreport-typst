// Title page: logo row, title, abstract, keywords and the data table.

#import "../config/fonts.typ": *
#import "../config/colors.typ": *
#import "../modules/logos.typ": title-logos

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
  main-logo-scale: 1.0,
  margin: 2cm,
  credit: [Made with #sym.suit.heart in Typst],
  credit-url: "https://github.com/frederikbeimgraben/HSRT-Report",
  font-size: sizes.normal,
) = page(header: none, footer: none, numbering: none, {
  set par(leading: leading-for(font-size, stretch: 1.0), spacing: 0pt, justify: true)

  if logos.len() > 0 {
    place(
      top + left,
      dy: 1.5cm - margin,
      title-logos(logos, scale: logos-scale, main-scale: main-logo-scale),
    )
  }

  place(
    bottom + right,
    dx: margin - 0.1cm,
    dy: margin - 0.1cm,
    text(font: heading-font, size: sizes.script, fill: luma(50%), link(credit-url, credit)),
  )

  v(4cm + 30pt)

  block(
    below: 5pt,
    text(font: heading-font, size: sizes.Huge, weight: "bold", title),
  )
  line(length: 100%, stroke: 0.5mm + rule-color)

  block(
    above: font-size * 2 + 63pt,
    below: 1.8pt,
    text(font: heading-font, size: sizes.Large, weight: "bold")[Abstract],
  )
  abstract
  v(1em)
  strong[Keywords]
  linebreak()
  keywords

  v(1fr)
  _data-table(data)
})
