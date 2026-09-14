// Diagonal background watermark.
//
// The LaTeX class tiles the watermark text at 8% scale, which reads as a fine
// gray texture rather than as words. A tiling fill keeps that look at a
// fraction of the cost.

#import "../config/fonts.typ": heading-font

#let watermark-layer(
  body,
  fill: luma(88%),
  size: 1pt,
  angle: 45deg,
  extent: 60cm,
) = {
  if body == none { return }

  let cell = box(
    inset: (x: size, y: size * 0.3),
    text(font: heading-font, size: size, fill: fill, body),
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
