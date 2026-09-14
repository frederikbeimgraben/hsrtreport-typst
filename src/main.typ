// Main document file.

#import "../hsrtreport/lib.typ": *
#import "metadata.typ"
#import "glossary.typ"

#show: hsrtreport.with(
  ..metadata.settings,
  terms: glossary.terms,
  acronyms: glossary.acronyms,
  bib: bibliography("main.bib", style: "ieee", title: none),
)

#include "chapters/01_template_demo.typ"
