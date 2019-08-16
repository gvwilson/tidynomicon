library(tidyverse)
library(shiny)

ui <- fluidPage(
  titlePanel("UNICEF Data"),
  sidebarLayout(
    position = "right",
    sidebarPanel(
      img(src = "logo.png", width = 200),
      fileInput("datafile", p("data file")),
      dateRangeInput("years", p("years"), format = "yyyy")
    ),
    mainPanel(
      textOutput("filename")
    )
  )
)

server <- function(input, output){
  output$filename <- renderText({
    paste("input file:", input$datafile$datapath)
  })
}

shinyApp(ui = ui, server = server)