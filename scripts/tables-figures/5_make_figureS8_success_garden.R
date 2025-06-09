# ────────────────────────────────────────────────────────────────────────────────────────────────
# make_figureS8_success - probability of resprouting success after repeated disturbance common garden
# ────────────────────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load saved model object
model <- readRDS(here::here("outputs", "models", "model_repeated_success_garden.rds"))


## Figure S8 : Plot predicted probability of success garden ------

# Generate predictions
pred_df <- ggpredict(model, terms = c("biomass_pre[all]"))


# plot
plot_repeated_success_garden <- plot(pred_df, show_data  = T) +
  geom_line(linewidth = 1, color = "#FFB90F", alpha = 0.5) +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), fill = "#FFB90F",alpha = 0.1) +
  theme_classic(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 14),
    title = element_blank()
  ) +
  labs(
    x = "Pre-disturbance Biomass",
    y = "Probability of Success"
  )


# Show plot ----
print (plot_repeated_success_garden)

# Save plot ----
ggsave(
  filename = here::here("outputs", "figures", "figure_S8_repeated_success.png"),
  plot = plot_repeated_success_garden,
  width = 14,
  height = 10,
  units = "cm",
  dpi = 300
)




