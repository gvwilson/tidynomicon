# tidy-05.R
library(tidyverse)

raw <- read_csv("infant_hiv/raw/infant_hiv.csv", skip = 2, na = c("-"))
countries <- raw$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
head(body)
