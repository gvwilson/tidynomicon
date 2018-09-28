# tidy-03.R
library(tidyverse)

raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
head(raw)
