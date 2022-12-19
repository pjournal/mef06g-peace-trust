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
      
      selectInput("region", "Region:", sort(unique(meyve$province))),
      selectInput("province", "Province:", sort(unique(meyve$province))),
      selectInput("main_type", "Main Type:", sort(unique(meyve$main_type))),
      selectInput("product_name", "Product Name:", sort(unique(meyve$product_name))),
      selectInput("Year", "Year:", c(2010:2021)),
  
    dataTableOutput("table")
  )

# Define server logic
server <- function(input, output) {
  
  # Filter data based on user input
  filtered_data <- reactive({
    meyve %>% 
      filter(province == input$province, year == input$year,main_type == input$main_type,product_name == input$product_name)
  })
  
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
           