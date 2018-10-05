#!/usr/bin/env Rscript

library(stringr)
library(purrr)
library(knitr)

filenames <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) > 0) {
    return(args)
  }
  dir(".", "*.Rmd")
}

process <- function(sources, out_dir) {
  map(sources, function(src) {
    out_file <- paste(out_dir, str_replace(src, "Rmd$", "md"), sep = "/")
    knit(src, output = out_file)
  })
}

main <- function(out_dir) {
  process(filenames(), out_dir)
}

main("_en")
