# ────────────────────────────────────────────────────────────────────────────────
# variance_components_field.R — Variance decomposition for field data
# ────────────────────────────────────────────────────────────────────────────────

# Load setup -----
source(here::here("scripts", "setup.R"))

# Load cleaned field datasets for SEM analyses -----
df_SEM_1_field <- readRDS(here::here("outputs", "data", "df_SEM_1_field.rds"))
df_SEM_2_field <- readRDS(here::here("outputs", "data", "df_SEM_2_field.rds"))


# Fit null models for variance partitioning -----

modPart1 <- lme(drybiomass_pre ~ 1, random = ~1 | species / site_name,
                data = df_SEM_1_field, na.action = na.omit)

modPart2 <- lme(success_1 ~ 1, random = ~1 | species / site_name,
                data = df_SEM_1_field, na.action = na.omit)

modPart3 <- lme(drybiomass_post ~ 1, random = ~1 | species / site_name,
                data = df_SEM_2_field, na.action = na.omit)

modPart4 <- lme(success_2 ~ 1, random = ~1 | species / site_name,
                data = df_SEM_2_field, na.action = na.omit)

# This function prints:
# - VarCorr() from nlme: raw variance at each level
# - varcomp() from ape: proportional variance across levels

print_variance <- function(model, label) {
  cat("\n─────────────────────────────────────────────\n")
  cat(paste("Model:", label), "\n")
  cat("Total Variance (VarCorr):\n")
  print(VarCorr(model))

  cat("\nRelative Variance (ape::varcomp):\n")
  print(ape::varcomp(model, scale = 1))
  cat("─────────────────────────────────────────────\n")
}

# Output model summaries (optional verbose output) ----
print_variance(modPart1, "1: drybiomass_pre")
print_variance(modPart2, "2: success_1")
print_variance(modPart3, "3: drybiomass_post")
print_variance(modPart4, "4: success_2")

# Save model objects -----
saveRDS(modPart1, "outputs/models/var_mod1_field.rds")
saveRDS(modPart2, "outputs/models/var_mod2_field.rds")
saveRDS(modPart3, "outputs/models/var_mod3_field.rds")
saveRDS(modPart4, "outputs/models/var_mod4_field.rds")

