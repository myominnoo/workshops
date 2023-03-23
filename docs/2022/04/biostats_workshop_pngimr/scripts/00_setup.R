
# Install R Packages if required ------------------------------------------

packages_required <- c("tidyverse", "magrittr", "janitor", "readxl", 
                       "gtsummary", "sjlabelled", "smd", 
                       "broom", "ggfortify")
are_packages_installed <- packages_required %in% installed.packages()

if (!all(are_packages_installed)) {
    packages_required <- packages_required[!are_packages_installed]
    install.packages(packages_required)
}



# Load R packages ---------------------------------------------------------

library(magrittr)
library(tidyverse)
library(janitor)
library(sjlabelled)

# Import data -------------------------------------------------------------

covid <- readxl::read_excel("data/png_covid19_2021.xls")


    
