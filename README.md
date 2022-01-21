
<!-- README.md is generated from README.Rmd. Please edit that file -->

# canadacovid

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/canadacovid)](https://CRAN.R-project.org/package=canadacovid)
[![R-CMD-check](https://github.com/taylordunn/canadacovid/workflows/R-CMD-check/badge.svg)](https://github.com/taylordunn/canadacovid/actions)
[![Codecov test
coverage](https://codecov.io/gh/taylordunn/canadacovid/branch/main/graph/badge.svg)](https://app.codecov.io/gh/taylordunn/canadacovid?branch=main)
<!-- badges: end -->

The goal of `canadacovid` is to provide a wrapper around the API service
for the [COVID-19 Tracker Canada](https://covid19tracker.ca/). To see
how the package was developed, see [this
post](https://tdunn.ca/posts/2021-12-30-canada-covid-19-data-in-r-creating-a-package/).

## Installation

Install `canadacovid` from CRAN:

``` r
install.packages("canadacovid")
```

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

summary_overall <- get_summary()
glimpse(summary_overall)
#> Rows: 1
#> Columns: 22
#> $ last_updated                <dttm> 2022-01-20 18:10:02
#> $ latest_date                 <date> 2022-01-20
#> $ change_cases                <int> 23167
#> $ change_fatalities           <int> 210
#> $ change_tests                <int> 81335
#> $ change_hospitalizations     <int> -6
#> $ change_criticals            <int> 8
#> $ change_recoveries           <int> 30579
#> $ change_vaccinations         <int> 198559
#> $ change_vaccinated           <int> 14000
#> $ change_boosters_1           <int> 187385
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 2866146
#> $ total_fatalities            <int> 32217
#> $ total_tests                 <int> 55885939
#> $ total_hospitalizations      <int> 10609
#> $ total_criticals             <int> 1203
#> $ total_recoveries            <int> 2520615
#> $ total_vaccinations          <int> 75105874
#> $ total_vaccinated            <int> 29729902
#> $ total_boosters_1            <int> 13229157
#> $ total_vaccines_distributed  <int> 84909134
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by “province” or “region”:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 23
#> $ last_updated                <dttm> 2022-01-20 18:10:02, 2022-01-20 18:10:02,~
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", ~
#> $ date                        <chr> "2022-01-20", "2022-01-20", "2022-01-20", ~
#> $ change_cases                <int> 7757, 6528, 696, 488, 850, 2150, 0, 1171, ~
#> $ change_fatalities           <int> 75, 98, 4, 3, 7, 15, 0, 0, 8, 0, 0, 0, 0
#> $ change_tests                <int> 42907, 0, 4459, 4580, 2450, 12274, 0, 3513~
#> $ change_hospitalizations     <int> -71, -14, 2, 1, 34, -4, 0, 16, 30, 0, 0, 0~
#> $ change_criticals            <int> 5, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0
#> $ change_recoveries           <int> 12578, 0, 0, 392, 6809, 3174, 0, 1092, 653~
#> $ change_vaccinations         <int> 104845, 0, 18072, 10130, 8531, 59042, 0, 2~
#> $ change_vaccinated           <int> 9205, 0, 306, 307, 913, 2001, 0, 1263, 5, ~
#> $ change_boosters_1           <int> 86274, 0, 17233, 9159, 6739, 54080, 0, 0, ~
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 977194, 818947, 31874, 24489, 113196, 3057~
#> $ total_fatalities            <int> 10801, 12639, 128, 199, 1485, 2520, 2, 961~
#> $ total_tests                 <int> 22288866, 15682022, 1674063, 666919, 13574~
#> $ total_hospitalizations      <int> 4061, 3411, 85, 124, 665, 891, 8, 215, 113~
#> $ total_criticals             <int> 594, 285, 12, 12, 50, 115, 4, 23, 108, 0, ~
#> $ total_recoveries            <int> 887023, 747819, 17152, 19899, 75969, 26576~
#> $ total_vaccinations          <int> 29769719, 16953912, 1998064, 1575232, 2681~
#> $ total_vaccinated            <int> 11570076, 6734670, 798609, 626997, 1048824~
#> $ total_boosters_1            <int> 5793578, 2844797, 327601, 261910, 488289, ~
#> $ total_vaccines_distributed  <int> 33390981, 19822969, 2243162, 1756685, 2987~
```

Day-by-day reports are retrieved with `get_reports`:

``` r
reports_overall <- get_reports()
#> Called from: get_reports()
#> debug: reports %>% dplyr::mutate(dplyr::across(tidyselect::matches("^change|total"), 
#>     as.integer), dplyr::across(tidyselect::matches("^date"), 
#>     as.Date), last_updated = as.POSIXct(.data$last_updated, tz = "America/Regina"))
glimpse(reports_overall)
#> Rows: 727
#> Columns: 22
#> $ last_updated                <dttm> 2022-01-20 18:10:02, 2022-01-20 18:10:02,~
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
#> $ last_updated      <dttm> 2022-01-20 14:12:04, 2022-01-20 14:12:04, 2022-01-2~
#> $ date              <date> 2021-01-01, 2021-01-02, 2021-01-03, 2021-01-04, 202~
#> $ change_fatalities <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
#> $ total_fatalities  <int> 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, ~
```

## To-do

-   Consider adding `memoise` functionality to avoid repeated API
    requests.
