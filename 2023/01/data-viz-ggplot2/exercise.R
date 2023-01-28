

# <<<<< ============================================================= >>>>> 
#                       Data Vizualization using GGPLOT2
#                               EXERCISES 
# <<<<< ============================================================= >>>>> 


# setup -------------------------------------------------------------------

## install R packages if not installed
packages <- c("tidyverse")
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


# Create a dummy dataset --------------------------------------------------




# Exercises ---------------------------------------------------------------
