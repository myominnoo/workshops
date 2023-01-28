10 Handy Tidyverse Tricks in R
================

# Disclaimers

References:

- [R for data science (2e)](https://r4ds.hadley.nz/)
- [tidyverse](https://www.tidyverse.org/)
- [Eight R tidyverse for everyday data
  engineering](https://tomaztsql.wordpress.com/2022/07/14/eight-r-tidyverse-tips-for-everyday-data-engineering/)

Dataset:

``` r
?penguins
```

# 1. Tidy data

- one column, one variable
- one row, one observation
- one cell, one value

``` r
penguins
```

    # A tibble: 344 × 8
       species island    bill_length_mm bill_depth_mm flipper_…¹ body_…² sex    year
       <fct>   <fct>              <dbl>         <dbl>      <int>   <int> <fct> <int>
     1 Adelie  Torgersen           39.1          18.7        181    3750 male   2007
     2 Adelie  Torgersen           39.5          17.4        186    3800 fema…  2007
     3 Adelie  Torgersen           40.3          18          195    3250 fema…  2007
     4 Adelie  Torgersen           NA            NA           NA      NA <NA>   2007
     5 Adelie  Torgersen           36.7          19.3        193    3450 fema…  2007
     6 Adelie  Torgersen           39.3          20.6        190    3650 male   2007
     7 Adelie  Torgersen           38.9          17.8        181    3625 fema…  2007
     8 Adelie  Torgersen           39.2          19.6        195    4675 male   2007
     9 Adelie  Torgersen           34.1          18.1        193    3475 <NA>   2007
    10 Adelie  Torgersen           42            20.2        190    4250 <NA>   2007
    # … with 334 more rows, and abbreviated variable names ¹​flipper_length_mm,
    #   ²​body_mass_g

``` r
glimpse(penguins)
```

    Rows: 344
    Columns: 8
    $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
    $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
    $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
    $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
    $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
    $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
    $ sex               <fct> male, female, female, NA, female, male, female, male…
    $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…

# 2. Use native pipe `|>` for code readibility and chaining multiple functions

- passess object from left to right sides.
- `|>` loses several features of `%>%` from magrittr package
- native - reduce package dependencies
- faster??

``` r
## without pipe operator
count(
  rename(
    select(
      mutate(penguins, nonsense = paste(species, island)), 
        species, island, nonsense
    ), 
    species_name = species, 
    island_name = island
  ), 
  nonsense
)
```

    # A tibble: 5 × 2
      nonsense             n
      <chr>            <int>
    1 Adelie Biscoe       44
    2 Adelie Dream        56
    3 Adelie Torgersen    52
    4 Chinstrap Dream     68
    5 Gentoo Biscoe      124

``` r
## a chain of random operations 
penguins |>  
  mutate(nonsense = paste(species, island)) |>  
  select(species, island, nonsense) |> 
  rename(species_name = species, 
         island_name = island) |> 
  count(nonsense)
```

    # A tibble: 5 × 2
      nonsense             n
      <chr>            <int>
    1 Adelie Biscoe       44
    2 Adelie Dream        56
    3 Adelie Torgersen    52
    4 Chinstrap Dream     68
    5 Gentoo Biscoe      124

``` r
## use inner piping inside mutate
penguins |>  
  mutate(
    species_new = species |>
      str_to_title() |> 
      str_to_sentence() |> 
      str_to_upper() |> 
      str_to_lower()
  ) |>  
  select(species, species_new)
```

    # A tibble: 344 × 2
       species species_new
       <fct>   <chr>      
     1 Adelie  adelie     
     2 Adelie  adelie     
     3 Adelie  adelie     
     4 Adelie  adelie     
     5 Adelie  adelie     
     6 Adelie  adelie     
     7 Adelie  adelie     
     8 Adelie  adelie     
     9 Adelie  adelie     
    10 Adelie  adelie     
    # … with 334 more rows

# 3. Rename variables on select()

- quick renaming on the same function
- no separate call for rename()

``` r
penguins |> 
  rename(species_name = species, 
         island_name = island)
```

    # A tibble: 344 × 8
       species_name island_name bill_length_mm bill_de…¹ flipp…² body_…³ sex    year
       <fct>        <fct>                <dbl>     <dbl>   <int>   <int> <fct> <int>
     1 Adelie       Torgersen             39.1      18.7     181    3750 male   2007
     2 Adelie       Torgersen             39.5      17.4     186    3800 fema…  2007
     3 Adelie       Torgersen             40.3      18       195    3250 fema…  2007
     4 Adelie       Torgersen             NA        NA        NA      NA <NA>   2007
     5 Adelie       Torgersen             36.7      19.3     193    3450 fema…  2007
     6 Adelie       Torgersen             39.3      20.6     190    3650 male   2007
     7 Adelie       Torgersen             38.9      17.8     181    3625 fema…  2007
     8 Adelie       Torgersen             39.2      19.6     195    4675 male   2007
     9 Adelie       Torgersen             34.1      18.1     193    3475 <NA>   2007
    10 Adelie       Torgersen             42        20.2     190    4250 <NA>   2007
    # … with 334 more rows, and abbreviated variable names ¹​bill_depth_mm,
    #   ²​flipper_length_mm, ³​body_mass_g

``` r
penguins |> 
  select(species_name = species, island_name = island)
```

    # A tibble: 344 × 2
       species_name island_name
       <fct>        <fct>      
     1 Adelie       Torgersen  
     2 Adelie       Torgersen  
     3 Adelie       Torgersen  
     4 Adelie       Torgersen  
     5 Adelie       Torgersen  
     6 Adelie       Torgersen  
     7 Adelie       Torgersen  
     8 Adelie       Torgersen  
     9 Adelie       Torgersen  
    10 Adelie       Torgersen  
    # … with 334 more rows

# 4. Operations across() multiple columns at once

- tidy evaluation can be used: like everything(), starts_with()
- for multiple elements, c() need to be used.

``` r
penguins |>  
  mutate(
    bill_length_mm = as.character(bill_length_mm), 
    bill_depth_mm = as.character(bill_depth_mm), 
    flipper_length_mm = as.character(flipper_length_mm)
  )
```

    # A tibble: 344 × 8
       species island    bill_length_mm bill_depth_mm flipper_…¹ body_…² sex    year
       <fct>   <fct>     <chr>          <chr>         <chr>        <int> <fct> <int>
     1 Adelie  Torgersen 39.1           18.7          181           3750 male   2007
     2 Adelie  Torgersen 39.5           17.4          186           3800 fema…  2007
     3 Adelie  Torgersen 40.3           18            195           3250 fema…  2007
     4 Adelie  Torgersen <NA>           <NA>          <NA>            NA <NA>   2007
     5 Adelie  Torgersen 36.7           19.3          193           3450 fema…  2007
     6 Adelie  Torgersen 39.3           20.6          190           3650 male   2007
     7 Adelie  Torgersen 38.9           17.8          181           3625 fema…  2007
     8 Adelie  Torgersen 39.2           19.6          195           4675 male   2007
     9 Adelie  Torgersen 34.1           18.1          193           3475 <NA>   2007
    10 Adelie  Torgersen 42             20.2          190           4250 <NA>   2007
    # … with 334 more rows, and abbreviated variable names ¹​flipper_length_mm,
    #   ²​body_mass_g

``` r
penguins |> 
  mutate(across(c(bill_length_mm:flipper_length_mm), ~ as.character(.x))) |> 
  glimpse()
```

    Rows: 344
    Columns: 8
    $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
    $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
    $ bill_length_mm    <chr> "39.1", "39.5", "40.3", NA, "36.7", "39.3", "38.9", …
    $ bill_depth_mm     <chr> "18.7", "17.4", "18", NA, "19.3", "20.6", "17.8", "1…
    $ flipper_length_mm <chr> "181", "186", "195", NA, "193", "190", "181", "195",…
    $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
    $ sex               <fct> male, female, female, NA, female, male, female, male…
    $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…

# 5. rowwise() & c_across() for row-wise operations

``` r
## find row means for bill_length_mm, bill_depth_mm, and flipper_length_mm
penguins |>  
  rowwise() |>
  mutate(means = mean(c(bill_length_mm, bill_depth_mm, flipper_length_mm), na.rm = TRUE))
```

    # A tibble: 344 × 9
    # Rowwise: 
       species island    bill_length_mm bill_dep…¹ flipp…² body_…³ sex    year means
       <fct>   <fct>              <dbl>      <dbl>   <int>   <int> <fct> <int> <dbl>
     1 Adelie  Torgersen           39.1       18.7     181    3750 male   2007  79.6
     2 Adelie  Torgersen           39.5       17.4     186    3800 fema…  2007  81.0
     3 Adelie  Torgersen           40.3       18       195    3250 fema…  2007  84.4
     4 Adelie  Torgersen           NA         NA        NA      NA <NA>   2007 NaN  
     5 Adelie  Torgersen           36.7       19.3     193    3450 fema…  2007  83  
     6 Adelie  Torgersen           39.3       20.6     190    3650 male   2007  83.3
     7 Adelie  Torgersen           38.9       17.8     181    3625 fema…  2007  79.2
     8 Adelie  Torgersen           39.2       19.6     195    4675 male   2007  84.6
     9 Adelie  Torgersen           34.1       18.1     193    3475 <NA>   2007  81.7
    10 Adelie  Torgersen           42         20.2     190    4250 <NA>   2007  84.1
    # … with 334 more rows, and abbreviated variable names ¹​bill_depth_mm,
    #   ²​flipper_length_mm, ³​body_mass_g

``` r
## find row sums for bill_length_mm, bill_depth_mm, and flipper_length_mm
penguins |> 
  rowwise() |>
  mutate(sums = sum(c(bill_length_mm, bill_depth_mm, flipper_length_mm), na.rm = TRUE))
```

    # A tibble: 344 × 9
    # Rowwise: 
       species island    bill_length_mm bill_dep…¹ flipp…² body_…³ sex    year  sums
       <fct>   <fct>              <dbl>      <dbl>   <int>   <int> <fct> <int> <dbl>
     1 Adelie  Torgersen           39.1       18.7     181    3750 male   2007  239.
     2 Adelie  Torgersen           39.5       17.4     186    3800 fema…  2007  243.
     3 Adelie  Torgersen           40.3       18       195    3250 fema…  2007  253.
     4 Adelie  Torgersen           NA         NA        NA      NA <NA>   2007    0 
     5 Adelie  Torgersen           36.7       19.3     193    3450 fema…  2007  249 
     6 Adelie  Torgersen           39.3       20.6     190    3650 male   2007  250.
     7 Adelie  Torgersen           38.9       17.8     181    3625 fema…  2007  238.
     8 Adelie  Torgersen           39.2       19.6     195    4675 male   2007  254.
     9 Adelie  Torgersen           34.1       18.1     193    3475 <NA>   2007  245.
    10 Adelie  Torgersen           42         20.2     190    4250 <NA>   2007  252.
    # … with 334 more rows, and abbreviated variable names ¹​bill_depth_mm,
    #   ²​flipper_length_mm, ³​body_mass_g

Use `c_across()` for tidy evaluation like everything(), starts_with().

``` r
## find row sums for bill_length_mm, bill_depth_mm, and flipper_length_mm
penguins |> 
  rowwise() |>
  mutate(sums = sum(c_across(bill_length_mm:flipper_length_mm), na.rm = TRUE))
```

    # A tibble: 344 × 9
    # Rowwise: 
       species island    bill_length_mm bill_dep…¹ flipp…² body_…³ sex    year  sums
       <fct>   <fct>              <dbl>      <dbl>   <int>   <int> <fct> <int> <dbl>
     1 Adelie  Torgersen           39.1       18.7     181    3750 male   2007  239.
     2 Adelie  Torgersen           39.5       17.4     186    3800 fema…  2007  243.
     3 Adelie  Torgersen           40.3       18       195    3250 fema…  2007  253.
     4 Adelie  Torgersen           NA         NA        NA      NA <NA>   2007    0 
     5 Adelie  Torgersen           36.7       19.3     193    3450 fema…  2007  249 
     6 Adelie  Torgersen           39.3       20.6     190    3650 male   2007  250.
     7 Adelie  Torgersen           38.9       17.8     181    3625 fema…  2007  238.
     8 Adelie  Torgersen           39.2       19.6     195    4675 male   2007  254.
     9 Adelie  Torgersen           34.1       18.1     193    3475 <NA>   2007  245.
    10 Adelie  Torgersen           42         20.2     190    4250 <NA>   2007  252.
    # … with 334 more rows, and abbreviated variable names ¹​bill_depth_mm,
    #   ²​flipper_length_mm, ³​body_mass_g

``` r
## find row sums for bill_length_mm, bill_depth_mm, and flipper_length_mm
penguins |> 
  rowwise() |>
  mutate(sums = sum(c_across(ends_with("_mm")), na.rm = TRUE))
```

    # A tibble: 344 × 9
    # Rowwise: 
       species island    bill_length_mm bill_dep…¹ flipp…² body_…³ sex    year  sums
       <fct>   <fct>              <dbl>      <dbl>   <int>   <int> <fct> <int> <dbl>
     1 Adelie  Torgersen           39.1       18.7     181    3750 male   2007  239.
     2 Adelie  Torgersen           39.5       17.4     186    3800 fema…  2007  243.
     3 Adelie  Torgersen           40.3       18       195    3250 fema…  2007  253.
     4 Adelie  Torgersen           NA         NA        NA      NA <NA>   2007    0 
     5 Adelie  Torgersen           36.7       19.3     193    3450 fema…  2007  249 
     6 Adelie  Torgersen           39.3       20.6     190    3650 male   2007  250.
     7 Adelie  Torgersen           38.9       17.8     181    3625 fema…  2007  238.
     8 Adelie  Torgersen           39.2       19.6     195    4675 male   2007  254.
     9 Adelie  Torgersen           34.1       18.1     193    3475 <NA>   2007  245.
    10 Adelie  Torgersen           42         20.2     190    4250 <NA>   2007  252.
    # … with 334 more rows, and abbreviated variable names ¹​bill_depth_mm,
    #   ²​flipper_length_mm, ³​body_mass_g

# 6. Vectorize with case_when() instead of ifelse() / if_else()

- faster with vectorization
- write multiple statements

``` r
penguins |> 
  mutate(
    sex = case_when(
      sex == "male" ~ "M", 
      sex == "female" ~ "F", 
      TRUE ~ "missing"
    )
  ) |> 
  count(sex)
```

    # A tibble: 3 × 2
      sex         n
      <chr>   <int>
    1 F         165
    2 M         168
    3 missing    11

# 7. Transmute() instead of mutate()

- transmute adds new variables and remove existing ones.

``` r
penguins |> 
  mutate(sex_new = case_when(
    sex == "male" ~ "M", 
    sex == "female" ~ "F"
  )) |> 
  glimpse() 
```

    Rows: 344
    Columns: 9
    $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
    $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
    $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
    $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
    $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
    $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
    $ sex               <fct> male, female, female, NA, female, male, female, male…
    $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…
    $ sex_new           <chr> "M", "F", "F", NA, "F", "M", "F", "M", NA, NA, NA, N…

``` r
penguins |> 
  transmute(
    sex_new = case_when(
      sex == "male" ~ "M", 
      sex == "female" ~ "F"
    ), 
    ## add variables if you don't want to remove them
    species, island
  ) |> 
  glimpse()
```

    Rows: 344
    Columns: 3
    $ sex_new <chr> "M", "F", "F", NA, "F", "M", "F", "M", NA, NA, NA, NA, "F", "M…
    $ species <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adelie…
    $ island  <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgersen, Torgers…

# 8. Lumping levels with fct_lump_n() and fct_infreq()

``` r
glimpse(mpg) 
```

    Rows: 234
    Columns: 11
    $ manufacturer <chr> "audi", "audi", "audi", "audi", "audi", "audi", "audi", "…
    $ model        <chr> "a4", "a4", "a4", "a4", "a4", "a4", "a4", "a4 quattro", "…
    $ displ        <dbl> 1.8, 1.8, 2.0, 2.0, 2.8, 2.8, 3.1, 1.8, 1.8, 2.0, 2.0, 2.…
    $ year         <int> 1999, 1999, 2008, 2008, 1999, 1999, 2008, 1999, 1999, 200…
    $ cyl          <int> 4, 4, 4, 4, 6, 6, 6, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 8, 8, …
    $ trans        <chr> "auto(l5)", "manual(m5)", "manual(m6)", "auto(av)", "auto…
    $ drv          <chr> "f", "f", "f", "f", "f", "f", "f", "4", "4", "4", "4", "4…
    $ cty          <int> 18, 21, 20, 21, 16, 18, 18, 18, 16, 20, 19, 15, 17, 17, 1…
    $ hwy          <int> 29, 29, 31, 30, 26, 26, 27, 26, 25, 28, 27, 25, 25, 25, 2…
    $ fl           <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p…
    $ class        <chr> "compact", "compact", "compact", "compact", "compact", "c…

``` r
count(mpg, manufacturer)
```

    # A tibble: 15 × 2
       manufacturer     n
       <chr>        <int>
     1 audi            18
     2 chevrolet       19
     3 dodge           37
     4 ford            25
     5 honda            9
     6 hyundai         14
     7 jeep             8
     8 land rover       4
     9 lincoln          3
    10 mercury          4
    11 nissan          13
    12 pontiac          5
    13 subaru          14
    14 toyota          34
    15 volkswagen      27

``` r
mpg |> 
  mutate(manufacturer = fct_infreq(manufacturer)) |> 
  count(manufacturer)
```

    # A tibble: 15 × 2
       manufacturer     n
       <fct>        <int>
     1 dodge           37
     2 toyota          34
     3 volkswagen      27
     4 ford            25
     5 chevrolet       19
     6 audi            18
     7 hyundai         14
     8 subaru          14
     9 nissan          13
    10 honda            9
    11 jeep             8
    12 pontiac          5
    13 land rover       4
    14 mercury          4
    15 lincoln          3

``` r
mpg |> 
  mutate(manu = manufacturer |>
           fct_infreq() |>  
           fct_lump_n(n = 5)) |>
  count(manu)
```

    # A tibble: 6 × 2
      manu           n
      <fct>      <int>
    1 dodge         37
    2 toyota        34
    3 volkswagen    27
    4 ford          25
    5 chevrolet     19
    6 Other         92

# 9. nest_by(), and list() to model data within a data.frame

``` r
penguins |> 
  nest_by(species) |> 
  mutate(
    mod = list(
      lm(body_mass_g ~ flipper_length_mm, data = data)
    ), 
    pred = list(predict(mod))
  ) |> 
  ungroup() 
```

    # A tibble: 3 × 4
      species                 data mod    pred       
      <fct>     <list<tibble[,7]>> <list> <list>     
    1 Adelie             [152 × 7] <lm>   <dbl [151]>
    2 Chinstrap           [68 × 7] <lm>   <dbl [68]> 
    3 Gentoo             [124 × 7] <lm>   <dbl [123]>

# 10. reduce() lists into one

``` r
v <- 1:4
v
```

    [1] 1 2 3 4

``` r
sum(v)
```

    [1] 10

``` r
reduce(v, `+`)
```

    [1] 10

``` r
gender <- tibble(id = letters[1:6], gender = sample(c("M", "F"), 6, TRUE))
age_cm <- tibble(id = letters[1:6], age = runif(6, min = 150, max = 190))
bmi <- tibble(id = letters[1:6], bmi = runif(6, min = 15, max = 40))

gender
```

    # A tibble: 6 × 2
      id    gender
      <chr> <chr> 
    1 a     M     
    2 b     M     
    3 c     M     
    4 d     M     
    5 e     M     
    6 f     F     

``` r
age_cm
```

    # A tibble: 6 × 2
      id      age
      <chr> <dbl>
    1 a      183.
    2 b      159.
    3 c      186.
    4 d      152.
    5 e      188.
    6 f      162.

``` r
bmi
```

    # A tibble: 6 × 2
      id      bmi
      <chr> <dbl>
    1 a      31.7
    2 b      33.1
    3 c      37.5
    4 d      24.4
    5 e      36.7
    6 f      16.0

``` r
l <- list(gender, age_cm, bmi)
l
```

    [[1]]
    # A tibble: 6 × 2
      id    gender
      <chr> <chr> 
    1 a     M     
    2 b     M     
    3 c     M     
    4 d     M     
    5 e     M     
    6 f     F     

    [[2]]
    # A tibble: 6 × 2
      id      age
      <chr> <dbl>
    1 a      183.
    2 b      159.
    3 c      186.
    4 d      152.
    5 e      188.
    6 f      162.

    [[3]]
    # A tibble: 6 × 2
      id      bmi
      <chr> <dbl>
    1 a      31.7
    2 b      33.1
    3 c      37.5
    4 d      24.4
    5 e      36.7
    6 f      16.0

``` r
reduce(l, left_join, by = "id")
```

    # A tibble: 6 × 4
      id    gender   age   bmi
      <chr> <chr>  <dbl> <dbl>
    1 a     M       183.  31.7
    2 b     M       159.  33.1
    3 c     M       186.  37.5
    4 d     M       152.  24.4
    5 e     M       188.  36.7
    6 f     F       162.  16.0
