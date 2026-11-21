# Methodology

## Data Collection

### E. coli Data
- **Source:** City of Austin Open Data Portal
- **Dataset:** ECOLI_BACTERIA_2013-PRESENT.csv
- **Observations:** 3,837 initial → 3,832 after cleaning
- **Variables:** Watershed, sample date/time, site type, coordinates, E. coli concentration (MPN/100 mL)
- **Time Period:** 2013–2025

### Weather Data
- **Source:** Visual Crossing Timeline Weather API
- **Variables Retrieved:** Temperature, humidity, precipitation, dew point, wind speed, pressure, cloud cover
- **Matching:** Based on latitude, longitude, and sample datetime

## Data Preprocessing Pipeline

### Stage 1-4: Data Cleaning
- Loaded raw dataset (3,837 × 23)
- Selected key variables: watershed, date, site type, coordinates, concentration
- Temporal decomposition into year, month, day, hour
- Quality control: removed 5 rows with missing values → 3,832 valid observations

### Stage 5: API Weather Enrichment
- Built R function: `get_weather_data(lat, lon, date, time, api_key)`
- Automated looping through all 3,832 observations
- Extracted 13 weather variables per observation
- Final dataset: ECOLI_W_API.csv (3,832 × 20)

## Exploratory Data Analysis

### Temporal Analysis
- Aggregated by year, month, hour using dplyr
- Computed medians (preferred over mean due to right-skew)
- Visualized with ggplot2 box plots and time series

### Spatial Analysis
- Created interactive maps using leaflet
- Circle markers scaled and colored by concentration
- Analyzed four representative watersheds (urban vs. rural)

### Relationship Analysis
- Hexagonal binning for temperature vs. E. coli
- Watershed-level Pearson correlations with humidity
- Stratified analysis by site type and season

## Predictive Modeling

### Models Tested
1. Linear Regression (baseline)
2. Ridge Regression (L2 regularization)
3. Random Forest (nonlinear, interactions)
4. Gradient Boosting (ensemble)

### Feature Engineering
- Standardized continuous variables
- One-hot encoded categoricals (site type, watershed, month)
- 80/20 train-test split

### Evaluation Metrics
- **Regression:** MSE, MAE, R²
- **Classification:** Precision, recall, F1 score
