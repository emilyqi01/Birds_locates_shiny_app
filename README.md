# Discover Forest birds' locations Projects

## Description
This project is to create a shiny app and 
show the birds' locations in a map.

---

## Getting Started

Follow these steps to prepare the data and execute the analysis:


For reproducibility, viewers may delete derived data in the data/derived folder. However, do not delete the folders themselves, as this may cause errors when saving.




### Step 1: Data Cleaning

This section outlines the steps required to clean and prepare the dataset for analysis, focusing on observations of birds.

1. **Navigate to the Data-Cleaning Directory:**
   - Change to the `data-cleaning` directory within the project folder.

2. **Execute Cleaning Scripts:**
   - Run the following R scripts in order to clean different aspects of the dataset:
     - `location_cleaning.R`: Cleans and preprocesses location data.
     - `observe_cleaning.R`: Filters and processes observation records.
     - `taxon_cleaning.R`: Cleans taxonomic data to ensure consistency.
   - These scripts remove instances of missing data and filter out only the important variables for the dataset. All scripts output the intermediate cleaned data into the `data/derived` folder.

3. **Run Bird Selection Script:**
   - Execute `bird_selection.R` to select the five most popular birds observed in the dataset.
   - This script further processes the data to include taxon names, specific locations (latitude, longitude, and elevation), and associates images of the birds.
   - It stores the final cleaned dataset as `selected_bird.csv` in the `data/derived` folder.


### Step 2: Conducting Analysis


### Step 3: Report


---

## Data Sources

### DATA ONE Platform Datasets
- **CSV Files**: `location.csv`, `observation.csv`, `taxon.csv`
- **Source**: Datasets are sourced from the [DATA ONE platform](https://search.dataone.org/view/https%3A%2F%2Fpasta.lternet.edu%2Fpackage%2Fmetadata%2Feml%2Fedi%2F359%2F3#https%3A%2F%2Fpasta.lternet.edu%2Fpackage%2Fdata%2Feml%2Fedi%2F359%2F3%2Fe09491aee3bd9ec02e805ffdac0beb12).
- **Storage**: Files are stored in `data/raw_data`.
- **Usage**: Data is used for cleaning, processing, and analysis as part of this project.

### Bird Pictures
- **Source**: Images are obtained from [Birds of the World](https://birdsoftheworld.org/bow/home).
- **Storage**: Images are stored in `data/pictures`.
- **Usage**: Utilized for visual representation, educational presentations, and application interface.


---

## Datasets Overview

We utilize two primary datasets: `home_school_district.csv` and `home_school_state.csv`, sourced from the Washington Post's repository on home schooling.

- `home_school_state.csv` provides six years of home-school enrollment data across 33 states.
- `home_school_district.csv` contains records from 6,661 districts, with each state comprising a unique set of districts. All districts' information include six years' population of home-schooling, district unique id and district name.

### Data Cleaning

- Removed all instances of `NA` values from both datasets.
- Excluded districts with zero enrollments from `home_school_district.csv`.
- Excluded districts with missing values which means when we group by district id, exclude districts that do not have 6 data information.



### Data Integration

- Introduced an 'Abbreviation' column to `home_school_state.csv` to align with `home_school_district.csv`, which uses state abbreviations.

All refined datasets are stored in the `data/derived` directory for streamlined access.


---
 

## Dataset Analysis



---


## Licensing
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
