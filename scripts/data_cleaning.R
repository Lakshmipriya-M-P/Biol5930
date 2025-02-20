library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Debug prints
print("Column names in raw_data:")
print(colnames(raw_data))
print("First few values in 'date' column:")
print(head(raw_data$date))

# Ensure 'date' column exists before processing
if (!"date" %in% colnames(raw_data)) {
  stop("Error: 'date' column not found in dataset!")
}

# Handle missing or incorrect date values safely
raw_data$date <- ifelse(is.na(raw_data$date) | raw_data$date == "", NA, raw_data$date)

# Extract first 10 characters and convert to Date safely
raw_data$date <- as.Date(substr(raw_data$date, 1, 10), format="%Y-%m-%d")

# Print debugging info
print("First few values in 'date' column after conversion:")
print(head(raw_data$date))

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values for other columns
clean_data[is.na(clean_data)] <- "Unknown"

# Ensure the correct column name is used for pellet count calculation
if (!"pellet.count" %in% colnames(clean_data)) {
  stop("Error: 'pellet.count' column not found!")
}

# Calculate pellet density per hectare (adjust as needed)
clean_data <- clean_data %>%
  mutate(Pellet_Density = as.numeric(pellet.count) / 1)

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
