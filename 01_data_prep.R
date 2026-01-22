# =============================================================================
# 01_data_prep.R
# Data preparation and cleaning for IL-6 mortality analysis
# =============================================================================

# Load packages
library(tidyverse)
library(survival)

# -----------------------------------------------------------------------------
# Load data
# -----------------------------------------------------------------------------
data <- read.csv("project.2025.csv")

# Examine structure
str(data)
summary(data)

# -----------------------------------------------------------------------------
# Create analysis variables
# -----------------------------------------------------------------------------

# Event indicator: 1 = death, 0 = alive at last contact
data$event <- ifelse(data$Alive == "Yes", 0, 1)

# Survival time: years from enrollment to last contact
data$time <- data$Age.last.contact - data$Age.enrollment

# Create survival object
surv_obj <- Surv(time = data$time, event = data$event)

# -----------------------------------------------------------------------------
# Define model variables
# -----------------------------------------------------------------------------

# Primary predictor
main_predictor <- "log.il6"

# Covariates for adjusted model
covariates <- c("sex", "Age.enrollment", "educ", "Z.bmi", "Z.sysbp", "DSST")

# Variables for descriptive table
table_vars <- c("sex", "Age.enrollment", "educ", "DSST", 
                "Z.bmi", "Z.sysbp", "log.il6", "log.new.hscrp")

# -----------------------------------------------------------------------------
# Check missing data
# -----------------------------------------------------------------------------
cat("\nMissing data summary:\n")
sapply(data[, c(main_predictor, covariates)], function(x) sum(is.na(x)))

# Complete case count for adjusted analysis
complete_cases <- data %>%
  select(all_of(c(main_predictor, covariates, "event", "time"))) %>%
  na.omit() %>%
  nrow()

cat("\nComplete cases for adjusted analysis:", complete_cases, "\n")
cat("Missing:", nrow(data) - complete_cases, 
    "(", round((nrow(data) - complete_cases) / nrow(data) * 100, 1), "%)\n")

# -----------------------------------------------------------------------------
# Save prepared data
# -----------------------------------------------------------------------------
# save(data, surv_obj, main_predictor, covariates, table_vars, 
#      file = "output/prepared_data.RData")
