
# `fastMatMR` <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/fastMatMR)](https://cran.r-project.org/package=fastMatMR)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/606_status.svg)](https://github.com/ropensci/software-review/issues/606)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
![runiverse-name](https://ropensci.r-universe.dev/badges/:name)
![runiverse-package](https://ropensci.r-universe.dev/badges/fastMatMR)
[![DOI](https://zenodo.org/badge/685246044.svg)](https://zenodo.org/badge/latestdoi/685246044)
[![R-CMD-check](https://github.com/ropensci/fastMatMR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/fastMatMR/actions/workflows/R-CMD-check.yaml)
[![pkgcheck](https://github.com/ropensci/fastMatMR/workflows/pkgcheck/badge.svg)](https://github.com/ropensci/fastMatMR/actions?query=workflow%3Apkgcheck)
<!-- badges: end -->

## About

`fastMatMR` provides R bindings for reading and writing to [Matrix
Market files](https://math.nist.gov/MatrixMarket/formats.html) using the
high-performance [fast_matrix_market C++
library](https://github.com/alugowski/fast_matrix_market) (version
1.7.4).

## Why?

[Matrix Market files](https://math.nist.gov/MatrixMarket/formats.html)
are crucial to much of the data-science ecosystem. The `fastMatMR`
package focuses on high-performance read and write operations for Matrix
Market files, serving as a key tool for data extraction in computational
and data science pipelines.

The target audience and scientific applications primarily include data
scientists or researchers developing numerical methods who may wish to
either test standard NIST (National Institute of Standards and
Technology) which include:

> comparative studies of algorithms for numerical linear algebra,
> featuring nearly 500 sparse matrices from a variety of applications,
> as well as matrix generation tools and services.

Additionally, being able to use the matrix market file format, means it
is easier to interface `R` analysis with those in `Python` (e.g. `SciPy`
uses the same underlying `C++` library). These files can also be used
with the [Tensor Algebra
Compiler](http://tensor-compiler.org/docs/tensors.html) (TACO).

### Features

- **Extended Support**: `fastMatMR` supports standard R vectors,
  matrices, as well as `Matrix` sparse objects.

- **Performance**: The package is a thin wrapper around one of the
  fastest C++ libraries for reading and writing `.mtx` files.

- **Correctness**: Unlike `Matrix`, roundtripping with `NA` and `NaN`
  values works by coercing to `NaN` instead of to arbitrarily high
  numbers.

We have vignettes for both
[read](https://docs.ropensci.org/fastMatMR/articles/fmm_read_bench.html)
and
[write](https://docs.ropensci.org/fastMatMR/articles/fmm_write_bench.html)
operations to demonstrate the performance claims.

#### Alternatives and statement of need

- The `Matrix` package allows reading and writing sparse matrices in the
  `.mtx` (matrix market) format.
  - However, for `.mtx` files, it can only handles sparse matrices for
    writing and reading.
  - Round-tripping (writing and subsequently reading) data with `NA` and
    `NaN` values produces arbitrarily high numbers instead of preserving
    `NaN` / handling `NA`

## Installation

### CRAN

For the latest `CRAN` version:

``` r
install.packages("fastMatMR")
```

### R-Universe

For the latest development version of `fastMatMR`:

``` r
install.packages("fastMatMR",
                 repos = "https://ropensci.r-universe.dev")
```

### Development Git

For the latest commit, one can use:

``` r
# install.packages("devtools")
devtools::install_github("ropensci/fastMatMR")
```

## Quick Example

``` r
library(fastMatMR)
spmat <- Matrix::Matrix(c(1, 0, 3, 2), nrow = 2, sparse = TRUE)
write_fmm(spmat, "sparse.mtx")
fmm_to_sparse_Matrix("sparse.mtx")
```

The resulting `.mtx` file is language agnostic, and can even be read
back in `python` as an example:

``` bash
pip install fast_matrix_market
python -c 'import fast_matrix_market as fmm; print(fmm.read_array_or_coo("sparse.mtx"))'
((array([1., 3., 2.]), (array([0, 0, 1], dtype=int32), array([0, 1, 1], dtype=int32))), (2, 2))
python -c 'import fast_matrix_market as fmm; print(fmm.read_array("sparse.mtx"))'
array([[1., 3.],
       [0., 2.]])
```

Similarly, `fastMatMR` supports writing and reading from other `R`
objects (e.g. standard R vectors and matrices), as seen in the [getting
started
vignette](https://docs.ropensci.org/fastMatMR/articles/fastMatMR.html).

## Contributing

Contributions are very welcome. Please see the [Contribution
Guide](https://docs.ropensci.org/fastMatMR/CONTRIBUTING.html) and our
[Code of Conduct](https://ropensci.org/code-of-conduct/).

## License

This project is licensed under the [MIT
License](https://docs.ropensci.org/fastMatMR/LICENSE.html).

### Logo

The logo was generated via a non-commercial use prompt on hotpot.ai,
both [blue](https://hotpot.ai/s/art-generator/8-TNiwRilbBFnQHwK), and
[green](https://hotpot.ai/s/art-generator/8-E2dBngG5nRiwCeL), as a riff
on the [NIST Matrix Market logo](https://math.nist.gov/MatrixMarket/).
The text was added in a presentation software (WPS Presentation).
Hexagonal cropping was accomplished in a [hexb](http://hexb.in/)
compatible design [using
hexsticker](https://github.com/fridex/hexsticker).
