
# ────────────────────────────────────────────────────────────────────────────────
# regression_models_field.R
# ────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted  data ------
df_NSC <- readRDS(here::here("outputs", "data", "df_NSC.rds"))
df_repeated_success_field <- readRDS(here::here("outputs", "data", "df_repeated_success_field.rds"))

# Root NSC under contrasting aridity levels  —-----

## Starch - Stepwise model selection -----
starch_null  <- lm(starch_log ~ 1, data = df_NSC)
starch_mod1  <- lm(starch_log ~ species, data = df_NSC)
starch_mod2  <- lm(starch_log ~ aridity, data = df_NSC)
starch_mod3  <- lm(starch_log ~ species * aridity, data = df_NSC)

anova(starch_null, starch_mod1, starch_mod2, starch_mod3)  # Check significance
simulateResiduals(starch_mod1, plot = TRUE)                #poor fit
simulateResiduals(starch_mod3, plot = TRUE)                # poor fit

#### Subset model for ACY only -----
#(GAL had many undetectable starch measurements)
starch_acy_null <- lm(starch_log ~ 1, data = df_NSC[df_NSC$species == "ACY", ])
starch_acy_mod1 <- lm(starch_log ~ aridity, data = df_NSC[df_NSC$species == "ACY", ])

anova(starch_acy_null, starch_acy_mod1) #not significant


#### Final model output ----
starch_acy_model <- lm(starch_log ~ aridity, data = df_NSC[df_NSC$species == "ACY", ])

anova(starch_acy_model)

#### Check residuals ----
simulateResiduals(starch_acy_mod1, plot = TRUE) #good



## Total Soluble Sugars - Stepwise model selection -----
ss_null  <- lm(total_soluble_sugars ~ 1, data = df_NSC)
ss_mod1  <- lm(total_soluble_sugars ~ aridity, data = df_NSC)
ss_mod2  <- lm(total_soluble_sugars ~ species, data = df_NSC)
ss_mod3  <- lm(total_soluble_sugars ~ species * aridity, data = df_NSC)

anova(ss_null, ss_mod1, ss_mod2, ss_mod3) #check significance

#### Final model output ----

ss_model  <- lm(total_soluble_sugars ~ aridity, data = df_NSC)
anova(ss_model)

#### Check residuals -----

simulateResiduals(ss_model, plot = TRUE) #good

# Resprouting success after repeated disturbance  -----

## Stepwise GLMMs -------

null <- glmer(success ~ 1 + (1 | site_name / plant_id),
              family = binomial, data = df_repeated_success_field, na.action = na.omit)

model1 <- glmer(success ~ biomass_pre_log + (1 | site_name / plant_id),
               family = binomial, data = df_repeated_success_field, na.action = na.omit)

model2 <- glmer(success ~ biomass_pre_log + species + (1 | site_name / plant_id),
               family = binomial, data = df_repeated_success_field, na.action = na.omit)

model3 <- glmer(success ~ biomass_pre_log + species + cut + (1 | site_name / plant_id),
               family = binomial, data = df_repeated_success_field, na.action = na.omit)

model4 <- glmer(success ~ biomass_pre_log * cut + species + (1 | site_name / plant_id),
               family = binomial, data = df_repeated_success_field, na.action = na.omit)

model5 <- glmer(success ~ biomass_pre_log * cut + cut * species + (1 | site_name / plant_id),
               family = binomial, data = df_repeated_success_field, na.action = na.omit,
               control = glmerControl(optimizer = "bobyqa"))

## Model comparison ----
anova(null, model1, model2, model3, model4, model5)

## Residual diagnostics ----
simulateResiduals(model1, plot = TRUE) #lowest AIC, but qq deviation shows poor fit
simulateResiduals(model2, plot = TRUE)
simulateResiduals(model3, plot = TRUE)
simulateResiduals(model4, plot = TRUE)
simulateResiduals(model5, plot = TRUE) #final model

## Summary of final model  -----
model_repeated_success <- glmer(success ~ biomass_pre_log * cut + cut * species + (1 | site_name / plant_id),
                family = binomial, data = df_repeated_success_field, na.action = na.omit,
                control = glmerControl(optimizer = "bobyqa"))

summary(model_repeated_success)
anova(model_repeated_success)

## Save model object ----
saveRDS(model_repeated_success, here::here("outputs", "models", "model_repeated_success_field.rds"))



