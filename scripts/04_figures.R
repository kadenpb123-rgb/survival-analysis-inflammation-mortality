# =============================================================================
# 04_figures.R
# Kaplan-Meier curves and forest plots for IL-6 mortality analysis
# =============================================================================

# Load packages
library(tidyverse)
library(survival)
library(survminer)

# -----------------------------------------------------------------------------
# Create IL-6 groups for Kaplan-Meier
# -----------------------------------------------------------------------------

# Median split for visualization
data$il6_group <- ifelse(
  data$log.il6 > median(data$log.il6, na.rm = TRUE), 
  "High IL-6", 
  "Low IL-6"
)

# Fit survival curves by IL-6 group
fit <- survfit(surv_obj ~ il6_group, data = data)

# -----------------------------------------------------------------------------
# Figure 1: Kaplan-Meier Survival Curves
# -----------------------------------------------------------------------------

km_plot <- ggsurvplot(
  fit, 
  data = data,
  pval = TRUE,                    # Show log-rank p-value
  risk.table = TRUE,              # Show number at risk
  risk.table.height = 0.25,
  palette = c("#E41A1C", "#377EB8"),
  legend.title = "IL-6 Level",
  legend.labs = c("High IL-6", "Low IL-6"),
  xlab = "Time (years)",
  ylab = "Survival Probability",
  title = "Kaplan-Meier Survival Curves by IL-6 Level",
  ggtheme = theme_bw(),
  font.main = c(14, "bold"),
  font.x = c(12),
  font.y = c(12),
  font.tickslab = c(10)
)

print(km_plot)

# Save figure
# ggsave("output/figures/km_survival_curve.png", 
#        plot = print(km_plot), 
#        width = 10, height = 8, dpi = 300)

# -----------------------------------------------------------------------------
# Figure 2: Forest Plot of Adjusted Hazard Ratios
# -----------------------------------------------------------------------------

forest_plot <- ggforest(
  cox_adj, 
  data = data,
  main = "Adjusted Hazard Ratios for All-Cause Mortality",
  fontsize = 0.9
)

print(forest_plot)

# Save figure
# ggsave("output/figures/forest_plot.png", 
#        plot = forest_plot, 
#        width = 10, height = 8, dpi = 300)

# -----------------------------------------------------------------------------
# Optional: Additional visualizations
# -----------------------------------------------------------------------------

# IL-6 distribution by survival status
il6_dist_plot <- ggplot(data, aes(x = log.il6, fill = Alive)) +
  geom_density(alpha = 0.5) +
  scale_fill_manual(
    values = c("No" = "#E41A1C", "Yes" = "#377EB8"),
    labels = c("Deceased", "Alive")
  ) +
  labs(
    x = "Log-transformed IL-6",
    y = "Density",
    fill = "Survival Status",
    title = "Distribution of IL-6 by Survival Status"
  ) +
  theme_bw() +
  theme(legend.position = "bottom")

print(il6_dist_plot)

# ggsave("output/figures/il6_distribution.png", 
#        plot = il6_dist_plot, 
#        width = 8, height = 6, dpi = 300)
