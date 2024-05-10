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
obs_data <- read.csv("./data/derived_data/observe_update.csv")

# Define server function 
server <- function(input, output) {
  # import the instruction text from other directories
  # Read the instruction text 
  inscontent <- readLines("texts/instruction.txt", warn = FALSE)

  # Output the text as HTML
  output$ins_txt <- renderUI({
    HTML(inscontent)
  })
  
  # Define a reactive expression that filters taxon frequency 
  # based on a user-defined range from a slider input
  filtered_taxon_freq <- reactive({
    # Group data by taxon_id, calculate the count of occurrences for each taxon, and remove grouping structure
    taxon_id_freq <- obs_data %>%
      group_by(taxon_id) %>%
      summarize(count = n(), .groups = "drop") %>%
      arrange(desc(count)) # Sort data in descending order based on count
    # Retrieve the range selected by the user from the slider input
    taxon_range <- input$taxon_range_slider
    # Filter the data to include only taxon IDs within the specified range
    taxon_id_freq %>%
      filter(taxon_id >= taxon_range[1] & taxon_id <= taxon_range[2])
  })
  
  # Generate and display a bar plot of taxon ID frequency controlled by the slider input
  output$taxon_id_frequency_plot <- renderPlot({
    # Obtain the filtered data from the reactive expression
    filtered_data <- filtered_taxon_freq()
    # Create a bar plot using ggplot2
    ggplot(filtered_data, aes(x = as.factor(taxon_id), y = count, fill = count)) +
      geom_bar(stat = "identity") +
      scale_fill_gradient(low =  "skyblue", high = "darkgreen") +
      theme_minimal() +
      labs(x = "Taxon ID", y = "Frequency", title = "Frequency of Taxon IDs") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
  
  
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
  # Read text content from about years' elevation location of birds trending
  textContent <- readLines("texts/elevation_trend_analysis.txt", warn = FALSE)
  trend_text <- paste("<p>", textContent, "</p>", collapse = "")
  # Highlight specific taxa names 
  trend_text <- gsub("Setophaga occidentalis", "<strong>Setophaga occidentalis</strong>", trend_text)
  trend_text <- gsub("Poecile rufescens", "<strong>Poecile rufescens</strong>", trend_text)
  trend_text <- gsub("Sitta canadensis", "<strong>Sitta canadensis</strong>", trend_text)
  trend_text <- gsub("Troglodytes pacificus", "<strong>Troglodytes pacificus</strong>", trend_text)
  trend_text <- gsub("Catharus ustulatus", "<strong>Catharus ustulatus</strong>", trend_text)
  # Output the text as HTML
  output$trend_ana <- renderUI({
    HTML(trend_text)
  })
  
  # Render a boxplot of elevation for each taxon, filtered by the selected year
  output$elevationPlot <- renderPlot({
    # Filter the data based on the selected year
    data_for_plot <- bird_data %>%
      filter(year == input$select_year)  
    # Define a vibrant color palette
    vibrant_palette <- RColorBrewer::brewer.pal(n = length(unique(data_for_plot$taxon_name)), name = "Set3")
    
    # Create the boxplot using the filtered data
    ggplot(data_for_plot, aes(x = as.factor(taxon_name), y = elevation, color = as.factor(taxon_name), fill = as.factor(taxon_name))) +
      geom_boxplot(alpha = 0.5, outlier.shape = 19, outlier.size = 2, lwd = 0.75) +  
      scale_color_manual(values = vibrant_palette) +
      scale_fill_manual(values = vibrant_palette) +
      labs(x = "Taxon Name", y = "Elevation (m)", color = "Taxon Name", fill = "Taxon Name") +
      theme_minimal() +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 0, hjust = 0.5),  # Set angle to 0 for horizontal labels
            legend.text = element_text(size = 10)) +
      guides(fill = guide_legend(override.aes = list(color = NULL)))  # Remove color border around legend keys
  })
  

  
  # Render a bar plot showing the count of observations per taxon for the selected year
  output$taxon_distribution_plot <- renderPlot({
    data <- bird_data %>%
      filter(year == input$year_select) %>%
      group_by(taxon_name) %>%
      summarize(n = n(), .groups = "drop") # Group data by taxon and count occurrences
    
    # Wrap taxon names to avoid cluttering the x-axis
    data$taxon_name <- str_wrap(data$taxon_name, width = 20)
    
    ggplot(data, aes(x = taxon_name, y = n, fill = taxon_name)) +
      geom_col(position = "dodge") +
      labs(title = paste("Taxon Distribution for", input$year_select), x = "Taxon Name", y = "Count") +
      scale_fill_manual(values = c("#17648d", "#51bec7", "#d6ab63", "#843844", "#008c8f")) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })


  # Read text content from about years' elevation location of birds trending
  taxoncontent <- readLines("texts/taxon_analysis.txt", warn = FALSE)
  taxon_text <- paste("<p>", taxoncontent, "</p>", collapse = "")
  # Highlight specific taxa names 
  taxon_text <- gsub("Setophaga occidentalis", "<strong>Setophaga occidentalis</strong>", taxon_text)
  taxon_text <- gsub("Poecile rufescens", "<strong>Poecile rufescens</strong>", taxon_text)
  taxon_text <- gsub("Sitta canadensis", "<strong>Sitta canadensis</strong>", taxon_text)
  taxon_text <- gsub("Troglodytes pacificus", "<strong>Troglodytes pacificus</strong>", taxon_text)
  taxon_text <- gsub("Catharus ustulatus", "<strong>Catharus ustulatus</strong>", taxon_text)
  # Output the text as HTML
  output$taxon_ana <- renderUI({
    HTML(taxon_text)
  })

  
  
  # Render a Leaflet map to display the distribution of taxa with interactive features
  output$map <- renderLeaflet({
    # Define a color palette for the map based on taxon names
    pal <- colorFactor(
      palette = c("#17648d", "#51bec7", "#d6ab63", "#843844", "#008c8f"),
      domain = bird_data$taxon_name  
    )
    
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
                       image_path,
                       "' style='width:100px; height:auto;'>")
      )
  })
  
  
  
  
}
