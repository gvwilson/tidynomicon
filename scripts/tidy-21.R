# tidy-21.R
library(tidyverse)

# Constants.
raw_filename <- "infant_hiv/raw/infant_hiv.csv"
tidy_filename <- "infant_hiv/tidy/infant_hiv.csv"
num_rows <- 192

# Get and clean percentages.
raw <- read_csv(raw_filename, skip = 2, na = c("-"))
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
sliced <- slice(raw, 1:num_rows)
countries <- sliced$ISO3
body <- sliced %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
percents <- map_dfr(trimmed, function(col) as.numeric(col) / 100)

# Separate three-column chunks and add countries and years.
first_year <- 2009
last_year <- 2017
num_years <- (last_year - first_year) + 1
chunks <- vector("list", num_years)
for (year in 1:num_years) {
  end <- year + 2
  temp <- select(percents, year:end)
  names(temp) <- c("estimate", "hi", "lo")
  temp$country <- countries
  temp$year <- rep((first_year + year) - 1, num_rows)
  temp <- select(temp, country, year, everything())
  chunks[[year]] <- temp
}

# Combine chunks and order by country and year.
tidy <- bind_rows(chunks)
tidy <- arrange(tidy, country, year)

# Save.
write_csv(tidy, tidy_filename)
