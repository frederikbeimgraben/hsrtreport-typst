// HSRTReport - report template of the Faculty of Informatics, Reutlingen
// University. Typst port of the HSRTReport LaTeX class.
//
// Original author: Martin Oswald (ZHAW), modified by Frederik Beimgraben.
// License: Creative Commons CC BY-SA 4.0

#import "config/fonts.typ": *
#import "config/colors.typ": *
#import "config/typography.typ": typography, compact-list
#import "config/sections.typ": sections, subfigure, unnumbered
#import "config/pagesetup.typ": page-setup
#import "modules/logos.typ": variant-logos
#import "modules/listings.typ": listing, listings
#import "modules/icons.typ"
#import "modules/infoboxes.typ": *
#import "modules/glossary.typ": *
#import "modules/wordcount.typ": count-words, word-count, words-state
#import "pages/titlepage.typ": data-line, titlepage
#import "pages/toc.typ": *
#import "pages/glossaries.typ": acronym-page, glossary-page

// Labels of the title page table.
#let default-labels = (
  topic: "Thema",
  author: "Vorgelegt von",
  submitted-on: "Vorgelegt am",
  course: "Studiengang",
  module: "Modul",
  supervisor: "Dozent:in",
  semester: "Semester",
  word-count: "Wortanzahl",
)

#let _lines(value) = if type(value) == array {
  value.map(line => [#line]).join(linebreak())
} else {
  value
}

#let _date(value) = if type(value) == datetime {
  value.display("[day].[month].[year]")
} else {
  value
}

#let _author-block(author, semester-count, email) = {
  let lines = ()
  if author not in (none, "") { lines.push([#author]) }
  if semester-count != none { lines.push([#semester-count. Fachsemester]) }
  if email != none { lines.push(link("mailto:" + email, email)) }
  lines.join(linebreak())
}

// Builds the rows of the title page table from the single fields. Groups of
// rows are separated by the same 5pt that the LaTeX class uses.
#let _title-data(fields, labels, show-word-count) = {
  let groups = (
    (("topic", fields.topic),),
    (("author", _author-block(fields.author, fields.semester-count, fields.email)),),
    (("submitted-on", _date(fields.submitted-on)),),
    (
      ("course", fields.course),
      ("module", _lines(fields.module)),
      ("supervisor", _lines(fields.supervisor)),
      ("semester", fields.semester),
      ("word-count", if show-word-count { word-count() }),
    ),
  )

  let rows = ()
  for group in groups {
    let filled = group.filter(((key, value)) => value not in (none, "", ()))
    if filled.len() == 0 { continue }
    if rows.len() > 0 { rows.push(5pt) }
    for (key, value) in filled {
      rows.push(data-line(labels.at(key), value))
    }
  }
  rows
}

// "MPG": "Medizinproduktegesetz" is short for
// "MPG": (short: "MPG", long: "Medizinproduktegesetz").
#let _normalize-acronyms(acronyms) = {
  let normalized = (:)
  for (key, value) in acronyms {
    normalized.insert(
      key,
      if type(value) == dictionary { value } else { (short: key, long: value) },
    )
  }
  normalized
}

// "Wort": [Bedeutung] is short for "Wort": (name: "Wort", description: [...]).
#let _normalize-terms(terms) = {
  let normalized = (:)
  for (key, value) in terms {
    normalized.insert(
      key,
      if type(value) == dictionary { value } else { (name: key, description: value) },
    )
  }
  normalized
}

#let _normalize-logos(logos, variant) = {
  if logos == auto { return variant-logos.at(variant, default: ()) }
  if type(logos) == str { return (logos,) }
  logos
}

#let hsrtreport(
  // Title page
  title: [Titel der Arbeit],
  author: "",
  email: none,
  semester-count: none,
  topic: none,
  submitted-on: none,
  course: none,
  module: none,
  supervisor: none,
  semester: none,
  abstract: none,
  keywords: none,
  created-on: none,
  data: auto,
  extra-data: (),
  labels: default-labels,
  show-word-count: false,
  // Logos
  variant: "meti",
  logos: auto,
  logos-scale: 1.0,
  main-logo-scale: 1.0,
  footer-logos: true,
  // Front matter and back matter
  show-toc: true,
  show-figure-list: false,
  show-table-list: false,
  show-listing-list: false,
  show-equation-list: false,
  show-glossary: auto,
  show-acronyms: auto,
  terms: (:),
  acronyms: (:),
  bib: none,
  // Layout
  watermark: none,
  chapter-pagebreak: false,
  paper: "a4",
  paper-width: 210mm,
  margin: 2cm,
  font-size: sizes.normal,
  lang: "de",
  credit-url: "https://github.com/frederikbeimgraben/hsrtreport-typst",
  body,
) = {
  let logos = _normalize-logos(logos, variant)
  let terms = _normalize-terms(terms)
  let acronyms = _normalize-acronyms(acronyms)
  let labels = default-labels + labels
  let show-glossary = if show-glossary == auto { terms.len() > 0 } else { show-glossary }
  let show-acronyms = if show-acronyms == auto { acronyms.len() > 0 } else { show-acronyms }

  let data = if data == auto {
    _title-data(
      (
        topic: topic,
        author: author,
        email: email,
        semester-count: semester-count,
        submitted-on: submitted-on,
        course: course,
        module: module,
        supervisor: supervisor,
        semester: semester,
      ),
      labels,
      show-word-count,
    )
  } else {
    data
  }

  set document(
    title: title,
    author: author,
    keywords: if type(keywords) == str {
      keywords.split(",").map(keyword => keyword.trim())
    } else {
      ()
    },
    date: if type(created-on) == datetime { created-on } else { auto },
  )

  show: typography.with(font-size: font-size, lang: lang)
  show: sections.with(chapter-pagebreak: chapter-pagebreak, font-size: font-size)
  show: listings
  show: page-setup.with(
    title: title,
    author: author,
    paper: paper,
    paper-width: paper-width,
    margin: margin,
    logos: logos,
    show-footer-logos: footer-logos,
    logos-scale: logos-scale,
    main-logo-scale: main-logo-scale,
    watermark: watermark,
  )

  words-state.update(count-words(body))

  register(
    terms: terms,
    acronyms: acronyms,
    printed: (terms: show-glossary, acronyms: show-acronyms),
  )

  titlepage(
    title: title,
    abstract: abstract,
    keywords: keywords,
    data: data + extra-data,
    logos: logos,
    logos-scale: logos-scale,
    main-logo-scale: main-logo-scale,
    margin: margin,
    credit-url: credit-url,
    font-size: font-size,
  )

  if show-toc { toc() }
  if show-figure-list { figure-list() }
  if show-table-list { table-list() }
  if show-listing-list { listing-list() }
  if show-equation-list { equation-list() }

  pagebreak(weak: true)
  counter(page).update(1)

  body

  if show-glossary and terms.len() > 0 {
    pagebreak(weak: true)
    glossary-page(terms)
  }
  if show-acronyms and acronyms.len() > 0 {
    pagebreak(weak: true)
    acronym-page(acronyms)
  }
  if bib != none {
    pagebreak(weak: true)
    heading(level: 1, numbering: none, outlined: false)[Literaturverzeichnis]
    bib
  }
}
