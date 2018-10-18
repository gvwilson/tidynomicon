#!/usr/bin/env Rscript

library(stringr)
library(purrr)
library(knitr)

USAGE = "Knit one or more RMarkdown files to create Markdown files.

Usage: build.R [optional list of .Rmd files]

If no filenames are given, all .Rmd files in the current directory are
processed.  Markdown files are placed in './_en'."

filenames <- function(args) {
  if (length(args) > 0) {
    return(args)
  }
  dir(".", "*.Rmd$")
}

process <- function(sources, out_dir) {
  map(sources, function(src) {
    out_file <- paste(out_dir, str_replace(src, "Rmd$", "md"), sep = "/")
    knit(src, output = out_file)
  })
}

main <- function(out_dir) {
  args <- commandArgs(trailingOnly = TRUE)
  if ((length(args) == 1) && (args[1] %in% c("-h", "--help"))) {
    message(USAGE)
    quit(status = 0)
  }
  process(filenames(args), out_dir)
}

main("_en")
