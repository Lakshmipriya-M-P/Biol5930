
# Data Cleaning Script - Pellet & Kill Counts (2014–2022)
# Author: Lakshmipriya M P


# 1. Load required libraries
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
library(lubridate)

# 2. Load raw pellet data
pellet_path <- "data/raw/BRF_deer_pellet_data_RAW.csv"
pellet_df <- read_csv(pellet_path)

# 3. Clean and filter pellet data for 2014–2022
pellet_clean <- pellet_df %>%
  mutate(
    date = as.Date(date),
    year = year(date),
    transect = as.factor(transectID),
    pointno = as.integer(pointno),
    pellet.count = if_else(is.na(pellet.count),
                           median(pellet.count, na.rm = TRUE),
                           pellet.count)
  ) %>%
  filter(year >= 2014, year <= 2022) %>%
  select(year, date, transect, pointno, pellet.count)

# 4. Save cleaned pellet data
write_csv(pellet_clean, "data/processed/BRF_deer_pellet_data_CLEANED.csv")
cat("✅ Saved cleaned pellet data to /data/processed/\n")


# 5. Load raw kill data
kill_path <- "data/raw/BRF_Cumulative_Deer_Harvest_Records_raw.csv"
kill_df <- read_csv(kill_path)

# 6. Clean and filter kill data for 2014–2022
kill_clean <- kill_df %>%
  mutate(
    date = as.Date(date),
    year = year(date)
  ) %>%
  filter(year >= 2014, year <= 2022) %>%
  select(year, everything())  # move 'year' to first column

# 7. Save cleaned kill data
write_csv(kill_clean, "data/processed/BRF_deer_kill_data_CLEANED.csv")
cat("saved cleaned kill data to /data/processed/\n")
