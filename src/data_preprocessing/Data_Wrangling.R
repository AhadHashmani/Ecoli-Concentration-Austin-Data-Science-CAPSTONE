#Uncomment if local
#install.packages("dplyr")
library(dplyr)
library(tidyr)

# Repo-root path, with a fallback when the working directory is this script's folder.
raw_path <- "data/raw/ECOLI_BACTERIA_2013-PRESENT.csv"
out_path <- "data/processed/ECOLI_CLEAN.csv"
if (!file.exists(raw_path)) {
  raw_path <- file.path("..", "..", "data", "raw", "ECOLI_BACTERIA_2013-PRESENT.csv")
  out_path <- file.path("..", "..", "data", "processed", "ECOLI_CLEAN.csv")
}

data <- read.csv(raw_path)

#Orig data
head(data)

#Rename/Reorder
clean <- data %>% select("WATERSHED", "SAMPLE_DATE", "SITE_TYPE", "LON_DD_WGS84", "LAT_DD_WGS84", "RESULT")
clean <- clean %>% rename("LONGITUDE" = "LON_DD_WGS84", "LATITUDE" = "LAT_DD_WGS84", "RESULT (MPN/100ML)" = "RESULT")
clean <- clean %>% select("LONGITUDE", "LATITUDE", "SAMPLE_DATE", "WATERSHED", "SITE_TYPE", "RESULT (MPN/100ML)")

#Split time and date
clean <- clean %>% separate(SAMPLE_DATE, into = c("SAMPLE_DATE", "SAMPLE_TIME"), sep = " ", extra = "merge")

head(clean)
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
write.csv(clean, out_path, row.names = FALSE)
