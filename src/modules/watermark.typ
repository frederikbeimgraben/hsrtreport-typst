// Diagonal background watermark.
//
// The watermark text repeats in a diagonal grid of tiles. The tiles are large
// enough to read the word. A tiling fill keeps the cost low.

#import "../config/fonts.typ": heading-font

#let watermark-layer(
  body,
  fill: luma(90%),
  size: 24pt,
  font: heading-font,
  angle: 45deg,
  extent: 60cm,
) = {
  if body == none { return }

  let cell = box(
    inset: (x: size, y: size * 0.6),
    text(font: font, size: size, fill: fill, body),
  )

  place(
    center + horizon,
    rotate(angle, rect(
      width: extent,
      height: extent,
      stroke: none,
      fill: tiling(cell),
    )),
  )
}
