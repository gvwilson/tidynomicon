# tidy-02.R
library(tidyverse)

raw <- read_csv("raw/infant_hiv.csv", skip = 2)
head(raw)
