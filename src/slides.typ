// HSRTSlides - presentation template in the style of HSRTReport.
//
// The slides take the fonts, the colors, the logos, the skyline and the info
// boxes of the report. A level 1 heading opens a section with its own section
// slide, a level 2 heading opens a new slide and becomes its title.
//
// License: Creative Commons CC BY-SA 4.0

#import "config/fonts.typ": *
#import "config/colors.typ": *
#import "config/typography.typ": typography
#import "modules/logos.typ" as logos-module
#import "modules/logos.typ": footer-logo-names, title-logo-names
#import "modules/listings.typ": listings
#import "modules/watermark.typ": watermark-layer
#import "modules/infoboxes.typ": box-scale

// Font sizes of a slide. The steps keep the ratios of the report sizes.
#let slide-sizes = (
  tiny: 10pt,
  small: 14pt,
  normal: 18pt,
  large: 22pt,
  frame-title: 26pt,
  section: 36pt,
  title: 40pt,
)

// Rule below a title, the same 0.5mm black line as on the report title page.
#let _rule(above: 8pt, stroke: 0.5mm) = block(
  above: above,
  below: 0pt,
  line(length: 100%, stroke: stroke + rule-color),
)

// The current step of a slide with `steps`, for `only` and `uncover`.
#let _step = state("hsrt-slide-step", 1)

// The section that is open on the page. A section slide names itself.
#let _active-section() = {
  let page-number = here().page()
  let sections = query(heading.where(level: 1))
    .filter(section => section.location().page() <= page-number)
  if sections.len() == 0 { none } else { sections.last() }
}

// True when a level 1 heading starts on the page: the section slide.
#let _is-section-slide() = {
  let page-number = here().page()
  query(heading.where(level: 1)).any(it => it.location().page() == page-number)
}

#let _head-foot(body) = text(
  font: heading-font,
  size: slide-sizes.tiny,
  fill: head-foot-color,
  body,
)

#let _header(short-title) = context {
  if _is-section-slide() { return }
  let section = _active-section()
  _head-foot(grid(
    columns: (1fr, auto),
    align: (left + bottom, right + bottom),
    short-title,
    if section != none {
      if section.numbering != none {
        let number = counter(heading).at(section.location()).at(0, default: 0)
        [#number~#sym.dash.en~#section.body]
      } else {
        section.body
      }
    },
  ))
}

#let _footer(author, date, logos, logos-scale) = context {
  let page-number = counter(page).get().at(0, default: 0)
  let total = counter(page).final().at(0, default: 0)
  _head-foot(grid(
    columns: (1fr, auto, 1fr),
    align: (left + horizon, center + horizon, right + horizon),
    {
      author
      if author != none and date != none [ #sym.dot.c ]
      date
    },
    [Folie~#page-number~von~#total],
    if logos.len() > 0 {
      logos-module.footer-logos(logos, scale: logos-scale, height: 0.7cm)
    },
  ))
}

#let _background(paper-width, watermark) = {
  watermark-layer(watermark)
  logos-module.skyline(paper-width)
}

#let _date(value) = if type(value) == datetime {
  value.display("[day].[month].[year]")
} else {
  value
}

#let _normalize-logos(logos, names) = {
  if logos == auto { return names }
  if type(logos) in (str, bytes, dictionary) { return (logos,) }
  logos
}

// Shows `body` on the given steps of a slide and leaves no space on the other
// steps. `steps` is a number, an array of numbers, or a string such as "2-"
// (from step 2 on) or "1-3".
#let _matches(steps, current) = {
  if type(steps) == int { return current == steps }
  if type(steps) == array { return current in steps }
  if type(steps) == str {
    let (from, to) = steps.split("-").map(part => part.trim())
    let from = if from == "" { 1 } else { int(from) }
    let to = if to == "" { calc.inf } else { int(to) }
    return current >= from and current <= to
  }
  panic("steps is a number, an array of numbers or a range like \"2-\"")
}

#let only(steps, body) = context {
  if _matches(steps, _step.get()) { body }
}

// Shows `body` on the given steps of a slide. On the other steps the space
// stays reserved, so the layout does not jump.
#let uncover(steps, body) = context {
  if _matches(steps, _step.get()) { return body }
  // `hide` keeps the list markers and the enum numbers, so they are hidden
  // here as well.
  set list(marker: _ => hide[•])
  set enum(numbering: (..numbers) => hide(numbering("1.", ..numbers)))
  hide(body)
}

// A slide. `title` becomes a level 2 heading. With `steps: n` the slide is
// repeated n times, and `only` and `uncover` show their content step by step.
#let slide(title: none, steps: 1, body) = {
  for step in range(1, steps + 1) {
    pagebreak(weak: true)
    _step.update(step)
    if title != none {
      if step == 1 {
        heading(level: 2, title)
      } else {
        // The repeated title stays out of the outline and the PDF bookmarks.
        heading(level: 2, outlined: false, bookmarked: false, title)
      }
    }
    body
  }
  _step.update(1)
}

// The variant of the presentation, for the color of the focus slide.
#let _variant = state("hsrt-slides-variant", "inf")

// Black text on a light fill, white text on a dark fill.
#let _text-on(fill) = {
  let lightness = luma(fill).components().first()
  if lightness < 60% { white } else { black }
}

// A slide in the accent color of the variant, for one statement or a
// question: yellow for INF and HSRT, gray for STUPA, pink for AStA.
// `fill` sets another color.
#let focus-slide(fill: auto, body) = {
  pagebreak(weak: true)
  context {
    let fill = if fill == auto { variant-accent(_variant.get()) } else { fill }
    page(
      header: none,
      footer: none,
      background: none,
      fill: fill,
      align(center + horizon, text(
        font: heading-font,
        size: slide-sizes.section,
        weight: "bold",
        fill: _text-on(fill),
        hyphenate: false,
        body,
      )),
    )
  }
}

// The list of sections, on a slide of its own, in the style of the table of
// contents of the report: Blender, sections bold in the link color, slide
// titles with dot leaders and the slide number. `depth: 2` adds the slides.
#let outline-slide(title: [Inhalt], depth: 1) = {
  pagebreak(weak: true)
  heading(level: 2, outlined: false, bookmarked: false, title)

  show outline.entry: it => link(
    it.element.location(),
    it.indented(it.prefix(), it.inner()),
  )
  show outline.entry.where(level: 1): set block(above: 0.75em)
  show outline.entry.where(level: 1): set text(
    size: slide-sizes.large,
    weight: "bold",
  )
  show outline.entry.where(level: 1): set outline.entry(fill: none)
  show outline.entry.where(level: 2): set block(above: 0.45em)
  set outline.entry(fill: repeat(gap: 0.35em)[.])
  set text(font: heading-font, fill: link-color)
  set outline(indent: 1.5em)
  outline(title: none, depth: depth)
}

// Content in columns, 1fr each unless `widths` says otherwise.
#let cols(widths: auto, gutter: 1.2cm, ..cells) = {
  let cells = cells.pos()
  grid(
    columns: if widths == auto { (1fr,) * cells.len() } else { widths },
    column-gutter: gutter,
    ..cells,
  )
}

#let _data-table(data) = {
  let rows = ()
  for (label, value) in data {
    if value in (none, "", ()) { continue }
    rows.push(strong(label))
    rows.push(value)
  }
  table(
    columns: (auto, 1fr),
    column-gutter: 12pt,
    stroke: none,
    inset: (x: 0pt, y: 1.5pt),
    align: left + top,
    ..rows,
  )
}

#let _title-slide(
  title,
  subtitle,
  data,
  logos,
  logos-scale,
  margin,
  credit-url,
  background,
) = page(header: none, footer: none, background: background, {
  if logos.len() > 0 {
    place(
      top + left,
      dy: 0.9cm - margin.top,
      logos-module.title-logos(logos, scale: logos-scale),
    )
  }

  place(
    bottom + right,
    dx: margin.x - 0.3cm,
    dy: margin.bottom - 0.25cm,
    text(
      font: heading-font,
      size: slide-sizes.tiny * 0.7,
      fill: luma(50%),
      link(credit-url)[Made with #sym.suit.heart in Typst],
    ),
  )

  v(1fr)
  block(
    below: 0pt,
    text(
      font: heading-font,
      size: slide-sizes.title,
      weight: "bold",
      hyphenate: false,
      title,
    ),
  )
  _rule()
  if subtitle != none {
    block(
      above: 12pt,
      text(font: heading-font, size: slide-sizes.large, subtitle),
    )
  }
  v(1fr)
  set text(size: slide-sizes.small)
  _data-table(data)
  v(0.6cm)
})

#let hsrtslides(
  // Title slide
  title: [Titel des Vortrags],
  subtitle: none,
  short-title: auto,
  author: none,
  email: none,
  date: none,
  event: none,
  institution: none,
  labels: (
    author: "Vortrag von",
    date: "Datum",
    event: "Veranstaltung",
    institution: "Einrichtung",
  ),
  extra-data: (),
  show-title-slide: true,
  // Logos
  variant: "inf",
  logos: auto,
  footer-logos: auto,
  logos-scale: 1.0,
  // Layout
  watermark: none,
  aspect-ratio: "16-9",
  font-size: slide-sizes.normal,
  lang: "de",
  credit-url: "https://github.com/frederikbeimgraben/hsrtreport-typst",
  body,
) = {
  let logos = _normalize-logos(logos, title-logo-names(variant))
  let footer-logos = if footer-logos == false {
    ()
  } else if footer-logos in (auto, true) {
    _normalize-logos(auto, footer-logo-names(variant))
  } else {
    _normalize-logos(footer-logos, ())
  }
  let short-title = if short-title == auto { title } else { short-title }
  let date = _date(date)
  let paper-width = 28cm
  let paper-height = if aspect-ratio == "4-3" { 21cm } else { 15.75cm }
  let margin = (x: 1.4cm, top: 1.9cm, bottom: 1.7cm)
  let footer-author = if type(author) == array { author.join(", ") } else { author }

  set document(
    title: title,
    author: if type(author) == array { author } else if author == none { () } else { author },
    date: if type(date) == datetime { date } else { auto },
  )

  show: typography.with(font-size: font-size, lang: lang)
  set par(justify: false, leading: 0.55em, spacing: 0.9em)
  set list(indent: 0.6em, spacing: 0.75em, marker: ([•], [--], [·]))
  set enum(indent: 0.6em, spacing: 0.75em)
  show: listings
  show raw.where(block: true): set text(size: font-size * 0.7)
  set table(inset: 6pt)

  let background = _background(paper-width, watermark)
  _variant.update(variant)
  // The info boxes grow with the body text, 18pt against the 11pt report.
  box-scale.update(font-size / sizes.normal)

  set page(
    width: paper-width,
    height: paper-height,
    margin: margin,
    header-ascent: 35%,
    footer-descent: 30%,
    header: _header(short-title),
    footer: _footer(footer-author, date, footer-logos, logos-scale),
    background: background,
  )

  set heading(numbering: none)
  show heading: set text(font: heading-font, weight: "bold")

  // A section: a slide of its own with the number, the name and the rule.
  show heading.where(level: 1): set heading(numbering: "1", supplement: [Abschnitt])
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    align(horizon, block(width: 100%, {
      set align(left + top)
      if it.numbering != none {
        text(
          font: heading-font,
          size: slide-sizes.large,
          fill: head-foot-color,
          [#it.supplement #counter(heading).display(it.numbering)],
        )
      }
      block(
        above: 6pt,
        below: 0pt,
        text(size: slide-sizes.section, hyphenate: false, it.body),
      )
      _rule()
    }))
    pagebreak()
  }

  // A slide title: a new slide, the title and a thin rule below it.
  show heading.where(level: 2): it => {
    pagebreak(weak: true)
    block(below: 0.9em, {
      block(
        below: 0pt,
        text(size: slide-sizes.frame-title, hyphenate: false, it.body),
      )
      _rule(above: 6pt, stroke: 0.3mm)
    })
  }
  show heading.where(level: 3): set text(size: slide-sizes.large)
  show heading.where(level: 3): set block(above: 1em, below: 0.6em)

  if show-title-slide {
    let author-block = {
      let lines = ()
      if author != none {
        lines.push(if type(author) == array { author.join(", ") } else { author })
      }
      if email != none { lines.push(link("mailto:" + email, email)) }
      lines.join(linebreak())
    }
    _title-slide(
      title,
      subtitle,
      (
        (labels.author, author-block),
        (labels.date, date),
        (labels.event, event),
        (labels.institution, institution),
      )
        + extra-data,
      logos,
      logos-scale,
      margin,
      credit-url,
      background,
    )
  }

  body
}
