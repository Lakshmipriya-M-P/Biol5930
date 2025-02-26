# Load necessary libraries
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv", stringsAsFactors = FALSE)

# Debugging: Print column names
print("Column names in raw_data:")
print(colnames(raw_data))

# Ensure all required columns exist (excluding 'year' since we derive it)
required_columns <- c("date", "transect.location", "transectID", "reader", "pointno", "pellet.count", "notes")
missing_columns <- setdiff(required_columns, colnames(raw_data))

if (length(missing_columns) > 0) {
  stop(paste("Error: Missing required columns:", paste(missing_columns, collapse = ", ")))
}

# Convert 'date' column to Date format with multiple parsing attempts
raw_data$date <- suppressWarnings(ymd(raw_data$date))  # First attempt with YYYY-MM-DD

# If still NA, try parsing with alternative formats
raw_data$date[is.na(raw_data$date)] <- suppressWarnings(mdy(raw_data$date[is.na(raw_data$date)]))
raw_data$date[is.na(raw_data$date)] <- suppressWarnings(dmy(raw_data$date[is.na(raw_data$date)]))

# Final check for any unparsed dates
if (any(is.na(raw_data$date))) {
  warning("Some dates could not be parsed. Check the raw data for inconsistencies.")
}

# Extract 'year' from 'date' column
raw_data$year <- year(raw_data$date)

# Standardize categorical columns
clean_data <- raw_data %>%
  mutate(
    transect.location = str_to_title(str_trim(transect.location)),  # Capitalize first letter & trim spaces
    transectID = as.character(transectID),
    reader = str_to_lower(str_trim(reader)),  # Convert to lowercase & trim spaces
    notes = replace_na(notes, "No Notes")  # Replace missing notes with "No Notes"
  )

# Convert 'pointno' to integer
clean_data$pointno <- as.integer(clean_data$pointno)

# Convert 'pellet.count' to numeric and handle missing values
clean_data$pellet.count <- suppressWarnings(as.numeric(clean_data$pellet.count))
clean_data$pellet.count[is.na(clean_data$pellet.count)] <- 0  # Replace missing counts with 0

# Create 'Pellet_Density' variable
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)  # Placeholder: Adjust denominator if needed

# Remove duplicates
clean_data <- clean_data %>% distinct()

# Debugging: Print summary after cleaning
print(paste("Total records after cleaning:", nrow(clean_data)))
print(paste("Missing values in pellet.count after cleaning:", sum(is.na(clean_data$pellet.count))))

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")