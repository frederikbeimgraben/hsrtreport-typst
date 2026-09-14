// Page geometry, running head, footer and background layers.

#import "fonts.typ": *
#import "colors.typ": *
#import "../modules/logos.typ" as logos-module
#import "../modules/watermark.typ": watermark-layer

// The running head and the page number follow the chapter that is open on the
// page, the way the chapter counter does in the LaTeX class: the front matter
// and the back matter have no numbered chapter, so both stay empty there.
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

#let _in-main-matter() = {
  let chapter = _active-chapter()
  chapter != none and chapter.numbering != none
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

#let footer(author: none) = context {
  _head-foot(grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    author,
    if _in-main-matter() {
      [Seite~#counter(page).get().at(0, default: 0)~von~#counter(page).final().at(0, default: 0)]
    },
    [],
  ))
}

#let background(
  paper-width: 210mm,
  logos: (),
  show-footer-logos: false,
  logos-scale: 1.0,
  main-logo-scale: 1.0,
  watermark: none,
  margin: 2cm,
) = {
  watermark-layer(watermark)
  logos-module.skyline(paper-width)
  if show-footer-logos and logos.len() > 0 {
    place(
      bottom + right,
      dx: -margin,
      dy: -1.5em,
      logos-module.footer-logos(logos, scale: logos-scale, main-scale: main-logo-scale),
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
  show-footer-logos: false,
  logos-scale: 1.0,
  main-logo-scale: 1.0,
  watermark: none,
  body,
) = {
  set page(
    paper: paper,
    margin: margin,
    header-ascent: 21.7pt,
    footer-descent: 23.3pt,
    numbering: none,
    header: header(title: title),
    footer: footer(author: author),
    background: background(
      paper-width: paper-width,
      logos: logos,
      show-footer-logos: show-footer-logos,
      logos-scale: logos-scale,
      main-logo-scale: main-logo-scale,
      watermark: watermark,
      margin: margin,
    ),
  )
  body
}
