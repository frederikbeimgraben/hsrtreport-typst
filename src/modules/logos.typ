// Logo placement on the title page and in the page footer.

#let _images = "../assets/images/"

#let variant-logos = (
  meti: (("INF/Kombiniert", 0.9),),
  mki: (("INF/Simple", 0.9),),
  huc: (("HSRT", 0.9),),
)

#let _normalize(entry) = if type(entry) == str {
  (entry, 1.0)
} else if type(entry) == dictionary {
  (entry.name, entry.at("scale", default: 1.0))
} else {
  (entry.at(0), entry.at(1, default: 1.0))
}

#let logo-image(name, height) = image(
  _images + "logos/" + name.replace("/", "-") + ".svg",
  height: height,
)

// Invisible spacer that reserves the same space as the placeholder image of
// the LaTeX class, which is 30 by 205 units.
#let _anchor(height) = box(width: height * 30 / 205, height: height)

#let _row(cells, gutter) = grid(
  columns: cells.len(),
  column-gutter: gutter,
  align: horizon,
  ..cells,
)

#let title-logos(logos, scale: 1.0, main-scale: 1.0) = {
  let entries = logos.map(_normalize)
  _row(
    (
      _anchor(2cm * main-scale * scale),
      ..entries.map(((name, s)) => logo-image(name, 1.5cm * s * scale)),
    ),
    0.5cm,
  )
}

#let footer-logos(logos, scale: 1.0, main-scale: 1.0) = {
  let entries = logos.map(_normalize).rev()
  _row(
    (
      ..entries.map(((name, s)) => logo-image(name, 1.5cm * s * scale * 0.55)),
      _anchor(2cm * main-scale * scale * 0.45),
    ),
    1.5cm,
  )
}

#let skyline(paper-width) = place(
  bottom + left,
  image(_images + "Skyline.svg", width: 1.5 * paper-width),
)
