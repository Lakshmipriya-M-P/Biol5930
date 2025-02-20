library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Print column names for debugging
print("Column names in raw_data:")
print(colnames(raw_data))

# Ensure the correct date column is used
if (!"date" %in% colnames(raw_data)) {
  stop("Error: 'date' column not found in dataset!")
}

# Convert date format
raw_data$date <- as.Date(raw_data$date, format="%Y-%m-%d")

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Calculate pellet density per hectare (ensure correct column names)
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)  # Adjust if there's a correct area column

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
