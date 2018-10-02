data <- read_csv("raw/at_health_facilities.csv", skip = 7)
firstlast <- data %>%
  mutate(rownum = row_number()) %>%
  filter(iso3 %in% c("AFG", "ZWE")) %>%
  filter(row_number() %in% c(1, n())) %>%
  select(rownum)
tidy <- data %>%
  slice(1:firstlast[[2, 1]]) %>%
  select(-`Country/areas`, -starts_with("X")) %>%
  map_dfr(function(x) ifelse(str_detect(x, "-"), NA, x)) %>%
  mutate_at(vars(-c(iso3, Source)), as.numeric) %>%
  mutate_at(vars(-c(iso3, year, Source, `Source year`)), function(x) x / 100)