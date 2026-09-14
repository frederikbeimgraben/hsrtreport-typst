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

#let hsrtreport(
  title: [Titel der Arbeit],
  author: "",
  created-on: none,
  abstract: none,
  keywords: none,
  module-name: none,
  data: (),
  variant: "meti",
  logos: auto,
  logos-scale: 1.0,
  main-logo-scale: 1.0,
  footer-logos: false,
  show-toc: true,
  show-figure-list: false,
  show-table-list: false,
  show-listing-list: false,
  show-equation-list: false,
  show-glossary: false,
  show-acronyms: false,
  terms: (:),
  acronyms: (:),
  bib: none,
  watermark: none,
  chapter-pagebreak: false,
  paper: "a4",
  paper-width: 210mm,
  margin: 2cm,
  font-size: sizes.normal,
  lang: "de",
  credit-url: "https://github.com/frederikbeimgraben/HSRT-Report",
  body,
) = {
  let logos = if logos == auto { variant-logos.at(variant, default: ()) } else { logos }
  let keyword-list = if type(keywords) == str {
    keywords.split(",").map(k => k.trim())
  } else {
    ()
  }

  set document(
    title: title,
    author: author,
    keywords: keyword-list,
    date: created-on,
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
    data: data,
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
