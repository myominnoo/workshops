
# -------------------------------------------------------------------------
#                   Biostatistics Workshop - PNGIMR 
#                           R Workflow
# -------------------------------------------------------------------------

## Author: Myo Minn Oo
## Date: 8 April 2022 

## clear workspace 
rm(list = ls())


# Setup -------------------------------------------------------------------

source("scripts/00_setup.R")


# Data processing  --------------------------------------------------------

source("scripts/01_data_process.R")


# Data Export -------------------------------------------------------------

save(covid_processed, file = "data/covid.RData")
