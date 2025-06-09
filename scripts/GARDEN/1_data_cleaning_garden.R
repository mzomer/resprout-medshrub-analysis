# ─────────────────────────────────────────────────────────────────────
# data_cleaning_garden.R — Data wrangling for common garden experiment
# ─────────────────────────────────────────────────────────────────────

# Load Setup  ----
source(here::here("scripts", "setup.R"))

# Load Data ----
df_SEM_1_garden <- read.csv(here::here("data", "data_garden.csv"))

# Convert variables to appropriate types ----
df_SEM_1_garden <- df_SEM_1_garden %>%
  mutate(
    # Convert binomial outcomes to numeric (required for piecewiseSEM)
    success_1 = as.numeric(success_1),
    success_2 = as.numeric(success_2),

    # Factor variables
    water_treatment = factor(water_treatment),
    aridity_seed_provenance = factor(aridity_seed_provenance)
  )

# Histogram for visual check of normality
hist(df_SEM_1_garden$drybiomass_pre, main = "Pre-disturbance Biomass", xlab = "drybiomass_pre")
hist(df_SEM_1_garden$drybiomass_post, main = "Resprout vigour", xlab = "drybiomass_post")

# Sample size by treatment group ----
df_SEM_1_garden %>%
  count(aridity_seed_provenance, water_treatment)

# Subset: SEM 2 — only plants that successfully resprouted ----
df_SEM_2_garden <- df_SEM_1_garden %>%
  filter(success_1 == 1)



# Data Resprout Success with repeated disturbance -----

## Prepare long-format dataset  ----

df_repeated_success_garden <- df_SEM_1_garden %>%
  # Combine resprout success (cut 1 and cut 2)
  pivot_longer(
    cols = starts_with("success_"),
    names_to = "cut",
    values_to = "success"
  ) %>%
  mutate(
    cut = ifelse(cut == "success_1", 1, 2),

    # Combined pre-disturbance biomass
    biomass_pre = if_else(cut == 1, drybiomass_pre, drybiomass_post)
  ) %>%
  drop_na(biomass_pre)


# Ensure correct variable types
df_repeated_success_garden <- df_repeated_success_garden %>%
  mutate(
    cut = factor(cut),
    success = factor(success),
    water_treatment = factor(water_treatment, levels = c("Watered", "Drought")),
    aridity_seed_provenance = factor(aridity_seed_provenance)
  )

str(df_repeated_success_garden)


#Save data objects -----

saveRDS(df_SEM_1_garden, here::here("outputs", "data", "df_SEM_1_garden.rds"))
saveRDS(df_SEM_2_garden, here::here("outputs", "data", "df_SEM_2_garden.rds"))
saveRDS(df_repeated_success_garden, here::here("outputs", "data", "df_repeated_success_garden.rds"))

