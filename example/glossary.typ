// Glossary and acronym definitions.
//
// Use an entry in the text with #gls("key"), #glspl("key"), #glsgen("key") or
// #acrshort("key").

// Short form: "key": [description]. The long form adds the German cases.
#let terms = (
  "Textkörper": (
    name: "Textkörper",
    description: [
      Bezeichnung für den Bereich innerhalb der Arbeit, in dem die eigentliche
      Ausarbeitung enthalten ist. Der Textkörper umfasst alle Kapitel zwischen
      Einleitung und Fazit.
    ],
    genitive: "Textkörpers",
    plural: "Textkörper",
  ),
)

// Short form: "key": "long form". The long form adds a differing short form.
#let acronyms = (
  "Abb": (short: "Abb.", long: "Abbildung"),
  "Tab": (short: "Tab.", long: "Tabelle"),
  "MPG": "Medizinproduktegesetz",
  "MS": "Microsoft®",
)
