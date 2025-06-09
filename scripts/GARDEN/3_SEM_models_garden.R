# ────────────────────────────────────────────────────────────────
# SEM_models_garden.R — Piecewise SEMs for common garden data
# ────────────────────────────────────────────────────────────────

# Load Setup ----
source(here::here("scripts", "setup.R"))

# Detach lmerTest to avoid psem conflicts
if ("package:lmerTest" %in% search()) {
  detach("package:lmerTest", unload = TRUE)
}

# Load cleaned and subsetted data ----
df_SEM_1_garden <- readRDS(here::here("outputs", "data", "df_SEM_1_garden.rds"))
df_SEM_2_garden <- readRDS(here::here("outputs", "data", "df_SEM_2_garden.rds"))


# SEM 1 — Pre-disturbance biomass and survival after first cut -----

SEM_1_garden <- psem(
  lmer(drybiomass_pre ~ water_treatment + aridity_seed_provenance + (1 | site_name),
       data = df_SEM_1_garden),

  glmer(success_1 ~ drybiomass_pre + water_treatment + aridity_seed_provenance + (1 | site_name),
        family = binomial, data = df_SEM_1_garden),

  data = df_SEM_1_garden
)

summary(SEM_1_garden, .progressBar = FALSE)


# Residual diagnostics — SEM 1
simulateResiduals(SEM_1_garden[[1]], plot = TRUE)
testDispersion(SEM_1_garden[[1]])

simulateResiduals(SEM_1_garden[[2]], plot = TRUE)
testDispersion(SEM_1_garden[[2]])



# SEM 2 — Resprouting vigour and success after second disturbance  --------

# Initial hypothesis model
SEM_2_garden <- psem(
  lmer(drybiomass_pre ~ water_treatment + aridity_seed_provenance + (1 | site_name),
       data = df_SEM_2_garden),

  lmer(drybiomass_post ~ drybiomass_pre + water_treatment + aridity_seed_provenance + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_garden),

  glmer(success_2 ~ water_treatment + aridity_seed_provenance + drybiomass_post + (1 | site_name),
        family = binomial, na.action = na.omit, data = df_SEM_2_garden),

  data = df_SEM_2_garden
)

summary(SEM_2_garden, .progressBar = FALSE)

# remove temporally implausible pathway
summary(update(SEM_2_garden, success_2 %~~% drybiomass_pre), .progressBar = FALSE)


# Final SEM 2 model -----
# Excludes the path success_2 ~ drybiomass_post (resprout vigour), which was not significant
# Retains aridity_seed_provenance in all sub-models: model fit is still strong and the non-significant result is important
#mto support the conclusion that there was no local adaptation

SEM_2_final_garden <- psem(
  lmer(drybiomass_pre ~ water_treatment + aridity_seed_provenance + (1 | site_name),
       data = df_SEM_2_garden),

  lmer(drybiomass_post ~ drybiomass_pre + water_treatment + aridity_seed_provenance + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_garden),

  glmer(success_2 ~ water_treatment + aridity_seed_provenance + (1 | site_name),
        family = binomial, na.action = na.omit, data = df_SEM_2_garden),

  data = df_SEM_2_garden
)

summary(SEM_2_final_garden, .progressBar = FALSE)

# Remove temporally implausible pathways
summary(update(SEM_2_final_garden,success_2 %~~% drybiomass_pre, drybiomass_post %~~% success_2), .progressBar = FALSE)

# Residual diagnostics — SEM 2
simulateResiduals(SEM_2_garden[[1]], plot = TRUE)
testDispersion(SEM_2_garden[[1]])

simulateResiduals(SEM_2_garden[[2]], plot = TRUE)
testDispersion(SEM_2_garden[[2]])

simulateResiduals(SEM_2_garden[[3]], plot = TRUE)
testDispersion(SEM_2_garden[[3]])

