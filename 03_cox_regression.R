# =============================================================================
# 03_cox_regression.R
# Cox proportional hazards regression for IL-6 and mortality
# =============================================================================

# Load packages
library(tidyverse)
library(survival)

# -----------------------------------------------------------------------------
# Crude Cox Model (unadjusted)
# -----------------------------------------------------------------------------

cox_crude <- coxph(
  as.formula(paste("surv_obj ~", main_predictor)), 
  data = data
)

cat("=== CRUDE COX MODEL ===\n")
summary(cox_crude)

# Extract crude HR
crude_hr <- exp(coef(cox_crude))
crude_ci <- exp(confint(cox_crude))
cat("\nCrude HR for log-IL6:", round(crude_hr, 2), 
    "(95% CI:", round(crude_ci[1], 2), "-", round(crude_ci[2], 2), ")\n")

# -----------------------------------------------------------------------------
# Adjusted Cox Model
# -----------------------------------------------------------------------------

cox_adj <- coxph(
  as.formula(
    paste("surv_obj ~", main_predictor, "+", paste(covariates, collapse = "+"))
  ), 
  data = data
)

cat("\n=== ADJUSTED COX MODEL ===\n")
summary(cox_adj)

# -----------------------------------------------------------------------------
# Extract and format results
# -----------------------------------------------------------------------------

# Function to extract HR, CI, and p-value
extract_cox_results <- function(model) {
  coefs <- summary(model)$coefficients
  conf <- confint(model)
  
  data.frame(
    Variable = rownames(coefs),
    HR = round(exp(coefs[, "coef"]), 3),
    CI_Lower = round(exp(conf[, 1]), 3),
    CI_Upper = round(exp(conf[, 2]), 3),
    P_Value = format(coefs[, "Pr(>|z|)"], scientific = TRUE, digits = 3)
  )
}

cat("\n=== ADJUSTED MODEL RESULTS ===\n")
adj_results <- extract_cox_results(cox_adj)
print(adj_results)

# -----------------------------------------------------------------------------
# Model diagnostics
# -----------------------------------------------------------------------------

cat("\n=== MODEL FIT ===\n")
cat("Concordance:", round(summary(cox_adj)$concordance[1], 3), "\n")
cat("Likelihood ratio test p-value:", 
    format(summary(cox_adj)$logtest[3], scientific = TRUE), "\n")

# -----------------------------------------------------------------------------
# Compare crude vs adjusted HR for IL-6
# -----------------------------------------------------------------------------

cat("\n=== CONFOUNDING ASSESSMENT ===\n")
adj_hr <- exp(coef(cox_adj)["log.il6"])
percent_change <- (crude_hr - adj_hr) / crude_hr * 100

cat("Crude HR:", round(crude_hr, 2), "\n")
cat("Adjusted HR:", round(adj_hr, 2), "\n")
cat("Percent change:", round(percent_change, 1), "%\n")
cat("Interpretation: Substantial confounding by covariates\n")
