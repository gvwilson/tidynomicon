library(stringr)
library(purrr)
library(knitr)
map(dir(".", "*.Rmd"), function(f) {
  out_dir <- ifelse(f == "index.Rmd", ".", "_en")
  out_file <- paste(out_dir, str_replace(f, "Rmd$", "md"), sep = "/")
  knit(f, output = out_file)
})
