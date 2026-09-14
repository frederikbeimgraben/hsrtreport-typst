// Font families and the size steps of an 11pt KOMA-Script document.
//
// The bundled TTFs carry patched name tables, so each typeface resolves as one
// family with all its weights. See tools/patch-fonts.py.

#let heading-font = ("Blender", "Libertinus Serif")
#let body-font = ("DIN", "Libertinus Serif")
#let mono-font = ("DejaVu Sans Mono",)

#let blender(..args, body) = text(font: heading-font, ..args, body)
#let din(..args, body) = text(font: body-font, ..args, body)

#let sizes = (
  tiny: 4.98pt,
  script: 5.98pt,
  footnote: 7.97pt,
  small: 9.96pt,
  normal: 10.909pt,
  large: 11.955pt,
  Large: 14.346pt,
  LARGE: 17.215pt,
  huge: 20.66pt,
  Huge: 24.787pt,
)

// LaTeX sets \baselineskip to 1.2467 x font size. The Typst leading is the
// rest of that after the ascender-to-descender span of DIN.
#let line-stretch = 1.0
#let body-span = 1.211
#let baseline-skip(size, stretch: line-stretch) = size * 1.2467 * stretch
#let leading-for(size, stretch: line-stretch) = baseline-skip(size, stretch: stretch) - size * body-span
