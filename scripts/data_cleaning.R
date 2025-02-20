library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Debug prints
print("Column names in raw_data:")
print(colnames(raw_data))
print("First few values in 'date' column:")
print(head(raw_data$date))

# Extract the first 10 characters ("YYYY-MM-DD") and convert to Date
raw_data$date <- as.Date(substr(raw_data$date, 1, 10), format="%Y-%m-%d")

print("First few values in 'date' column after conversion:")
print(head(raw_data$date))

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Calculate pellet density per hectare (adjust if you have a proper Survey_Area column)
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
