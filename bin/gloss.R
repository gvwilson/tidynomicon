#!/usr/bin/env Rscript

library(readr)
library(stringr)

USAGE = "Find missing and redundant entries in glossary.

Usage: gloss.R /path/to/glossary.md [optional list of .Rmd and .md files]

If no filenames are given after the first (which must be the path to the
glossary), this script processes all files matching './*md' that start with
the three dashes of a YAML header."

main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  stopifnot(length(args) >= 1)
  if (args[1] %in% c("-h", "--help")) {
    message(USAGE)
    quit(status = 0)
  }
  glossary <- args[1]
  if (length(args) == 1) {
    sources <- dir(".", "*md$")
  } else {
    sources <- args[2:length(args)]
  }
  defined <- get_defined(glossary)
  required <- get_required(sources)
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
  text <- read_file(filename)
  if (! startsWith(text, "---")) {
    return(NULL)
  }
  str_match_all(text, pattern)[[1]][,2]
}

main()
