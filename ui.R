library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)
library(emojifont)
# Load the data
bird_data = read.csv("./data/derived_data/selected_bird.csv")
obs_data <- read.csv("./data/derived_data/observe_update.csv")
# Load font with emoji
load.emojifont('OpenSansEmoji.ttf')

header <- dashboardHeader(
  title = paste0(emojifont::emoji('bird'), " Forest Bird Observations ", emojifont::emoji('bird')),
  titleWidth = 300 # Adjust this based on your dashboard's layout
)
# Define the sidebar content with filters
sidebar = dashboardSidebar(
  width = 300,
  sidebarMenu(
    id = "sidebar",
    menuItem("Instructions", tabName = "instructions", icon = icon("info-circle")),
    menuItem("Overall Taxon Distribution", tabName = "show_plots", icon = icon("globe")),
    menuItem("Filters", tabName = "maping", icon = icon("map")),
    menuItem("Elevation_selection", tabName = "ele", icon = icon("filter")),
    menuItem("Analyzing", tabName = "analysis", icon = icon("chart-line"))
  ),
  conditionalPanel(
    condition = "input.sidebar === 'maping'",
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
  tags$head(
    tags$link(rel = "stylesheet", 
              href = "https://fonts.googleapis.com/css2?family=Arvo:wght@400;700&display=swap"),
    tags$style(HTML("
    /* Include Google Font link for Roboto in the <head> section of your HTML if not already included */
    
    /* Specific selectors for the main header with Roboto font */
    body .main-header .logo, body .main-header .navbar {
      background-color: #5f6b40 !important; /* Blue background */
      color: #FFFFFF !important; /* White text color */
      font-family: 'Arvo', sans-serif !important; /* Applying Arvo font */
      font-size: 18px; /* Adjust font size as needed */
    }

    /* Remaining styles */
    body .main-sidebar, body .left-side {
      background-color: #353a26 !important;
    }
    body .sidebar a {
      color: #FFFFFF !important;
    }
    body .box.box-primary > .box-header {
      background-color: #96a782 !important;
      color: #353a26 !important;
      font-family: 'Roboto', sans-serif !important;
    }
     /* Styling for the box content background color */
    body .box.box-primary {
    background-color: #dfe6d3 !important; /* Light green background for the box content */
    }
    body, body h1, body h2, body h3, body h4, body h5, body h6 {
      font-family: 'Roboto', sans-serif !important;
    }
    body .title, body h1, body h2, body h3, body h4, body h5, body h6 {
      font-weight: bold !important;
    }
  "))
  ),
  
  
    tabItem(tabName = "instructions",
            # Display this panel if either the instructions or filters tab is active
            conditionalPanel(
              condition = "input.sidebar == 'instructions' || input.sidebar == 'maping'",
              fluidRow(
                box(
                  width = 12,
                  title = "Instructions",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  status = "primary", 
                  p("This is a dashboard for bird observation in specific areas from 2009 to present. 
                    Users could use it to discover birds' locations (including latitude, altitude and elevation)over years."),
                  p("Use the controls to filter the bird observation data based on year, taxon ID, and elevation range. 
                    The map will update automatically to reflect the filters applied."),
                  p("Hover over points on the map to see more details about each observation."),
                  
                )
              )
            )
    ),
    tabItem(tabName = "show_plots",
            conditionalPanel(
              condition = "input.sidebar == 'show_plots'",
              # Using divs with consistent style for alignment
              
              fluidRow(
                box(width = 12,
                  title = "Interactive Guide for the Taxon ID Frequency Plot",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    collapsed = FALSE,
                  status = "primary",
                    p("Explore the Taxon ID Frequency plot by adjusting the range slider below to filter the data according to Taxon ID. 
                    Simply drag the handles of the slider to set the minimum and maximum IDs you are interested in, 
                    and watch the plot dynamically update to show the frequency of observations within your selected range. 
                    This interactive feature allows you to focus on specific segments of the data, helping you identify 
                    trends and outliers in Taxon ID distribution effectively.
                      Use the insights gained here to deepen your understanding of the dataset and enhance your ecological analyses."),

                )),

              
              fluidRow(
                column(12, sliderInput("taxon_range_slider", "Select Taxon ID Range:",
                                       min = min(obs_data$taxon_id), 
                                       max = max(obs_data$taxon_id), 
                                       value = c(min(obs_data$taxon_id), max(obs_data$taxon_id)),
                                       step = 1)
                )
              ),
              fluidRow(
                box(
                  title = "Taxon ID Frequency",
                  width = 12,
                  plotOutput("taxon_id_frequency_plot", height = "300px")
                )
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
              condition = "input.sidebar == 'maping'",
              box(width = 12, leafletOutput("map", height = "500px"))
            )
    ),
  tabItem(tabName = "analysis",
          # Display this panel if either the instructions or filters tab is active
          conditionalPanel(
            condition = "input.sidebar == 'analysis' ",
            fluidRow(
              box(
                width = 12,
                title = "Bird Observation Analysis at H.J. Andrews Experimental Forest",
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = FALSE,
                status = "primary", 
                img(src = "Poecile_rufescens.jpeg", height = "200px", width = "100%", alt = "Forest Image"),
                p("This analysis encompasses observations conducted at the H.J. Andrews Experimental Forest, 
                located in North America. The forest experiences a cool, moist climate during winter, 
                transitioning to warm and dry conditions in the summer. 
                The annual precipitation averages approximately 2,500 mm, 
                predominantly as rain at lower elevations and snow at higher altitudes.
                Our research highlights the five predominant bird species thriving in the coniferous forest habitat of this region. 
                Notably, Setophaga occidentalis shows a preference for more humid microhabitats, while Poecile rufescens is typically found at lower elevations.
                Future studies could enhance our understanding by integrating additional environmental variables such as weather patterns, 
                wind conditions, stream noise levels, snow coverage, and the phenology of local flora like vine maple and rhododendron.")
              ),
              # Second box for audio controls
              box(
                width = 12,
                title = "Listen to the Bird Calls",
                solidHeader = TRUE,
                status = "primary",
                collapsible = TRUE,
                collapsed = FALSE,
                tags$ul(
                  tags$li("Setophaga occidentalis", tags$audio(src = "audio/Setophaga_occidentalis.mp3", type = "audio/mp3", controls = TRUE)),
                  tags$li("Poecile rufescens", tags$audio(src = "audio/Poecile_rufescens.mp3", type = "audio/mp3", controls = TRUE)),
                  tags$li("Troglodytes pacificus", tags$audio(src = "audio/Troglodytes_pacificus.mp3", type = "audio/mp3", controls = TRUE)),
                  tags$li("Sitta canadensis", tags$audio(src = "audio/Sitta_canadensis.mp3", type = "audio/mp3", controls = TRUE)),
                  tags$li("Catharus ustulatus", tags$audio(src = "audio/Catharus_ustulatus.mp3", type = "audio/mp3", controls = TRUE))
                )
              )
            )
          )
  ),
  )

# Compile the dashboard elements
ui = dashboardPage(
  skin = "blue",
  header,
  sidebar = sidebar,
  body = body
)