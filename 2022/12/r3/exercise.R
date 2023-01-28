

# <<<<< ============================================================= >>>>> 
#                       R for Researchers Webinar
#                               EXERCISES 
# <<<<< ============================================================= >>>>> 


# setup -------------------------------------------------------------------

## install R packages if not installed
packages <- c("tidyverse", "stringr", "palmerpenguins")
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
library(stringr)
library(palmerpenguins)


# Exercises ---------------------------------------------------------------

## check penguins dataset 
?penguins

# 1. Tidy data 


# 2. Use native pipe ` |> ` for code readibility and chaining multiple functions


# 3. Rename variables on select() 


# 4. Operations across() multiple columns at once


# 5. rowwise() & c_across() for row-wise operations


# 6. Vectorize with case_when() instead of ifelse() / if_else() 


# 7. Transmute() instead of mutate()


# 8. Lumping levels with fct_lump_n() and fct_infreq()


# 9. nest_by(), and list() to model data within a data.frame


# 10. reduce() lists into one 





