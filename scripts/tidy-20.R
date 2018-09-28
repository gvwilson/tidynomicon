# tidy-20.R
library(tidyverse)

raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
missing <- raw %>%
  filter(is.na(Countries) | (Countries == "") | is.na(ISO3) | (ISO3 == "")) %>%
  select(Countries, ISO3)
missing
