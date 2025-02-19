#K.Terlizzi 
#09.19.2024
#Cleaning BRF pellet count data from 2014 to 2024

#load packages

library(dplyr)

#load data

pellet <- read.csv("your file path")

#2024 data was collected on FieldMaps and therefore the "reader" column is filled with a different code than previous years

pellet_readers <- pellet %>%
  mutate (reader = ifelse(reader == "kterlizzi_BRF", "KT", reader))

pellet_readers <- pellet_readers %>%
  mutate (reader = ifelse(reader == "aculotta_BRF", "AC", reader))

pellet_readers <- pellet_readers %>%
  mutate (reader = ifelse (reader == "slapoint2", "SL", reader))

#Data collected by AC in 2024 were on paper. Dates in this file refer to the date it was entered into the computer not the actual observation date.
#This needs to be changed if an accurate density measurement is to be calculated

pellet_dates <- pellet_readers %>%
  mutate(date = ifelse(reader == "AC" & year == 2024 & transectID == "A", "2024-03-27", date))

pellet_dates <- pellet_dates %>%
  mutate(date = ifelse(reader == "AC" & year == 2024 & transectID == "D", "2024-03-27", date))

pellet_dates <- pellet_readers %>%
  mutate(date = ifelse(reader == "AC" & year == 2024 & transectID == "U", "2024-03-22", date))

pellet_dates <- pellet_readers %>%
  mutate(date = ifelse(reader == "AC" & year == 2024 & transectID == "V", "2024-03-27", date))

#Transect D in 2024 was done in the field on paper by BS but recorded in the computer by AC. "reader" needs to be changed from AC to BS

pellet_BS <- pellet_dates %>%
  mutate(reader = ifelse(year == 2024 & transectID == "D", "BS", reader))

#need to fill in blank "transect.location" for transects with an transectID
#first load the .csv with transect locations

transect_info <- read.csv("C:/Users/KatieTerlizzi/OneDrive - Black Rock Forest/Shared Documents - Data/Animals/Mammals/Deer Data/Pellet Count Survey Data/transect start and end points.csv", header = TRUE)


pellet_locations <- pellet_BS %>%
  left_join(transect_info, by = "transectID") %>%
  mutate(transect.location.x = ifelse(is.na(transect.location.x) | transect.location.y == "", 
                                     transect.location.y, 
                                     transect.location.x)) %>%
  select(-transect.location.y)

#Rename transect.location.x back to transect.location

pellet_locations <- pellet_locations %>%
  rename(transect.location = transect.location.x)

#need to remove %M:%H:%S from the date

pellet_nohour <- pellet_locations %>%
  mutate(date = as.Date(date))

#Remove any points where pellet.count is blank or NA. Some observers used "999" when a point could not be accessed and was not surveyed. These should be removed

pellet_clean <- pellet_nohour %>%
  filter(!is.na(pellet.count) & pellet.count != "" & pellet.count != "999")



#Write .csv

write.csv (pellet_clean, "your file path", row.names = FALSE)
