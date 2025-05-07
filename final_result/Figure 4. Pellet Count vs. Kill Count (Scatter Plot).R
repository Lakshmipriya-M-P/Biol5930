# Load libraries
library(ggplot2)
library(readr)
library(dplyr)

# Load data
pellet_data <- read_csv("BRF_deer_pellet_data_clean.csv")
kill_data <- read_csv("BRF_Cumulative_Deer_Harvest_Records_raw.csv")

# Aggregate both datasets by year
pellet_totals <- pellet_data %>%
  group_by(year) %>%
  summarise(pellet_count = sum(pellet.count, na.rm = TRUE))

kill_totals <- kill_data %>%
  group_by(year) %>%
  summarise(kill_count = n()) %>%
  filter(year >= 2014, year <= 2022)

# Merge on year
combined_df <- merge(pellet_totals, kill_totals, by = "year")

# Compute Pearson correlation
correlation <- cor(combined_df$pellet_count, combined_df$kill_count, method = "pearson")
print(paste("Pearson correlation coefficient (r):", round(correlation, 2)))

# Scatter plot
ggplot(combined_df, aes(x = kill_count, y = pellet_count)) +
  geom_point(size = 3) +
  labs(title = "Pellet Count vs Kill Count",
       x = "Total Kills",
       y = "Total Pellets") +
  theme_minimal()
