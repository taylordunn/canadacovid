
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
library(tidyverse, quietly = TRUE)
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
#> $ last_updated                <dttm> 2022-01-04 20:00:00
#> $ latest_date                 <date> 2022-01-05
#> $ change_cases                <int> 38567
#> $ change_fatalities           <int> 68
#> $ change_tests                <int> 84125
#> $ change_hospitalizations     <int> 1022
#> $ change_criticals            <int> 39
#> $ change_recoveries           <int> 21672
#> $ change_vaccinations         <int> 291073
#> $ change_vaccinated           <int> 14300
#> $ change_boosters_1           <int> 258695
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 2393543
#> $ total_fatalities            <int> 30524
#> $ total_tests                 <int> 53632718
#> $ total_hospitalizations      <int> 5081
#> $ total_criticals             <int> 701
#> $ total_recoveries            <int> 1938674
#> $ total_vaccinations          <int> 69853531
#> $ total_vaccinated            <int> 29464565
#> $ total_boosters_1            <int> 8573395
#> $ total_vaccines_distributed  <int> 74272404
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by “province” or “region”:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 23
#> $ last_updated                <dttm> 2022-01-04 20:00:00, 2022-01-04 20:00:00,~
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", ~
#> $ date                        <date> 2022-01-05, 2022-01-05, 2022-01-05, 2022-~
#> $ change_cases                <int> 11582, 14486, 842, 779, 1787, 3798, 0, 541~
#> $ change_fatalities           <int> 13, 39, 0, 3, 2, 0, 0, 0, 11, 0, 0, 0, 0
#> $ change_tests                <int> 59137, 0, 0, 3668, 6237, 0, 0, 2389, 12694~
#> $ change_hospitalizations     <int> 791, 158, 5, 3, 1, 19, 0, 11, 34, 0, 0, 0,~
#> $ change_criticals            <int> 22, 6, 3, 0, -2, -3, 0, 2, 11, 0, 0, 0, 0
#> $ change_recoveries           <int> 11669, 0, 7057, 65, 17, 886, 0, 157, 1821,~
#> $ change_vaccinations         <int> 180013, 0, 22337, 5587, 12107, 41463, 0, 1~
#> $ change_vaccinated           <int> 8682, 0, 546, 268, 454, 1593, 0, 1272, 148~
#> $ change_boosters_1           <int> 161487, 0, 20447, 4785, 11013, 37165, 0, 0~
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 828032, 680308, 22456, 18345, 89050, 27050~
#> $ total_fatalities            <int> 10252, 11820, 111, 168, 1402, 2427, 0, 960~
#> $ total_tests                 <int> 21549027, 14868979, 1601042, 630521, 12992~
#> $ total_hospitalizations      <int> 2081, 1750, 45, 59, 252, 317, 0, 106, 470,~
#> $ total_criticals             <int> 288, 191, 8, 16, 30, 83, 0, 13, 72, 0, 0, ~
#> $ total_recoveries            <int> 683750, 488030, 15700, 11352, 68804, 23719~
#> $ total_vaccinations          <int> 27750953, 15457130, 1815283, 1466105, 2515~
#> $ total_vaccinated            <int> 11436474, 6691563, 795461, 622997, 1039795~
#> $ total_boosters_1            <int> 4056554, 1457767, 155144, 164358, 344261, ~
#> $ total_vaccines_distributed  <int> 28411391, 16179459, 1950040, 1604365, 2885~
```

Day-by-day reports are retrieved with `get_reports`:

``` r
reports_overall <- get_reports()
glimpse(reports_overall)
#> Rows: 712
#> Columns: 22
#> $ last_updated                <dttm> 2022-01-04 20:00:00, 2022-01-04 20:00:00,~
#> $ date                        <date> 2020-01-25, 2020-01-26, 2020-01-27, 2020-~
#> $ change_cases                <int> 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 2, 0, ~
#> $ change_fatalities           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_tests                <int> 2, 4, 20, 10, 3, 26, 33, 23, 24, 16, 56, 5~
#> $ change_hospitalizations     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_criticals            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_recoveries           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_vaccinations         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_vaccinated           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_boosters_1           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_cases                 <int> 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 5, 7, 7, ~
#> $ total_fatalities            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_tests                 <int> 2, 6, 26, 36, 39, 65, 98, 121, 145, 161, 2~
#> $ total_hospitalizations      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_criticals             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_recoveries            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_vaccinations          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_vaccinated            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_boosters_1            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
#> $ total_vaccines_distributed  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
```

This function comes with a number of arguments to return very specific
data:

``` r
reports_ns_fatalities_2021 <-
  get_reports(province = "NS", stat = "fatalities",
              after = "2021-01-01", before = "2021-12-31")
glimpse(reports_ns_fatalities_2021)
#> Rows: 365
#> Columns: 5
#> $ province          <chr> "NS", "NS", "NS", "NS", "NS", "NS", "NS", "NS", "NS"~
#> $ last_updated      <dttm> 2022-01-04 20:00:00, 2022-01-04 20:00:00, 2022-01-0~
#> $ date              <date> 2021-01-01, 2021-01-02, 2021-01-03, 2021-01-04, 202~
#> $ change_fatalities <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
#> $ total_fatalities  <int> 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, ~
```
