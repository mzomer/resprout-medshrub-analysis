# ─────────────────────────────────────────────────────────────
# data_exploration_field.R — Exploratory analyses of field data
# ─────────────────────────────────────────────────────────────

# Load setup
source(here::here("scripts", "setup.R"))

# Load cleaned data
df_SEM_1_field <- readRDS(here::here("outputs", "data", "df_SEM_1_field.rds"))
df_SEM_2_field <- readRDS(here::here("outputs", "data", "df_SEM_2_field.rds"))

# Explore: Pre-disturbance biomass ~ Years since fire (YSF) ------
# relationship is non-significant for both species

ggplot(df_SEM_1_field, aes(x = ysf, y = drybiomass_pre_log)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal() +
  labs(title = "Pre-disturbance biomass ~ YSF")

# Model for ACY
ysf_model_acy <- lmer(drybiomass_pre_log ~ ysf + (1 | site_name),
                      data = df_SEM_1_field[df_SEM_1_field$species == "ACY", ])
summary(ysf_model_acy)
anova(ysf_model_acy)
simulateResiduals(ysf_model_acy, plot = TRUE)

# Model for GAL
ysf_model_gal <- lmer(drybiomass_pre_log ~ ysf + (1 | site_name),
                      data = df_SEM_1_field[df_SEM_1_field$species == "GAL", ])
summary(ysf_model_gal)
anova(ysf_model_gal)
simulateResiduals(ysf_model_gal, plot = TRUE)


# Explore: Resprouting vigour ~ Pre-disturbance condition -----


# Correlation matrix of pre-disturbance traits
cordf_pre <- df_SEM_1_field %>%
  select(drybiomass_pre_log, num_stems_pre, diameter_stem_pre, height_pre, crown_length_pre)
corrplot(cor(cordf_pre), method = "number")


# Stepwise model: resprouting success after cut 1

# Null model
null_success <- lmer(success_1 ~ 1 + (1 | site_name), data = df_SEM_1_field)

# Add individual predictors
success_1 <- update(null_success, . ~ . + species)
success_2 <- update(null_success, . ~ . + drybiomass_pre_log)
success_3 <- update(null_success, . ~ . + num_stems_pre)
success_4 <- update(null_success, . ~ . + diameter_stem_pre)

# Compare to null
anova(null_success, success_1)  # species ns
anova(null_success, success_2)  # biomass ns
anova(null_success, success_3)  # stems ns
anova(null_success, success_4)  # diameter ns


# Stepwise model: resprouting vigour (drybiomass_post_log)
# Pre-disturbance biomass is the most important plant condition variable for resprout vigour

# Null model
null_vigour <- lmer(drybiomass_post_log ~ 1 + (1 | site_name), data = df_SEM_2_field)

# Add individual predictors
vigour_1 <- update(null_vigour, . ~ . + species)
vigour_2 <- update(null_vigour, . ~ . + drybiomass_pre_log)
vigour_3 <- update(null_vigour, . ~ . + num_stems_pre)
vigour_4 <- update(null_vigour, . ~ . + diameter_stem_pre)

# Compare to null
anova(null_vigour, vigour_1)  # species
anova(null_vigour, vigour_2)  # biomass ***
anova(null_vigour, vigour_3)  # stems ***
anova(null_vigour, vigour_4)  # diameter **

# Base model with biomass
model_vigour <- lmer(drybiomass_post_log ~ drybiomass_pre_log + (1 | site_name),
                     data = df_SEM_2_field)

# Add other variables to base model
vigour_5 <- update(model_vigour, . ~ . + species)
vigour_6 <- update(model_vigour, . ~ . + num_stems_pre)
vigour_7 <- update(model_vigour, . ~ . + diameter_stem_pre)

anova(model_vigour, vigour_5)  # species ***
anova(model_vigour, vigour_6)  # stems ns
anova(model_vigour, vigour_7)  # diameter ns

# Final model
model_vigour2 <- lmer(drybiomass_post_log ~ drybiomass_pre_log + species + (1 | site_name),
                      data = df_SEM_2_field)

# Additional checks
vigour_8 <- update(model_vigour2, . ~ . + num_stems_pre)
vigour_9 <- update(model_vigour2, . ~ . + diameter_stem_pre)

anova(model_vigour2, vigour_8)  # ns
anova(model_vigour2, vigour_9)  # ns

# Final model summaries
anova(model_vigour2)
summary(model_vigour2)

simulateResiduals(model_vigour2, plot = T) #slight qq deviation

# Exploratory Plots ------

# Pre → Post biomass
ggplot(df_SEM_2_field, aes(x = drybiomass_pre_log, y = drybiomass_post_log)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Stems
ggplot(df_SEM_2_field, aes(x = num_stems_pre, y = drybiomass_post_log)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Stem diameter
ggplot(df_SEM_2_field, aes(x = diameter_stem_pre, y = drybiomass_post_log)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Height
ggplot(df_SEM_2_field, aes(x = height_pre, y = drybiomass_post_log)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()


