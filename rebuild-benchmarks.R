## Kanged and updated from https://www.kloppenborg.ca/2021/06/long-running-vignettes/

devtools::clean_dll()
cpp11::cpp_register()
devtools::document()
devtools::load_all()


old_wd <- getwd()

setwd("vignettes/")

knitr::knit("fmm_write_bench.Rmd.orig", output = "fmm_write_bench.Rmd")
knitr::purl("fmm_write_bench.Rmd.orig", output = "fmm_write_bench.R")

setwd(old_wd)
