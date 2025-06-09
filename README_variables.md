# Variable Definitions

This document describes the column variables and units for the data files in the `data/` directory.

## data_field.csv

- **experiment**: Always “field” experiment.
- **species**: Species code (ACY = *Anthyllis cytisoides*; GAL = *Globularia alypum*).
- **site_name**: Text name for each site.
- **site_number**: Numeric site ID.
- **plant_id**: ID number within each site (1–25).
- **plant_unique_id**: Unique identifier across all sites.

#### Pre-cut (before cut 1) measurements
- **height_pre**: Plant height (centimetres, cm).
- **crown_length_pre**: Plant crown length (centimetres, cm).
- **crown_width_pre**: Plant crown width (centimetres, cm).
- **num_stems_pre**: Number of stems (integer count).
- **diameter_stem_pre**: Diameter of largest stem (millimetres, mm).
- **biomass_pre**: Fresh biomass (grams, g).
- **drybiomass_pre**: Estimated dry biomass (grams, g).

#### Post-cut (two years after cut 1) measurements
- **height_post**: Plant height (centimetres, cm).
- **crown_length_post**: Crown length (centimetres, cm).
- **num_resprouts_post**: Number of resprouting stems (integer count).
- **diameter_stem_post**: Diameter of largest resprouting stem (millimetres, mm).
- **drybiomass_post**: Dry biomass (grams, g).

- **success_1**: Resprout success after cut 1 (1 = yes/alive; 0 = no/dead).

#### Post-cut 2 
- **success_2**: Resprout success after cut 2 (1 = yes/alive; 0 = no/dead).

## sites_field.csv

- **site_name**: Matches the `site_name` in **data_field.csv**.
- **site_number**: Numeric ID (matches `site_number` in **data_field.csv**).
- **species**: ACY or GAL.
- **lat**: Latitude in decimal degrees (°).
- **long**: Longitude in decimal degrees (°).
- **fire_activity**: Percentage (%) of the 10 km-radius buffer area burned per year.
- **ysf**: Years since last fire in location of plants (years).
- **soil_carbon**: Soil total organic carbon content (% dry material).
- **soil_nitrogen**: Soil total nitrogen content (% dry material).
- **aridity**: (1 − aridity index) (higher value = more arid; unitless).
- **rainfall_post_2018**: Accumulated precipitation 5 months after cut 1 (2018) (millimetres, mm).
- **rainfall_post_2020**: Accumulated precipitation 5 months after cut 2 (2020) (millimetres, mm).

## data_rootNSC.csv

- **species**: ACY or GAL.
- **site_name**: Matches the `site_name` in the other files.
- **plant_id**: Plant ID within each site (1–25).
- **dry_material_g**: Dry weight of root sample (grams, g).
- **starch**: Root starch concentration (grams per 100 g dry root; g 100 g⁻¹ dry weight).
- **total_soluble_sugars**: Root total soluble sugar concentration (grams per 100 g dry root; g 100 g⁻¹ dry weight).
- **aridity**: Categorical: “High” or “Low” aridity site.

> **Note**: Although labeled “concentration,” these are mass-per-mass values (e.g. 5 g per 100 g dry), effectively % dry weight.

## data_garden.csv

- **Experiment**: Always “common garden” experiment.
- **species**: Always ACY (Anthyllis cytisoides).
- **site_name**: Source location of the seed.
- **site_number**: Numeric site ID of source location.
- **plant_number**: ID number within each provenance site (integer count).
- **plant_id**: Unique identifier for each plant.
- **aridity_seed_provenance**: “High” or “Low,” indicating the aridity category of seed origin.
- **Water_treatment**: “Drought” or “Watered.”

### Pre-cut (before cut 1) measurements
- **height_pre**: Plant height (centimetres, cm).
- **crown_length_pre**: Plant crown length (centimetres, cm).
- **crown_width_pre**: Plant crown width (centimetres, cm).
- **number_stems_pre**: Number of stems (integer count).
- **diameter_stem_pre**: Diameter of largest stem (millimetres, mm).
- **biomass_pre**: Fresh biomass (grams, g).
- **drybiomass_pre**: Dry biomass (grams, g).

### Post-cut (one year after cut 1) measurements
- **height_post**: Plant height (centimetres, cm).
- **crown_length_post**: Plant crown length (centimetres, cm).
- **number_resprouts_post**: Number of resprouting stems (integer count).
- **diameter_stem_post**: Diameter of largest resprouting stem (millimetres, mm).
- **drybiomass_post**: Dry biomass (grams, g).
- **success_1**: Resprout survival after first cut (1 = yes; 0 = no).

### Post-cut 2
- **success_2**: Resprout survival after second cut (1 = yes; 0 = no).
