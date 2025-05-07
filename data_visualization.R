
# Deer Pellet and Kill Count Visualization

#setwd("C:/Users/lasya/OneDrive/Desktop/Data analysis/Biol5930/data/processed")
# 1. Install and load required packages
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(lubridate)

# 2. Load cleaned datasets
pellet_df <- read_csv("BRF_deer_pellet_data_CLEANED.csv")
kill_df <- read_csv("BRF_deer_kill_data_CLEANED.csv")

# 3. Convert date column if needed
pellet_df <- pellet_df %>% mutate(date = as.Date(date))
kill_df <- kill_df %>% mutate(date = as.Date(date), year = year(date))

# 4. Histogram of Pellet Counts
ggplot(pellet_df, aes(x = pellet.count)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Pellet Counts",
       x = "Pellet Count", y = "Frequency") +
  theme_minimal()

# 5. Scatter Plot: Pellet Count by Transect
ggplot(pellet_df, aes(x = transect, y = pellet.count)) +
  geom_jitter(alpha = 0.6, size = 2, color = "darkgreen") +
  labs(title = "Pellet Count by Transect",
       x = "Transect", y = "Pellet Count") +
  theme_minimal()

# 6. Time Series Plot: Pellet Count Over Time
ggplot(pellet_df, aes(x = date, y = pellet.count)) +
  geom_line(aes(group = transect), color = "gray60", alpha = 0.5) +
  geom_point(color = "firebrick", alpha = 0.7) +
  labs(title = "Pellet Count Over Time",
       x = "Date", y = "Pellet Count") +
  theme_minimal()

# 7. Bar Chart: Average Pellet Count per Transect
ggplot(pellet_df, aes(x = transect, y = pellet.count, fill = transect)) +
  stat_summary(fun = mean, geom = "bar", alpha = 0.7) +
  labs(title = "Average Pellet Count per Transect",
       x = "Transect", y = "Average Pellet Count") +
  theme_minimal() +
  theme(legend.position = "none")

# --------------------------------------------
# KILL DATA VISUALIZATION
# --------------------------------------------

# 8. Kill Count by Year (Bar Plot)
kill_counts_by_year <- kill_df %>%
  count(year)

ggplot(kill_counts_by_year, aes(x = factor(year), y = n)) +
  geom_bar(stat = "identity", fill = "tomato", alpha = 0.8) +
  labs(title = "Total Kill Counts by Year",
       x = "Year", y = "Number of Deer Harvested") +
  theme_minimal()

# 9. Histogram of Harvest Dates
ggplot(kill_df, aes(x = date)) +
  geom_histogram(binwidth = 30, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Harvest Date Distribution",
       x = "Date", y = "Number of Deer Harvested") +
  theme_minimal()
