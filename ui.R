library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)

# Load the data
bird_data = read.csv("./data/derived_data/selected_bird.csv")

# Define the sidebar content with filters
sidebar <- dashboardSidebar(
  width = 300, 
  sidebarMenu(
    menuItem("Instructions", tabName = "instructions", icon = icon("info-circle")),
    menuItem("Filters", tabName = "filters", icon = icon("filter"),
             selectInput(
               inputId = "year_select",
               label = "Select Year:",
               choices = unique(bird_data$year),
               selected = unique(bird_data$year)[1]
             ),
             checkboxGroupInput(
               inputId = "taxon_select",
               label = "Select Taxon ID:",
               choices = unique(bird_data$taxon_name),
               selected = unique(bird_data$taxon_name)[1]
             ),
             sliderInput(
               inputId = "elevation_range",
               label = "Select Elevation Range:",
               min = min(bird_data$elevation, na.rm = TRUE),
               max = max(bird_data$elevation, na.rm = TRUE),
               value = c(min(bird_data$elevation, na.rm = TRUE), max(bird_data$elevation, na.rm = TRUE))
             ),
             plotOutput("taxon_plot")
    )
    
  )
)
# Create the body of the dashboard
body <- dashboardBody(
  
  tabItem(tabName = "instructions",
          fluidRow(
            box(
              title = "Instructions",
              status = "info",
              solidHeader = TRUE,
              collapsible = TRUE,
              collapsed = FALSE, # Starts uncollapsed since the user has clicked 'Instructions'
              p("Use the controls to filter the bird observation data based on year, taxon ID, and elevation range. The map will update automatically to reflect the filters applied."),
              p("Hover over points on the map to see more details about each observation."),
              width = 12 # Full width
            )
          )
  ),
            fluidRow(
              box(width = 12, leafletOutput("map", height = "500px"))
          
  )
)

# Compile the dashboard elements
ui <- dashboardPage(
  skin = "blue",
  header = dashboardHeader(title = "Bird Observations Dashboard"),
  sidebar = sidebar,
  body = body
)

