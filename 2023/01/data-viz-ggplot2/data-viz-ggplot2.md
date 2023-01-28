Data visualization using GGPLOT2
================
1/28/23

# About

This is a one-hour workshop to understand the basics of graphs and
visualizing data using `GGPLOT2` in R. This is not by any means a
comprehensive course on R or data visualization, but an attempt to
quickly get researchers started on creating plots using R by
demonstrating an relatively simple example drawn from the literature. On
a technical note regarding themes, the default theme from `ggprism` is
used for the purpose of creating publication-ready graphs.

# Recommended books

1.  [R for data science (2e)](https://r4ds.hadley.nz/)
2.  [Exploratory Data Analysis with
    R](https://bookdown.org/rdpeng/exdata/)
3.  [GGPLOT2
    Cheatsheet](https://posit.co/wp-content/uploads/2022/10/data-visualization-1.pdf)

# Reference & dataset:

Mohammadi, A., Bagherichimeh, S., Choi, Y. et al. Immune parameters of
HIV susceptibility in the female genital tract before and after
penile-vaginal sex. Commun Med 2, 60 (2022).
<https://doi.org/10.1038/s43856-022-00122-7>

# Instructions:

## R & RStudio

Go to the link and follow the steps to install R & RStudio:
<https://posit.co/download/rstudio-desktop/>.

Check which operating system you are using, either windows or macOS.

## Exercise files

1.  Download individual files on this link:
    <https://github.com/myominnoo/workshops/tree/main/2023/01/data-viz-ggplot2>  
2.  Put them in a folder.
3.  Right-click or double-click open the `R` file named `exercise.R`.
4.  Run the lines below the section `setup`.

``` r
packages <- c("tidyverse", "readxl", "ggprism")
for(package in packages){
  if(!package %in% rownames(installed.packages())){
    install.packages(pkgs = package, repos = "https://cran.rstudio.com/")
  }
  
  if(!package %in% rownames(installed.packages())){
    stop(paste("Package", package, "is not available"))
  }
}
```

# Getting started

## Checklist for creating a plot[^1]

1.  Formulate your question
2.  Identify variables (columns) needed to answer your question
3.  Read in your data
4.  Run `str()`
5.  Look at the top and the bottom of your data, `head()` and `tail()`
6.  Check your “n”s
7.  Create your plot
8.  Challenge your solution
9.  Follow up

## Anatomy of a simple graph

Most importantly, data is essential to creating a plot. It can be a
linelist or summary numbers.

Basic components also include x-y axises and labels.

![](data-viz-ggplot2_files/figure-commonmark/unnamed-chunk-3-1.png)

Then, data points.

![](data-viz-ggplot2_files/figure-commonmark/unnamed-chunk-4-1.png)

Then, another axis or grouping shown by color, shape, or size. When
there is a grouping, you can decide whether the legend should be shown
or not, and if shown, location of the legend should be considered as
well.

    Warning: Using size for a discrete variable is not advised.

![](data-viz-ggplot2_files/figure-commonmark/unnamed-chunk-5-1.png)

Lastly, we can decide to add a title. However, when you submit a paper,
the plot itself is often separate from the title/subtitle and the
legend.

    Warning: Using size for a discrete variable is not advised.

![](data-viz-ggplot2_files/figure-commonmark/unnamed-chunk-6-1.png)

## Getting dataset

To download the dataset, run the following lines of codes.

``` r
## load required packages
library(tidyverse)


# Getting dataset ---------------------------------------------------------

## download dataset from the journal website
url <- "https://static-content.springer.com/esm/art%3A10.1038%2Fs43856-022-00122-7/MediaObjects/43856_2022_122_MOESM3_ESM.xlsx"
download.file(url, "43856_2022_122_MOESM3_ESM.xlsx")
```

Then, we read the dataset into R.

``` r
fig2 <- readxl::read_excel("43856_2022_122_MOESM3_ESM.xlsx", 
                   sheet = "Figure 2")
```

We use str(), head(), and tail() to understand the data structure

``` r
str(fig2)
```

    tibble [36 × 22] (S3: tbl_df/tbl/data.frame)
     $ Semen IFNa2a    : num [1:36] 1.3 0.84 1.38 1.64 1.83 1.54 1.87 1.4 1.21 1.72 ...
     $ CVS IFNa2a      : num [1:36] 1.55 1.14 1.46 1.47 1.49 1.19 1.13 2.09 1.55 0.84 ...
     $ Semen IL-17     : num [1:36] 0.62 0.76 0.98 1.11 1.47 0.99 1.64 0.77 0.39 1.96 ...
     $ CVS IL-17       : num [1:36] 2.36 1.08 1.69 2.61 1.5 1.58 1.71 2.86 2.24 1.36 ...
     $ Semen IL-1a     : num [1:36] 1.88 2.38 2.12 2.71 2.17 1.86 2.58 1.98 2.68 3.04 ...
     $ CVS IL-1a       : num [1:36] 4.63 4.84 4.52 4.91 3.74 4.11 4.61 4.03 4.57 3.94 ...
     $ Semen IL-6      : num [1:36] -0.06 0.08 0.61 0.84 1 NA 1.06 0.66 0.32 1.59 ...
     $ CVS IL-6        : num [1:36] 3.04 1.12 1.57 3.36 1.99 2.12 2.3 3.4 3.19 2.11 ...
     $ Semen IL-8      : num [1:36] 2.49 2.2 2.59 3.09 3.05 2.42 2.97 3.13 2.47 3.73 ...
     $ CVS IL-8        : num [1:36] 4.56 3.83 3.96 4.56 4.38 4.51 4.5 4.56 4.56 4.12 ...
     $ Semen IP-10     : num [1:36] 4.47 3.18 4.39 4.68 4.82 4.52 4.84 4.47 4.34 4.73 ...
     $ CVS IP-10       : num [1:36] 3.16 3.36 3.67 2.99 3.57 3.04 3.17 4.82 3.28 3.13 ...
     $ Semen MIG       : num [1:36] 4.08 2.67 4.18 4.55 4.71 4.45 4.77 4.33 4.14 4.53 ...
     $ CVS MIG         : num [1:36] 2.19 2.03 2.97 2.75 2.62 1.99 2.33 3.73 2.07 1.73 ...
     $ Semen MIP-1b    : num [1:36] 2.45 2.18 2.86 2.7 3.02 2.35 2.86 3.02 2.1 3.91 ...
     $ CVS MIP-1b      : num [1:36] 3.11 2.14 2.69 3.68 2.53 2.57 2.72 3.37 3.59 2.3 ...
     $ Semen MIP-3a    : num [1:36] 2.6 1.31 2.84 3.06 2.87 2.79 2.79 3.15 2.84 4.43 ...
     $ CVS MIP-3a      : num [1:36] 3.14 2.36 2.9 4.24 3.68 3.16 2.85 3.05 4.3 2.76 ...
     $ Semen E-cadherin: num [1:36] 5.23 4.55 5.19 5.74 5.42 5.58 5.52 5.5 5.38 5.2 ...
     $ CVS E-cadherin  : num [1:36] 5.99 4.79 5.29 6.26 3.89 3.48 4.33 6.17 4.87 4.66 ...
     $ Semen MMP9      : num [1:36] 2.22 2.89 3.26 4.05 4.56 2.64 3.78 3.53 2.66 6.1 ...
     $ CVS MMP9        : num [1:36] 6.1 4.95 5.73 6.42 5.54 5.42 5.83 6.55 6.31 4.72 ...

``` r
head(fig2)
```

    # A tibble: 6 × 22
      `Semen IFNa2a` CVS I…¹ Semen…² CVS I…³ Semen…⁴ CVS I…⁵ Semen…⁶ CVS I…⁷ Semen…⁸
               <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    1           1.3     1.55    0.62    2.36    1.88    4.63   -0.06    3.04    2.49
    2           0.84    1.14    0.76    1.08    2.38    4.84    0.08    1.12    2.2 
    3           1.38    1.46    0.98    1.69    2.12    4.52    0.61    1.57    2.59
    4           1.64    1.47    1.11    2.61    2.71    4.91    0.84    3.36    3.09
    5           1.83    1.49    1.47    1.5     2.17    3.74    1       1.99    3.05
    6           1.54    1.19    0.99    1.58    1.86    4.11   NA       2.12    2.42
    # … with 13 more variables: `CVS IL-8` <dbl>, `Semen IP-10` <dbl>,
    #   `CVS IP-10` <dbl>, `Semen MIG` <dbl>, `CVS MIG` <dbl>,
    #   `Semen MIP-1b` <dbl>, `CVS MIP-1b` <dbl>, `Semen MIP-3a` <dbl>,
    #   `CVS MIP-3a` <dbl>, `Semen E-cadherin` <dbl>, `CVS E-cadherin` <dbl>,
    #   `Semen MMP9` <dbl>, `CVS MMP9` <dbl>, and abbreviated variable names
    #   ¹​`CVS IFNa2a`, ²​`Semen IL-17`, ³​`CVS IL-17`, ⁴​`Semen IL-1a`, ⁵​`CVS IL-1a`,
    #   ⁶​`Semen IL-6`, ⁷​`CVS IL-6`, ⁸​`Semen IL-8`

``` r
tail(fig2)
```

    # A tibble: 6 × 22
      `Semen IFNa2a` CVS I…¹ Semen…² CVS I…³ Semen…⁴ CVS I…⁵ Semen…⁶ CVS I…⁷ Semen…⁸
               <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    1           1.72    1.23    1.29    2.08    2.33    4.55    1.04    1.47    3.19
    2           1.83    1.2     1.85    2.21    2.65    3.9     1.14    2.6     3.3 
    3           2.13    1.33    2.21    2.23    2.86    4.52    1.51    2.72    3.42
    4           2.27    1.39    2.39    1.45    4.81    4.68    1.62    1.44    3.13
    5           1.56    0.93    0.86    1.08    2.66    4       0.92    0.81    2.94
    6           1.42    1.43    0.67    1.75    2.53    4.19    0.22    2.55    2.45
    # … with 13 more variables: `CVS IL-8` <dbl>, `Semen IP-10` <dbl>,
    #   `CVS IP-10` <dbl>, `Semen MIG` <dbl>, `CVS MIG` <dbl>,
    #   `Semen MIP-1b` <dbl>, `CVS MIP-1b` <dbl>, `Semen MIP-3a` <dbl>,
    #   `CVS MIP-3a` <dbl>, `Semen E-cadherin` <dbl>, `CVS E-cadherin` <dbl>,
    #   `Semen MMP9` <dbl>, `CVS MMP9` <dbl>, and abbreviated variable names
    #   ¹​`CVS IFNa2a`, ²​`Semen IL-17`, ³​`CVS IL-17`, ⁴​`Semen IL-1a`, ⁵​`CVS IL-1a`,
    #   ⁶​`Semen IL-6`, ⁷​`CVS IL-6`, ⁸​`Semen IL-8`

In the current dataset, each column represents a cytokine variable. To
create figure 2, what we want is two columns, `type` containing the
names of cytokines and `value` containing their values. To do this, we
need to change the data structure from wide format to long format.

[^1]: modified from [Exploratory Data Analysis with
    R](https://bookdown.org/rdpeng/exdata/)
