# ────────────────────────────────────────────────────────────────────────────────
# variance_components_garden.R — Variance decomposition for garden data
# ────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted field data ------
df_SEM_1_garden <- readRDS(here::here("outputs", "data", "df_SEM_1_garden.rds"))
df_SEM_2_garden <- readRDS(here::here("outputs", "data", "df_SEM_2_garden.rds"))


# Fit null models for variance partitioning -----

modPart1 <- lme(drybiomass_pre ~ 1, random = ~1 | water_treatment/aridity_seed_provenance,
                data = df_SEM_1_garden, na.action = na.omit)

modPart2 <- lme(success_1 ~ 1, random = ~1 | water_treatment/aridity_seed_provenance,
                data = df_SEM_1_garden, na.action = na.omit)

modPart3 <- lme(drybiomass_post ~ 1, random = ~1 | water_treatment/aridity_seed_provenance,
                data = df_SEM_2_garden, na.action = na.omit)

modPart4 <- lme(success_2 ~ 1, random = ~1 | water_treatment/aridity_seed_provenance,
                data = df_SEM_2_garden, na.action = na.omit)


# Function to display variance components -----
#
# - Total Variance:
#     Calculated using nlme::VarCorr(). This gives the raw variance estimates at each level.
#     The "Residual" value represents **within-group variance** — i.e., variation among individual plants
#     within the same site and species.
#
# - Relative Variance:
#     Calculated using ape::varcomp(). This expresses variance as proportions of the total.
#     For example:
#         species   = between-species variance
#         site_name = between-site variance (nested within species)
#         Within    = residual (among-individuals within site/species)

print_variance <- function(model, label) {
  cat("\n─────────────────────────────────────────────\n")
  cat(paste("Model:", label), "\n")
  cat("Total Variance (VarCorr):\n")
  print(VarCorr(model))

  cat("\nRelative Variance (ape::varcomp):\n")
  print(ape::varcomp(model, scale = 1))
  cat("─────────────────────────────────────────────\n")
}

# Output results -------
print_variance(modPart1, "1: drybiomass_pre")
print_variance(modPart2, "2: success_1")
print_variance(modPart3, "3: drybiomass_post")
print_variance(modPart4, "4: success_2")


# Save model objects -----
saveRDS(modPart1, "outputs/models/var_mod1_garden.rds")
saveRDS(modPart2, "outputs/models/var_mod2_garden.rds")
saveRDS(modPart3, "outputs/models/var_mod3_garden.rds")
saveRDS(modPart4, "outputs/models/var_mod4_garden.rds")

