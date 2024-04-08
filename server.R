#------------------------------------------------------------------------
#                       ---- Server Script ----
#  this script runs all internal operations to make your shiny app work
#------------------------------------------------------------------------


# Load packages
library(dplyr)
library(stringr)
library(countrycode)
library(here)
library(shiny)

# Define server logic required to calculate the square of a number
server <- function(input, output) {
  
  output$square <- renderText({
    # Calculate the square of the input value
    as.numeric(input$num)^2
    
  })
  output$squareNumber <- renderText({
    as.numeric(input$number)^2
  })
}
