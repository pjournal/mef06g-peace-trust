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

df <- data.frame(Province = c("Istanbul", "Ankara", "Izmir", "Bursa", "Eskisehir"),
                 Year = c(2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020),
                 Decare = c(1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000),
                 Production = c(50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000, 90000, 95000, 100000),
                 Unit = c("Ton", "Ton", "Ton", "Ton", "Ton", "Ton", "Ton", "Ton", "Ton", "Ton", "Ton"))

# Define UI
ui <- fluidPage(
  titlePanel("Agricultural Production in Turkey"),
  sidebarLayout(
    sidebarPanel(
      selectInput("province", "Province:", sort(unique(meyve$province))),
      selectInput("province", "Province:", sort(unique(meyve$province))),
      selectInput("year", "Year:", c(2010:2021))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Filter data based on user input
  filtered_data <- reactive({
    df %>% 
      filter(Province == input$province, Year == input$year)
  })
  
  # Plot data
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Decare, y = Production)) +
      geom_point() +
      labs(x = "Decare", y = "Production")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
           