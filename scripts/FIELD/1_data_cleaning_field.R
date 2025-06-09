
# ────────────────────────────────────────────────────────────────
# data_cleaning_field.R — Data wrangling for field experiment
# ────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load Data -----
data_field   <- read.csv(here::here("data", "data_field.csv"))
sites_field  <- read.csv(here::here("data", "sites_field.csv"))
df_NSC  <- read.csv(here::here("data", "data_rootNSC.csv"))

# Data SEM -----

# Convert variables to appropriate types
data_field <- data_field %>%
  mutate(
    species            = factor(species),
    site_number        = factor(site_number),
    site_name          = factor(site_name),
    height_post        = as.numeric(height_post),
    crown_length_post  = as.numeric(crown_length_post),
    crown_width_post   = as.numeric(crown_width_post)
  )

# Merge plant-level and site-level data
df_all <- merge(data_field, sites_field, by = c("site_number", "site_name", "species"))

# Scale and center environmental variables
df_all <- df_all %>%
  mutate(
    aridity_sc             = scale(aridity),
    fire_activity_sc       = scale(fire_activity),
    ysf_sc                 = scale(ysf),
    soil_nitrogen_sc       = scale(soil_nitrogen),
    soil_carbon_sc         = scale(soil_carbon),
    rainfall_post_2018_sc  = scale(rainfall_post_2018),
    rainfall_post_2020_sc  = scale(rainfall_post_2020)
  )

# Correlation of environmental predictors-----
corr_vars <- df_all %>%
  select(aridity_sc, fire_activity_sc, soil_nitrogen_sc,
         soil_carbon_sc, ysf_sc, rainfall_post_2018_sc, rainfall_post_2020_sc)

corrplot(cor(corr_vars), method = "number")  # Strong correlation: soil N & soil C

# Convert binomial outcomes to numeric (for piecewiseSEM compatibility)
df_all <- df_all %>%
  mutate(
    success_1 = as.numeric(success_1),
    success_2 = as.numeric(success_2)
  )

## Subset 1 — All plants (SEM 1) -----
df_SEM_1_field <- df_all %>%
  drop_na(success_1) %>%
  mutate(
    drybiomass_pre_log    = log(drybiomass_pre),
    drybiomass_pre_log_sc = as.vector(scale(drybiomass_pre_log))
  )

## Subset 2 — Only resprouted plants with post-disturbance biomass (SEM 2) -----
df_SEM_2_field <- df_all %>%
  drop_na(drybiomass_post) %>%
  mutate(
    drybiomass_pre_log     = log(drybiomass_pre),
    drybiomass_pre_log_sc  = as.vector(scale(drybiomass_pre_log)),
    drybiomass_post_log    = log(drybiomass_post),
    drybiomass_post_log_sc = as.vector(scale(drybiomass_post_log))
  )


# Data Resprout Success with repeated disturbance -----

## Prepare long-format dataset  -----

df_repeated_success_field <- df_SEM_1_field %>%

  #combined resprout success (cut 1 and cut 2)
  pivot_longer(
    cols = starts_with("success_"),
    names_to = "cut",
    values_to = "success"
  ) %>%
  mutate(
    cut = ifelse(cut == "success_1", 1, 2),

    #log transform and scale biomass
    drybiomass_post_log = log(drybiomass_post),
    drybiomass_post_log_sc = as.vector(scale(drybiomass_post_log)),

    # Combined pre-disturbance biomass
    biomass_pre_log = if_else(cut == 1, drybiomass_pre_log, drybiomass_post_log),
    biomass_pre_log_sc = as.vector(scale(biomass_pre_log)),

  ) %>%
  select(site_number, site_name, species, plant_id, success, cut,
         biomass_pre_log) %>%
  drop_na(biomass_pre_log)  # remove NAs for modeling

# Ensure correct variable types
df_repeated_success_field <- df_repeated_success_field %>%
  mutate(
    cut = factor(cut),
    species = factor(species, levels = c("ACY", "GAL")),
    success = factor(success)
  )

str(df_repeated_success_field)


# Data root NSC & Aridity -----

# Log-transform starch
df_NSC$starch_log <- log(df_NSC$starch)

# Ensure factors are correctly set
df_NSC$species     <- as.factor(df_NSC$species)
df_NSC$aridity <- as.factor(df_NSC$aridity)


#Save data objects -----

saveRDS(df_SEM_1_field, here::here("outputs", "data", "df_SEM_1_field.rds"))
saveRDS(df_SEM_2_field, here::here("outputs", "data", "df_SEM_2_field.rds"))
saveRDS(df_repeated_success_field, here::here("outputs", "data", "df_repeated_success_field.rds"))
saveRDS(df_NSC, here::here("outputs", "data", "df_NSC.rds"))

