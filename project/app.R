library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(DT)


# Load data
tarim <- readRDS("data//tarim.rds")
meyve <- readRDS("data//meyve.rds")
sebze <- readRDS("data//sebze.rds")
tahil <- readRDS("data//tahil.rds")
regions <- readRDS("data//Regions.rds")

sebze <- sebze %>% 
  rename(production = 'decare')

tahil <- tahil %>% 
  rename(production = 'decare')

# Define UI

ui <- fluidPage(

  tags$style(HTML("
    
    body {
      background-color: lightgreen;
      font-family: sans-serif;
    }
    h1, h2 {
      font-family: serif;
      color: black;
    }
  ")),
  
  
  titlePanel("Agricultural Production in Turkey"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("dataset", label = "Choose Data", 
                   choices = c("Meyve"="meyve","Sebze"="sebze","Tahıl"="tahil","Tarım"="tarim"), inline = T),
      

      selectInput("province", "Select Province:", choices = NULL),
      selectInput("main_type", "Select Main Type:", choices = NULL),
      selectInput("product_name", "Select Product Name:", choices = NULL),
      selectInput("unit", "Select Unit:", choices = NULL),
    ),
    mainPanel(
      plotOutput("lineplot"),
      DT::dataTableOutput("datatable")

  )))

server <- function(input, output,session) {
  # Update choices in dropdown box based on selected dataset
  

  
  observeEvent(input$dataset, {
    updateSelectInput(session, "province", choices = unique(eval(parse(text = paste0(input$dataset, "$province")))))
    updateSelectInput(session, "main_type", choices = unique(eval(parse(text = paste0(input$dataset, "$main_type")))))
    updateSelectInput(session, "product_name", choices = unique(eval(parse(text = paste0(input$dataset, "$product_name")))))
    updateSelectInput(session, "unit", choices = unique(eval(parse(text = paste0(input$dataset, "$unit")))))

  })
  
  observeEvent(input$dataset, {
    if (input$dataset %in% c("tarim")) {
      updateSelectInput(session, "main_type", choices=character(0))
      updateSelectInput(session, "product_name", choices=character(0))
      updateSelectInput(session, "unit", choices=character(0))
    } 
  }) 
  

  
  output$lineplot <- renderPlot({
    
    if (input$dataset %in% c("meyve","sebze","tahil")) {
    # Subset the data based on the selected variables
    plot_data <- subset(eval(parse(text = paste0(input$dataset))),
                        main_type == input$main_type &
                          product_name == input$product_name &
                          unit == input$unit &
                          province == input$province)
    
    # Create the line plot
    ggplot(plot_data, aes(x = year, y = production)) +
      geom_line() +
      xlab("Year")+
      ylab("Production")+
      ggtitle(paste(input$province ,"-", input$product_name, "(",input$unit,")" ))
    }
    else{
      # Subset the data based on the selected variables
      plot_data <- subset(eval(parse(text = paste0(input$dataset))),
                          
                            province == input$province)
      
      # Create the line plot
      ggplot(plot_data, aes(x = year, y = decare)) +
        geom_line() +
        xlab("Year")+
        ylab("Decare")+
        ggtitle(paste("Agricultural Areas (Decare) of ", input$province))
    }
  })
  
  output$datatable <- DT::renderDataTable({
    if (input$dataset %in% c("meyve","sebze","tahil")) {
    # Subset the data based on the selected variables
    table_data <- subset(eval(parse(text = paste0(input$dataset))),
                         main_type == input$main_type &
                           product_name == input$product_name &
                           unit == input$unit &
                           province == input$province)
    }
    else {
      table_data <- subset(eval(parse(text = paste0(input$dataset))),
                             province == input$province)
    }
    
    # Return the data table
    table_data
  })
  
}
# Run the app
shinyApp(ui = ui, server = server)