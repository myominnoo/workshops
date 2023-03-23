

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
summary(fig2_ds)

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


fig2_pvalues <- fig2_long %>% 
  rstatix::group_by(cytokine) %>% 
  rstatix::wilcox_test(value ~ sample, paired = FALSE) %>% 
  rstatix::add_x_position(x = "cytokine", dodge = 0.9) %>% # dodge must match points
  mutate(label = ifelse(p < 0.05, 
                        ifelse(p < 0.01, 
                               ifelse(p < 0.001, "***", "**"), "*"), "ns"))


fig2_long %>% 
  ## initiate a ggplot with specified x and y axises
  ggplot(aes(x = cytokine, y = value)) + 
  ## create jittered points with specified width
  geom_jitter(aes(color = sample), position = position_jitterdodge(0.25)) +
  scale_color_manual(values = c("red", "blue")) +
  ## change y axis limit 
  scale_y_continuous(breaks = c(-2, 0, 2, 4, 6, 8), limits = c(-2, 8)) +
  geom_hline(yintercept = 0, linetype = "dotted") +
  labs(x = "", y = "Log 10 [immune factors, pg/ml]") + 
  ## add prism theme 
  ggprism::theme_prism(base_size = 10) +
  theme(legend.position = "top") +
  ggprism::add_pvalue(
    fig2_pvalues, y = c(3.8, 3.8, 6.5, 4, 5.8, 6, 6, 5.5, 5.5, 7.8, 7.8), 
    xmin = "xmin", xmax = "xmax"
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
