library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(ggplot2)
# Load the data
bird_data = read.csv("./data/derived_data/selected_bird.csv")
obs_data <- read.csv("./data/derived_data/observe_update.csv")
# Create the shiny dashboard header
header <- dashboardHeader(
  title = HTML("&#x1F332; Forest Bird Observations &#x1F426;"),
  titleWidth = 300 
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
  # only appear when we want to visualize on maps
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
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
    tabItem(tabName = "instructions",
            # Display this panel if either the instructions or filters tab is active
            conditionalPanel(
              condition = "input.sidebar == 'instructions'",
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
  tabItem(tabName = "maping",
          
          conditionalPanel(
            condition = "input.sidebar == 'maping'",
            fluidRow(
              box(
                width = 12,
                title = "Let's Play to visualize on the map!!",
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = FALSE,
                status = "primary", 
                p("This is a dashboard for bird observation in specific areas from 2009 to present. 
                    Users could use it to discover birds' locations (including latitude, altitude and elevation)over years."),
                p("Use the controls to filter the bird observation data based on year, taxon ID, and elevation range. 
                    The map will update automatically to reflect the filters applied."),
                p("Hover over points on the map to see more details about each observation."),
                
              ),
              box(width = 12, leafletOutput("map", height = "500px")),
              box(width = 12, title = "Analysis of Taxon Distribution Across Multiple Years",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = FALSE,
                  status = "primary",
                  htmlOutput("taxon_ana")
                  )
            )
            
          )
  ),
    tabItem(tabName = "ele",
            conditionalPanel(
              condition = "input.sidebar == 'ele'",
              fluidRow(
                column(6,  # Adjust width as needed for the text
                       h4("Select your interested year:"),  # Example text element
                       p("Please select the year you want to examine. The data will be filtered accordingly.")
                ),
                column(6,  # Adjust the remaining space for the selectInput
                       selectInput(
                         inputId = "select_year",
                         label = "Select Year:",
                         choices = unique(bird_data$year),
                         selected = unique(bird_data$year)[1]
                       )
                ),
              box(
                title = "Taxon ID Frequency",
                width = 12,
                plotOutput("elevationPlot", height = "300px")
              ),
              box(
                width = 12,
                title = "Bird Observation Analysis at H.J. Andrews Experimental Forest",
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = FALSE,
                status = "primary",
                htmlOutput("trend_ana"))
              )),
              
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
                  tags$li(
                    style = "display: flex; align-items: center; gap: 40px;", 
                    img(src = "picture/Setophaga_occidentalis.jpeg", width = 120, height = 90),
                    tags$audio(src = "audio/Setophaga_occidentalis.mp3", type = "audio/mp3", controls = TRUE),
                    tags$span("In the sun-dappled branches of the western forests, the Setophaga occidentalis, 
                    or the Hermit Warbler, shares its musical gift with the world. Its song is a delicate tapestry of high notes, each one pure and clear, 
                              carrying a sweetness that transcends the buzzing quality found in the song of the Townsend's Warbler.")
                  ),
                  tags$li(
                    style = "display: flex; align-items: center; gap: 40px;", 
                    img(src = "picture/Poecile_rufescens.jpeg", width = 120, height = 90),
                    tags$audio(src = "audio/Poecile_rufescens.mp3", type = "audio/mp3", controls = TRUE),
                    tags$span("The Poecile rufescens, affectionately known as the chestnut-backed Chickadee, fills the forest with its lively chatter, 
                    a squeaky chick-a-dee that dances through the air, sharper and swifter than the calls of its avian kin. It's a creature of whimsy, 
                    often punctuating the silence with its thin, delicate tsee-deee, a sound that seems to shimmer amidst the leaves, 
                              accompanied by delicate lisping notes that flutter like whispers on the wind. ")
                  ),
                  tags$li(
                    style = "display: flex; align-items: center; gap: 40px;", 
                    img(src = "picture/Troglodytes_pacificus.jpeg", width = 120, height = 90),
                    tags$audio(src = "audio/Troglodytes_pacificus.mp3", type = "audio/mp3", controls = TRUE),
                    tags$span("In the dense undergrowth, the Troglodytes pacificus, known as the Pacific Wren, 
                    orchestrates its symphony of sound, a cacophony of high-pitched, 
                    diverse trills and chatters that cascade through the air with breathtaking speed and variation.
                              Its call, an explosive burst of energy, echoes through the woodland, 
                              a sharp \"kit!\" or \"kit-kit!\" that reverberates amidst the lush greenery, 
                              marking its presence in the wilderness with fervent enthusiasm.")
                  ),
                  tags$li(
                    style = "display: flex; align-items: center; gap: 40px;", 
                    img(src = "picture/Sitta_canadensis.jpeg", width = 120, height = 90),
                    tags$audio(src = "audio/Sitta_canadensis.mp3", type = "audio/mp3", controls = TRUE),
                    tags$span("In the tranquil woodland, the Sitta canadensis, or the Red-breasted Nuthatch, 
                    adds its unique melody to the natural chorus, a tinny \"yank-yank\" that pierces the air with its distinctiveness, 
                              rising higher in pitch and imbued with a nasal quality unlike the call of the White-breasted Nuthatch.")
                  ),
                  tags$li(
                    style = "display: flex; align-items: center; gap: 40px;", 
                    img(src = "picture/Catharus_ustulatus.jpeg", width = 120, height = 90),
                    tags$audio(src = "audio/Catharus_ustulatus.mp3", type = "audio/mp3", controls = TRUE),
                    tags$span("In the hushed canopy of the forest, the Catharus ustulatus,
                    known as the Swainson's Thrush, unveils its melodic masterpiece, a song that weaves through the air like delicate threads of sound. Its ethereal melody unfolds in a series of reedy spiraling notes, each inflected upward, 
                              creating a mesmerizing symphony that resonates through the woodland, 
                              captivating all who are fortunate enough to hear it.")
                  )
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