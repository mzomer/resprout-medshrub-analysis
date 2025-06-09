# ────────────────────────────────────────────────────────────────────────────────
# make_table1.R — Variance decomposition for field data
# ────────────────────────────────────────────────────────────────────────────────

# Load Setup  -----
source(here::here("scripts", "setup.R"))

# Load cleaned and subsetted  data ------
modPart1 <- readRDS(here::here("outputs", "models", "var_mod1_field.rds"))
modPart2 <- readRDS(here::here("outputs", "models", "var_mod2_field.rds"))
modPart3 <- readRDS(here::here("outputs", "models", "var_mod3_field.rds"))
modPart4 <- readRDS(here::here("outputs", "models", "var_mod4_field.rds"))


# Extract variance as formatted summary rows
# This function:
# - Retrieves total variance via VarCorr
# - Retrieves proportional variance via ape::varcomp
# - Combines both into readable strings with total (proportional) variance like "1334.494 (0.235)"

extract_variance <- function(model, variable, n_plants) {
  is_nlme <- inherits(model, "lme")

  if (is_nlme) {
    vc_mat <- as.matrix(VarCorr(model))
    numeric_vars <- suppressWarnings(as.numeric(vc_mat[, "Variance"]))
    var_total <- setNames(numeric_vars[!is.na(numeric_vars)][1:3],
                          c("species", "site_name", "Residual"))
  } else {
    vc_df <- as.data.frame(VarCorr(model))
    vc_df <- vc_df[!is.na(vc_df$vcov), ]
    var_total <- setNames(vc_df$vcov, vc_df$grp)
  }

  var_prop_raw <- ape::varcomp(model, scale = 1)
  var_prop <- setNames(as.numeric(var_prop_raw), names(var_prop_raw))
  names(var_prop)[names(var_prop) == "Within"] <- "Residual"

  format_val <- function(name) {
    if (name %in% names(var_total) && name %in% names(var_prop)) {
      sprintf("%.3f (%.3f)", var_total[name], var_prop[name])
    } else {
      "NA (NA)"
    }
  }

  data.frame(
    Variable = paste0(variable, " (", n_plants, ")"),
    Between_species    = format_val("species"),
    Among_populations  = format_val("site_name"),
    Among_individuals  = format_val("Residual"),
    stringsAsFactors = FALSE
  )
}


# 5. Create formatted variance summary table

tab1 <- extract_variance(modPart1, "Pre-biomass", "378")
tab2 <- extract_variance(modPart2, "Resprout success cut 1", "378")
tab3 <- extract_variance(modPart3, "Resprout vigour", "312")
tab4 <- extract_variance(modPart4, "Resprout success cut 2", "284")

# Combine all rows into final table
variance_table_field <- rbind(tab1, tab2, tab3, tab4)

# display table
print(variance_table_field, row.names = FALSE)

#write to csv
#write.csv(variance_table_field, "outputs/figures/variance_table_field.csv", row.names = FALSE)
