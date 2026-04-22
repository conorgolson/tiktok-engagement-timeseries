# TikTok Engagement Time Series Analysis

## Overview
This project investigates whether external chess-related interest—measured using Google Trends, Chess.com activity, and Lichess activity—can predict TikTok engagement. Engagement is measured through weekly views and follower growth.

The analysis applies basic time series econometrics techniques, focusing on simplicity and interpretability given a relatively small sample size.

---

## Research Question
Do external measures of chess interest predict changes in TikTok engagement?

---

## Data
The dataset consists of weekly observations including:

- TikTok views
- TikTok follower growth
- Posting frequency
- Google Trends index for:
     - "chess"
     - "chess.com" 
     - "lichess"


All variables are aggregated to a weekly frequency.

---

## Methodology
The analysis follows a standard time series workflow:

1. Data cleaning and merging
2. Weekly aggregation of all variables
3. Visualization of time series patterns
4. Stationarity testing using Augmented Dickey-Fuller (ADF) tests
5. First differencing of dependent variables to address non-stationarity
6. Regression analysis with lagged explanatory variables
7. Model diagnostics using ACF plots and Ljung-Box tests

---

## Model Specification

The baseline model is:

ΔYₜ = α + βXₜ₋₁ + γZₜ + εₜ

Where:
- Yₜ = engagement (views or followers)
- Xₜ₋₁ = lagged external chess interest variables
- Zₜ = posting frequency

---

## Results

- Posting frequency is a strong and statistically significant predictor of both views and follower growth.
- External chess interest variables (Google Trends, Chess.com, Lichess) are not statistically significant predictors.
- Results are robust to inclusion of lagged dependent variables.
- Residual diagnostics indicate no substantial autocorrelation, suggesting the model is adequately specified.

---

## Key Insight

Engagement appears to be driven primarily by content production (posting activity) rather than external demand signals such as search interest.

---

## Project Structure

```
tiktok-engagement-timeseries/
│
├── data/
│   ├── viewers_weekly.csv
│   ├── followers_weekly.csv
│   ├── posts_weekly.csv
│   └── trends_weekly.csv
│
├── script/
│   └── analysis.R
│
├── output/
│   └── final_dataset.csv
│
└── README.md
```

---

## How to Run

1. Download or clone this repository  
2. Ensure the folder structure is preserved when downloading or cloning the repository   
3. Open script/analysis.R  
4. Install required packages:
   install.packages(c("tidyverse", "lubridate", "tseries"))  
5. Run the script from top to bottom  

**Note:** The script assumes the working directory is set to the project root folder.

---

## Author

**Conor Golson**
