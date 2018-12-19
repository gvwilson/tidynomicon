---
title: "Web Applications with Shiny"
output: md_document
permalink: /shiny/
questions:
  - "FIXME"
objectives:
  - "FIXME"
keypoints:
  - "FIXME"
---



- FIXME: following <https://shiny.rstudio.com/tutorial/>
- Make sure Shiny is installed
- Make sure the built-in examples run
  - FIXME <https://github.com/rstudio/shiny/issues/2287>


```r
library(shiny)
runExample("01_hello")
```

- Every Shiny app has:
  - a user interface object (shows things to user)
  - a server function (the back end that provides data)
  - a call to `shinyApp` that binds the two together
  - can all live in the same file, though some people prefer to put the UI and server in separate files
- Let's reproduce that first example

## Setup

-   Create a directory called `faithful_app`.
    -   Every application needs to be in its own directory.)
-   Create a file in that directory called `app.R`.
    -   `runApp(directory_name)` automatically looks for `app.R`.)
-   Create the skeleton of the application


```r
library(shiny)

ui <- ...

server <- ...

shinyApp(ui = ui, server = server)
```

## The User Interface

-   The interface is a fluid page (resizes as needed)
-   Contains a single sidebar layout with two elements, `sidebarPanel` and `mainPanel`
-   The sidebar contains a `sliderInput` object that (as you'd expect from the name) creates a slider
    -   `label`, `min`, `max`, and `value` set it up
    -   `inputId` gives it a name that's used to refer to it in the server
-   There's also a `mainPanel` object that contains a single `plotOutput`
    -   Its `outputId` is used to refer to it in other code


```r
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)),
    mainPanel(plotOutput(outputId = "distPlot"))
  )
)
```

## The Server

-   Something has to react to changes in controls and update displays
-   Shiny watches for the former and takes care of the latter automatically...
    -   ...but we have to tell it what to watch, what to update, and how to make those updates
-   We create a function that Shiny calls when it needs to


```r
server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    })
}
```

-   When there is a change, Shiny notices and calls our function, giving it inputs (controls) and outputs (displays)
-   `input$bins` matches the `bins` ID for the slider, so the value of `input$bins` will be the value of the slider
-   `output$distPlot` matches the `distPlot` ID of the plot, so we can use Shiny's `renderPlot` function to tell it what to plot
    -   Can't use ggplot2 calls directly, but terminology is very similar
-   In this case:
    -   `x` axis is waiting times from the `faithful` data
    -   `bins` is the bin labels (look at `input$bins` to get value)
    -   `hist` is the histogram we want plotted

## Execution

-   Run `app.R` from the command line or use:


```r
runApp("faithful_app")
```

-   Once it's running, narrow the window to see the "fluid" part (resizing)

## The User Interface

-   Let's build a tool for exploring the UNICEF data
-   `mkdir unicef_app` and create `app.R`

<!-- app-ui-skeleton.R -->

```r
library(shiny)

ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      img(src = "logo.png", width = 200),
      h2("Controls")
    ),
    mainPanel(h1("Display"))
  )
)

server <- function(input, output){
  # Empty for now.
}

shinyApp(ui = ui, server = server)
```



```r
knitr::include_graphics("../files/app-ui-skeleton.png")
```

![plot of chunk unnamed-chunk-8](../../files/app-ui-skeleton.png)

-   Position the controls on the right
-   Use `h1`, `h2`, and similarly-named functions to create HTML elements
-   Use `img` to display a logo
-   Empty server
-   Run it: everything looks good except the image
    -   Turns out images have to be in the `unicef_app/www` folder

-   Now time to add widgets (interactive control elements)
    -   Buttons
    -   Checkboxes
    -   Radio buttons
    -   Pulldown selectors (for cases when checkboxes or radio buttons would take up too much space)
    -   Date inputs and date ranges
    -   Filenames
    -   Sliders (like the one seen before)
    -   Free-form text input
-   So we need to decide what we're going to visualize
-   Choose a date range
-   See line plot of average estimate by year
-   Also need to choose a file
-   Come back later and figure out how to constrain year input to match years in file

<!-- app-ui-prototype.R -->

```r
ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      img(src = "logo.png", width = 200),
      fileInput("datafile", p("data file")),
      dateRangeInput("years", p("years"), format = "yyyy")
    ),
    mainPanel(h1("Display"))
  )
)
```


```r
knitr::include_graphics("../files/app-ui-prototype.png")
```

![plot of chunk unnamed-chunk-10](../../files/app-ui-prototype.png)

-   Let's show the chosen filename in the output display

<!-- app-show-filename-wrong.R -->

```r
ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    # ...as before...
    mainPanel(
      textOutput("filename")
    )
  )
)

server <- function(input, output){
  output$filename <- renderText({
    paste("input file:", input$datafile)
  })
}
```

-   Initial display looks good:


```r
knitr::include_graphics("../files/app-show-filename-wrong-before.png")
```

![plot of chunk unnamed-chunk-12](../../files/app-show-filename-wrong-before.png)

-   Fill in filename: oops


```r
knitr::include_graphics("../files/app-show-filename-wrong-after.png")
```

![plot of chunk unnamed-chunk-13](../../files/app-show-filename-wrong-after.png)

-   Read the docs
    -   `input` is a named list-like object of everything set up in the interface
    -   `input$datafile` picks out one element, but it turns out that's a data frame
    -   `input$datafile$datapath` ought to get us what we want

<!-- app-show-filename-right.R -->

```r
server <- function(input, output){
  output$filename <- renderText({
    paste("input file:", input$datafile$datapath)
  })
}
```

-   Ah: we should show `name`, but use `datapath` when reading data
-   Let's fill in the server a bit

<!-- app-show-filename-correct.R -->

```r
server <- function(input, output){
  currentData <- NULL
  output$filename <- renderText({
    currentName <- input$datafile$name
    currentPath <- input$datafile$datapath
    if (is.null(currentName)) {
      currentData <- NULL
      text <- "no filename set"
    } else {
      currentData <- read_csv(currentPath)
      text <- paste("showing", currentName)
    }
    text
  })
}
```

-   Three places to put variables:
    1.  At the top of the script outside functions, they are run once when the app launches
    2.  Inside `server`, they are run once for each user
    3.  Inside a handler like `renderText`, they are run once on each change


```r
knitr::include_graphics("../files/app-show-filename-correct.png")
```

![plot of chunk unnamed-chunk-16](../../files/app-show-filename-correct.png)

## Reflecting Data in the File

-   Now comes the hard part: updating the chart when the file changes
-   Trick is to use a **reactive variable**
    -   A function that changes value whenever one of the inputs it depends on changes
-   `currentData` is created by calling `reactive` with a block of code that produces the variable's value
    -   It uses `input$datafile`, so it will automatically be triggered whenever `input$datafile` changes
    -   *And* other things can depend on it in the same way
    -   Which allows us to get rid of `currentData`
-   `output$filename` uses `currentData()`, so it is automatically called when the reactive variable's value changes

<!-- app-reactive-update.R -->

```r
server <- function(input, output){
  currentData <- reactive({
    currentPath <- input$datafile$datapath
    if (is.null(currentPath)) {
      result <- NULL
    } else {
      result <- read_csv(currentPath)
    }
    result
  })

  output$filename <- renderText({
    currentName <- input$datafile$name
    if (is.null(currentName)) {
      text <- "no filename set"
    } else {
      text <- paste("showing", currentName)
    }
    text
  })

  output$chart <- renderPlot({
    data <- currentData()
    if (is.null(data)) {
      message("no data")
      chart <- NULL
    } else {
      message("we have data, creating chart")
      chart <- data %>%
        group_by(year) %>%
        summarize(average = mean(estimate, na.rm = TRUE)) %>%
        ggplot() +
        geom_line(mapping = aes(x = year, y = average))
    }
    chart
  })
}
```


```r
knitr::include_graphics("../files/app-reactive-update.gif")
```

![plot of chunk unnamed-chunk-18](../../files/app-reactive-update.gif)
