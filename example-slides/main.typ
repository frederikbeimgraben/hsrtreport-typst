// Example presentation with the HSRTSlides template.

#import "@local/hsrtreport:1.0.0": *

#show: hsrtslides.with(
  title: [Template für Präsentationen],
  subtitle: [Folien im Stil von HSRTReport],
  // The short title appears in the head of every slide.
  short-title: [HSRTSlides],
  author: "Hans Maria Muster",
  email: "hans-maria.muster@student.hs-reutlingen.de",
  date: "XX.XX.20XX",
  event: "Mustermodul (METIX.X)",
  // Variant: "inf", "hsrt", "stupa", "asta", "echo" or "makers".
  variant: "inf",
  // Page format: "16-9" or "4-3".
  aspect-ratio: "16-9",
  watermark: none,
)

#outline-slide()

= Einleitung

== Aufbau einer Folie

- Eine Überschrift der Ebene 1 öffnet einen *Abschnitt* mit eigener Folie.
- Eine Überschrift der Ebene 2 öffnet eine *neue Folie* und wird ihr Titel.
- Der Kopf nennt den Kurztitel und den Abschnitt, der Fuß die Vortragenden,
  die Foliennummer und die Logos.

=== Zwischenüberschrift

Fließtext steht in DIN, Überschriften stehen in Blender, wie im Bericht.

== Zwei Spalten

#cols(
  [
    *Links*
    - Punkt eins
    - Punkt zwei
      - Unterpunkt
  ],
  [
    *Rechts*
    + Erster Schritt
    + Zweiter Schritt
    + Dritter Schritt
  ],
)

= Inhalte

== Info-Boxen

#cols(
  [
    #info-box[Ein Hinweis für das Publikum.]
    #warning-box[Eine Warnung.]
  ],
  [
    #success-box[Ein Erfolg.]
    #discussion-box[Eine Frage zur Diskussion.]
  ],
)

== Abstimmungsergebnis

#voting-results(12, 3, 2)[*Antrag:* Anschaffung eines neuen Beamers]

== Code

```python
def fibonacci(n: int) -> int:
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

#slide(title: [Schritt für Schritt], steps: 3)[
  - Die Folie hat drei Schritte.
  #uncover("2-")[- Ab Schritt 2 erscheint dieser Punkt.]
  #uncover(3)[- In Schritt 3 erscheint der letzte Punkt.]

  #only(3)[#success-box[`only` zeigt Inhalt nur auf einem Schritt.]]
]

== Tabelle und Formel

#cols(
  table(
    columns: 3,
    [*Posten*], [*Plan*], [*Ist*],
    [Druck], [500 €], [420 €],
    [Technik], [1200 €], [1310 €],
  ),
  [
    Der Saldo ist
    $ Delta = sum_i ("Plan"_i - "Ist"_i) = -30 "€" $
  ],
)

#focus-slide[Vielen Dank für die Aufmerksamkeit!]
