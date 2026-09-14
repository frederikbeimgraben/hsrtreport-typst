// Glossary and list of abbreviations.

#import "../config/fonts.typ": *
#import "../modules/glossary.typ": entry-label, pages-of

#let _table(entry-name, description-name, page-name, rows) = table(
  columns: (3fr, 5.8fr, 1.2fr),
  stroke: (x, y) => if y == 0 { (bottom: 0.6pt + black) } else { none },
  inset: (x: 0pt, y: 5pt),
  align: (left + top, left + top, left + top),
  table.header(
    strong(entry-name),
    strong(description-name),
    strong(page-name),
  ),
  ..rows,
)

#let glossary-page(
  entries,
  title: [Glossar],
  entry-name: [Wort],
  description-name: [Bedeutung],
  page-name: [Seite(n)],
) = context {
  if entries.len() == 0 { return }

  heading(level: 1, numbering: none, outlined: false, title)

  let rows = ()
  for key in entries.keys().sorted() {
    let entry = entries.at(key)
    let pages = pages-of(key)
    rows.push([#entry.at("name", default: key)#entry-label(key)])
    rows.push(entry.at("description", default: []))
    rows.push(pages.map(str).join(", "))
  }
  _table(entry-name, description-name, page-name, rows)
}

#let acronym-page(
  entries,
  title: [Abkürzungsverzeichnis],
  entry-name: [Abkürzung],
  description-name: [Bedeutung],
  page-name: [Seite(n)],
) = context {
  if entries.len() == 0 { return }

  heading(level: 1, numbering: none, outlined: false, title)

  let rows = ()
  for key in entries.keys().sorted() {
    let entry = entries.at(key)
    let pages = pages-of(key)
    rows.push([#entry.at("short", default: key)#entry-label(key)])
    rows.push(entry.at("long", default: []))
    rows.push(pages.map(str).join(", "))
  }
  _table(entry-name, description-name, page-name, rows)
}
