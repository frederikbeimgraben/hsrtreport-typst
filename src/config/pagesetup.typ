// Page geometry, running head, footer and background layers.

#import "fonts.typ": *
#import "colors.typ": *
#import "../modules/logos.typ" as logos-module
#import "../modules/watermark.typ": watermark-layer

// True from the first chapter of the body onward. The page number in the
// footer gets the "von M" suffix from there, also in the back matter.
#let numbered-body = state("hsrt-numbered-body", false)

// The running head names the chapter that is open on the page. The front
// matter and the back matter have no numbered chapter, so it stays empty
// there, as \ifHSRTBackMatter does in the LaTeX class.
#let _active-chapter() = {
  let page-number = here().page()
  let chapters = query(heading.where(level: 1))
    .filter(chapter => chapter.location().page() <= page-number)
  if chapters.len() == 0 { return none }
  chapters.last()
}

#let _chapter-label() = {
  let chapter = _active-chapter()
  if chapter == none or chapter.numbering == none { return none }
  let number = counter(heading).at(chapter.location()).at(0, default: 0)
  [#number~#sym.dash.en~#chapter.body]
}

#let _head-foot(body) = text(
  font: heading-font,
  size: sizes.normal,
  fill: head-foot-color,
  body,
)

#let header(title: none) = context {
  _head-foot(grid(
    columns: (1fr, auto),
    align: (left, right),
    title,
    _chapter-label(),
  ))
}

#let footer(author: none, numbering: "1") = context {
  let page-number = counter(page).get().at(0, default: 0)
  let total = counter(page).final().at(0, default: 0)
  _head-foot(grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    author,
    if numbered-body.get() {
      [Seite~#std.numbering(numbering, page-number)~von~#std.numbering(numbering, total)]
    } else {
      [Seite~#std.numbering(numbering, page-number)]
    },
    [],
  ))
}

#let background(
  paper-width: 210mm,
  logos: (),
  logos-scale: 1.0,
  watermark: none,
) = {
  watermark-layer(watermark)
  logos-module.skyline(paper-width)
  if logos.len() > 0 {
    place(
      bottom + right,
      dx: -2.3cm,
      dy: -1.5em - 2pt,
      logos-module.footer-logos(logos, scale: logos-scale),
    )
  }
}

#let page-setup(
  title: none,
  author: none,
  paper: "a4",
  paper-width: 210mm,
  margin: 2cm,
  logos: (),
  logos-scale: 1.0,
  watermark: none,
  page-numbering: "1",
  body,
) = {
  set page(
    paper: paper,
    margin: margin,
    header-ascent: 21.7pt,
    footer-descent: 8.3pt,
    numbering: none,
    header: header(title: title),
    footer: footer(author: author, numbering: page-numbering),
    background: background(
      paper-width: paper-width,
      logos: logos,
      logos-scale: logos-scale,
      watermark: watermark,
    ),
  )
  body
}
