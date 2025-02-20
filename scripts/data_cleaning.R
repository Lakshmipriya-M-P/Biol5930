library(dplyr)
library(lubridate)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv")

# Debug prints for column names and date values
print("Column names in raw_data:")
print(colnames(raw_data))
print("First few values in 'date' column:")
print(head(raw_data$date))

# Convert 'date' column using lubridate's ymd_hms() function and then convert to Date
raw_data$date <- as.Date(ymd_hms(raw_data$date))

# Remove duplicates
clean_data <- raw_data %>% distinct()

# Handle missing values
clean_data[is.na(clean_data)] <- "Unknown"

# Calculate pellet density per hectare (adjust if an area column exists)
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
