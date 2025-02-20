library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Standardize date format
raw_data$Date <- as.Date(raw_data$Date, format="%Y-%m-%d")

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Calculate pellet density per hectare
clean_data <- clean_data %>%
  mutate(Pellet_Density = Pellet_Count / Survey_Area_Ha)

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
