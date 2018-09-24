# Libraries.
library(tidyverse)

# Settings.
raw_file <- 'infant_hiv/raw/infant_hiv.csv'
tidy_file <- 'infant_hiv/tidy/infant_hiv.csv'
left_padding <- 2
first_year <- 2009
last_year <- 2017
num_years <- 1 + last_year - first_year
header_height <- 2
num_rows <- 192
column_names <- c("estimate", "hi", "lo")
width <- 3

# Get the chunk of the CSV that's of interest.
raw_data <- read_csv(raw_file, skip = header_height, na = c("-"))
of_interest <- slice(raw_data, 1:num_rows)

# Fix and store ISO3 country names.
of_interest$ISO3[of_interest$Countries == "Kosovo"] = "XKX"
countries <- of_interest$ISO3

# Process each three-column chunk (holding values for one year).
chunks <- vector("list", num_years)
for (i in 1:num_years) {

  # Get the three-year chunk.
  start_loc = 1 + left_padding + (width * (i - 1))
  end_loc <- start_loc + width - 1
  chunk <- select(of_interest, start_loc:end_loc)
  
  # Convert textual percentages to fractions.
  # Reports of ">95%" are converted to 95%. This is probably sinful.
  chunk[chunk == ">95%"] <- "95%"
  chunk <- mutate_if(chunk, is_character, str_replace, pattern = "%", replacement = "")
  chunk <- as_tibble(map(map(chunk, as.numeric), function(x) x / 100.0))
  
  # Create and save a tibble with the right names and the years and countries.
  names(chunk) <- column_names
  chunk$year <- rep(first_year + i - 1, num_rows)
  chunk$country <- countries
  chunk <- select(chunk, country, year, everything())
  chunks[[i]] <- chunk
}

# Combine all the tibbles and sort by country and year.
tidy <- bind_rows(chunks)
tidy <- arrange(tidy, country, year)

# Save.
write_csv(tidy, tidy_file)