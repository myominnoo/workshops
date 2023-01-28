

# <<<<< ============================================================= >>>>> 
#                       Data Vizualization using GGPLOT2
#                               EXERCISES 
# <<<<< ============================================================= >>>>> 


# setup -------------------------------------------------------------------

## install R packages if not installed
packages <- c("tidyverse", "readxl", "ggprism", "rstatix", "patchwork")
for(package in packages){
  if(!package %in% rownames(installed.packages())){
    install.packages(pkgs = package, repos = "https://cran.rstudio.com/")
  }
  
  if(!package %in% rownames(installed.packages())){
    stop(paste("Package", package, "is not available"))
  }
}

## load required packages
library(tidyverse)

## clear workspace
rm(list = ls())


# Getting dataset ---------------------------------------------------------

## download dataset from the journal website
url <- "https://static-content.springer.com/esm/art%3A10.1038%2Fs43856-022-00122-7/MediaObjects/43856_2022_122_MOESM3_ESM.xlsx"
download.file(url, "43856_2022_122_MOESM3_ESM.xlsx")


# Creating Figure 2 -------------------------------------------------------

fig2_ds <- readxl::read_excel("43856_2022_122_MOESM3_ESM.xlsx", 
                   sheet = "Figure 2")

# first we use str(), head(), and tail() to understand the data structure
str(fig2_ds)
head(fig2_ds)
tail(fig2_ds)

fig2_long <- fig2_ds %>% 
  # change the data structure from wide to long format
  pivot_longer(everything(), names_to = "type") %>% 
  # separate type into sample and cytokine
  separate(type, into = c("sample", "cytokine"), sep = " ") %>% 
  mutate(
    cytokine = case_when(
      cytokine == "IFNa2a" ~ "IFNα2a", 
      cytokine == "IL-1a" ~ "IL-1α", 
      cytokine == "MIP-3a" ~ "MIP-3α", 
      cytokine == "MIP-1b" ~ "MIP-1β",
      TRUE ~ cytokine
    ), 
    cytokine = factor(cytokine, levels = c(
      "IFNα2a", "IL-17",  "IL-1α",  "IL-6",   "IL-8",   "IP-10",  "MIG",   
      "MIP-1β", "MIP-3α", "E-cadherin", "MMP9" 
    ))
  )







# Creating Figure 3 -------------------------------------------------------

fig3_ds <- readxl::read_excel("43856_2022_122_MOESM3_ESM.xlsx", 
                              sheet = "Figure 3 A-D")

str(fig3_ds)
head(fig3_ds)
tail(fig3_ds)

fig3_long <- fig3_ds %>% 
  select(sex = `Sex group`, starts_with("IP10"), starts_with("IP-10"), 
         starts_with("IL-1a")) %>% 
  mutate(id = 1:nrow(.)) %>% 
  pivot_longer(-c(sex, id), names_to = "type") %>% 
  separate(type, into = c("cytokine", "time"), sep = " ") %>% 
  mutate(
    cytokine = case_when(
      cytokine == "IP10" ~ "IP-10", 
      cytokine == "IL-1a" ~ "IL-1α", 
      TRUE ~ cytokine
    ), 
    time = factor(time, levels = c("Baseline", "+1h", "+72hrs"))
  )





# Saving figures ----------------------------------------------------------
