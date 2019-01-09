library(tidyverse)
library(shiny)

ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      img(src = "logo.png", width = 200),
      fileInput("datafile", p("data file")),
      sliderInput("years", "years",
                  min = 0,
                  max = 0,
                  value = c(0, 0),
                  sep = "")
    ),
    mainPanel(
      p(textOutput("filename")),
      plotOutput("chart")
    )
  )
)

server <- function(input, output, session){

  currentData <- reactive({
    req(input$datafile)
    read_csv(input$datafile$datapath)
  })

  minYear <- reactive({
    min(currentData()$year, na.rm = TRUE)
  })

  maxYear <- reactive({
    max(currentData()$year, na.rm = TRUE)
  })

  selectedData <- reactive({
    req(input$years)
    currentData() %>%
      filter(between(year, input$years[1], input$years[2]))
  })

  yearRange <- reactive({
    req(minYear(), maxYear())
    c(minYear(), maxYear())
  })

  observe({
    req(yearRange())
    freezeReactiveValue(input, "years")
    updateSliderInput(session, "years", min = yearRange()[1], max = yearRange()[2], value = yearRange())
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
