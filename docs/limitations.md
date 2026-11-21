# Limitations & Future Work

## Limitations

1. **Geographic bias:** Certain watersheds are sampled more often, and most rows are streams. Other site types are sparse, so site can confound a weather-only model.
2. **Temporal bias:** Samples concentrated in some seasons can make a seasonal pattern look stronger than the underlying change in the creeks.
3. **Preprocessing order:** In the classification notebooks, mean imputation and correlation-based feature selection run on the full table before the train/test split. That leakage check is still open.
4. **Class balance depends on the cutoff:** The notebooks label a row unsafe at 100 MPN/100 mL (1,934 of 3,832 rows). A high-event cutoff above 3,000 MPN/100 mL leaves 56 positive rows.
5. **Missing variables:** Land use, pollution sources, and water flow are not in the table.
6. **API failures:** 5 of 3,832 weather requests failed during the original pull. The enriched file in `data/processed/` is the table used downstream.

## Future Work

- Incorporate land-use and zoning data
- Map upstream pollution sources
- Develop real-time prediction system
- Time-series models (ARIMA, Prophet)
- Ensemble methods with hydrological variables
