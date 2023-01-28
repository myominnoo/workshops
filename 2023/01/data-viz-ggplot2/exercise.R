

# <<<<< ============================================================= >>>>> 
#                       Data Vizualization using GGPLOT2
#                               EXERCISES 
# <<<<< ============================================================= >>>>> 


# setup -------------------------------------------------------------------

## install R packages if not installed
packages <- c("tidyverse", "readxl", "ggprism")
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



# Getting dataset ---------------------------------------------------------

## download dataset from the journal website
url <- "https://static-content.springer.com/esm/art%3A10.1038%2Fs43856-022-00122-7/MediaObjects/43856_2022_122_MOESM3_ESM.xlsx"
download.file(url, "43856_2022_122_MOESM3_ESM.xlsx")


# Creating Figure 2 -------------------------------------------------------

fig2 <- readxl::read_excel("43856_2022_122_MOESM3_ESM.xlsx", 
                   sheet = "Figure 2")

# first we use str(), head(), and tail() to understand the data structure
str(fig2)
head(fig2)
tail(fig2)

fig2 %>% 
  # change the data structure from wide to long format
  pivot_longer(everything(), names_to = "type") %>% 
  # separate type into sample and cytokine
  separate(type, into = c("sample", "cytokine"), sep = " ")

mtcars %>% 
  ggplot(aes(mpg, hp, color = factor(cyl), 
             shape = factor(cyl), 
             size = factor(cyl))) + 
  geom_point() +
  labs(
    x = "x axis", 
    y = "y axis", 
    color = "cyl", 
    shape = "cyl", 
    size = "cyl") + 
  ggprism::theme_prism() +
  theme(legend.title = element_text())
