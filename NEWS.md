<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# fastMatMR 1.2.4 (2023-11-02)

- Same as previous version.


# fastMatMR 1.2.3 (2023-11-01)

## Changes

- Reworked getting started vignette to use temporary files

# fastMatMR 1.2.2 (2023-11-01)

## Changes

- Revised the package DESCRIPTION to adhere to CRAN guidelines.
- Updated examples for several functions to be self-contained and CRAN compliant.
- Enabled examples within the documentation
- Added documentation for releases

# fastMatMR 1.2.1 (2023-11-01)

## Changes

- Fixed dead URLs in README
- First CRAN compatible release attempt.

# fastMatMR 1.1.0 (2023-10-24)

## Features

- Handle paths with `~` ([#24](https://github.com/ropensci/fastMatMR/issues/24))
- Integrated support to handle integers in input files. ([#25](https://github.com/ropensci/fastMatMR/issues/25))
- Added support for handling `.mtx.gz` file formats. ([#28](https://github.com/ropensci/fastMatMR/issues/28))
- Updated `fast_matrix_market` to `1.7.4`

## Bug Fixes

- Improved error messages distinguishing between sparse and non-sparse matrices. ([#26](https://github.com/ropensci/fastMatMR/issues/26))
- Enhanced error messages for `sparse_to_fmm` function. ([#27](https://github.com/ropensci/fastMatMR/issues/27))

## Breaking changes

- Streamlined function naming for better clarity. ([#29](https://github.com/ropensci/fastMatMR/issues/29))

User facing functionality is not affected, `write_fmm` still works.

## Improved Documentation

- Streamlined the vignettes and readme.

# fastMatMR 0.0.1.0 (2023-09-02)

## Features

- Support reading `R` numeric vectors (`is.vector()`)
- Support reading of `R` `is.matrix()` numerical matrices
- Support reading sparse matrices from Matrix.


# fastMatMR 0.0.0.9000 (2023-08-31)

## Improved Documentation

- Added a performance benchmark for write and a basic introduction to the package.


## Features

- A full multi-OS set of tests conforming to CRAN submission requirements and ROpenSci is present. (#12)
- Support writing `R` numeric vectors (`is.vector()`)
- Support writing of `R` `is.matrix()` numerical matrices
- Support writing sparse matrices from Matrix.
