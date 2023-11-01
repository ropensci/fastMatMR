## Resubmission
This is a resubmission. In this version I have:

* Removed the package name from the title and removed quotes from the title and description.
* Used single quotes for software and package names in the description.
* Fixed the invalid URIs found in the documentation.
* Adjusted the usage of `\dontrun{}` in the package documentation.
* Added the [ROpensci review](https://github.com/ropensci/software-review/issues/606) to the DESCRIPTION
* Reworked the vignettes to prevent writing to disk

### Note

The "error" on Debian is a false positive, as noted on the [r-hub
tracker](https://github.com/r-hub/rhub/issues/448#issuecomment-793776145). The
build completes successfully in [55 minutes, 55.8
seconds](https://builder.r-hub.io/status/fastMatMR_1.2.3.tar.gz-58c06d43521e4c1f82cf96a35dd68a18)
on `r-hub`.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
