library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Debugging: Print column names and first few dates
print("Column names in raw_data:")
print(colnames(raw_data))

print("First few values in 'date' column:")
print(head(raw_data$date))

# Ensure 'date' column exists
if (!"date" %in% colnames(raw_data)) {
  stop("Error: 'date' column not found in dataset!")
}

# Convert date column correctly (handle timestamps)
raw_data$date <- as.Date(as.POSIXct(raw_data$date, format="%Y-%m-%d %H:%M:%S"))

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Calculate pellet density per hectare (ensure correct column names)
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)  # Adjust if necessary

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
