// Vector icons for the info boxes.
//
// The LaTeX class draws FontAwesome glyphs. Typst ships no icon font, so the
// icons are drawn here. Each icon fills a square box of the given size with a
// solid shape in `fill` and cuts the symbol out in `knockout`.

#import "../config/fonts.typ": heading-font

#let _glyph-icon(size, fill, knockout, glyph, shape) = box(width: size, height: size, {
  place(center + horizon, shape)
  // Cap height to baseline, so the glyph sits in the optical center.
  place(center + horizon, text(
    font: heading-font,
    size: size * 0.72,
    weight: "bold",
    fill: knockout,
    top-edge: "cap-height",
    bottom-edge: "baseline",
    glyph,
  ))
})

#let _disc(size, fill) = circle(radius: size / 2, fill: fill)

#let _triangle(size, fill) = polygon(
  fill: fill,
  (size * 0.5, 0pt),
  (size, size * 0.88),
  (0pt, size * 0.88),
)

// A rounded bar and a dot on the vertical center line, for "i" and "!".
#let _bar(size, fill, from, to, width: 0.14) = place(
  top + left,
  dx: size * (0.5 - width / 2),
  dy: size * from,
  rect(
    width: size * width,
    height: size * (to - from),
    radius: size * width / 2,
    fill: fill,
  ),
)

#let _dot(size, fill, y, radius: 0.085) = place(
  top + left,
  dx: size * (0.5 - radius),
  dy: size * (y - radius),
  circle(radius: size * radius, fill: fill),
)

#let info-circle(size, fill, knockout) = box(width: size, height: size, {
  place(center + horizon, _disc(size, fill))
  _dot(size, knockout, 0.28)
  _bar(size, knockout, 0.43, 0.76)
})

#let exclamation-circle(size, fill, knockout) = box(width: size, height: size, {
  place(center + horizon, _disc(size, fill))
  _bar(size, knockout, 0.22, 0.56)
  _dot(size, knockout, 0.72)
})

#let question-circle(size, fill, knockout) = _glyph-icon(size, fill, knockout, "?", _disc(size, fill))

#let exclamation-triangle(size, fill, knockout) = box(width: size, height: size, {
  place(top + left, dy: size * 0.06, _triangle(size, fill))
  _bar(size, knockout, 0.36, 0.66, width: 0.12)
  _dot(size, knockout, 0.80, radius: 0.07)
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
