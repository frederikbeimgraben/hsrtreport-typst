// Document metadata: title page fields, logos and options.

#let settings = (
  // Title of the document. It appears on the title page and in the PDF
  // metadata.
  title: [Template für wissenschaftliche Arbeiten],

  // Title page fields. Every field that stays `none` leaves out its row.
  author: "Hans Maria Muster",
  email: "hans-maria.muster@student.hs-reutlingen.de",
  semester-count: "X",
  submitted-on: "XX.XX.20XX",
  course: "Medizinisch Technische Informatik B.Sc.",
  module: ("METIX.X", "Mustermodul"),
  supervisor: "Prof. Dr. Max Mustermann",
  semester: "Wintersemester 20XX/20XX",
  // topic: "Thema-XXX",
  // show-word-count: true,

  // Report variant: "inf", "hsrt", "stupa", "asta", "echo" or "makers". It
  // selects the default logos. Give `logos` to select other logos, for
  // example logos: ("INF", ("HSRT", 0.8)).
  variant: "inf",

  // Watermark text. `none` prints no watermark.
  watermark: none,

  // Front matter.
  show-toc: true,
  show-figure-list: false,
  show-table-list: false,

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
)
