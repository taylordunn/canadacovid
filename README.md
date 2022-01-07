
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
#> $ last_updated                <dttm> 2022-01-05 20:00:00
#> $ latest_date                 <date> 2022-01-06
#> $ change_cases                <int> 42189
#> $ change_fatalities           <int> 60
#> $ change_tests                <int> 97545
#> $ change_hospitalizations     <int> 448
#> $ change_criticals            <int> 52
#> $ change_recoveries           <int> 15995
#> $ change_vaccinations         <int> 119166
#> $ change_vaccinated           <int> 11416
#> $ change_boosters_1           <int> 103664
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 2436353
#> $ total_fatalities            <int> 30584
#> $ total_tests                 <int> 54016081
#> $ total_hospitalizations      <int> 5531
#> $ total_criticals             <int> 753
#> $ total_recoveries            <int> 2019613
#> $ total_vaccinations          <int> 70071379
#> $ total_vaccinated            <int> 29478459
#> $ total_boosters_1            <int> 8769227
#> $ total_vaccines_distributed  <int> 74317454
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by “province” or “region”:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 23
#> $ last_updated                <dttm> 2022-01-05 20:00:00, 2022-01-05 20:00:00,~
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", ~
#> $ date                        <date> 2022-01-06, 2022-01-06, 2022-01-06, 2022-~
#> $ change_cases                <int> 13339, 15874, 745, 672, 2537, 3223, 0, 930~
#> $ change_fatalities           <int> 20, 26, 0, 1, 6, 3, 0, 1, 3, 0, 0, 0, 0
#> $ change_tests                <int> 59241, 0, 0, 1856, 6248, 14562, 0, 3307, 1~
#> $ change_hospitalizations     <int> 198, 203, 3, 4, 11, 7, 0, -6, 28, 0, 0, 0,~
#> $ change_criticals            <int> 31, 16, 1, 3, 3, 7, 0, -1, -8, 0, 0, 0, 0
#> $ change_recoveries           <int> 12036, 0, 0, 227, 98, 1329, 0, 140, 2165, ~
#> $ change_vaccinations         <int> 0, 0, 13191, 6333, 17825, 50044, 0, 2172, ~
#> $ change_vaccinated           <int> 0, 0, 255, 273, 657, 1851, 0, 1382, 6998, ~
#> $ change_boosters_1           <int> 0, 0, 12286, 5611, 16299, 44329, 0, 0, 251~
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 841371, 696182, 23201, 19017, 91587, 27373~
#> $ total_fatalities            <int> 10272, 11846, 111, 169, 1408, 2430, 0, 961~
#> $ total_tests                 <int> 21608268, 15129145, 1606541, 632377, 13054~
#> $ total_hospitalizations      <int> 2279, 1953, 48, 63, 263, 324, 0, 100, 498,~
#> $ total_criticals             <int> 319, 207, 9, 19, 33, 90, 0, 12, 64, 0, 0, ~
#> $ total_recoveries            <int> 695786, 552862, 15700, 11579, 68902, 23852~
#> $ total_vaccinations          <int> 27750953, 15551922, 1828474, 1472438, 2533~
#> $ total_vaccinated            <int> 11436474, 6693709, 795716, 623270, 1040452~
#> $ total_boosters_1            <int> 4056554, 1547080, 167430, 169969, 360560, ~
#> $ total_vaccines_distributed  <int> 28411391, 16179459, 1950040, 1604365, 2885~
```

Day-by-day reports are retrieved with `get_reports`:

``` r
reports_overall <- get_reports()
glimpse(reports_overall)
#> Rows: 713
#> Columns: 22
#> $ last_updated                <dttm> 2022-01-05 20:00:00, 2022-01-05 20:00:00,~
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
#> $ last_updated      <dttm> 2022-01-05 20:00:00, 2022-01-05 20:00:00, 2022-01-0~
#> $ date              <date> 2021-01-01, 2021-01-02, 2021-01-03, 2021-01-04, 202~
#> $ change_fatalities <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
#> $ total_fatalities  <int> 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, ~
```

## To-do

-   Consider adding `memoise` functionality to avoid repeated API
    requests.
