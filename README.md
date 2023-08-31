
# `fastMatMR` <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/HaoZeke/fastMatMR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/HaoZeke/fastMatMR/actions/workflows/R-CMD-check.yaml)
[![pkgcheck](https://github.com/HaoZeke/fastMatMR/workflows/pkgcheck/badge.svg)](https://github.com/HaoZeke/fastMatMR/actions?query=workflow%3Apkgcheck)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![DOI](https://zenodo.org/badge/685246044.svg)](https://zenodo.org/badge/latestdoi/685246044)
<!-- badges: end -->

## About

`fastMatMR` provides R bindings for reading and writing to [Matrix
Market files](https://math.nist.gov/MatrixMarket/formats.html) using the
high-performance [fast_matrix_market C++
library](https://github.com/alugowski/fast_matrix_market) (version
1.7.2).

## Why?

- **Extended Support**: Unlike the `Matrix` package, which only handles
  sparse matrices, `fastMatMR` supports standard R vectors, matrices, as
  well as `Matrix` sparse objects.

- **Performance**: The package is a thin wrapper around one of the
  fastest C++ libraries for reading and writing `.mtx` files.

## Installation

You can install the development version of `fastMatMR` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("HaoZeke/fastMatMR")
```

## Quick Example

``` r
library(fastMatMR)
Matrix::Matrix(c(1, 0, 3, 2), nrow = 2, sparse = TRUE) -> spmat
write_fmm(vec, "vector.mtx")
```

To see what this does, consider reading it back in `python`:

``` bash
pip install fast_matrix_market
python -c 'import fast_matrix_market as fmm; print(fmm.read_array_or_coo("sparse.mtx"))'
((array([1., 3., 2.]), (array([0, 0, 1], dtype=int32), array([0, 1, 1], dtype=int32))), (2, 2))
```

Similarly, we support writing and reading from other `R` objects.

## Development

### Local Development

Often it is useful to have `pixi` handle the dependencies:

``` bash
pixi shell
```

A `pre-commit` job is set up on CI to enforce consistent styles. It is
advisable to set it up locally as well using
[pipx](https://pypa.github.io/pipx/) for isolation:

``` bash
# Run before committing
pipx run pre-commit run --all-files
# Or install the git hook to enforce this
pipx run pre-commit install
```

If you find that `pre-commit` for R is flaky, you can consider the
following commands:

``` bash
find . \( -path "./.pixi" -o -path "./renv" \) -prune -o -type f -name "*.R" -exec Rscript -e 'library(styler); style_file("{}")' \;
Rscript -e 'library(lintr); lintr::lint_package(".")'
```

#### Tests

Tests and checks are run on the CI, however locally one can use:

``` bash
Rscript -e 'devtools::test()'
```

#### Documentation

Ideally each change should be documented. Major changes should be
`vignettes`, and minor ones can be added to `newsfragments`.

Benchmark vignettes are pre-computed via:

``` bash
Rscript rebuild-benchmarks.R
```

Which makes it faster to build the package and run checks.

## License

This project is licensed under the MIT License.

### Logo

The logo was generated via a non-commercial use prompt on hotpot.ai,
both [blue](https://hotpot.ai/s/art-generator/8-TNiwRilbBFnQHwK), and
[green](https://hotpot.ai/s/art-generator/8-E2dBngG5nRiwCeL), as a riff
on the [NIST Matrix Market logo](https://math.nist.gov/MatrixMarket/).
The text was added in a presentation software (WPS Presentation).
Hexagonal cropping was accomplished in a [hexb](http://hexb.in/)
compatible design [using
hexsticker](https://github.com/fridex/hexsticker).
