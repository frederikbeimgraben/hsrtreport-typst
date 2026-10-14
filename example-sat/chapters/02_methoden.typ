#import "@local/hsrtreport:1.1.0": *

= Methoden

== Abbildungen

Jede Abbildung erhält eine Nummer aus der Kapitelnummer und einer
fortlaufenden Nummer (@fig:menu).

#figure(
  rect(width: 8cm, height: 2cm, fill: luma(92%)),
  caption: [Auswahlmenü auf der Webseite der HS Reutlingen],
) <fig:menu>

== Tabellen

Tabellen erhalten die Beschriftung ebenfalls unterhalb (@tab:formate).

#figure(
  table(
    columns: 4,
    [Formatbezeichner], [Schrift], [Größe \[pt\]], [kursiv],
    [Überschrift 1], [Franklin Gothic Book], [16], [nein],
    [Eigennamen], [Times New Roman], [12], [ja],
  ),
  caption: [Beispiele für Formatvorlagen],
) <tab:formate>

== Formeln

Jede Formel trägt eine fortlaufende Nummer. Den Titel für das
Formelverzeichnis gibt `formula` an (@eq:pol).

#formula(title: [Polstellenberechnung])[
  $ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a) $ <eq:pol>
]

Der #gls("Textkörper") enthält die eigentliche Ausarbeitung.#footnote[Jede
Fußnote beinhaltet mindestens einen vollständigen Satz.]
