# 📊 Empirical Macroeconomics Project

> Empirical analysis of macroeconomic relationships using time-series econometrics — examining business cycle dynamics, monetary transmission, and macro-financial linkages with real-world data.

---

## Overview

This project applies **empirical macroeconomics** techniques to test and quantify relationships between key macro variables. Using publicly available data from sources such as the RBI, FRED, World Bank, and IMF, it implements modern time-series methods — VAR models, cointegration tests, and impulse-response analysis — to draw evidence-backed conclusions about the macro economy.

---

## Research Questions

1. How does monetary policy (repo rate) transmit to output and inflation in India?  
2. Is there a long-run relationship between fiscal deficits and interest rates?  
3. What are the dynamic effects of global commodity shocks on domestic inflation?  
4. Do financial conditions (credit spreads, equity indices) lead real economic activity?  

---

## Methodology

| Method | Purpose |
|---|---|
| **ADF / KPSS / PP Tests** | Unit-root and stationarity testing |
| **Johansen Cointegration** | Long-run equilibrium relationships |
| **VAR / SVAR** | Multivariate dynamic modelling |
| **Impulse-Response Functions** | Shock transmission & propagation |
| **Forecast Error Variance Decomposition** | Attribution of variation across variables |
| **Granger Causality** | Directional predictive relationships |
| **ARIMA / SARIMA** | Univariate forecasting baselines |

---

## Data Sources

| Dataset | Source | Frequency |
|---|---|---|
| CPI Inflation | MOSPI / RBI | Monthly |
| Repo Rate | RBI DBIE | Monthly |
| GDP / GVA | MOSPI | Quarterly |
| Fiscal Deficit | CGA, India | Quarterly |
| WPI / Global Commodity Prices | World Bank | Monthly |
| Exchange Rate (INR/USD) | RBI | Daily/Monthly |

---

## Project Structure

```
Empirical-Macro-Project/
├── data/
│   ├── raw/                  # Downloaded datasets (CSV / XLSX)
│   └── processed/            # Cleaned, merged time series
├── notebooks/
│   ├── 01_data_preparation.ipynb
│   ├── 02_descriptive_analysis.ipynb
│   ├── 03_unit_root_tests.ipynb
│   ├── 04_var_model.ipynb
│   ├── 05_irf_fevd.ipynb
│   └── 06_forecasting.ipynb
├── src/
│   ├── data_loader.py
│   ├── stationarity.py
│   ├── var_analysis.py
│   └── visualisation.py
├── reports/
│   └── empirical_macro_report.pdf
├── requirements.txt
└── README.md
```

---

## Quickstart

```bash
# 1. Clone the repo
git clone https://github.com/anujpanwarma2024/Empirical-Macro-Project.git
cd Empirical-Macro-Project

# 2. Set up environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Explore the notebooks in order
jupyter notebook notebooks/
```

---

## Key Findings

- Monetary policy shocks have a **significant but lagged** (2–3 quarter) effect on CPI inflation in India.  
- Evidence of **cointegration** between fiscal deficits and the yield on 10-year G-secs.  
- Global commodity price shocks explain ~30% of domestic WPI variance at a 6-month horizon.  
- Credit spreads exhibit **Granger-causality** towards industrial output with a 1-quarter lead.  

---

## References

- Bernanke, B. & Blinder, A. (1992). *The Federal Funds Rate and the Channels of Monetary Transmission.*  
- Sims, C. A. (1980). *Macroeconomics and Reality.* Econometrica.  
- RBI Handbook of Statistics on Indian Economy — [rbi.org.in](https://rbi.org.in)  
- Hamilton, J. D. (1994). *Time Series Analysis.* Princeton University Press.

---

## Author

**Anuj Panwar** · [GitHub](https://github.com/anujpanwarma2024)
