#Uncomment if local
#install.packages("dplyr")
library(dplyr)
library(tidyr)

#Change path to csv
data <- read.csv("C:\\Users\\adisr\\Downloads\\ECOLI_BATCTERIA_2013-PRESENT_20250228.csv")

#Orig data
head(data)

#Rename/Reorder
clean <- data %>% select("WATERSHED", "SAMPLE_DATE", "SITE_TYPE", "LON_DD_WGS84", "LAT_DD_WGS84", "RESULT")
clean <- clean %>% rename("LONGITUDE" = "LON_DD_WGS84", "LATITUDE" = "LAT_DD_WGS84", "RESULT (MPN/100ML)" = "RESULT")
clean <- clean %>% select("LONGITUDE", "LATITUDE", "SAMPLE_DATE", "WATERSHED", "SITE_TYPE", "RESULT (MPN/100ML)")

#Split time and date
clean <- clean %>% separate(SAMPLE_DATE, into = c("SAMPLE_DATE", "SAMPLE_TIME"), sep = " ", extra = "merge")

head(clean)
write.csv(clean, "C:\\Users\\adisr\\Downloads\\ECOLI_CLEAN.csv", row.names = FALSE)
