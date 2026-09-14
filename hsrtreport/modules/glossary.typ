// Glossary and acronym handling.
//
// Entries are registered once by the template. Every use drops a marker into
// the document, so the printed lists can collect the page numbers and the first
// use of an acronym can expand to its long form.

#let terms-state = state("hsrt-glossary-terms", (:))
#let acronyms-state = state("hsrt-glossary-acronyms", (:))
#let printed-state = state("hsrt-glossary-printed", (terms: false, acronyms: false))

#let register(terms: (:), acronyms: (:), printed: (terms: false, acronyms: false)) = {
  terms-state.update(terms)
  acronyms-state.update(acronyms)
  printed-state.update(printed)
}

#let entry-label(key) = label("gls:" + key)

#let _capitalize(body) = {
  show text: it => upper(it.text.slice(0, 1)) + it.text.slice(1)
  body
}

#let _marker(key) = [#metadata(key)#label("hsrt-gls")]

#let _is-first(key) = {
  query(selector(label("hsrt-gls")).before(here(), inclusive: false))
    .filter(m => m.value == key)
    .len() == 0
}

#let _linked(key, kind, body) = {
  let printed = printed-state.get()
  if printed.at(kind, default: false) {
    link(entry-label(key), body)
  } else {
    body
  }
}

#let _lookup(key) = {
  let acronyms = acronyms-state.get()
  if key in acronyms { return ("acronyms", acronyms.at(key)) }
  let terms = terms-state.get()
  if key in terms { return ("terms", terms.at(key)) }
  panic("unknown glossary key: " + key)
}

#let _use(key, field: "name", expand: auto, capitalize: false) = context {
  let (kind, entry) = _lookup(key)
  let body = if kind == "acronyms" {
    let short = entry.at("short", default: key)
    let long = entry.at("long", default: short)
    let full = expand == true or (expand == auto and _is-first(key))
    if full [#long (#short)] else [#short]
  } else {
    entry.at(field, default: entry.at("name", default: key))
  }
  if capitalize { body = _capitalize(body) }
  _linked(key, kind, body)
  _marker(key)
}

#let gls(key) = _use(key)
#let Gls(key) = _use(key, capitalize: true)
#let glspl(key) = _use(key, field: "plural")
#let glsgen(key) = _use(key, field: "genitive")
#let glsdat(key) = _use(key, field: "dative")

#let acrshort(key) = _use(key, expand: false)
#let acr(key) = acrshort(key)
#let acrlong(key) = context {
  let (_, entry) = _lookup(key)
  entry.at("long", default: key)
  _marker(key)
}
#let acrfull(key) = _use(key, expand: true)

#let pages-of(key) = {
  query(label("hsrt-gls"))
    .filter(m => m.value == key)
    .map(m => counter(page).at(m.location()).at(0, default: 0))
    .dedup()
    .sorted()
}
