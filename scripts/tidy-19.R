# tidy-19.R
library(tidyverse)

raw <- read_csv("infant_hiv/raw/infant_hiv.csv", skip = 2, na = c("-"))
missing <- raw %>%
  filter(is.na(Countries) | (Countries == "") | is.na(ISO3) | (ISO3 == "")) %>%
  select(Countries, ISO3)
missing
