find_empty_rows <- function(source) {
  read_csv(source) %>%
    pmap(function(...) {
      args <- list(...)
      all(is.na(args) | (args == ""))
    }) %>%
    as.logical() %>%
    as.tibble() %>%
    rename(empty = value) %>%
    mutate(id = row_number()) %>%
    filter(empty) %>%
    pull(id)
}
