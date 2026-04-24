# TikTok Engagement Time Series Analysis

## Overview
This project examines whether external chess related interest, measured using Google Trends, is associated with TikTok engagement. Engagement is measured through weekly views and follower growth.

The analysis applies basic time series econometrics techniques, focusing on simplicity and interpretability given a relatively small sample size.

## Implementation
- R (tidyverse, lubridate, tseries)

---

## Research Question
Are external measures of chess interest associated with changes in TikTok engagement?

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
7. Model comparison with and without posting controls  
8. Robustness checks using views-per-post normalization  
9. Model diagnostics using ACF plots and Ljung-Box tests  

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
- External chess interest variables are not statistically significant predictors of total views or follower growth in baseline specifications.  
- Results remain unchanged when posting controls are removed, suggesting findings are not driven by the inclusion of posting frequency.  
- When normalizing engagement using views per post, some external chess interest measures become statistically significant, indicating a potential relationship with engagement efficiency rather than total engagement.  
- Residual diagnostics indicate no substantial autocorrelation, suggesting the models are adequately specified.  

---

## Key Insight

Overall engagement appears to be primarily associated with content production (posting activity). However, external chess interest may be related to variation in engagement per post, suggesting that demand signals may influence content performance rather than overall activity levels.

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
