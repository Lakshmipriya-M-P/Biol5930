library(dplyr)
library(lubridate)
library(stringr)

# Load raw data
raw_data <- read.csv("data/raw/BRF_deer_pellet_data_RAW.csv", stringsAsFactors = FALSE)

# Debugging: Print column names
print("Column names in raw_data:")
print(colnames(raw_data))

# Ensure all required columns exist
required_columns <- c("year", "date", "transect.location", "transectID", "reader", "pointno", "pellet.count", "notes")
missing_columns <- setdiff(required_columns, colnames(raw_data))

if (length(missing_columns) > 0) {
  stop(paste("Error: Missing required columns:", paste(missing_columns, collapse = ", ")))
}

# Convert 'date' column to standard format
raw_data$date <- as.character(raw_data$date)
raw_data$date <- as.Date(parse_date_time(raw_data$date, orders = c("ymd", "mdy", "dmy")), format = "%Y-%m-%d")

# Extract 'year' from 'date' column
raw_data$year <- year(raw_data$date)

# Standardize categorical columns (transect.location, transectID, reader)
clean_data <- raw_data %>%
  mutate(
    transect.location = str_to_title(transect.location),  # Capitalize first letter
    transectID = as.character(transectID),
    reader = str_to_lower(reader),  # Convert to lowercase for consistency
    notes = ifelse(is.na(notes) | notes == "", "No Notes", notes) # Handle missing notes
  )

# Convert 'pointno' to integer
clean_data$pointno <- as.integer(clean_data$pointno)

# Convert 'pellet.count' to numeric and handle missing values
clean_data$pellet.count <- suppressWarnings(as.numeric(clean_data$pellet.count))
clean_data$pellet.count[is.na(clean_data$pellet.count)] <- 0  # Replace missing counts with 0

# Create 'Pellet_Density' variable
clean_data <- clean_data %>%
  mutate(Pellet_Density = pellet.count / 1)

# Remove duplicates
clean_data <- clean_data %>% distinct()

# Debugging: Print summary after cleaning
print(paste("Total records after cleaning:", nrow(clean_data)))
print(paste("Missing values in pellet.count after cleaning:", sum(is.na(clean_data$pellet.count))))

# Save cleaned data
write.csv(clean_data, "data/processed/BRF_deer_pellet_data_CLEAN.csv", row.names = FALSE)

print("Data cleaning and harmonization complete!")
