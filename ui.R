library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)
# Load the data
bird_data = read.csv("./data/derived_data/selected_bird.csv")

# Define the sidebar content with filters
sidebar = dashboardSidebar(
  width = 300,
  sidebarMenu(
    id = "sidebar",
    menuItem("Instructions", tabName = "instructions", icon = icon("info-circle")),
    menuItem("Overall Taxon Distribution", tabName = "show_plots", icon = icon("globe")),
    menuItem("Filters", tabName = "filters", icon = icon("filter")),
    menuItem("Elevation_selection", tabName = "ele", icon = icon("filter"))
  ),
  conditionalPanel(
    condition = "input.sidebar === 'filters'",
    div(style = "padding: 20px;",
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
        )
    ),
    plotOutput("taxon_plot")
  )
)
# Create the body of the dashboard
body = dashboardBody(
    tabItem(tabName = "instructions",
            # Display this panel if either the instructions or filters tab is active
            conditionalPanel(
              condition = "input.sidebar == 'instructions' || input.sidebar == 'filters'",
              fluidRow(
                box(
                  title = "Instructions",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  p("This is a dashboard for bird observation in specific areas from 2009 to present. 
                    Users could use it to discover birds' locations (including latitude, altitude and elevation)over years."),
                  p("Use the controls to filter the bird observation data based on year, taxon ID, and elevation range. 
                    The map will update automatically to reflect the filters applied."),
                  p("Hover over points on the map to see more details about each observation."),
                  width = 12
                )
              )
            )
    ),
    tabItem(tabName = "show_plots",
            conditionalPanel(
              condition = "input.sidebar == 'show_plots'",
              box(
                title = "Taxon ID Frequency",
                width = 12,
                plotOutput("taxon_id_frequency_plot", height = "300px")
              )
            )
    ),
    tabItem(tabName = "ele",
            conditionalPanel(
              condition = "input.sidebar == 'ele'",
              fluidRow(selectInput(
                inputId = "select_year",
                label = "Select Year:",
                choices = unique(bird_data$year),
                selected = unique(bird_data$year)[1]
              )),
              box(
                title = "Taxon ID Frequency",
                width = 12,
                plotOutput("elevationPlot", height = "300px")
              )
            )
    ),
    tabItem(tabName = "maping",
            conditionalPanel(
              condition = "input.sidebar == 'filters'",
              box(width = 12, leafletOutput("map", height = "500px"))
            )
    )
  )

# Compile the dashboard elements
ui = dashboardPage(
  skin = "blue",
  header = dashboardHeader(title = "Bird Observations Dashboard"),
  sidebar = sidebar,
  body = body
)