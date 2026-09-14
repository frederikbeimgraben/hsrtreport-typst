// Code listings: a framed block with the line numbers in the left margin.

#import "../config/fonts.typ": *

#let _frame-inset = (x: 6pt, y: 6pt)

#let listings(number-lines: true, leading: 0.55em, body) = {
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Listing])

  show raw.where(block: true): set text(size: sizes.footnote)
  show raw.where(block: true): set par(leading: leading, justify: false)
  show raw.where(block: true): it => {
    let code = block(
      width: 100%,
      stroke: 0.4pt + black,
      inset: _frame-inset,
      breakable: false,
      it,
    )
    if not number-lines { return code }

    let numbers = block(
      inset: (y: _frame-inset.y),
      stack(
        dir: ttb,
        spacing: leading,
        ..it.lines.map(line => text(fill: luma(30%), str(line.number))),
      ),
    )
    grid(
      columns: (auto, 1fr),
      column-gutter: 5pt,
      align: (right + top, left + top),
      numbers,
      code,
    )
  }

  body
}

#let listing(code, caption: none) = figure(
  code,
  kind: raw,
  supplement: [Listing],
  caption: caption,
)
