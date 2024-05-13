# This r script is to do data cleaning on the location csv
# It should include deleting NAs and selecting useful variables for furthur analysis
# Also it should save the deriving dataset
# import libaries
library(dplyr)
library(tidyverse)
# read the location dataset
location_data = read.csv("./data/raw_data/location.csv")
head(location_data)
# deal with nas
# Select the desired columns
selected_loc = location_data %>%
  select(location_id, latitude, longitude, elevation) %>% drop_na()
  # Remove rows with NA values in any of the selected columns
write.csv(selected_loc, "./data/derived_data/loc_update.csv",row.names = FALSE)  

