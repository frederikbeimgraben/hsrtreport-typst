// Info boxes.
//
// A box tints its background with the box color. Nested boxes get a stronger
// tint, so the nesting stays visible. The icon uses the same color at a
// stronger tint and hangs over the left edge of the frame.

#import "icons.typ"
#import "../config/colors.typ": *

#let _level = counter("hsrt-colored-box-level")

#let _tint(color, percent) = color.lighten(100% - percent)

// Frame padding and where the icon sits relative to the left frame edge.
#let _inset-left = 10pt + 0.25cm
#let _icon-center = (x: 6pt, y: 12pt)

#let colored-box(
  icon: icons.info-circle,
  color: blue,
  icon-size: 18pt,
  icon-offset: (0pt, 0pt),
  body,
) = {
  _level.step()
  context {
    let level = _level.get().first()
    let background = calc.min(5% + 7.5% * level, 100%)
    let foreground = calc.min(background + 20%, 100%)
    let fill = _tint(color, background)

    block(
      width: 100%,
      breakable: true,
      above: 2.24em,
      below: 1.31em,
      fill: fill,
      radius: 5pt,
      inset: (left: _inset-left, right: 10pt, y: 10pt),
      {
        place(
          top + left,
          dx: icon-offset.at(0) - _inset-left + _icon-center.x - icon-size / 2,
          dy: icon-offset.at(1) + _icon-center.y - icon-size / 2,
          icon(icon-size, _tint(color, foreground), white),
        )
        body
      },
    )
  }
  _level.update(l => l - 1)
}

#let info-box(color: blue, body) = colored-box(
  icon: icons.info-circle,
  color: color,
  body,
)

#let warning-box(color: red, body) = colored-box(
  icon: icons.exclamation-triangle,
  color: color,
  body,
)

#let success-box(color: green, body) = colored-box(
  icon: icons.check-circle,
  color: color,
  icon-offset: (0pt, 2pt),
  body,
)

#let important-box(color: orange, body) = colored-box(
  icon: icons.exclamation-circle,
  color: color,
  body,
)

#let custom-box(icon, color, body) = colored-box(icon: icon, color: color, body)

#let discussion-box(color: han-blue, body) = colored-box(
  icon: icons.comments,
  color: color,
  body,
)

#let voting-results-box(color, body) = colored-box(
  icon: icons.vote,
  color: color,
  icon-offset: (-0.2cm, 0pt),
  body,
)

#let voting-results(yes, no, abstained, body) = {
  let color = if yes > no {
    british-racing-green
  } else if yes < no {
    red
  } else {
    eggplant
  }

  voting-results-box(color, {
    body
    grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1.5em,
      custom-box(icons.check-circle, british-racing-green)[*Ja:* #yes],
      custom-box(icons.times-circle, red)[*Nein:* #no],
      custom-box(icons.question-circle, eggplant)[*Enthaltung:* #abstained],
    )
  })
}
