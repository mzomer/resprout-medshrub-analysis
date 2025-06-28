# Analysis of Intraspecific Resprouting Variability in Mediterranean Shrubs, Spain

This repository contains all code, data, and outputs needed to reproduce the analyses in:

*Maya A. Zomer, Bruno Moreira, Juli G. Pausas (2025). Pre-disturbance plant condition drives intraspecific resprouting variability in Mediterranean shrubs.Journal of Experimental Botany. https://doi.org/10.1093/jxb/eraf246 *

We investigated how long-term environmental conditions (aridity, fire history, soil nitrogen), immediate post-disturbance water availability (rainfall), and potential local adaptation shape resprouting variability in two Mediterranean shrub species. We applied a standardized two-cut disturbance in two experimental contexts: a field experiment across an aridity gradient in eastern Spain (*Anthyllis cytisoides*, *Globularia alypum*), and a common garden experiment using *A. cytisoides* grown from seeds collected from high- and low-aridity regions and exposed to drought and watered treatments. Plant responses were tracked across three stages: resprouting success after the first cut (yes/no), resprouting vigour (dry aboveground biomass of successful resprouts), and resprouting success after the second cut (yes/no).

We used **variance component analysis** to partition variation in plant condition and resprouting response across hierarchical levels (e.g., species, population, individual). **Structural equation models (SEM)** were applied to identify direct and indirect drivers of resprouting, particularly the mediating role of pre-disturbance plant size. Finally, we used **regression models (binomial GLMMs and linear models)** to evaluate the effects of repeated disturbances on resprouting success and to test how root non-structural carbohydrate (NSC) concentrations varied with aridity.


## Workflow Notes
All structural equation modelling (SEM) analyses were run with R package 'piecewiseSEM 2.1.2' and R version 4.4.1. To avoid version conflicts, this project provides a Docker container that runs in RStudio Server - a self-contained environment that includes the correct R version and all required package versions.

• Build and run the container as described in `README_docker.md`.  
• Log in to RStudio Server at `http://localhost:8787` (the project will open automatically).  
• Source `scripts/setup.R`, then run the numbered scripts in `scripts/FIELD/` and `scripts/GARDEN/` to reproduce the published analyses and figures.  


## Folder Overview

- **data 📁**  
  raw data from the field and common‐garden experiments (see `README_variables.md` for variable information)

- **outputs 📁**  
  - **data 📁**    – intermediate RDS subsetted data  
  - **models 📁**  – intermediate RDS model objects  
  - **figures 📁** – final PNG manuscript figures  

- **scripts 📁**  

  - **`setup.R` 📄.**      – loads libraries, sources helper functions, sets global R options  

  - **FIELD 📁** – field‐experiment analyses:  
    -  **`1_data_cleaning_field.R` 📄**          – data cleaning  
    -  **`2_variance_components_field.R` 📄**    – extracting variance components 
    -  **`3_SEM_models_field.R` 📄**             – fitting SEM models   
    -  **`4_regression_models_field.R` 📄**      – fitting regression models      
    -  **`5_data_exploration_field.R` 📄**       – additional data exploration 
    
  - **GARDEN 📁** – common‐garden experiment analyses:  
    - **`1_data_cleaning_garden.R` 📄**          – data cleaning  
    - **`2_variance_components_garden.R` 📄**    – extracting variance components  
    - **`3_SEM_models_garden.R` 📄**             – fitting SEM models  
    - **`4_regression_models_garden.R` 📄**      – fitting regression models  
    - **`5_data_exploration_garden.R` 📄**       – additionaldata exploration 

  - **tables-figures 📁**     
    -  **`1_make_table1.R` 📄**                  – generate Table 1 (variance components field)
    -  **`2_make_figure3_NSC.R` 📄**             – generate Figure 3 (NSC analysis field)  
    -  **`3_make_figure4_success.R` 📄**         – generate Figure 4 (resprouting success field)  
    -  **`4_make_tableS11.R` 📄**                – generate Table S11 (variance components garden)
    -  **`5_make_figureS8_success.R` 📄**        – generate Figure S8 (resprouting success garden)  

  - **utils 📁**     – reusable utility functions (multigroup SEM helpers)  

- **`resprout-medshrub.Rproj`** – RStudio Project file (opens the project root)
- **`Dockerfile`** – builds a Docker container that runs in RStudio Server, with all system and R package dependencies pre-installed from `renv.lock`.
- **`renv.lock`** – records the exact versions of all R packages used in the project; these are restored during the Docker build via `renv::restore()`.
- **`piecewiseSEM_2.1.2.tar`** – local source tarball of `piecewiseSEM` (optional; already installed in Docker)


------
## README Files
- **`README.md`**               – (this file) project overview and folder descriptions 
- **`README_docker.md`**        – instructions for building/running the Docker container  
- **`README_variables.md`**     – column definitions and units for data files


