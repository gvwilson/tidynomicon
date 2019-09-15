library(tidyverse)
library(reticulate)
library(rlang)
library(knitr)
library(glue)
library(here)
library(kableExtra)
library(gt)

knitr::opts_chunk$set(comment = NA)
knitr::opts_knit$set(width = 69)

# From https://community.rstudio.com/t/showing-only-the-first-few-lines-of-the-results-of-a-code-chunk/6963/2
TIDYNOMICON_OUTPUT_LENGTH <- 20
TIDYNOMICON_CONTINUATION <- "..."
hook_output <- knit_hooks$get("output")
knit_hooks$set(output = function(x, options) {
  desired <- options$output.lines

  # `output.lines` not set, so use default hook.
  if (is.null(desired)) {
    return(hook_output(x, options))
  }

  # `output.lines` is NA so replace with preferred output length
  if (is.na(desired)) {
    desired <- TIDYNOMICON_OUTPUT_LENGTH
  }

  # Process output.
  x <- unlist(strsplit(x, "\n"))
  if (length(desired)==1) {          # scalar => first N lines
    if (length(x) > desired) {
      # truncate the output, but add ....
      x <- c(head(x, desired), TIDYNOMICON_CONTINUATION)
    }
  } else {                           # vector => select only those lines
    x <- c(TIDYNOMICON_CONTINUATION, x[desired], TIDYNOMICON_CONTINUATION)
  }

  # Paste the selected lines together and pass to default hook.
  x <- paste(c(x, ""), collapse = "\n")
  hook_output(x, options)
})
