# tidy-04.R
library(tidyverse)

raw <- read_csv("infant_hiv/raw/infant_hiv.csv", skip = 2, na = c("-"))
countries <- raw$ISO3
body <- raw %>%
  filter(-ISO3, -Countries)
