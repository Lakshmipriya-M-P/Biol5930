# ============================
# 1. Install & Load Libraries
# ============================
install.packages("tidyverse", dependencies = TRUE)  

library(tidyverse)

# ============================
# 2. Load the Data
# ============================
df <- read.csv("C:/Users/lasya/OneDrive/Desktop/DATA ANALYSIS/Biol5930/data/raw/BRF_deer_pellet_data_RAW.csv", 
               stringsAsFactors = FALSE, na.strings = c("", "NA"))  # Treat empty strings as NA

# Check column names & structure
colnames(df)
str(df)

# ============================
# 3. Rename Columns (if needed)
# ============================
df <- df %>%
  rename(
    year = year,
    date = date,
    location = transect.location,  
    transect = transectID,
    observer = reader,
    point = pointno,
    pellet_count = pellet.count,
    notes = notes
  )

# ============================
# 4. Convert Data Types
# ============================
# Convert date column to proper Date format
df$date <- as.Date(df$date, format="%Y-%m-%d")

# Convert categorical variables to factors
df$location <- as.factor(df$location)
df$transect <- as.factor(df$transect)
df$observer <- as.factor(df$observer)

# Convert numeric variables (if needed)
df$point <- as.integer(df$point)
df$pellet_count <- as.integer(df$pellet_count)

# ============================
# 5. Handle Missing Values
# ============================
# Check for missing values
sum(is.na(df))

# Remove rows where key values (date, location, pellet count) are missing
df <- df %>%
  filter(!is.na(date) & !is.na(location) & !is.na(pellet_count))

# Fill missing values in 'notes' column with "No notes"
df$notes[is.na(df$notes)] <- "No notes"

# ============================
# 6. Remove Duplicates
# ============================
df <- df %>% distinct()

# ============================
# 7. Summary of Cleaned Data
# ============================
summary(df)

# ============================
# 8. Data Visualization
# ============================

# Scatter plot: Pellet count vs Date
ggplot(df, aes(x = date, y = pellet_count, color = location)) +
  geom_point(alpha = 0.6) +
  labs(title = "Pellet Count Over Time", x = "Date", y = "Pellet Count") +
  theme_minimal()

# Boxplot: Pellet count by location
ggplot(df, aes(x = location, y = pellet_count, fill = location)) +
  geom_boxplot() +
  labs(title = "Distribution of Pellet Count by Location", x = "Location", y = "Pellet Count") +
  theme_minimal()

# Time-series trend: Average pellet count over time
df %>%
  group_by(date) %>%
  summarise(avg_pellet = mean(pellet_count, na.rm = TRUE)) %>%
  ggplot(aes(x = date, y = avg_pellet)) +
  geom_line(color = "blue") +
  labs(title = "Average Pellet Count Over Time", x = "Date", y = "Avg Pellet Count") +
  theme_minimal()

# ============================
# Save Cleaned Data (Optional)
# ============================
write.csv(df, "C:/Users/lasya/OneDrive/Desktop/DATA ANALYSIS/Biol5930/data/clean/BRF_deer_pellet_data_CLEAN.csv", row.names = FALSE)