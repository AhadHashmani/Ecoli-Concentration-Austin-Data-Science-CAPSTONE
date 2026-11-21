# Visualization Code
library(ggplot2)

if (!exists("ECOLI_W_API")) {
  data_path <- "data/processed/ECOLI_W_API.csv"
  if (!file.exists(data_path)) {
    data_path <- file.path("..", "..", "data", "processed", "ECOLI_W_API.csv")
  }
  ECOLI_W_API <- read.csv(data_path, stringsAsFactors = FALSE)
}

#For Hexbin plot of Temperature vs. E. coli Concentration
ggplot(ECOLI_W_API, aes(x = TEMPERATURE, y = RESULT..MPN.100ML.)) +
  geom_hex() +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Hexbin Plot of Temperature vs. E. coli Concentration", 
       x = "Temperature (°F)", y = "E. coli Concentration (MPN/100 mL)") +
  theme_minimal()

#For Hexbin plot of Temperature vs. E. coli Concentration by Site Type
ggplot(ECOLI_W_API, aes(x = TEMPERATURE, y = RESULT..MPN.100ML.)) +
  geom_hex() +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Hexbin Plot of Temperature vs. E. coli Concentration by Site Type", 
       x = "Temperature (°F)", y = "E. coli Concentration (MPN/100 mL)") +
  theme_minimal() + 
  facet_wrap(~ SITE_TYPE)