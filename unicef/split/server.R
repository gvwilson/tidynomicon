server <- function(input, output){

  currentData <- reactive({
    read_csv(input$datafile$datapath)
  })
  
  selectedData <- reactive({
    req(input$years)
    currentData() %>%
      filter(between(year, input$years[1], input$years[2]))
  })
  
  observeEvent(input$datafile, {
    current <- currentData()
    lowYear <- min(current$year)
    highYear <- max(current$year)
    insertUI(
      selector = "#datafileInput",
      where = "afterEnd",
      ui = sliderInput("years", "years", 
                       min = lowYear,
                       max = highYear,
                       value = c(lowYear, highYear),
                       sep = "")
    )
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
