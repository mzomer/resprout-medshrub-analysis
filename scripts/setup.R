# ────────────────────────────────────────────────────────────────
# setup.R — Load libraries, source functions, set project options
# ────────────────────────────────────────────────────────────────


## Load packages
library(tidyverse)       # Core tidyverse
library(piecewiseSEM)    # Piecewise structural equation modeling: Version 2.1
library(multcompView)    # for categorical variables in SEM
library(lme4)            # Linear/mixed models
library(lmerTest)        # p-values for lmer models
library(DHARMa)          # Residual diagnostics for mixed models
library(ggeffects)       # Marginal effects and predictions
library(corrplot)        # Correlation plots
library(here)            # Relative paths
library(ape)             # Variance partitioning (varcomp)
library(nlme)            # Linear/mixed models (used for variance components)
library(ggpubr)          # plotting
library(patchwork)       # plot layout


# install piecewiseSEM version 2.1.2 if it isn't already installed
if (!requireNamespace("piecewiseSEM", quietly = TRUE)) {
  install.packages("piecewiseSEM_2.1.2.tar", repos = NULL, type = "source")
}

## Global options
options(stringsAsFactors = FALSE)

## Source custom SEM helper functions
#use these revised helper functions when using piecewiseSEM v2.1 to correct issue with handling data for multigroup
source(here::here("scripts", "utils", "multigroup.R")) #correction line 39 rhs2: https://github.com/jslefche/piecewiseSEM/issues/209
source(here::here("scripts", "utils", "coef.R"))
source(here::here("scripts", "utils", "rhelpers.R"))


## Set default plotting theme
theme_set(theme_minimal())

## Print session info (optional, for reproducibility)
message("R version: ", R.Version()$version.string)
# R version 4.4.1 (2024-06-14)
sessionInfo()

