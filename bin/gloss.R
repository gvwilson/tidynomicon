#!/usr/bin/env Rscript

library(readr)
library(stringr)

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  stopifnot(length(args) >= 1)
  glossary <- args[1]
  if (length(args) == 1) {
    sources <- dir(".", "*.md$")
  } else {
    sources <- args[2:length(args)]
  }
  defined <- get_defined(glossary)
  required <-get_required(sources)
  show("required but not defined", required, defined)
  show("defined but not required", defined, required)
}

get_defined <- function(filename) {
  extract(filename, "\\{:#([^}]+)\\}")
}

get_required <- function(filenames) {
  unlist(lapply(filenames, extract, "/glossary/#([^)]+)"))
}

show <- function(title, have, need) {
  words <- have[! (have %in% need)]
  if (length(words) > 0) {
    cat(title, "\n")
    for (w in words) {
      cat("  ", w, "\n")
    }
  }
}

extract <- function(filename, pattern) {
  str_match_all(read_file(filename), pattern)[[1]][,2]
}

main()
