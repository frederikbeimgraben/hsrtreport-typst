// Color palette of the HSRTReport class.

#let link-color = rgb(16.1%, 31.0%, 42.7%)
#let cite-color = rgb(28.6%, 42.7%, 53.7%)
#let url-color = rgb(7.1%, 21.2%, 32.2%)

#let head-foot-color = luma(50%)
#let rule-color = luma(0%)

#let british-racing-green = rgb(0%, 26%, 15%)
#let eggplant = rgb(38%, 25%, 32%)
#let han-blue = rgb(27%, 42%, 81%)
#let navy-blue = rgb(0%, 0%, 50%)
#let pansy-purple = rgb(47%, 9%, 29%)
#let shocking-pink = rgb(99%, 6%, 75%)
#let light-gray = luma(80%)

#let hsrt-yellow = rgb("#ffed00")

// Fill of the focus slide per variant. A variant that is absent here takes
// the yellow of the logos.
#let stupa-gray = luma(35%)
#let asta-pink = shocking-pink
#let variant-accents = (
  stupa: stupa-gray,
  asta: asta-pink,
)
#let variant-accent(variant) = variant-accents.at(variant, default: hsrt-yellow)
