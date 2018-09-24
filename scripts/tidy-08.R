# tidy-08.R
library(tidyverse)

fixture <- c(NA, "1%", "10%", "100%")
result <- as.numeric(str_replace(fixture, "%", "")) / 100
result
is.numeric(result)
