// The vendored logos, the variants that select them, and their placement.

#let _images = "../assets/images/"

// A logo reference is one of:
//   "INF"                     a vendored name
//   ("INF", 0.9)              a vendored name with a scale
//   (name: "INF", scale: 0.9) the same, written out
//   (data: read("x.svg", encoding: none), scale: 0.9)   your own file
#let known-logos = (
  "HSRT": "HSRT.svg",
  "INF": "INF.svg",
  "INF-Simple": "INF-Simple.svg",
  "STUPA": "STUPA.svg",
  "ASTA": "ASTA.svg",
  "ECHO": "ECHO.svg",
  "MAKERS": "MAKERS.svg",
  "MAKERS-RAlign": "MAKERS-RAlign.svg",
  "MAKERS-Icon": "MAKERS-Icon.svg",
)

// The title page logos of a variant.
#let variant-logos = (
  inf: ("INF",),
  hsrt: ("HSRT",),
  stupa: ("STUPA",),
  asta: ("ASTA",),
  echo: ("ECHO",),
  makers: ("MAKERS",),
)

// The footer logos of a variant. A variant that is absent here repeats its
// title page logos. MAKERS puts the icon into the page corner, so the footer
// takes the right-aligned logo.
#let variant-footer-logos = (
  makers: ("MAKERS-RAlign",),
)

#let title-logo-names(variant) = variant-logos.at(variant, default: ())

#let footer-logo-names(variant) = variant-footer-logos.at(
  variant,
  default: title-logo-names(variant),
)

#let _entry(logo) = {
  if type(logo) == str {
    (name: logo, scale: 1.0)
  } else if type(logo) == bytes {
    (data: logo, scale: 1.0)
  } else if type(logo) == dictionary {
    (scale: 1.0) + logo
  } else if type(logo) == array {
    (name: logo.at(0), scale: logo.at(1, default: 1.0))
  } else {
    panic("a logo is a name, a (name, scale) pair, a dictionary or image bytes")
  }
}

#let logo-image(logo, height) = {
  let entry = _entry(logo)
  if "data" in entry {
    return image(entry.data, height: height * entry.scale)
  }
  let name = entry.name
  if name not in known-logos {
    panic(
      "unknown logo "
        + name
        + ": use one of "
        + known-logos.keys().join(", ")
        + ", or pass image bytes",
    )
  }
  image(_images + "logos/" + known-logos.at(name), height: height * entry.scale)
}

#let _row(cells, gutter) = grid(
  columns: cells.len(),
  column-gutter: gutter,
  align: horizon,
  ..cells,
)

// Logos at the top left of the title page: 1.4cm high, 0.5cm apart, the row
// starting 2cm from the left edge of the page.
#let title-logos(logos, scale: 1.0, height: 1.4cm, gutter: 0.5cm) = _row(
  logos.map(logo => logo-image(logo, height * scale)),
  gutter,
)

// Logos at the bottom right of every page after the title page: 0.8cm high,
// 0.3cm apart, the row ending 2.3cm from the right edge of the page.
#let footer-logos(logos, scale: 1.0, height: 0.8cm, gutter: 0.3cm) = _row(
  logos.map(logo => logo-image(logo, height * scale)),
  gutter,
)

#let skyline(paper-width) = place(
  bottom + left,
  image(_images + "Skyline.svg", width: 1.5 * paper-width),
)
