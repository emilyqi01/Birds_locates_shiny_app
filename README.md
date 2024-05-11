# Forest birds' observation shiny app

# Table of Contents
- [Description](#description)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Tabs and contents included in the app](#tabs-and-contents-included-in-the-app)
- [Some special directory](#some-special-directory)
- [Data Sources](#data-sources)
  - [DATA ONE Platform Datasets](#data-one-platform-datasets)
  - [Bird Pictures](#bird-pictures)
  - [Bird Audios](#bird-audios)
- [Screenshots](#screenshots)
- [Troubleshooting](#troubleshooting)
- [Authors and Acknowledgment](#authors-and-acknowledgment)
- [License](#license)
- [Contact Information](#contact-information)


## Description
This Shiny app visualizes bird observation data, providing interactive tools for data exploration and analysis. It is designed for educators, researchers, and birdwatching enthusiasts.

## Prerequisites
### Software Requirements
- R (Version 4.0 or higher recommended)
- RStudio (Recommended for ease of use)

## Installation
Download the project files from the repository and ensure all required packages are installed.
### R Packages
Install the required packages using the following command:
```R
install.packages(c("shiny", "shinydashboard", "shinythemes", "dplyr", "ggplot2", "leaflet"))
```

## Running the App
To run the app locally, open the app directory in RStudio and open either server or ui R script and click the run app button. Alternatively, navigate to the app directory in the terminal and start R:
```R
R -e "shiny::runApp()"
```
Or you can directly view the app from the link().




## Tabs and contents included in the app
- **Overall Taxon Distribution**: Discover the entire dataset we use
- **Interactive Maps**: View bird observations on a dynamic map and use the filtering button to explore more.
- **Analysis on elevation and distribution of taxon for multiple years**: In the 'View the Map' section and discovering the 'Taxon Distribution Across Multiple Years'.
By exploring the 'Elevation Analysis' section, you can also gain insights and make predictions about future trends.
- **More interests on birds**: Explore the 'Discovering' section to uncover the intriguing origins of our dataset, which hails from an experimental forest.



---

## For reproducibility : Getting Started 

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
### Step 12: Run the app
   - Directly to the `server.R` or `ui.R` and run the app.
---

## Some special directory 
- the www directory
It stores the dashboard style file in `style.css`, downloarded pictures and audio utilized in the app.
Using www directory is because files in the www directory are directly accessible through relative paths, and the server expects static resources to be placed here. When we link to files using a relative path like img src='your_image.png', it references the root path as www.
- the texts directory
Since I include many statitical analysis in my dashboard, the test are very long. It is convenient to write them first in txt file and then import to the ui and server.

## Data Sources

### DATA ONE Platform Datasets
- **CSV Files**: `location.csv`, `observation.csv`, `taxon.csv`
- **Source**: Datasets are sourced from the [DATA ONE platform](https://search.dataone.org/view/https%3A%2F%2Fpasta.lternet.edu%2Fpackage%2Fmetadata%2Feml%2Fedi%2F359%2F3#https%3A%2F%2Fpasta.lternet.edu%2Fpackage%2Fdata%2Feml%2Fedi%2F359%2F3%2Fe09491aee3bd9ec02e805ffdac0beb12).
- **Storage**: Files are stored in `data/raw_data`.
- **Usage**: Data is used for cleaning, processing, and analysis as part of this project.

### Bird Pictures
- **Source**: Images are obtained from [Birds of the World](https://birdsoftheworld.org/bow/home).
- **Storage**: Images are stored in `www/picture`.
- **Usage**: Utilized for visual representation, educational presentations, and application interface.

### Bird Audios
- **Source**: Bird audios are obtained from [Audubon Field Guide](https://www.audubon.org/field-guide/bird/pacific-wren).
- **Storage**: Images are stored in `www/audio`.
- **Usage**: Utilized for 





## Screenshots
![Dashboard Screenshot](data/screenshots/dashboard.png)

## Troubleshooting
For any issues regarding dependencies, ensure all packages are updated to their latest versions.

## Authors and Acknowledgment
- Yinglai Qi (Developer)
- Yinglai Qi (Data Analyst)
Special thanks to the DATA ONE platform and Birds of the World website for providing the data.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact Information
For support or queries, reach out to [emilyqi01@outlook.com](mailto:emilyqi01@outlook.com).

