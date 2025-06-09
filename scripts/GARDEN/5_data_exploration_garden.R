# ─────────────────────────────────────────────────────────────────────────
# data_exploration_garden.R — Exploratory analyses of common garden data
# ─────────────────────────────────────────────────────────────────────────

# Load setup
source(here::here("scripts", "setup.R"))

# Load cleaned data
df_SEM_1_garden <- readRDS(here::here("outputs", "data", "df_SEM_1_garden.rds"))
df_SEM_2_garden <- readRDS(here::here("outputs", "data", "df_SEM_2_garden.rds"))



# Exploratory stepwise models — Resprout vigour (Garden, ACY) -----
#pre-disturbance plant biomass is the most important plant condition variable for resprout vigour

# Correlation matrix of pre-disturbance traits
cordf_pre <- df_SEM_2_garden %>%
  select(drybiomass_pre, number_stems_pre, diameter_stem_pre, height_pre, crown_length_pre)
corrplot(cor(cordf_pre), method = "number")

# Null model
null_vigour <- lmer(drybiomass_post ~ 1 + (1 | site_name), na.action = na.omit, data = df_SEM_2_garden)

# Single predictor models
vigour_1 <- update(null_vigour, . ~ . + water_treatment)
vigour_2 <- update(null_vigour, . ~ . + aridity_seed_provenance)
vigour_3 <- update(null_vigour, . ~ . + drybiomass_pre)
vigour_4 <- update(null_vigour, . ~ . + height_pre)
vigour_5 <- update(null_vigour, . ~ . + number_stems_pre)
vigour_6 <- update(null_vigour, . ~ . + crown_length_pre)


# Compare to null
anova(null_vigour, vigour_1)  # water_treatment ***
anova(null_vigour, vigour_2)  # aridity_seed_provenance ns
anova(null_vigour, vigour_3)  # drybiomass_pre ***
anova(null_vigour, vigour_4)  # convergence **
anova(null_vigour, vigour_5)  # stems ns
anova(null_vigour, vigour_6)  # crown length **

# Additive models
null_vigour_2 <- lmer(drybiomass_post ~ water_treatment + (1 | site_name), na.action = na.omit, data = df_SEM_2_garden)

vigour_7 <- update(null_vigour_2, . ~ . + aridity_seed_provenance)
vigour_8 <- update(null_vigour_2, . ~ . + drybiomass_pre)
vigour_9 <- update(null_vigour_2, . ~ . + height_pre)
vigour_10 <- update(null_vigour_2, . ~ . + number_stems_pre)
vigour_11 <- update(null_vigour_2, . ~ . + crown_length_pre)


# Compare to null
anova(null_vigour_2, vigour_7)  # aridity_seed_provenance ns
anova(null_vigour_2, vigour_8)  # drybiomass_pre *
anova(null_vigour_2, vigour_9)  # height_pre ns
anova(null_vigour_2, vigour_10) # stems ns
anova(null_vigour_2, vigour_11) # crown length ns


# Final comparison including interaction
null_vigour_3 <- lmer(drybiomass_post ~ water_treatment + drybiomass_pre + (1 | site_name),
               na.action = na.omit, data = df_SEM_2_garden)

null_vigour_4 <- lmer(drybiomass_post ~ water_treatment * drybiomass_pre + (1 | site_name),
               na.action = na.omit, data = df_SEM_2_garden)

# Compare interaction vs additive model
anova(null_vigour_3, null_vigour_4) # ns

# Overall comparison
anova(null_vigour, null_vigour_2, null_vigour_3)

#Final model summaries
anova(null_vigour_3)
summary(null_vigour_3)

simulateResiduals(null_vigour_3, plot = T) #good

# Exploratory Plots ------

# Pre → Post biomass
ggplot(df_SEM_2_garden, aes(x = drybiomass_pre, y = drybiomass_post)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Stems
ggplot(df_SEM_2_garden, aes(x = number_stems_pre, y = drybiomass_post)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Stem diameter
ggplot(df_SEM_2_garden, aes(x = diameter_stem_pre, y = drybiomass_post)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()

# Height
ggplot(df_SEM_2_garden, aes(x = height_pre, y = drybiomass_post)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~species) +
  theme_minimal()


