

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
library(stringr) # manipulating string
library(palmerpenguins) #penguins  


# Exercises ---------------------------------------------------------------

## check penguins dataset 
?penguins

# 1. Tidy data 




# 2. Use native pipe ` |> ` for code readibility and chaining multiple functions

# mac - Cmd + Shift + M
penguins |> 
  mutate(nonsense = paste(species, island)) |> 
  select(species, island, nonsense) |> 
  glimpse()

# %>%  from magrittr package 

penguins  %>% ## original dataset  
  mutate(nonsense = paste(species, island))  %>% # penguins + nonsense
  select(species, island, nonsense)  %>% # updated datset with three columns
  glimpse()

# 3. Rename variables on select() 


penguins |> 
  rename(species_new = species, island_new = island) |> 
  glimpse()

penguins |>  
  select(s = species, i = island)

# 4. Operations across() multiple columns at once
penguins |> 
  mutate(across(bill_length_mm:flipper_length_mm, ~ as.character(.x))) |> 
  glimpse()

penguins |> 
  mutate(across(ends_with("_mm"), ~ as.logical(.x))) |> 
  glimpse()

## everything(), starts_with(), ends_with()

# 5. rowwise() & c_across() for row-wise operations

# rowMeans()
penguins |>  
  rowwise() |> 
  mutate(means = mean(c(bill_length_mm, bill_depth_mm, flipper_length_mm), na.rm = TRUE)) |> 
  select(bill_length_mm:flipper_length_mm, means)


penguins |> 
  rowwise() |> 
  mutate(row_sum = sum(c_across(ends_with("_mm")), na.rm = TRUE)) |> 
  select(bill_length_mm:flipper_length_mm, row_sum)

# 6. Vectorize with case_when() instead of ifelse() / if_else() 

# ifelse(cond, true, 
# 			 ifelse(cond, true, 
# 			 			 ifelse(cond, true)))

penguins |> 
  mutate(sex_re = case_when(
    # cond ~ "value"
    sex == "male" ~ "M", 
    # sex == "female" ~ "F", 
    TRUE ~ "missing"
  )) |> 
  count(sex_re)


# 7. Transmute() instead of mutate()

penguins |> 
  transmute(sex = case_when(
    sex == "male" ~ 1, 
    TRUE ~ 0
  ), species, island 
  
  ) |> 
  glimpse()

# 8. Lumping levels with fct_lump_n() and fct_infreq()

mpg |> 
  count(manufacturer)

mpg |> 
  mutate(manu = fct_infreq(manufacturer)) |> 
  count(manu)

mpg |>  
  mutate(manu = manufacturer |> 
           fct_infreq() |> 
           fct_lump_n(n = 3)) |> 
  count(manu)


# 9. nest_by(), and list() to model data within a data.frame
count(penguins, species)

penguins |> 
  nest_by(species) |> 
  mutate(
    model = list(lm(body_mass_g ~ flipper_length_mm, data = data)), 
    pred = list(predict(model))
  ) |> 
  ungroup() |> 
  View()


# 10. reduce() lists into one 

v <- 1:4
v
sum(v)
1 + 2 + 3 + 4

reduce(v, sum)
reduce(v, `+`)


gender <- tibble(id = letters[1:6], gender = sample(c("M", "F"), 6, TRUE))
age_cm <- tibble(id = letters[1:6], age = runif(6, min = 150, max = 190))
bmi <- tibble(id = letters[1:6], bmi = runif(6, min = 15, max = 40))


gender |> 
  left_join(age_cm, by = "id") |> 
  left_join(bmi, by = "id")



ds <- list(gender, age_cm, bmi)
reduce(ds, left_join, by = "id")









