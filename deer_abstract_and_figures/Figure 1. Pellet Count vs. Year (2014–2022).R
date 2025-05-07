# Load libraries
library(ggplot2)
library(readr)
library(dplyr)

# Load the data
pellet_data <- read_csv("BRF_deer_pellet_data_clean.csv")

# Aggregate total pellet counts by year
yearly_pellet_totals <- pellet_data %>%
  group_by(year) %>%
  summarise(total_pellets = sum(pellet.count, na.rm = TRUE))

# Plot
ggplot(yearly_pellet_totals, aes(x = year, y = total_pellets)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "blue", size = 2) +
  labs(title = "Pellet Count vs Year",
       x = "Year",
       y = "Total Pellets") +
  theme_minimal()
