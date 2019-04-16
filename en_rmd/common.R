knitr::opts_chunk$set(comment = NA)
knitr::opts_knit$set(base.url = "../")
figure_path <- file.path("figures",
  tools::file_path_sans_ext(basename(knitr::current_input())),
  "/") # need trailing slash to keep ggplot2 output happy
knitr::opts_chunk$set(fig.path = figure_path)
knitr::opts_knit$set(width = 69)
