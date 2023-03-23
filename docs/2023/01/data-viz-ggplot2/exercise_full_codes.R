

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


fig2_pvalues <- fig2_long %>% 
  rstatix::group_by(cytokine) %>% 
  rstatix::wilcox_test(value ~ sample, paired = FALSE) %>% 
  rstatix::add_x_position(x = "cytokine", dodge = 0.9) %>% # dodge must match points
  mutate(label = ifelse(p < 0.05, 
                        ifelse(p < 0.01, 
                               ifelse(p < 0.001, "***", "**"), "*"), "ns"))

fig2 <- fig2_long %>% 
  ## initiate a ggplot with specified x and y axises
  ggplot(aes(x = cytokine, y = value)) + 
  ## create jittered points with specified width
  geom_jitter(aes(color = sample), position = position_jitterdodge(0.25)) +
  ## change y axis limit 
  scale_y_continuous(breaks = c(-2, 0, 2, 4, 6, 8), limits = c(-2, 8)) +
  geom_hline(yintercept = 0, linetype = "dotted") +
  scale_color_manual(values = c("red", "blue")) +
  labs(x = "", y = "Log 10 [immune factors, pg/ml]") +
  ## add prism theme 
  ggprism::theme_prism(base_size = 10) +
  theme(legend.position = "top") +
  ggprism::add_pvalue(
    fig2_pvalues, y = c(3.8, 3.8, 6.5, 4, 5.8, 6, 6, 5.5, 5.5, 7.8, 7.8), 
    xmin = "xmin", xmax = "xmax"
  )

fig2





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


fig3_pvalues <- fig3_long %>% 
  rstatix::group_by(sex, cytokine) %>% 
  rstatix::wilcox_test(value ~ time, paired = TRUE) %>% 
  rstatix::add_x_position(x = "time", dodge = 0.9) %>% # dodge must match points
  mutate(label = ifelse(p < 0.05, 
                        ifelse(p < 0.01, 
                               ifelse(p < 0.001, "***", "**"), "*"), "ns"))

fig3_med <- fig3_long %>% 
  group_by(sex, cytokine, time) %>% 
  summarize(med = median(value, na.rm = TRUE), 
            med = round(med, 1))


fig3a_pvalues <- fig3_pvalues%>% 
  filter(sex == "codnomless", cytokine == "IP-10")
fig3a_med <- fig3_med %>% 
  filter(sex == "codnomless", cytokine == "IP-10") 

fig3a <- fig3_long %>% 
  filter(cytokine == "IP-10", sex == "codnomless") %>% 
  ggplot(aes(x = time, y = value, group = id)) +
  geom_point() + 
  geom_line() +
  #Axis log transformation:
  annotation_logticks(scaled = TRUE, sides = "l") +
  scale_y_log10(breaks = c(1, 10, 1e2, 1e3, 1e4, 1e5), 
                labels = scales::label_number()) +
  geom_hline(yintercept = 10, color = "red", linetype = "dotted", size = 1) +
  annotate("text", 1, 1, label = fig3a_med %>% filter(time == "Baseline") %>% pull(med), 
           color = "red") +
  annotate("text", 2, 1, label = fig3a_med %>% filter(time == "+1h") %>% pull(med), 
           color = "red") +
  annotate("text", 3, 1, label = fig3a_med %>% filter(time == "+72hrs") %>% pull(med), 
           color = "red") +
  labs(x = "", y = "IP-10 (pg/ml)") +
  ggprism::theme_prism(base_size = 10) +
  ggprism::add_pvalue(
    fig3a_pvalues, 
    y = c(10^5, 10^6, 10^5), 
    xmin = "xmin", xmax = "xmax"
  )
fig3a


fig3b_pvalues <- fig3_pvalues%>% 
  filter(sex == "condom", cytokine == "IP-10")
fig3b_med <- fig3_med %>% 
  filter( sex == "condom", cytokine == "IP-10") 

fig3b <- fig3_long %>% 
  filter(cytokine == "IP-10", sex == "condom") %>% 
  ggplot(aes(x = time, y = value, group = id)) +
  geom_point() + 
  geom_line() +
  #Axis log transformation:
  annotation_logticks(scaled = TRUE, sides = "l") +
  scale_y_log10(breaks = c(1, 10, 1e2, 1e3, 1e4, 1e5), 
                labels = scales::label_number()) +
  geom_hline(yintercept = 10, color = "red", linetype = "dotted", size = 1) +
  annotate("text", 1, 1, label = fig3b_med %>% filter(time == "Baseline") %>% pull(med), 
           color = "red") +
  annotate("text", 2, 1, label = fig3b_med %>% filter(time == "+1h") %>% pull(med), 
           color = "red") +
  annotate("text", 3, 1, label = fig3b_med %>% filter(time == "+72hrs") %>% pull(med), 
           color = "red") +
  labs(x = "", y = "IP-10 (pg/ml)") +
  ggprism::theme_prism(base_size = 10) +
  ggprism::add_pvalue(
    fig3b_pvalues, 
    y = c(10^5, 10^6, 10^5), 
    xmin = "xmin", xmax = "xmax"
  )
fig3b



fig3c_pvalues <- fig3_pvalues%>% 
  filter(sex == "codnomless", cytokine == "IL-1α")
fig3c_med <- fig3_med %>% 
  filter(sex == "codnomless", cytokine == "IL-1α") 


fig3c <- fig3_long %>% 
  filter(cytokine == "IL-1α", sex == "codnomless") %>% 
  ggplot(aes(x = time, y = value, group = id)) +
  geom_point() + 
  geom_line() +
  #Axis log transformation:
  annotation_logticks(scaled = TRUE, sides = "l") +
  scale_y_log10(breaks = c(1, 10, 1e2, 1e3, 1e4, 1e5), 
                labels = scales::label_number()) +
  geom_hline(yintercept = 1e3, color = "red", linetype = "dotted", size = 1) +
  annotate("text", 1, 1e2, label = fig3c_med %>% filter(time == "Baseline") %>% pull(med), 
           color = "red") +
  annotate("text", 2, 1e2, label = fig3c_med %>% filter(time == "+1h") %>% pull(med), 
           color = "red") +
  annotate("text", 3, 1e2, label = fig3c_med %>% filter(time == "+72hrs") %>% pull(med), 
           color = "red") +
  labs(x = "", y = "IL-1α (pg/ml)") +
  ggprism::theme_prism(base_size = 10) +
  ggprism::add_pvalue(
    fig3c_pvalues, 
    y = c(10^6, 10^7, 10^6), 
    xmin = "xmin", xmax = "xmax"
  )
fig3c



fig3d_pvalues <- fig3_pvalues%>% 
  filter(sex == "condom", cytokine == "IL-1α")
fig3d_med <- fig3_med %>% 
  filter( sex == "condom", cytokine == "IL-1α") 

fig3d <- fig3_long %>% 
  filter(cytokine == "IL-1α", sex == "condom") %>% 
  ggplot(aes(x = time, y = value, group = id)) +
  geom_point() + 
  geom_line() +
  #Axis log transformation:
  annotation_logticks(scaled = TRUE, sides = "l") +
  scale_y_log10(breaks = c(1, 10, 1e2, 1e3, 1e4, 1e5), 
                labels = scales::label_number()) +
  geom_hline(yintercept = 1e3, color = "red", linetype = "dotted", size = 1) +
  annotate("text", 1, 1e2, label = fig3d_med %>% filter(time == "Baseline") %>% pull(med), 
           color = "red") +
  annotate("text", 2, 1e2, label = fig3d_med %>% filter(time == "+1h") %>% pull(med), 
           color = "red") +
  annotate("text", 3, 1e2, label = fig3d_med %>% filter(time == "+72hrs") %>% pull(med), 
           color = "red") +
  labs(x = "", y = "IL-1α (pg/ml)") +
  ggprism::theme_prism(base_size = 10) +
  ggprism::add_pvalue(
    fig3d_pvalues, 
    y = c(10^6, 10^7, 10^6), 
    xmin = "xmin", xmax = "xmax"
  )
fig3d



library(patchwork)

fig3 <- (fig3a + fig3b) / (fig3c + fig3d) + 
  plot_annotation(tag_levels = "a")




# Saving figures ----------------------------------------------------------

ggsave("fig2_exercise.tiff", fig2, 
       width = 10, height = 6, compression = "lzw")
ggsave("fig3_exercise.tiff", fig3,
       width = 10, height = 7, compression = "lzw")
 

