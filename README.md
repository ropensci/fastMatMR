
# `fastMatMR` <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/HaoZeke/fastMatMR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/HaoZeke/fastMatMR/actions/workflows/R-CMD-check.yaml)
[![pkgcheck](https://github.com/HaoZeke/fastMatMR/workflows/pkgcheck/badge.svg)](https://github.com/HaoZeke/fastMatMR/actions?query=workflow%3Apkgcheck)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![DOI](https://zenodo.org/badge/685246044.svg)](https://zenodo.org/badge/latestdoi/685246044)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/606_status.svg)](https://github.com/ropensci/software-review/issues/606)
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

- **Correctness**: Unlike `Matrix`, roundtripping with `NA` and `NaN`
  values works by coercing to `NaN` instead of to arbitrarily high
  numbers.

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
spmat <- Matrix::Matrix(c(1, 0, 3, 2), nrow = 2, sparse = TRUE)
write_fmm(spmat, "sparse.mtx")
```

To see what this does, consider reading it back in `python`:

``` bash
pip install fast_matrix_market
python -c 'import fast_matrix_market as fmm; print(fmm.read_array_or_coo("sparse.mtx"))'
((array([1., 3., 2.]), (array([0, 0, 1], dtype=int32), array([0, 1, 1], dtype=int32))), (2, 2))
python -c 'import fast_matrix_market as fmm; print(fmm.read_array("sparse.mtx"))'
array([[1., 3.],
       [0., 2.]])
```

Similarly, we support writing and reading from other `R` objects
(e.g. standard R vectors and matrices), as seen in the [basic use
vignette](https://haozeke.github.io/fastMatMR/articles/basic_usage.html).

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
