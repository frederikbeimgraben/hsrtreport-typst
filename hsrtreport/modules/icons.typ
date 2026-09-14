// Vector icons for the info boxes.
//
// The LaTeX class draws FontAwesome glyphs. Typst ships no icon font, so the
// icons are drawn here. Each icon fills a square box of the given size with a
// solid shape in `fill` and cuts the symbol out in `knockout`.

#import "../config/fonts.typ": heading-font

#let _glyph-icon(size, fill, knockout, glyph, shape) = box(width: size, height: size, {
  place(center + horizon, shape)
  place(
    center + horizon,
    dy: -size * 0.02,
    text(font: heading-font, size: size * 0.6, weight: "bold", fill: knockout, glyph),
  )
})

#let _disc(size, fill) = circle(radius: size / 2, fill: fill)

#let _triangle(size, fill) = polygon(
  fill: fill,
  (size * 0.5, 0pt),
  (size, size * 0.88),
  (0pt, size * 0.88),
)

#let info-circle(size, fill, knockout) = _glyph-icon(size, fill, knockout, "i", _disc(size, fill))

#let exclamation-circle(size, fill, knockout) = _glyph-icon(size, fill, knockout, "!", _disc(size, fill))

#let question-circle(size, fill, knockout) = _glyph-icon(size, fill, knockout, "?", _disc(size, fill))

#let exclamation-triangle(size, fill, knockout) = box(width: size, height: size, {
  place(center + horizon, _triangle(size, fill))
  place(
    center + horizon,
    dy: size * 0.11,
    text(font: heading-font, size: size * 0.5, weight: "bold", fill: knockout, "!"),
  )
})

#let _check(size, stroke-color) = curve(
  stroke: (paint: stroke-color, thickness: size * 0.13, cap: "round", join: "round"),
  curve.move((0pt, size * 0.30)),
  curve.line((size * 0.18, size * 0.48)),
  curve.line((size * 0.48, size * 0.06)),
)

#let _cross(size, stroke-color) = {
  let s = (paint: stroke-color, thickness: size * 0.13, cap: "round")
  box(width: size * 0.46, height: size * 0.46, {
    place(curve(stroke: s, curve.move((0pt, 0pt)), curve.line((size * 0.46, size * 0.46))))
    place(curve(stroke: s, curve.move((0pt, size * 0.46)), curve.line((size * 0.46, 0pt))))
  })
}

#let check-circle(size, fill, knockout) = box(width: size, height: size, {
  place(center + horizon, _disc(size, fill))
  place(center + horizon, _check(size, knockout))
})

#let times-circle(size, fill, knockout) = box(width: size, height: size, {
  place(center + horizon, _disc(size, fill))
  place(center + horizon, _cross(size, knockout))
})

#let comments(size, fill, knockout) = box(width: size, height: size, {
  place(
    top + left,
    dx: size * 0.06,
    dy: size * 0.10,
    rect(width: size * 0.66, height: size * 0.50, radius: size * 0.12, fill: fill),
  )
  place(
    top + left,
    dx: size * 0.12,
    dy: size * 0.56,
    polygon(fill: fill, (0pt, 0pt), (size * 0.20, 0pt), (0pt, size * 0.18)),
  )
  place(
    top + left,
    dx: size * 0.30,
    dy: size * 0.38,
    rect(
      width: size * 0.64,
      height: size * 0.48,
      radius: size * 0.12,
      fill: fill,
      stroke: size * 0.07 + knockout,
    ),
  )
})

#let vote(size, fill, knockout) = box(width: size, height: size, {
  place(
    center + horizon,
    rect(width: size * 0.92, height: size * 0.76, radius: size * 0.10, fill: fill),
  )
  place(center + horizon, dy: -size * 0.02, _check(size * 0.92, knockout))
})
