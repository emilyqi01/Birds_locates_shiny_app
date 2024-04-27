# This R script is designed to provide the server-side logic for
# a Shiny application focused on bird data visualization.

# Load necessary libraries
library(stringr)     
library(shiny)       # For building interactive web apps
library(leaflet)     # For creating interactive maps
library(dplyr)       
library(ggplot2)     

# Load the necessary bird data from a CSV file
bird_data = read.csv("./data/derived_data/selected_bird.csv")

# Map image paths from directory to Shiny app path
addResourcePath("bird_images", "data/picture")

# Define server function to provide reactive outputs and render UI components
server <- function(input, output) {
  # Reactive expression to filter data based on user selections in the UI
  filtered_data <- reactive({
    bird_data %>% 
      filter(
        year == input$year_select &                  # Filter by selected year
          taxon_name %in% input$taxon_select &         # Filter by selected taxon
          elevation >= input$elevation_range[1] &      # Filter by minimum elevation
          elevation <= input$elevation_range[2]        # Filter by maximum elevation
      )
  })
  
  # Define a palette for coloring map markers based on taxon names
  pal <- colorFactor(topo.colors(length(unique(bird_data$taxon_name))), domain = unique(bird_data$taxon_name))
  
  # Render the Leaflet map with reactive data
  output$map <- renderLeaflet({
    leaflet(data = filtered_data()) %>%
      addTiles() %>%
      addCircleMarkers(
        ~longitude, ~latitude,
        radius = 5,
        color = ~pal(taxon_name),
        opacity = 0.8,
        fillOpacity = 0.8,
        popup = ~paste("Taxon Name:", taxon_name, 
                       "<br>Elevation:", elevation,
                       "<br><img src='", 
                       URLencode(str_replace(image_path, "data/picture/", "bird_images/")),
                       "' style='width:100px; height:auto;'>")
      )
  })
  
  # Render a bar plot showing the count of observations per taxon for the selected year
  output$taxon_plot <- renderPlot({
    data <- bird_data %>%
      filter(year == input$year_select) %>%
      group_by(taxon_name) %>%
      summarize(n = n(), .groups = "drop")
    # Wrap taxon names to avoid cluttering the x-axis
    data$taxon_name <- str_wrap(data$taxon_name, width = 20)
    ggplot(data, aes(x = taxon_name, y = n, fill = taxon_name)) +
      geom_col(position = "dodge") +
      labs(title = paste("Taxon Distribution for", input$year_select), x = "Taxon Name", y = "Count") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
}
