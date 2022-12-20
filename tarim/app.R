install.packages("shiny")
library(shiny)


shinyUI(fluidPage(
  
  # Radio buttons for selecting the dataset
  radioButtons("dataset", "Select dataset:",
               c("Dataset 1" = 1,
                 "Dataset 2" = 2,
                 "Dataset 3" = 3,
                 "Dataset 4" = 4)),
  
  # Dropdown menus for selecting variables
  selectInput("main_type", "Select main type:", choices = NULL),
  selectInput("product_code", "Select product code:", choices = NULL),
  selectInput("product_name", "Select product name:", choices = NULL),
  selectInput("unit", "Select unit:", choices = NULL),
  selectInput("province", "Select province:", choices = NULL),
  
  # Output element for the line plot and data table
  mainPanel(
    plotOutput("lineplot"),
    DT::dataTableOutput("datatable")
  )
))

shinyServer(function(input, output) {
  
  # Load the datasets
  dataset1 <- read.csv("dataset1.csv")
  dataset2 <- read.csv("dataset2.csv")
  dataset3 <- read.csv("dataset3.csv")
  dataset4 <- read.csv("dataset4.csv")
  
  # Update the choices in the dropdown menus based on the selected dataset
  observeEvent(input$dataset, {
    updateSelectInput(session, "main_type", choices = unique(eval(parse(text = paste0("dataset", input$dataset, "$main_type"))))
                      updateSelectInput(session, "product_code", choices = unique(eval(parse(text = paste0("dataset", input$dataset, "$product_code"))))
                                        updateSelectInput(session, "product_name", choices = unique(eval(parse(text = paste0("dataset", input$dataset, "$product_name"))))
                                                          updateSelectInput(session, "unit", choices = unique(eval(parse(text = paste0("dataset", input$dataset, "$unit"))))
                                                                            updateSelectInput(session, "province", choices = unique(eval(parse(text = paste0("dataset", input$dataset, "$province"))))
  })
                                                                            