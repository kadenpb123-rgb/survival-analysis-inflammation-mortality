# =============================================================================
# 02_descriptive_stats.R
# Baseline characteristics stratified by survival status
# =============================================================================

# Load packages
library(tidyverse)
library(tableone)

# -----------------------------------------------------------------------------
# Create Table 1: Baseline characteristics by survival status
# -----------------------------------------------------------------------------

table_vars <- c("sex", "Age.enrollment", "educ", "DSST", 
                "Z.bmi", "Z.sysbp", "log.il6", "log.new.hscrp")

table1 <- CreateTableOne(
  vars = table_vars, 
  strata = "Alive", 
  data = data, 
  test = FALSE
)

print(table1, showAllLevels = TRUE)

# -----------------------------------------------------------------------------
# Summary statistics
# -----------------------------------------------------------------------------

cat("\n=== Sample Summary ===\n")
cat("Total N:", nrow(data), "\n")
cat("Deaths:", sum(data$event == 1, na.rm = TRUE), "\n")
cat("Alive:", sum(data$event == 0, na.rm = TRUE), "\n")
cat("Follow-up time (years):\n")
cat("  Mean:", round(mean(data$time, na.rm = TRUE), 1), "\n")
cat("  Median:", round(median(data$time, na.rm = TRUE), 1), "\n")
cat("  Range:", round(min(data$time, na.rm = TRUE), 1), "-", 
    round(max(data$time, na.rm = TRUE), 1), "\n")

# -----------------------------------------------------------------------------
# IL-6 distribution by survival status
# -----------------------------------------------------------------------------

cat("\n=== Log-IL6 by Survival Status ===\n")
data %>%
  group_by(Alive) %>%
  summarise(
    n = n(),
    mean = round(mean(log.il6, na.rm = TRUE), 2),
    sd = round(sd(log.il6, na.rm = TRUE), 2),
    median = round(median(log.il6, na.rm = TRUE), 2),
    q25 = round(quantile(log.il6, 0.25, na.rm = TRUE), 2),
    q75 = round(quantile(log.il6, 0.75, na.rm = TRUE), 2)
  ) %>%
  print()
