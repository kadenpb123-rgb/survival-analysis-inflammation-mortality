# IL-6 and Mortality in Aging Adults

A survival analysis examining the association between systemic inflammation (IL-6) and all-cause mortality in a longitudinal cohort of older adults.

## Research Question

Is elevated interleukin-6 (IL-6) associated with increased mortality risk, independent of demographic, physiological, and cognitive factors?

## Key Findings

- **Crude HR:** 2.02 (95% CI: 1.94–2.10) per unit increase in log-IL6
- **Adjusted HR:** 1.30 (95% CI: 1.22–1.39) after controlling for confounders
- Substantial confounding by age, sex, cognitive function, and body composition
- Kaplan-Meier curves showed significantly lower survival in high IL-6 group (log-rank p < 0.001)

## Methods

- **Design:** Longitudinal cohort study with ~8 years follow-up
- **Sample:** 4,581 adults (1,260 deaths, 3,315 alive at follow-up)
- **Primary Exposure:** Log-transformed IL-6
- **Outcome:** All-cause mortality
- **Analysis:** Cox proportional hazards regression

### Covariates
- Age at enrollment
- Sex
- Years of education
- BMI (z-score)
- Systolic blood pressure (z-score)
- Digit Symbol Substitution Test (DSST) score

## Repository Structure
```
survival-analysis-inflammation-mortality/
├── README.md
├── scripts/
│   ├── 01_data_prep.R
│   ├── 02_descriptive_stats.R
│   ├── 03_cox_regression.R
│   └── 04_figures.R
└── reports/
    └── BS852_Final_Project.pdf
```

## Tools Used

- **R** (version 4.5.1)
- **Packages:** survival, survminer, tableone, tidyverse

## Author

Kaden Bailey  
MS Applied Biostatistics Candidate, Boston University

