// Layout "sat-meti": the seminar paper (SAT) of the course meTI.
//
// The layout copies the Word template "Dokumentvorlage Seminararbeit",
// version 7.4. Libre Franklin replaces Franklin Gothic Book. TeX Gyre Termes
// replaces Times New Roman.

#import "../modules/glossary.typ": entry-label, register
#import "../modules/wordcount.typ": count-words, words-state
#import "../modules/watermark.typ": watermark-layer
#import "../modules/listings.typ": listings

#let sat-sans = ("Libre Franklin",)
#let sat-serif = ("TeX Gyre Termes",)

#let sat-sizes = (
  title: 24pt,
  normal: 12pt,
  h1: 16pt,
  h2: 14pt,
  h3: 12pt,
  lists: 10pt,
  header: 12pt,
  footer: 10pt,
  footnote: 10pt,
  abstract: 10pt,
)

// The line gap (hhea lineGap) of Libre Franklin. The text box spans the
// ascender and the descender, so one line takes the single line height of
// the font.
#let _leading = 0.238em
// The Word template puts 6pt below each paragraph.
#let _par-space = 6pt
// One single line of 12pt body text.
#let _line = 1.25 * sat-sizes.normal

#let sat-labels = (
  header: "Hochschule Reutlingen – Fakultät Informatik – Studiengang meti",
  course-prefix: "Studiengang",
  document-type: "Seminararbeit",
  submitted-by: "vorgelegt von:",
  semester-count: "Fachsemester",
  contact: "Kontaktadresse:",
  submitted-on: "vorgelegt am:",
  word-count: "Anzahl der Wörter:",
  abstract: "Abstract:",
  keywords-en: "Keywords:",
  keywords: "Schlüsselwörter:",
  toc: "Inhalt",
  figures: "Abbildungsverzeichnis",
  tables: "Tabellenverzeichnis",
  equations: "Formelverzeichnis",
  equation: "Formel",
  acronyms: "Abkürzungsverzeichnis",
  glossary: "Glossar",
  bibliography: "Literaturverzeichnis",
  page: "Seite",
  page-of: "von",
)

// The exact text of the declaration in the Word template.
#let declaration-text = (
  "Hiermit erkläre ich an Eides statt, dass ich die vorliegende Arbeit selbstständig erstellt, keine nicht genannte fremde Hilfe in Anspruch genommen und alle von mir verwendeten Hilfsmittel und Quellen in der Arbeit benannt und kenntlich gemacht habe. Die Arbeit oder Teile davon wurden in keinem Prüfungsmodul zur Prüfung vorgelegt und verletzt in keiner Weise Rechte Dritter.",
  "Mir ist bekannt, dass eine unwahre Erklärung als Täuschung gewertet wird.",
)

// Prints the declaration text. The function does not print the heading.
// Write the level-1 heading in your document before the call. A linter
// that reads the source then finds the heading.
#let declaration() = {
  for paragraph in declaration-text {
    par(paragraph)
  }
}

// ---------------------------------------------------------------------------
// Word count
// ---------------------------------------------------------------------------

#let _space = [ ].func()

#let _plain(value) = {
  if type(value) == str { return value }
  if type(value) != content { return "" }
  if value.func() == _space { return " " }
  if value.has("text") { return _plain(value.text) }
  if value.has("children") { return value.children.map(_plain).join("") }
  if value.has("body") { return _plain(value.body) }
  if value.has("child") { return _plain(value.child) }
  ""
}

// Breaks the document into its top-level elements. Sequences, includes and
// styled content open up. Their styles do not matter for the count.
#let _flatten(value) = {
  if type(value) != content { return () }
  if value.has("children") { return value.children.map(_flatten).join(()) }
  if value.has("child") and value.has("styles") { return _flatten(value.child) }
  (value,)
}

#let _heading-level(value) = {
  let fields = value.fields()
  let level = fields.at("level", default: auto)
  if level == auto { fields.at("depth", default: 1) } else { level }
}

// Counts the words of the SAT text. The count starts at the first level-1
// heading of the body, or at the level-1 heading with the text `start`. It
// stops before the level-1 heading with the text `stop`, or before a
// bibliography. Heading texts, captions and footnotes count. Code and
// glossary markers do not count.
#let sat-count-words(body, start: none, stop: "Literaturverzeichnis") = {
  let counting = false
  let total = 0
  for item in _flatten(body) {
    if item.func() == heading and _heading-level(item) == 1 {
      let name = _plain(item.body).trim()
      if not counting and (start == none or name == start) {
        counting = true
      } else if counting and name == stop {
        break
      }
    }
    if item.func() == bibliography and counting { break }
    if counting { total += count-words(item) }
  }
  total
}

// ---------------------------------------------------------------------------
// Equations
// ---------------------------------------------------------------------------

// A numbered block equation with a title. The title goes below the equation
// as "Formel N : Titel" and into the list of equations. Put the label inside
// the body:
//   #formula(title: [Polstellenberechnung])[$ x = 1 $ <eq:pol>]
#let formula(title: none, body) = block(
  above: 2 * _line,
  below: 2 * _line,
  breakable: false,
  {
    show math.equation.where(block: true): set block(above: 0pt, below: _par-space)
    body
    if title != none {
      [#metadata((title: title))<hsrt-formula>]
      context {
        let number = counter(math.equation).get().first()
        let name = [#sat-labels.equation #number : #title]
        block(above: _par-space, below: 0pt, text(font: sat-serif, style: "italic", name))
      }
    }
  },
)

// ---------------------------------------------------------------------------
// Running head and footer
// ---------------------------------------------------------------------------

// The chapter of the page: the first numbered level-1 heading on the page,
// else the last one before the page. This is how STYLEREF works in Word.
#let _chapter() = {
  let page-number = here().page()
  let chapters = query(heading.where(level: 1)).filter(it => it.numbering != none)
  let on-page = chapters.filter(it => it.location().page() == page-number)
  if on-page.len() > 0 { return on-page.first() }
  let before = chapters.filter(it => it.location().page() < page-number)
  if before.len() > 0 { before.last() } else { none }
}

#let _header(title, labels) = context {
  set text(size: sat-sizes.header)
  set par(justify: false, spacing: _leading, leading: _leading)
  set align(center)
  let chapter = _chapter()
  let chapter-line = if chapter == none { [~] } else {
    let number = counter(heading).at(chapter.location()).first()
    [#number #chapter.body]
  }
  par(labels.header)
  par(title)
  par(chapter-line)
}

// Word gives NUMPAGES, the physical page count, as the total.
#let _footer(footer-id, labels, numbered: true) = context {
  set text(size: sat-sizes.footer)
  let total = {
    let ends = query(<hsrt-sat-end>)
    if ends.len() > 0 { ends.first().location().page() } else { here().page() }
  }
  grid(
    columns: (1fr, auto),
    align: (left, right),
    if footer-id != none { footer-id },
    if numbered {
      let number = counter(page).get().first()
      [#labels.page #number #labels.page-of #total]
    },
  )
}

// ---------------------------------------------------------------------------
// Lists of contents, figures, tables, equations, acronyms and terms
// ---------------------------------------------------------------------------

#let _list-heading(title) = heading(level: 1, numbering: none, outlined: false, title)

// The dots between the entry and its page number.
#let _dots = box(width: 1fr, repeat(gap: 0.2em)[.])

#let _toc(title, depth: 3) = {
  _list-heading(title)
  set text(size: sat-sizes.lists)
  show outline.entry: it => {
    let level = it.level
    let number = if it.element.numbering != none { it.prefix() }
    let body = if level == 1 { strong(upper(it.body())) } else { it.body() }
    let page = if level == 1 { strong(it.page()) } else { it.page() }
    // Word puts the text of every level 1.7cm from the margin.
    block(
      above: if level == 1 { _leading + _par-space } else { _leading },
      below: _leading,
      link(it.element.location(), par(
        justify: false,
        hanging-indent: 1.7cm,
        [#box(width: 1.7cm, if level == 1 { strong(number) } else { number })#body#_dots#page],
      )),
    )
  }
  outline(title: none, depth: depth, target: heading)
}

// One entry of a list of figures, tables or equations, as Word sets it:
// "Abbildung 3.1 : Titel ..... 5" with a hanging indent of 3cm.
#let _caption-entry(location, name, body, page) = block(
  above: _leading,
  below: _leading,
  link(location, par(justify: false, hanging-indent: 3cm, [#name : #body#_dots#page])),
)

#let _figure-list(title, kind) = {
  _list-heading(title)
  set text(size: sat-sizes.lists)
  // The number of a figure depends on its chapter. The entry prefix does not
  // know the chapter, so the entry calculates the number again.
  show outline.entry: it => {
    let location = it.element.location()
    let chapter = counter(heading).at(location).at(0, default: 0)
    let number = counter(figure.where(kind: kind)).at(location).first()
    _caption-entry(
      location,
      [#it.element.supplement #chapter.#number],
      it.body(),
      it.page(),
    )
  }
  outline(title: none, target: figure.where(kind: kind))
}

#let _equation-list(title, labels) = {
  _list-heading(title)
  set text(size: sat-sizes.lists)
  context for entry in query(<hsrt-formula>) {
    let location = entry.location()
    let number = counter(math.equation).at(location).first()
    _caption-entry(
      location,
      [#labels.equation #number],
      entry.value.title,
      counter(page).at(location).first(),
    )
  }
}

#let _plain-table(columns, rows) = {
  set par(justify: false)
  table(
    columns: columns,
    stroke: none,
    inset: (left: 0pt, right: 6pt, y: 2pt),
    align: left + top,
    ..rows,
  )
}

// Three columns without rules: "Abk. -- Langform".
#let _acronym-list(title, entries) = {
  _list-heading(title)
  set text(size: sat-sizes.lists)
  let rows = ()
  for key in entries.keys().sorted() {
    let entry = entries.at(key)
    rows.push([#entry.at("short", default: key)#entry-label(key)])
    rows.push([--])
    rows.push(entry.at("long", default: []))
  }
  _plain-table((3.25cm, 2.03cm, 1fr), rows)
}

// Two columns without rules: term and description.
#let _glossary-list(title, entries) = {
  _list-heading(title)
  set text(size: sat-sizes.lists)
  let rows = ()
  for key in entries.keys().sorted() {
    let entry = entries.at(key)
    rows.push([#entry.at("name", default: key)#entry-label(key)])
    rows.push(entry.at("description", default: []))
  }
  _plain-table((5.25cm, 1fr), rows)
}

// ---------------------------------------------------------------------------
// Title page and abstract page
// ---------------------------------------------------------------------------

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

#let _join(value) = if type(value) == array { value.join(", ") } else { value }

#let _images = "../assets/images/logos/"

// The logo row of the Word template: INF at the left, meTI in the middle and
// HSRT at the right, 2.5cm below the top edge of the page.
#let _title-logos() = place(
  top + left,
  dx: 3.07cm - 4cm,
  dy: 2.5cm - 3cm,
  box(width: 19.19cm - 3.07cm, grid(
    columns: (auto, 1fr, auto, 1fr, auto),
    align: horizon,
    image(_images + "INF.svg", height: 1.1cm),
    [],
    image(_images + "METI.jpeg", height: 1.38cm),
    [],
    image(_images + "HSRT.svg", height: 1.2cm),
  )),
)

#let _titlepage(
  title: none,
  author: none,
  email: none,
  semester-count: none,
  submitted-on: none,
  course: none,
  module: none,
  supervisor: none,
  semester: none,
  labels: sat-labels,
) = page(header: none, footer: none, {
  counter(page).update(0)
  set par(justify: false, spacing: _leading + _par-space)
  _title-logos()

  let seminar = if type(module) == array { module.last() } else { module }

  // The text starts below the logo row, as the header of the Word template
  // pushes it down.
  v(1.35cm)
  align(center, {
    if course != none { par[#labels.course-prefix #course] }
    if seminar != none { par[„#seminar“,] }
    if semester != none { par(semester) }
    if supervisor != none { par(_lines(supervisor)) }
    par[~]
    par("- " + labels.document-type + " -")
  })

  // The title starts 6cm below the top margin, that is 9cm below the top
  // edge of the page.
  place(top + left, dy: 6cm, block(width: 100%, {
    align(center, block(
      below: 15pt + _leading,
      text(size: sat-sizes.title, tracking: 0.25pt, hyphenate: false, title),
    ))
    par[~]
    align(center, {
      par(labels.submitted-by)
      if author not in (none, "") { par(author) }
      if semester-count != none { par[#semester-count. #labels.semester-count] }
    })
    par[~]
    par[~]
    par[~]
    let rows = ()
    if email != none {
      rows.push(labels.contact)
      rows.push(link("mailto:" + email, email))
    }
    rows.push(labels.submitted-on)
    rows.push(_date(submitted-on))
    rows.push(labels.word-count)
    rows.push(context str(words-state.get()))
    grid(
      columns: (4cm, 1fr),
      row-gutter: _leading + _par-space,
      ..rows,
    )
  }))
})

#let _abstract-page(abstract: none, keywords: none, keywords-en: none, labels: sat-labels) = {
  set text(font: sat-serif, style: "italic", size: sat-sizes.abstract)
  if abstract != none { par[*#labels.abstract* #abstract] }
  if keywords-en != none { par[*#labels.keywords-en* #_join(keywords-en)] }
  if keywords != none { par[*#labels.keywords* #_join(keywords)] }
}

// ---------------------------------------------------------------------------
// The layout
// ---------------------------------------------------------------------------

#let sat-meti(
  title: none,
  author: "",
  email: none,
  semester-count: none,
  submitted-on: none,
  course: none,
  module: none,
  supervisor: none,
  semester: none,
  abstract: none,
  keywords: none,
  keywords-en: none,
  footer-id: none,
  created-on: none,
  terms: (:),
  acronyms: (:),
  bib: none,
  watermark: none,
  lang: "de",
  labels: (:),
  body,
) = {
  let labels = sat-labels + labels
  let keyword-list(value) = if type(value) == str {
    value.split(",").map(keyword => keyword.trim())
  } else if type(value) == array { value } else { () }

  set document(
    title: title,
    author: author,
    keywords: keyword-list(keywords) + keyword-list(keywords-en),
    date: if type(created-on) == datetime { created-on } else { auto },
  )

  set page(
    paper: "a4",
    margin: (left: 4cm, right: 3cm, top: 3cm, bottom: 2cm),
    header-ascent: 0.3cm,
    footer-descent: 0.75cm,
    numbering: none,
    header: _header(title, labels),
    footer: _footer(footer-id, labels),
    background: watermark-layer(watermark),
  )

  // Body text: 12pt, justified, hyphenated, single line spacing, 6pt below
  // each paragraph.
  set text(
    font: sat-sans,
    size: sat-sizes.normal,
    lang: lang,
    hyphenate: true,
    top-edge: "ascender",
    bottom-edge: "descender",
  )
  set par(
    justify: true,
    leading: _leading,
    spacing: _leading + _par-space,
    first-line-indent: 0pt,
    linebreaks: "optimized",
  )
  // List items have no space between them ("Listenabsatz").
  set list(spacing: _leading)
  set enum(spacing: _leading)
  set std.terms(spacing: _leading)
  show raw: set text(font: ("DejaVu Sans Mono",))
  show link: it => if type(it.dest) == str {
    underline(text(fill: rgb("#0000ff"), it))
  } else { it }

  // Headings: numbered without a final dot. Level 4 has no number and stays
  // out of the outline.
  set heading(numbering: "1.1")
  show heading: set text(font: sat-sans, weight: "regular")
  show heading.where(level: 4): set heading(numbering: none, outlined: false, bookmarked: false)
  show heading: it => {
    let level = calc.min(it.level, 4)
    let (size, above, below, indent) = (
      (sat-sizes.h1, 24pt, _par-space, 0.76cm),
      (sat-sizes.h2, 12pt, _par-space, 1.4cm),
      (sat-sizes.h3, 10pt, _par-space, 1.27cm),
      (sat-sizes.normal, 10pt, 0pt, 0cm),
    ).at(level - 1)
    set text(size: size)
    set text(weight: "bold") if level >= 3
    set text(style: "italic", fill: rgb("#4f81bd")) if level == 4
    set par(justify: false)
    let content = if it.numbering != none {
      grid(
        columns: (indent, 1fr),
        context counter(heading).display(it.numbering),
        it.body,
      )
    } else {
      it.body
    }
    block(above: above + _leading, below: below + _leading, sticky: true, content)
  }
  // Each level-1 heading starts a new page, also the lists in the front
  // matter. Figures and tables count again from 1 in each chapter.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  // Figures and tables: caption below, "Abbildung 3.1 : Titel" in Termes
  // italic.
  show: listings
  set figure(numbering: n => context numbering(
    "1.1",
    counter(heading).get().at(0, default: 0),
    n,
  ))
  set figure.caption(position: bottom, separator: [ : ])
  show figure.where(kind: raw): set figure.caption(position: bottom)
  show figure.caption: set text(font: sat-serif, style: "italic")
  show figure.caption: set par(justify: false)
  show figure: set align(left)
  show figure: set block(below: 10pt + _leading)
  set table(stroke: 0.5pt + black)
  show table: set par(justify: false)

  // Equations: numbered over the whole text, 1cm from the left margin, two
  // lines above and below.
  set math.equation(numbering: "(1)", supplement: [#labels.equation])
  show math.equation.where(block: true): set block(above: 2 * _line, below: 2 * _line)
  show math.equation.where(block: true): set align(left)
  show math.equation.where(block: true): it => pad(left: 1cm, it)
  show ref: it => {
    let element = it.element
    if element != none and element.func() == math.equation {
      let number = counter(math.equation).at(element.location()).first()
      link(element.location(), [#labels.equation~#number])
    } else {
      it
    }
  }

  // Footnotes: 10pt, numbered over the whole text, a left rule of 30% of the
  // text width above them.
  set footnote.entry(
    separator: line(length: 30%, stroke: 0.5pt),
    indent: 0pt,
    gap: _leading,
  )
  show footnote.entry: set text(size: sat-sizes.footnote)
  show footnote.entry: set par(spacing: _leading)

  words-state.update(sat-count-words(body))
  register(terms: terms, acronyms: acronyms, printed: (terms: true, acronyms: true))

  // Page 0: the title page without header and footer.
  _titlepage(
    title: title,
    author: author,
    email: email,
    semester-count: semester-count,
    submitted-on: submitted-on,
    course: course,
    module: module,
    supervisor: supervisor,
    semester: semester,
    labels: labels,
  )

  // Page 2 of the file: abstract and keywords. It belongs to the title
  // sheet, so the first list page gets the number 1.
  page(footer: _footer(footer-id, labels, numbered: false), _abstract-page(
    abstract: abstract,
    keywords: keywords,
    keywords-en: keywords-en,
    labels: labels,
  ))

  counter(page).update(1)
  _toc(labels.toc, depth: 3)
  _figure-list(labels.figures, image)
  _figure-list(labels.tables, table)
  _equation-list(labels.equations, labels)
  _acronym-list(labels.acronyms, acronyms)
  _glossary-list(labels.glossary, terms)

  body

  if bib != none {
    heading(level: 1, labels.bibliography)
    bib
  }

  [#metadata(none)<hsrt-sat-end>]
}
