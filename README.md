
<!-- README.md is generated from README.Rmd. Please edit that file -->

# canadacovid

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/canadacovid)](https://CRAN.R-project.org/package=canadacovid)
[![R-CMD-check](https://github.com/taylordunn/canadacovid/workflows/R-CMD-check/badge.svg)](https://github.com/taylordunn/canadacovid/actions)
[![Codecov test
coverage](https://codecov.io/gh/taylordunn/canadacovid/branch/main/graph/badge.svg)](https://app.codecov.io/gh/taylordunn/canadacovid?branch=main)
<!-- badges: end -->

The goal of `canadacovid` is to provide a wrapper around the API service
for the [COVID-19 Tracker Canada](https://covid19tracker.ca/).

## Installation

You can install the development version of `canadacovid` from GitHub:

``` r
#install.packages("remotes")
remotes::install_github("taylordunn/canadacovid")
```

## Example

To get the latest summary data:

``` r
library(canadacovid)
library(tidyverse)
#> -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
#> v ggplot2 3.3.5     v purrr   0.3.4
#> v tibble  3.1.6     v dplyr   1.0.7
#> v tidyr   1.1.4     v stringr 1.4.0
#> v readr   2.1.1     v forcats 0.5.1
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

summary_overall <- get_summary()
glimpse(summary_overall)
#> Rows: 1
#> Columns: 22
#> $ latest_date                 <date> 2021-12-31
#> $ change_cases                <int> 35406
#> $ change_fatalities           <int> 33
#> $ change_tests                <int> 137829
#> $ change_hospitalizations     <int> 305
#> $ change_criticals            <int> 17
#> $ change_recoveries           <int> 4683
#> $ change_vaccinations         <int> 285617
#> $ change_vaccinated           <int> 9147
#> $ change_boosters_1           <int> 261121
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 2176408
#> $ total_fatalities            <int> 30313
#> $ total_tests                 <int> 53074265
#> $ total_hospitalizations      <int> 3125
#> $ total_criticals             <int> 531
#> $ total_recoveries            <int> 1879466
#> $ total_vaccinations          <int> 68713001
#> $ total_vaccinated            <int> 29411738
#> $ total_boosters_1            <int> 7562263
#> $ total_vaccines_distributed  <int> 74073364
#> $ last_updated                <dttm> 2021-12-30 20:00:00
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by province/territory:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 23
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", ~
#> $ date                        <date> 2021-12-31, 2021-12-31, 2021-12-31, 2021-~
#> $ change_cases                <int> 16713, 16461, 0, 0, 1490, 0, 0, 742, 0, 0,~
#> $ change_fatalities           <int> 15, 13, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0
#> $ change_tests                <int> 75093, 55446, 0, 0, 4471, 0, 0, 2819, 0, 0~
#> $ change_hospitalizations     <int> 179, 124, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0
#> $ change_criticals            <int> 5, 13, 0, 0, 1, 0, 0, -2, 0, 0, 0, 0, 0
#> $ change_recoveries           <int> 4630, 0, 0, 0, -21, 0, 0, 74, 0, 0, 0, 0, 0
#> $ change_vaccinations         <int> 195809, 88164, 0, 0, 0, 0, 0, 1644, 0, 0, ~
#> $ change_vaccinated           <int> 5571, 2540, 0, 0, 0, 0, 0, 1036, 0, 0, 0, ~
#> $ change_boosters_1           <int> 178909, 82212, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 756361, 603068, 17063, 13590, 80096, 25105~
#> $ total_fatalities            <int> 10194, 11724, 111, 159, 1392, 2420, 0, 955~
#> $ total_tests                 <int> 21254037, 14868979, 1568215, 615048, 12743~
#> $ total_hospitalizations      <int> 1144, 1063, 25, 40, 192, 211, 0, 79, 371, ~
#> $ total_criticals             <int> 205, 151, 3, 16, 30, 66, 0, 12, 48, 0, 0, ~
#> $ total_recoveries            <int> 647345, 488030, 8643, 10589, 68780, 230784~
#> $ total_vaccinations          <int> 27208675, 15333304, 1785034, 1445189, 2441~
#> $ total_vaccinated            <int> 11410550, 6687698, 794509, 622069, 1037539~
#> $ total_boosters_1            <int> 3571791, 1342896, 128183, 146807, 276639, ~
#> $ total_vaccines_distributed  <int> 28411391, 16179459, 1950040, 1604365, 2885~
#> $ last_updated                <dttm> 2021-12-30 20:00:00, 2021-12-30 20:00:00, ~
```

Or by health region:

``` r
summary_region <- get_summary(split = "region")
glimpse(summary_region)
#> Rows: 92
#> Columns: 19
#> $ hr_uid                 <int> 6101, 6001, 1100, 6201, 1011, 1012, 1013, 1014,~
#> $ date                   <date> 2021-12-23, 2021-12-23, 2021-12-23, 2021-12-28~
#> $ change_cases           <int> 0, 9, NA, 31, NA, NA, NA, NA, NA, NA, NA, NA, N~
#> $ change_fatalities      <int> 0, 0, NA, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA~
#> $ change_recoveries      <int> 0, 7, NA, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA~
#> $ total_cases            <int> 2090, 1661, 529, 710, 1380, 540, 305, 42, 685, ~
#> $ total_fatalities       <int> 12, 14, 0, 4, 7, 10, 1, 0, 8, 7, 8, 87, 290, 85~
#> $ total_tests            <int> 36435, 25087, 242814, 24355, 240838, 54999, 532~
#> $ total_hospitalizations <int> 0, NA, 0, 263, 0, 0, 0, 0, NA, NA, NA, NA, 17, ~
#> $ total_criticals        <int> 0, 0, 0, NA, 1, 0, 0, 0, NA, NA, NA, NA, 2, 18,~
#> $ total_recoveries       <int> 2059, 1602, 417, 672, 1319, 473, 234, 41, 640, ~
#> $ total_vaccinations     <int> 91434, 80825, 292619, 55230, NA, NA, NA, NA, NA~
#> $ total_vaccinated       <int> 36803, 34029, 133999, 24746, NA, NA, NA, NA, NA~
#> $ total_boosters_1       <int> 14692, 10341, 15181, NA, NA, NA, NA, NA, NA, NA~
#> $ change_tests           <int> NA, 70, NA, 969, NA, NA, NA, NA, NA, NA, NA, NA~
#> $ change_vaccinations    <int> NA, 0, 3486, 439, NA, NA, NA, NA, NA, NA, NA, N~
#> $ change_vaccinated      <int> NA, 0, 128, 81, NA, NA, NA, NA, NA, NA, NA, NA,~
#> $ change_boosters_1      <int> NA, 0, 2336, NA, NA, NA, NA, NA, NA, NA, NA, NA~
#> $ last_updated           <dttm> 2021-12-30 20:00:00, 2021-12-30 20:00:00, 2021~
```
