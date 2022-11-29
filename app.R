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
library(quantmod)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(
      h1("Stock Market Dashboard", align = "center")
    ),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
            # Ask user to inter stock symbol
            textInput("symbolInput", "Insert the stock symbol*"),
            
            # Ask user to inter desired start date
            textInput("start", "Insert the start date: YYYY-MM-DD"),
            
            # Add reactivity button
            actionButton("button", "APPLY", class = "btn-block"),
            
            # Commentary text and formatting
            HTML("<br/>"),
            "Once your table is generated, you may download it 
            by clicking on the button below.",
            HTML("<br/>"),
            
            # Add data file download button
            downloadButton("downloadButton", "Download"),
            
            # Commentary text and formatting
            HTML("<br/>"),
            HTML("<br/>"),
            HTML("<em>*A stock symbol is an arrangement of 
                 characters—usually letters—representing publicly-traded 
                 securities on an exchange. Exemples are: AAPL, MSFT, 
                 GOOGL, META.</em>")
    ),

        mainPanel(
          
          # Create two distinct tabs
          tabsetPanel(
            
            type = "tabs",
            
            # First tab displays data table
            tabPanel("Table", 
                     tableOutput("data")),
            
            # Second tab displays data chart
            tabPanel("Chart", 
                     plotOutput("chart"))
          )
      
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Get the xts object for the desired stock and time period
  symbol <- eventReactive(input$button, {
    getSymbols(input$symbolInput, src = "yahoo", from = input$start, 
               to = Sys.Date() + 1, auto.assign = FALSE)
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
  
  # render standard financial chart of desired stock and time period
  output$chart <- renderPlot({
    chartSeries(symbol())
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
