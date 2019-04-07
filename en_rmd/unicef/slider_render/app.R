library(tidyverse)
library(shiny)

ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      img(src = "logo.png", width = 200),
      fileInput("datafile", p("data file")),
      uiOutput("slider")
    ),
    mainPanel(
      p(textOutput("filename")),
      plotOutput("chart")
    )
  )
)

server <- function(input, output){

  currentData <- reactive({
    req(input$datafile)
    read_csv(input$datafile$datapath)
  })

  output$slider <- renderUI({
    current <- currentData()
    lowYear <- min(current$year)
    highYear <- max(current$year)

    sliderInput("years", "years",
                     min = lowYear,
                     max = highYear,
                     value = c(lowYear, highYear),
                     sep = "")
  })

  selectedData <- reactive({
    req(input$years)

    currentData() %>%
      filter(between(year, input$years[1], input$years[2]))
  })

  output$chart <- renderPlot({
    selectedData() %>%
      group_by(year) %>%
      summarize(average = mean(estimate, na.rm = TRUE)) %>%
        ggplot() +
        geom_line(mapping = aes(x = year, y = average)) +
        labs(title = paste("Years", input$years[1], "to", input$years[2]))
  })

  output$filename <- renderText({
    currentName <- input$datafile$name
    ifelse(is.null(currentName), "no filename set", paste("showing", currentName))
  })
}

shinyApp(ui = ui, server = server)
