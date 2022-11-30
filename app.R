#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load necessary libraries
library(shiny)
library(shinythemes)
library(dplyr)
library(quantmod)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = shinytheme("darkly"),

    # Application title
    titlePanel(
      h1("Stock Market Dashboard", align = "center")
    ),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
            # Ask user to enter stock symbol
            textInput("symbolInput", "Insert the stock symbol*", "MSFT"),
            
            # Ask user to enter desired start date
            textInput("start", "Insert the start date: YYYY-MM-DD",
                      "2020-01-10"),
            
            # Ask user to enter desired end date
            textInput("end", "Insert the end date: YYYY-MM-DD",
                      Sys.Date()),
            
            # Add reactivity button
            actionButton("button", "APPLY", class = "btn-block"),
            
            # Commentary text and formatting
            HTML("<br/> <br/>"),
            
            HTML("<em>*A stock symbol is an arrangement of 
                 characters—usually letters—representing publicly-traded 
                 securities on an exchange. Examples are: AAPL, MSFT, 
                 GOOGL, META, BAC, AMZN, T, MO.</em>"),
            
            HTML("<br/>"),
            
            "You can click on the link below for a list of accepted symbols,
            but please keep in mind that some symbols may still introduce 
            an error if they are not longer covered by Yahoo.",
            HTML("<br/>"),
            
            # Link for list of accepted symbols
            actionLink("SymbolsLink", "List of symbols", 
                       onclick ="window.open('https://docs.google.com/spreadsheets/d/1CnhCH7wH11uqlQTql3ehEXIcxnaUe008/edit?usp=sharing&ouid=116336507958196703721&rtpof=true&sd=true',
                       '_blank')")
    ),

        mainPanel(
          
          # Create two distinct tabs
          tabsetPanel(
            
            type = "tabs",
            
            # First tab displays data table
            tabPanel("Table", 
                     # Commentary text and formatting
                     HTML("<br/>"),
                     "Once your table is generated, you may download it by clicking on the button below.",
                     HTML("<br/>"),
                     
                     # Add data file download button
                     downloadButton("downloadButton", "Download"),
                     tableOutput("data")),
            
            # Second tab displays data chart
            tabPanel("Chart", 
                     plotOutput("chart")),
            
            # Third tab displays table filtered by volume range
            tabPanel("Volume Table",
                     
                     "In trading, volume refers to the number of shares traded in a stock.",
                     HTML("<br/> <br/>"),
                     
                     "The minimum number of traded shares in the selected period is:",
                     textOutput("minVol"),
                     HTML("<br/>"),
                     
                     "The maximum number of traded shares in the selected period is:",
                     textOutput("maxVol"),
                     HTML("<br/>"),
                     
                     HTML("<strong> Select the volume range for which you would like to generate a table:</strong>"),
                     HTML("<br/> <br/>"),
                     
                     # Ask user to enter desired minimum Volume
                     textInput("minVolume", "Minimum Volume"),
                     
                     # Ask user to enter desired maximum Volume
                     textInput("maxVolume", "Maximum Volume"),
                     
                     # Add reactivity button to filter data and generate filtered table
                     actionButton("filter", "FILTER", class = "btn-block"),
                     tableOutput("volumeTable")
                     )
          )
      
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Get the xts object for the desired stock and time period
  symbol <- eventReactive(input$button, {
    getSymbols(input$symbolInput, src = "yahoo", from = input$start, 
               to = as.Date(input$end) + 1, auto.assign = FALSE)
  })
  
  # Convert the xts object into a data frame
  symbol_converted <- eventReactive(input$button, {
    
    # Include xts index as a date column
    df <- data.frame(Date = format(index(symbol()), "%Y-%m-%d"),
                     coredata(symbol()))
    
    # Change column names
    colnames(df) <- c('Date','Open','High', 'Low', 'Close', 'Volume', 'Adjusted')
    
    df
  })
  
  # Render table of desired stock and time period
  output$data <- renderTable({
    symbol_converted()
  })
  
  # Create and name csv file containing data shown in table
  output$downloadButton <- downloadHandler(
    filename = function() { 
      paste(input$symbolInput, ".csv", sep="")
    },
    content = function(file) {
      write.csv(symbol_converted(), file)
    })
  
  # Render standard financial chart of desired stock and time period
  output$chart <- renderPlot({
    chartSeries(symbol())
  })
  
  # Renders minimum volume for the selected period
  output$minVol <- renderText({
    min(symbol_converted()$Volume)
  })
  
  # renders maximum volume for the selected period
  output$maxVol <- renderText({
    max(symbol_converted()$Volume)
  })
  
  # Filters data by desired volume range
  volumeData <- eventReactive(input$filter, {
    table <- symbol_converted() %>% filter(Volume > input$minVolume &
                                             Volume < input$maxVolume)
    
    table
  })
  
  # Renders filtered table
  output$volumeTable <- renderTable({
    volumeData()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
