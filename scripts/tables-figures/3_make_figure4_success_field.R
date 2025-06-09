# ─────────────────────────────────────────────────────────────────────────────────────────
# make_figure4_success - probability of resprouting success after repeated disturbance
# ─────────────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted  data ------
df_repeated_success <- readRDS(here::here("outputs", "data", "df_repeated_success_field.rds"))

# Load saved model object
model <- readRDS(here::here("outputs", "models", "model_repeated_success_field.rds"))


## Figure 4 : Plot predicted probability of success ------

# Create custom facet labels and colors
facet_labels <- c('1' = 'A. Cut 1', '2' = 'B. Cut 2')
custom_colors <- c("GAL" = "#5f7e89", "ACY" = "#c9a97d")

# Generate predictions
pred_df <- ggpredict(model, terms = c("biomass_pre_log[all]", "species", "cut"))

# Convert success to numeric for plotting
df_repeated_success$success_numeric <- as.numeric(as.character(df_repeated_success$success))

# Custom plot
plot_repeated_success <- ggplot(pred_df, aes(x = x, y = predicted,
                                           color = group, fill = group)) +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high, fill = group), alpha = 0.4, color = NA) +
  geom_line(linewidth = 1) +
  facet_wrap(~facet, labeller = as_labeller(facet_labels)) +
  scale_color_manual(values = custom_colors) +
  scale_fill_manual(values = custom_colors) +
  theme_classic(base_size = 14) +
  theme(
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.position = c(0.1, 0.3),
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0.1),
    panel.border = element_rect(color = "black", fill = NA, size = 1),
    legend.title = element_blank()
  ) +
  labs(
    x = "Pre-disturbance Biomass (log)",
    y = "Probability of Success"
  ) +
  geom_point(data = df_repeated_success,
             aes(x = biomass_pre_log,
                 y = success_numeric,
                 color = species),
             size = 1.5,
             alpha = 0.6,
             inherit.aes = FALSE)

# Show plot ----
print (plot_repeated_success) #warning of removed rows is due to missing plants for cut 2
                              #(didn't resprout after cut 1 or couldn't be found to assess cut 2)

# Save plot ----
ggsave(
  filename = here::here("outputs", "figures", "figure_4_repeated_success.png"),
  plot = plot_repeated_success,
  width = 16,
  height = 10,
  units = "cm",
  dpi = 300
)

