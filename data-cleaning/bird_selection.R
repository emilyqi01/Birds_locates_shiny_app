library(dplyr)
obs_data <- read.csv("./data/derived_data/observe_update.csv")
loc_data <- read.csv("./data/derived_data/loc_update.csv")
tax_data <- read.csv("./data/derived_data/taxon_update.csv")
# Assuming your data is in a tibble named 'selected_obs'

joined_data <- inner_join(obs_data, loc_data, by = "location_id")
joined_data <- inner_join(joined_data, tax_data, by = "taxon_id")

# Group by taxon_id, count the number of occurrences, and get the top 5
top_taxon_ids <- joined_data %>%
  group_by(taxon_id) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 5)

# View the result
print(top_taxon_ids)



# Get the top_taxon_ids as a vector
top_taxon_id_vector <- top_taxon_ids$taxon_id

# Filter joined_data to only include the top taxon_ids
filtered_joined_data <- joined_data %>%
  filter(taxon_id %in% top_taxon_id_vector)

# View the filtered result
print(filtered_joined_data)

# Example image path mapping
image_paths <- data.frame(
  taxon_name = unique(filtered_joined_data$taxon_name),
  image_path = c('./data/picture/Troglodytes_pacificus.jpeg', './data/picture/Poecile_rufescens.jpeg',
                 './data/picture/Setophaga_occidentalis.jpeg', './data/picture/Sitta_canadensis.jpeg',
                 './data/picture/Catharus_ustulatus.jpeg'))

filtered_joined_data <- filtered_joined_data %>%
  left_join(image_paths, by = "taxon_name")

write.csv(filtered_joined_data, "./data/derived_data/selected_bird.csv",row.names = FALSE)

