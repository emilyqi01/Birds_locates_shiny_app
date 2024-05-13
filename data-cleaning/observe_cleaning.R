# This r script is to do data cleaning on the observation csv
# It should include deleting NAs and selecting useful variables for furthur analysis
# Also it should save the deriving dataset
# import libaries
library(tidyverse)
# Read the observation dataset
obs_data = read.csv("./data/raw_data/observation.csv")
head(obs_data)
# Discover the obs_data, the value column for each row is all '1'
# thus there is no need to obain 'value' parameter in the derived dataset
value = obs_data %>% group_by(value) %>% summarise(count = n())
# Remove rows with NA values in any of the selected columns
# Select the desired columns
selected_obs = obs_data %>%
  select(observation_id, location_id, datetime, taxon_id) %>% drop_na()
# Add a column year by tranforming the datetime
selected_obs = selected_obs %>%
  mutate(year = year(datetime)) 

write.csv(selected_obs, "./data/derived_data/observe_update.csv",row.names = FALSE)


 