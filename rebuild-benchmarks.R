## Kanged and updated from https://www.kloppenborg.ca/2021/06/long-running-vignettes/
devtools::clean_dll()
cpp11::cpp_register()
devtools::document()
devtools::load_all()

knitr::knit("vignettes/fmm_write_bench.Rmd.orig", output = "vignettes/fmm_write_bench.Rmd")
knitr::purl("vignettes/fmm_write_bench.Rmd.orig", output = "vignettes/fmm_write_bench.R")
