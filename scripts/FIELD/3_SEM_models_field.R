# ────────────────────────────────────────────────────────────────
# SEM_models_field.R — Piecewise SEMs for field data
# ────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Detach lmerTest to avoid psem conflicts (object 'ret' not found)
if ("package:lmerTest" %in% search()) {
  detach("package:lmerTest", unload = TRUE)
}

# Load cleaned and subsetted field data ------
df_SEM_1_field <- readRDS(here::here("outputs", "data", "df_SEM_1_field.rds"))
df_SEM_2_field <- readRDS(here::here("outputs", "data", "df_SEM_2_field.rds"))


# SEM 1 — Resprouting success after first disturbance ------

## Hypothesis model -----

SEM_1_field_hypothesis <- psem(
  lmer(drybiomass_pre_log_sc ~ aridity_sc + soil_nitrogen_sc + fire_activity_sc + ysf_sc + (1 | site_number),
       na.action = na.omit, data = df_SEM_1_field),

  glmer(success_1 ~ drybiomass_pre_log_sc + rainfall_post_2018_sc + (1 | site_number),
        family = binomial, na.action = na.omit, data = df_SEM_1_field,
        control = glmerControl(optimizer = "bobyqa")),

  data = df_SEM_1_field # data term required for multigroup function
)

summary(SEM_1_field_hypothesis, .progressBar = FALSE) # Fit p = 0.029
multigroup(SEM_1_field_hypothesis, group = "species", standardize = "scale") # No significant multigroup differences


## Final model -----
  # remove non-significant predictors ysf (model 1) and rainfall post 2018 (model 2)
  # success 1 ~ pre-disturbance biomass pathway is not significant either, but maintain for continuity with SEM 2
  # model fit improved to p=0.42

SEM_1_field_final <- psem(
  lmer(drybiomass_pre_log_sc ~ aridity_sc + fire_activity_sc + soil_nitrogen_sc + (1 | site_name),
       na.action = na.omit, data = df_SEM_1_field),

  glmer(success_1 ~ drybiomass_pre_log_sc + (1 | site_name),
        family = binomial, na.action = na.omit, data = df_SEM_1_field,
        control = glmerControl(optimizer = "bobyqa")),

  data = df_SEM_1_field
)

summary(SEM_1_field_final, .progressBar = FALSE)
multigroup(SEM_1_field_final, group = "species", standardize = "scale") # No significant multigroup differences


## Residual diagnostics -----

#model 1
plot(simulateResiduals(SEM_1_field_final[[1]], re.form = NULL)) # good (conditioned on random effects)
testDispersion(SEM_1_field_final[[1]]) #good

#model 2
plot(simulateResiduals(SEM_1_field_final[[2]], re.form = NULL)) # good (conditioned on random effects)
testDispersion(SEM_1_field_final[[2]]) #good


# SEM 2 — Resprouting vigour and success after second disturbance ------

### Hypothesis model ----

SEM_2_field_hypothesis <- psem(
  lmer(drybiomass_pre_log_sc ~ aridity_sc + soil_nitrogen_sc + fire_activity_sc + ysf_sc + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_field),

  lmer(drybiomass_post_log_sc ~ drybiomass_pre_log_sc + rainfall_post_2018_sc + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_field),

  glmer(success_2 ~ drybiomass_post_log_sc + rainfall_post_2020_sc + (1 | site_name),
        family = binomial, na.action = na.omit, data = df_SEM_2_field,
        control = glmerControl(optimizer = "bobyqa")),

  data = df_SEM_2_field
)

summary(SEM_2_field_hypothesis, .progressBar = FALSE)
multigroup(SEM_2_field_hypothesis, group = "species", standardize = "scale")
# Note: NA warning is due to 29 plants that were not relocated for assessment of resprout success after Cut 2.
# These individuals are excluded from the success_2 model via na.action = na.omit and can be safely ignored.


# Remove temporally implausible path (pre-cut 1 biomass → success_2)
summary(update(SEM_2_field_hypothesis, success_2 %~~% drybiomass_pre_log_sc), .progressBar = FALSE)
multigroup(update(SEM_2_field_hypothesis, success_2 %~~% drybiomass_pre_log_sc), group = "species", standardize = "scale")


## Final model -----
  # test interactions between historical variables (ns)
  # remove rainfall 2018 (model 2) and rainfall 2020 (model 3) (ns for both species) & rerun hypothesis model
  # remove ysf (model 1) & rerun model
  # add pathway in model 2: vigour ~ aridity (dsep shows marginal significance 0.59)
  # vigour ~ aridity improves model AIC and multigroup model fit (p = 0.82), and has significant interaction with species

SEM_2_field_final <- psem(
  lmer(drybiomass_pre_log_sc ~ aridity_sc + fire_activity_sc + soil_nitrogen_sc + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_field),

  lmer(drybiomass_post_log_sc ~ drybiomass_pre_log_sc + aridity_sc + (1 | site_name),
       na.action = na.omit, data = df_SEM_2_field),

  glmer(success_2 ~ drybiomass_post_log_sc + (1 | site_name),
        family = binomial, na.action = na.omit, data = df_SEM_2_field,
        control = glmerControl(optimizer = "bobyqa")),

  data = df_SEM_2_field
)

# Remove temporally implausible path (pre-cut 1 biomass → success_2)
summary(update(SEM_2_field_final, success_2 %~~% drybiomass_pre_log_sc), .progressBar = FALSE)
multigroup(update(SEM_2_field_final, success_2 %~~% drybiomass_pre_log_sc), group = "species", standardize = "scale")


### Residual diagnostics -----

#model 1
plot(simulateResiduals(SEM_2_field_final[[1]], re.form = NULL)) # good (conditioned on random effects)
testDispersion(SEM_2_field_final[[1]])

#model 2
plot(simulateResiduals(SEM_2_field_final[[2]], re.form = NULL)) # KS p = 0.017, some QQ deviation
testDispersion(SEM_2_field_final[[2]]) #good

# fit model 2 separately to check with aridity:species interaction (for visual/diagnostic check)
model2_int <- lmer(drybiomass_post_log_sc ~ drybiomass_pre_log_sc + aridity_sc * species + (1 | site_name),
                   na.action = na.omit, data = df_SEM_2_field)
simulateResiduals(model2_int, plot = TRUE, re.form = NULL) #OK, only slight QQ deviation, # KS p = 0.043

#model 3
plot(simulateResiduals(SEM_2_field_final[[3]], re.form = NULL)) # good (conditioned on random effects)
testDispersion(SEM_2_field_final[[3]])


















