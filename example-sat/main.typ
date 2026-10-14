// Main document file of the SAT example.

#import "@local/hsrtreport:1.1.0": *
#import "metadata.typ"
#import "glossary.typ"

#show: hsrtreport.with(
  ..metadata.settings,
  terms: glossary.terms,
  acronyms: glossary.acronyms,
)

#include "chapters/01_einleitung.typ"
#include "chapters/02_methoden.typ"
#include "chapters/03_ergebnisse.typ"
#include "chapters/04_diskussion.typ"
#include "chapters/05_zusammenfassung.typ"

= Literaturverzeichnis
#bibliography("main.bib", style: "apa", title: none, full: true)

= Danksagungen
Ich danke allen Personen, die diese Arbeit unterstützt haben.

= Eidesstattliche Erklärung
#declaration()

#include "chapters/90_anhang.typ"
