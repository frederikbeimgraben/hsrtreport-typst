// Demonstration of the template features.

#import "../../hsrtreport/lib.typ": *

= Template-Features Demonstration <chap:template_demo>

Dieses Kapitel demonstriert die verschiedenen Funktionen und Möglichkeiten des
HSRTReport-Templates für wissenschaftliche Arbeiten.

== Textformatierung <sec:textformatierung_demo>

#unnumbered(level: 3)[Grundlegende Textauszeichnungen]

Das Template unterstützt verschiedene Textauszeichnungen:

- *Fetter Text* für wichtige Begriffe
- _Kursiver Text_ für Betonungen und Eigennamen
- `Maschinenschrift` für Code und Befehle
- #blender[Serifenlose Schrift] für spezielle Hervorhebungen
- #smallcaps[Kapitälchen] für besondere Formatierungen

#unnumbered(level: 3)[Spezielle Zeichen und Symbole]

Das Template unterstützt übliche Typografie:

- Gedankenstriche -- so wie hier -- für Einschübe
- Anführungszeichen: "deutsche Anführungszeichen" und #text(lang: "en")["englische Quotes"]
- Auslassungspunkte ... mit korrektem Spacing
- Mathematische Symbole: $alpha$, $beta$, $gamma$, $sum$, $integral$

#pagebreak()

== Listen und Aufzählungen <sec:listen_demo>

#unnumbered(level: 3)[Verschiedene Listentypen]

Standard-Aufzählung:

- Erster Punkt
- Zweiter Punkt
- Dritter Punkt mit Unterpunkten:
  - Unterpunkt A
  - Unterpunkt B

Nummerierte Liste:

+ Erster Schritt
+ Zweiter Schritt
+ Dritter Schritt

Kompakte Liste ohne Abstände:

#compact-list[
  - Element ohne Abstand darüber
  - Element ohne Abstand dazwischen
  - Element ohne Abstand darunter
]

Beschreibungsliste:

/ Begriff 1: Erklärung des ersten Begriffs
/ Begriff 2: Erklärung des zweiten Begriffs
/ Begriff 3: Erklärung des dritten Begriffs

== Mathematische Formeln <sec:formeln_demo>

#unnumbered(level: 3)[Inline-Formeln]

Formeln können direkt im Text verwendet werden, wie z.#sym.space.thin B.
$E = m c^2$ oder $a^2 + b^2 = c^2$. Auch komplexere Ausdrücke wie
$integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2$ sind möglich.

#unnumbered(level: 3)[Abgesetzte Formeln]

Einfache nummerierte Gleichung:

$ nabla times arrow(E) = -(partial arrow(B)) / (partial t) $ <eq:maxwell1>

Matrix-Darstellung:

$ bold(A) = mat(
  a_11, a_12, a_13;
  a_21, a_22, a_23;
  a_31, a_32, a_33;
) $ <eq:matrix>

== Abbildungen und Grafiken <sec:abbildungen_demo>

#unnumbered(level: 3)[Einfache Abbildung]

#figure(
  rect(width: 70%, height: 9cm, inset: 1em, stroke: 0.4pt)[
    #align(center + horizon)[
      #text(size: sizes.Large)[Platzhalter für Abbildung] \
      (Hier könnte eine Grafik, ein Diagramm oder ein Foto stehen)
    ]
  ],
  caption: [Demonstrationsabbildung mit Platzhalter],
) <fig:demo_abbildung>

Die @fig:demo_abbildung zeigt einen Platzhalter für eine echte Grafik.
Abbildungen werden automatisch nummeriert und im Abbildungsverzeichnis
aufgeführt.

#unnumbered(level: 3)[Teilabbildungen]

Mehrere Abbildungen lassen sich nebeneinander platzieren:

#figure(
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    subfigure(
      rect(width: 90%, height: 4cm, stroke: 0.4pt)[#align(center + horizon)[Bild A]],
      caption: [Erste Teilabbildung],
    ),
    subfigure(
      rect(width: 90%, height: 4cm, stroke: 0.4pt)[#align(center + horizon)[Bild B]],
      caption: [Zweite Teilabbildung],
    ),
  ),
  caption: [Zwei Abbildungen nebeneinander],
) <fig:subfigures_demo>

== Tabellen <sec:tabellen_demo>

#unnumbered(level: 3)[Einfache Tabelle]

#figure(
  table(
    columns: 5,
    align: (left, center, center, center, center),
    table.header(
      [*Messung*], [*Zeit [s]*], [*Spannung [V]*], [*Strom [A]*], [*Leistung [W]*],
    ),
    [1], [0], [12.0], [0.5], [6.0],
    [2], [10], [11.8], [0.6], [7.1],
    [3], [20], [11.5], [0.7], [8.1],
    [4], [30], [11.2], [0.8], [9.0],
  ),
  caption: [Messwerte-Demonstration],
) <tab:messwerte>

#unnumbered(level: 3)[Komplexe Tabelle mit verbundenen Zellen]

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    table.header(
      table.cell(rowspan: 2)[*Kategorie*],
      table.cell(colspan: 3)[*Messwerte*],
      [*Min*], [*Max*], [*Mittel*],
    ),
    [Temperatur [°C]], [18.5], [24.3], [21.2],
    [Luftfeuchtigkeit [%]], [45], [62], [53],
    [Druck [hPa]], [1013], [1021], [1017],
  ),
  caption: [Komplexe Tabellenstruktur],
) <tab:komplex>

== Code-Listings <sec:code_listings>

#unnumbered(level: 3)[Python-Code]

#listing(caption: [Python-Beispiel: Fakultätsfunktion])[
```python
def factorial(n):
    """Berechnet die Fakultät einer Zahl rekursiv."""
    if n <= 1:
        return 1
    else:
        return n * factorial(n - 1)

# Verwendungsbeispiel
for i in range(10):
    print(f"{i}! = {factorial(i)}")
```
] <lst:python>

#unnumbered(level: 3)[Typst-Code]

#listing(caption: [Typst-Beispiel: Dokumentstruktur])[
```typst
#import "../hsrtreport/lib.typ": *

#show: hsrtreport.with(
  title: [Überschrift],
  author: "Hans Maria Muster",
)

= Überschrift
Dies ist ein Beispieltext mit einer Formel: $x^2 + y^2 = r^2$

$ integral_(-infinity)^infinity e^(-x^2) dif x = sqrt(pi) $
```
] <lst:typst>

== Querverweise und Zitationen <sec:querverweise>

#unnumbered(level: 3)[Interne Querverweise]

Das Template unterstützt Querverweise mit sprechenden Namen:

- Verweis auf Kapitel: siehe @chap:template_demo
- Verweis auf Abschnitt: siehe @sec:formeln_demo
- Verweis auf Gleichung: siehe @eq:maxwell1
- Verweis auf Abbildung: siehe @fig:demo_abbildung
- Verweis auf Tabelle: siehe @tab:messwerte
- Verweis auf Listing: siehe @lst:python
- Zitierung: @ahrens2014

#unnumbered(level: 3)[Fußnoten]

Fußnoten#footnote[Dies ist eine Beispiel-Fußnote mit zusätzlichen
Informationen.] können für ergänzende Informationen verwendet werden. Sie
sollten jedoch sparsam eingesetzt werden#footnote[Eine zweite Fußnote zur
Demonstration der automatischen Nummerierung.] und nicht länger als vier Zeilen
sein.

== Glossar und Abkürzungen <sec:glossar_demo>

#unnumbered(level: 3)[Verwendung von Glossareinträgen]

Das Template verwaltet Fachbegriffe und Abkürzungen in eigenen Verzeichnissen:

- Erster Aufruf eines Glossarbegriffs: #gls("Textkörper")
- Zweiter Aufruf desselben Begriffs: #gls("Textkörper")
- Verwendung einer Abkürzung: #gls("MPG")
- Nochmalige Verwendung: #gls("MPG")

Die Begriffe werden automatisch in das entsprechende Verzeichnis aufgenommen.

== Spezielle Umgebungen <sec:spezielle_umgebungen>

#unnumbered(level: 3)[Infoboxen und Warnungen]

#info-box[
  Das ist der Inhalt der Info-Box.

  Boxen können auch geschachtelt werden:

  #info-box[
    Das ist der Inhalt der geschachtelten Info-Box.
  ]
]

#warning-box[
  Das ist der Inhalt der Warn-Box.
]

#success-box[
  Das ist der Inhalt der Erfolgs-Box.
]

#important-box[
  Das ist der Inhalt der Hinweis-Box.
]

#discussion-box[
  Das ist der Inhalt der Diskussions-Box.
]

#voting-results(12, 3, 2)[
  Antrag auf Anschaffung eines Templates.
]

#pagebreak()

== Erweiterte Features <sec:erweiterte_features>

#unnumbered(level: 3)[Grafiken im Dokument]

Typst zeichnet Diagramme ohne weitere Pakete. Rechtecke, Linien, Kurven und
Polygone stehen direkt zur Verfügung.

#unnumbered(level: 3)[Hyperlinks]

- Automatische Verlinkung von Querverweisen
- Klickbare URLs: #link("https://www.example.com")
- E-Mail-Links: #link("mailto:example@domain.com")[example\@domain.com]
- Verlinktes Inhaltsverzeichnis im PDF
