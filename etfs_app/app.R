#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(reticulate)

source_python("../get_data.py")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("ETF Price History"),

    # Sidebar
    sidebarLayout(
        sidebarPanel(
            selectInput("stock",
                      "ETFs:",
                      choices = c("AGG", "EEM", "EFA", "IJS", "SPY"),
                      multiple = TRUE),
            
            dateRangeInput("date",
                           "Date Range",
                           start = "2013-01-01",
                           end = "2017-12-31")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("pricePlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$pricePlot <- renderPlot({
        py$stocks %>% 
            mutate(date = as.Date(date)) %>%
            pivot_longer(-date, "stock") %>%
            filter(stock %in% input$stock,
                   date >= input$date[1],
                   date <= input$date[2]) %>% 
            ggplot(aes(x = date, y = value, group = stock, color = stock)) +
            geom_line() +
            scale_x_date(date_breaks = "years")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
