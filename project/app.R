library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)

# Load data
tarim <- readRDS("data//tarim.rds")
meyve <- readRDS("data//meyve.rds")
sebze <- readRDS("data//sebze.rds")
tahil <- readRDS("data//tahil.rds")
regions <- readRDS("data//Regions.rds")


# Define UI
ui <- fluidPage(
  titlePanel("Agricultural Production in Turkey"),
  
      radioButtons("dataset", label = "Choose Data", 
                   choices = c("Tarım"=1,"Meyve"=2,"Sebze"=3,"Tahıl"=4), inline = T),
      

      selectInput("province", "Province:", sort(unique(meyve$province))),
      selectInput("main_type", "Main Type:", sort(unique(meyve$main_type))),
      selectInput("product_name", "Product Name:", sort(unique(meyve$product_name))),

      plotOutput("plot"),
      # Add data table
      dataTableOutput("table")

  )

server <- function(input, output) {
  # Update choices in dropdown box based on selected dataset
  observe({
    if (input$dataset == 1) {
      updateSelectInput(session, "province", choices = names(tarim))
    } else if (input$dataset == 2) {
      updateSelectInput(session, "province", choices = names(meyve))
    } else if (input$dataset == 3) {
      updateSelectInput(session, "province", choices = names(sebze))
    } else if (input$dataset == 4) {
      updateSelectInput(session, "province", choices = names(tahil))
    } 
  })
  
  # Render plot
  output$plot <- renderPlot({
    # Use input$dataset to determine which dataset to use
    if (input$dataset == 1) {
      data <- tarım
    } else if (input$dataset == 2) {
      data <- meyve
    } else if (input$dataset == 3) {
      data <- sebze
    } else if (input$dataset == 4) {
      data <- tahıl
    } 
    
    # Use input$x to determine which variable to plot on the x-axis
    plot(data[, input$year], main = input$year)
  })
  
  # Render data table
  output$table <- renderDataTable({
    # Use input$dataset to determine which dataset to display
    if (input$dataset == 1) {
      data <- tarim
    } else if (input$dataset == 2) {
      data <- meyve
    } else if (input$dataset == 3) {
      data <- sebze
    } else if (input$dataset == 4) {
      data <- tahil
    }
    
    # Return the selected dataset
    return(data)
  })
}
# Run the app
shinyApp(ui = ui, server = server)
           