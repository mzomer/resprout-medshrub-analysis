
# ────────────────────────────────────────────────────────────────────────────────
# regression_models_garden.R - Resprouting success after repeated disturbance
# ────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted  data ------
df_repeated_success_garden <- readRDS(here::here("outputs", "data", "df_repeated_success_garden.rds"))


## Stepwise GLMMs -------

null <- glmer(success ~ 1 + (1 | site_name / plant_id),
              family = binomial, data = df_repeated_success_garden)

model1 <- glmer(success ~ biomass_pre + (1 | site_name / plant_id),
                family = binomial, data = df_repeated_success_garden)

model2 <- glmer(success ~ biomass_pre + cut + (1 | site_name / plant_id),
                family = binomial, data = df_repeated_success_garden)

model3 <- glmer(success ~ biomass_pre + water_treatment + (1 | site_name / plant_id),
                family = binomial, data = df_repeated_success_garden)

model4 <- glmer(success ~ biomass_pre + aridity_seed_provenance + (1 | site_name / plant_id),
                family = binomial, data = df_repeated_success_garden)



## Model comparison ----
anova(null, model1) #***
anova(model1, model2) #ns
anova(model1, model3) #ns
anova(model1, model4) #ns


## Residual diagnostics ----
simulateResiduals(model1, plot = TRUE) #good

## Summary of final model  -----
model_repeated_success_garden<- glmer(success ~ biomass_pre + (1 | site_name / plant_id),
                                      family = binomial, data = df_repeated_success_garden)

summary(model_repeated_success_garden)
anova(model_repeated_success_garden)

## Save model object ----
saveRDS(model_repeated_success_garden, here::here("outputs", "models", "model_repeated_success_garden.rds"))



