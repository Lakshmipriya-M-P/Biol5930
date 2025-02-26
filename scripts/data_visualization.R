# Load required libraries
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)

# Define file path
file_path <- "data/raw/BRF_deer_pellet_data_RAW.csv"

# Read the CSV file
raw_data <- read_csv(file_path)

# Inspect the first few rows
head(raw_data)

# Check data structure
str(raw_data)

# Summary statistics of numeric columns
summary(raw_data)

# Count missing values in each column
colSums(is.na(raw_data))

# Replace missing values in 'pellet.count' with 0 (if applicable)
raw_data$pellet.count[is.na(raw_data$pellet.count)] <- 0

# Remove rows where 'transect.location' or 'transectID' is missing
clean_data <- raw_data %>% drop_na(transect.location, transectID)

# Summarize pellet counts per transect
pellet_summary <- clean_data %>%
  group_by(transect.location) %>%
  summarise(total_pellets = sum(pellet.count, na.rm = TRUE),
            mean_pellets = mean(pellet.count, na.rm = TRUE),
            count_points = n())

# Print summary
print(pellet_summary)

# Visualize pellet counts per transect
ggplot(pellet_summary, aes(x = transect.location, y = total_pellets, fill = transect.location)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Total Pellet Counts per Transect", x = "Transect Location", y = "Total Pellets") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save cleaned data (optional)
write_csv(clean_data, "data/processed/BRF_deer_pellet_data_clean.csv")