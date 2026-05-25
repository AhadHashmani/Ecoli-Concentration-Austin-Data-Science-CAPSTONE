#Download, upload, and import "ECOLI_W_API.csv" to RStudio from previous data cleaning steps

# Visualization Code
install.packages("ggplot2")
library(ggplot2)

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