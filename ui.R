#------------------------------------------------------------------------

#                   UI, or "User Interface" Script

# this script designs the layout of everything the user will see in this Shiny App
#------------------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)

# testing
# Define UI for application that calculates the square of a number
ui <- fluidPage(
  
  # Application title is for calculation
  titlePanel("Square Calculator"),
  
  # Sidebar with a numeric input for the number to be squared
  sidebarLayout(
    sidebarPanel(
      numericInput("num", "Enter a number:", 1),
      numericInput("number", "Enter a number:", 1)
    ),
    
    # Show the calculated square of the input number
    mainPanel(
      textOutput("square"),
      textOutput("squareNumber")
    )
  )
)
