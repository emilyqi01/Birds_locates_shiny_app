# This r script is to do data cleaning on the taxon csv
# It should include deleting NAs and selecting useful variables for furthur analysis
# Also it should save the deriving dataset
# import libaries
library(tidyverse)
# Read the observation dataset
tax_data <- read.csv("./data/raw_data/taxon.csv")
head(tax_data)
selected_tax <- tax_data %>% drop_na() %>%
  select(taxon_id, taxon_name) 
write.csv(selected_tax, "./data/derived_data/taxon_update.csv",row.names = FALSE)
