library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)

#FUNCTIONS
convert_to_military_time <- function(standard_time) {
  # Parse the standard time using strptime
  time_obj <- strptime(standard_time, format = "%I:%M:%S %p")
  
  # Convert to military time (24-hour format)
  military_time <- format(time_obj, "%H:%M:%S")
  
  return(military_time)
}

remove_outliers <- function(data, column_name) {
  # Calculate Q1, Q3, and IQR
  Q1 <- quantile(data[[column_name]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[column_name]], 0.75, na.rm = TRUE)
  IQR_value <- IQR(data[[column_name]], na.rm = TRUE)
  
  # Define lower and upper bounds for outliers
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  
  # Filter out the outliers
  data_no_outliers <- data %>%
    filter(data[[column_name]] >= lower_bound & data[[column_name]] <= upper_bound)
  
  return(data_no_outliers)
}


#CLEANING DATA
data_path <- "data/processed/ECOLI_W_API.csv"
if (!file.exists(data_path)) {
  data_path <- file.path("..", "..", "data", "processed", "ECOLI_W_API.csv")
}
data <- read.csv(data_path)

#drop na columns
data <- data %>% select(-WINDGUST, -SOLARRADIATION, -SOLARENERGY, -UVINDEX)

#Seperating dates
data$SAMPLE_DATE <- mdy(data$SAMPLE_DATE)
data <- data %>% separate(SAMPLE_DATE, sep = "-", into=c("YEAR", "MONTH", "DAY"))
data <- data %>% select(-DAY)

#Convert to military
data$military_time <- convert_to_military_time(data$SAMPLE_TIME)
data <- data %>% separate(military_time, sep = ":", into=c("HOUR", "JUNK"))
table(data$HOUR)
data <- data %>% select(-JUNK, -SAMPLE_TIME)

#Remove outliers
data <- remove_outliers(data, "RESULT..MPN.100ML.")


#TIME SERIES ANALYSIS

#Year
ggplot(data, aes(x = YEAR, y = RESULT..MPN.100ML.)) +
  geom_boxplot()

yearly_concentration <- data %>%
  group_by(YEAR) %>%
  summarise(median_Concentration = median(RESULT..MPN.100ML., na.rm = TRUE))
yearly_concentration$Year <- as.factor(yearly_concentration$YEAR)

ggplot(yearly_concentration, aes(x = Year, y = median_Concentration)) +
  geom_line(group = 1) +   
  geom_point() +           
  ggtitle("Concentration Over the Years") +
  xlab("Year") +
  ylab("Median Concentration (MPN/100ML)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#Month
ggplot(data, aes(x = MONTH, y = RESULT..MPN.100ML.)) +
  geom_boxplot()

ggplot(data, aes(x = MONTH, y = RESULT..MPN.100ML.)) +
  stat_summary(fun = median, geom = "bar") +  # Calculate median and plot as bars
  ggtitle("Concentration Over Months Across All Years") +
  xlab("Month") +
  ylab("Median Concentration (MPN/100ML)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(data, aes(x = MONTH, y = RESULT..MPN.100ML.)) +
  stat_summary(fun = median, geom = "bar") +  # Calculate median and plot as bars
  ggtitle("Concentration Over Months and Year") +
  xlab("Month") +
  ylab("Median Concentration (MPN/100ML)") +
  theme_minimal() +
  facet_wrap(~YEAR, scales = "free_y") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#Hour
ggplot(data, aes(x = HOUR, y = RESULT..MPN.100ML.)) +
  geom_boxplot()

hourly_concentration <- data %>%
  group_by(HOUR) %>%
  summarise(median_Concentration = median(RESULT..MPN.100ML., na.rm = TRUE), count = n())

ggplot(data, aes(x = HOUR, y = RESULT..MPN.100ML.)) +
  stat_summary(fun = median, geom = "bar", size = 1) +  # Bar plot with mean concentration
  ggtitle("Median Concentration by Hour of the Day") +
  xlab("Hour of the Day") +
  ylab("Median Concentration (MPN/100ML)") +
  theme_minimal()

ggplot(data, aes(x = HOUR, y = RESULT..MPN.100ML.)) +
  stat_summary(fun = median, geom = "bar", size = 1) +  # Bar plot with mean concentration
  ggtitle("Median Concentration by Hour of the Day and Month") +
  xlab("Hour of the Day") +
  ylab("Median Concentration (MPN/100ML)") +
  theme_minimal() +
  facet_wrap(~MONTH)

