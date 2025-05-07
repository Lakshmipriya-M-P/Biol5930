
# ============================================
# Pellet and Kill Count Aggregation & Analysis
# ============================================

# Load required packages
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(readr)

# Load cleaned datasets
pellet_df <- read_csv("data/processed/BRF_deer_pellet_data_CLEANED.csv")
kill_df <- read_csv("data/processed/BRF_deer_kill_data_CLEANED.csv")

# Aggregate pellet data by year
pellet_summary <- pellet_df %>%
  group_by(year) %>%
  summarise(total_pellets = sum(pellet.count, na.rm = TRUE))

# Aggregate kill data by year
kill_summary <- kill_df %>%
  group_by(year) %>%
  summarise(total_kills = n())

# Merge both summaries by year
combined_df <- left_join(pellet_summary, kill_summary, by = "year")
print(combined_df)

# Visualization - Line plot of both metrics over time
ggplot(combined_df, aes(x = year)) +
  geom_line(aes(y = total_pellets, color = "Pellet Count")) +
  geom_point(aes(y = total_pellets, color = "Pellet Count")) +
  geom_line(aes(y = total_kills, color = "Kill Count")) +
  geom_point(aes(y = total_kills, color = "Kill Count")) +
  labs(title = "Pellet and Kill Counts vs Year",
       x = "Year", y = "Counts") +
  scale_color_manual(values = c("Pellet Count" = "blue", "Kill Count" = "red")) +
  theme_minimal()

# Scatter plot for correlation analysis
ggplot(combined_df, aes(x = total_kills, y = total_pellets)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  labs(title = "Pellet Count vs Kill Count",
       x = "Total Kills", y = "Total Pellets") +
  theme_minimal()

# Pearson correlation test
cor_result <- cor.test(combined_df$total_pellets, combined_df$total_kills, method = "pearson")
print(cor_result)
