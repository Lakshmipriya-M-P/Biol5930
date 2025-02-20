library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv", stringsAsFactors = FALSE)

# Debugging: Print column names and check first few dates
print("Column names in raw_data:")
print(colnames(raw_data))
print("First few values in 'date' column before conversion:")
print(head(raw_data$date))

# Ensure 'date' column exists
if (!"date" %in% colnames(raw_data)) {
  stop("Error: 'date' column not found in dataset!")
}

# Convert 'date' column to character before processing (fixes NA coercion issues)
raw_data$date <- as.character(raw_data$date)

# Parse date to extract the year
raw_data$year <- year(parse_date_time(raw_data$date, orders = c("ymd HMS", "ymd")))

# Debugging: Check the first few year values
print("First few values in 'year' column after conversion:")
print(head(raw_data$year))

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Ensure the correct column name is used for pellet count calculation
if (!"pellet.count" %in% colnames(clean_data)) {
  stop("Error: 'pellet.count' column not found!")
}

# Convert `pellet.count` to numeric and calculate pellet density
clean_data <- clean_data %>%
  mutate(Pellet_Density = as.numeric(pellet.count) / 1)

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
