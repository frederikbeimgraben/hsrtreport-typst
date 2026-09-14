// Document metadata: title page, logos and document-wide options.

#import "@local/hsrtreport:1.0.0": data-line, word-count

#let author = "Hans Maria Muster"

#let settings = (
  // Title of the document. It appears on the title page and in the PDF
  // metadata.
  title: [Titel der Arbeit],

  author: author,

  // Date of creation, format DD.MM.YYYY.
  created-on: none,

  // Watermark text. `none` prints no watermark.
  watermark: none,

  // Report variant: "meti", "mki" or "huc". It selects the default logo.
  variant: "meti",

  // Logos as (name, scale) pairs. Names refer to
  // hsrtreport/assets/images/logos/<name>.svg. Set `logos: auto` to take the
  // logo of the variant.
  logos: (("INF/Kombiniert", 0.9),),

  // Repeat the logos in the page footer.
  footer-logos: true,

  // Front matter.
  show-toc: true,
  show-figure-list: false,
  show-table-list: false,

  // Back matter.
  show-glossary: true,
  show-acronyms: true,

  // Abstract. It states the objective, the method and the result of the work
  // and must fit on the title page.
  abstract: [
    Das Abstract beschreibt in wenigen Sätzen die Zielsetzung und das Ergebnis
    der Ausarbeitung. Das Abstract muss sich vollständig auf der Titelseite
    befinden. Die Zeichensatzformatierung wird in einem eigenen Absatz
    beschrieben. Das Abstract soll es den Leser:innen ermöglichen, innerhalb
    von wenigen Augenblicken zu erfassen, welcher Inhalt hinter der Überschrift
    steckt und ob das Thema, aus Sicht der Leser:innen, zur weiteren Bearbeitung
    lohnt. Das Abstract ist keine verbale Beschreibung des
    Inhaltsverzeichnisses, sondern gibt kurz und knapp z.B. die Zielsetzung
    (z.B. Hypothese), die eingesetzten Methoden und die erzielten Ergebnisse /
    Erkenntnisse bekannt. Weitere Hinweise finden Sie außerdem im
    Vorlesungsskript.
  ],

  // Keywords, separated by commas. Take them from a standard list, for example
  // ACM CCS or IEEE, to make the work easy to index.
  keywords: "Seminararbeit, wissenschaftliche Ausarbeitung, Bachelor-Thesis, Studium, Plagiat",

  // Rows of the title page table. A length adds vertical space.
  data: (
    // data-line("Thema", [Thema-XXX: \ Template für wissenschaftliche Arbeiten]),
    5pt,
    data-line("Vorgelegt von", [
      #author \
      X. Fachsemester \
      #link("mailto:hans-maria.muster@student.hs-reutlingen.de")[hans-maria.muster\@student.hs-reutlingen.de]
    ]),
    5pt,
    data-line("Vorgelegt am", [XX.XX.20XX]),
    5pt,
    data-line("Studiengang", [Medizinisch Technische Informatik B.Sc.]),
    data-line("Modul", [METIX.X \ Mustermodul]),
    data-line("Dozent:in", [Prof. Dr. Max Mustermann]),
    data-line("Semester", [Wintersemester 20XX/20XX]),
    // data-line("Wortanzahl", [#word-count() Wörter]),
  ),

  // Module name for the footer.
  module-name: "METIX.Y – Mustermodul – WiSe XX/YY",
)
