# tidy-11.R
library(tidyverse)

raw <- read_csv("infant_hiv/raw/infant_hiv.csv", skip = 2, na = c("-"))
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = "%", replacement = "")
head(trimmed)
