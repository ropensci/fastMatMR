# To add extra release questions that devtools::release asks
# Ref. https://devtools.r-lib.org/reference/release.html
release_questions <- function() {
  c(
    "Did you re-build the benchmark vignettes using `rebuild-benchmarks.R`?"
  )
}
