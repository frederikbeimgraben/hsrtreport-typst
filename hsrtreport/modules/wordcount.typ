// Word count over a content tree.
//
// Replaces the texcount shell-out of the LaTeX class. Code blocks and glossary
// markers do not count.

#let _skipped = (raw, metadata, bibliography)

#let count-words(value) = {
  if type(value) == str {
    return value.split(regex("\\s+")).filter(word => word.trim() != "").len()
  }
  if type(value) == array {
    return value.map(count-words).sum(default: 0)
  }
  if type(value) != content {
    return 0
  }
  if value.func() in _skipped {
    return 0
  }
  if value.func() == text {
    return count-words(value.text)
  }
  value
    .fields()
    .values()
    .map(field => if type(field) in (content, array) { count-words(field) } else { 0 })
    .sum(default: 0)
}

#let words-state = state("hsrt-word-count", 0)

// Number of words in the body. Use it on the title page, for example
// data-line("Wortanzahl", word-count()).
#let word-count() = context words-state.get()
