// Main document file.

#import "@local/hsrtreport:1.0.0": *
#import "metadata.typ"
#import "glossary.typ"

#show: hsrtreport.with(
  ..metadata.settings,
  terms: glossary.terms,
  acronyms: glossary.acronyms,
  bib: bibliography("main.bib", style: "ieee", title: none),
)

#include "chapters/01_einleitung.typ"
