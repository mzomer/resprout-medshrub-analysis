# ────────────────────────────────────────────────────────────────────────────────
# make_figure3_NSC.R - root NSC under contrasting aridity levels
# ────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted  data ------
df_NSC <- readRDS(here::here("outputs", "data", "df_NSC.rds"))

# Plotting root NSC under contrasting aridity (Figure 3) ----

# Reshape for plotting
df_NSC_long <- df_NSC %>%
  pivot_longer(cols = c(starch, total_soluble_sugars),
               names_to = "Carbohydrate",
               values_to = "Percentage") %>%
  mutate(
    Carbohydrate = factor(Carbohydrate,
                          levels = c("starch", "total_soluble_sugars"),
                          labels = c("Starch", "Soluble Sugars")),
    aridity = factor(aridity,
                         levels = c("High", "Low"),
                         labels = c("High Aridity", "Low Aridity")),
    species = factor(species,
                     levels = c("ACY", "GAL"),
                     labels = c("A. ACY", "B. GAL"))
  )

# Color palette
colour_scale <- c("#C49B33", "#97BC92", "#FFFFFF")

# Base plot
NSC_plot <- ggplot(df_NSC_long, aes(x = Carbohydrate, y = Percentage, fill = aridity)) +
  geom_boxplot(color = "black", alpha = 0.8) +
  facet_wrap(~species) +
  scale_fill_manual(values = colour_scale) +
  labs(x = NULL, y = "Root NSC Concentration") +
  theme_classic(base_size = 14) +
  theme(
    axis.text.y = element_text(size = 14),
    axis.text.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_blank(),
    legend.position = c(0.85, 0.85),
    legend.background = element_blank(),
    legend.key = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0, size = 14)
  )

# Annotation labels
label_df <- data.frame(
  species = c("A. ACY", "A. ACY", "A. ACY", "A. ACY", "B. GAL", "B. GAL"),
  Carbohydrate = c("Starch", "Starch", "Soluble Sugars", "Soluble Sugars", "Soluble Sugars", "Soluble Sugars"),
  aridity = c("High Aridity", "Low Aridity", "High Aridity", "Low Aridity", "High Aridity", "Low Aridity"),
  label = c("a", "a", "A", "B", "A", "B"),
  y_pos = c(3.5, 2.5, 7, 3, 5, 4)
)

# Add labels to plot
NSC_plot  <- NSC_plot  +
  geom_text(data = label_df,
            aes(x = Carbohydrate, y = y_pos, label = label, group = aridity),
            position = position_dodge(width = 0.75),
            size = 5,
            hjust = -0.5,
            vjust = -0.2,
            inherit.aes = FALSE)

# Show plot ----
print(NSC_plot)

# Save plot ----
ggsave(
  filename = here::here("outputs", "figures", "figure_3_root_NSC.png"),
  plot = NSC_plot,
  width = 16,
  height = 10,
  units = "cm",
  dpi = 300
)

