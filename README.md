
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
#> $ last_updated                <dttm> 2022-01-07 20:00:00
#> $ latest_date                 <date> 2022-01-08
#> $ change_cases                <int> 30234
#> $ change_fatalities           <int> 74
#> $ change_tests                <int> 59210
#> $ change_hospitalizations     <int> 294
#> $ change_criticals            <int> 65
#> $ change_recoveries           <int> 12308
#> $ change_vaccinations         <int> 187135
#> $ change_vaccinated           <int> 10104
#> $ change_boosters_1           <int> 164668
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 2511473
#> $ total_fatalities            <int> 30742
#> $ total_tests                 <int> 54305056
#> $ total_hospitalizations      <int> 6275
#> $ total_criticals             <int> 858
#> $ total_recoveries            <int> 2075298
#> $ total_vaccinations          <int> 70985386
#> $ total_vaccinated            <int> 29514160
#> $ total_boosters_1            <int> 9589957
#> $ total_vaccines_distributed  <int> 80222864
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by “province” or “region”:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 23
#> $ last_updated                <dttm> 2022-01-07 20:00:00, 2022-01-07 20:00:00,~
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", ~
#> $ date                        <date> 2022-01-08, 2022-01-08, 2022-01-08, 2022-~
#> $ change_cases                <int> 13362, 15928, 0, 0, 0, 0, 0, 944, 0, 0, 0,~
#> $ change_fatalities           <int> 30, 44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ change_tests                <int> 55700, 0, 0, 0, 0, 0, 0, 3510, 0, 0, 0, 0,~
#> $ change_hospitalizations     <int> 122, 163, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0
#> $ change_criticals            <int> 47, 16, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0
#> $ change_recoveries           <int> 12007, 0, 0, 0, 0, 0, 0, 301, 0, 0, 0, 0, 0
#> $ change_vaccinations         <int> 184101, 0, 0, 0, 0, 0, 0, 3034, 0, 0, 0, 0~
#> $ change_vaccinated           <int> 8168, 0, 0, 0, 0, 0, 0, 1936, 0, 0, 0, 0, 0
#> $ change_boosters_1           <int> 164668, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 866632, 728286, 23879, 19857, 94850, 27687~
#> $ total_fatalities            <int> 10345, 11917, 112, 170, 1408, 2439, 0, 961~
#> $ total_tests                 <int> 21725105, 15246492, 1606541, 634368, 13111~
#> $ total_hospitalizations      <int> 2594, 2296, 48, 69, 297, 349, 0, 114, 504,~
#> $ total_criticals             <int> 385, 245, 7, 17, 34, 93, 0, 13, 64, 0, 0, ~
#> $ total_recoveries            <int> 719739, 577427, 17152, 12127, 68847, 24019~
#> $ total_vaccinations          <int> 28324152, 15762212, 1842770, 1481051, 2548~
#> $ total_vaccinated            <int> 11462390, 6700494, 796012, 623628, 1041044~
#> $ total_boosters_1            <int> 4571616, 1742133, 180694, 177530, 373869, ~
#> $ total_vaccines_distributed  <int> 32296511, 16948499, 2063380, 1681965, 2987~
```

Day-by-day reports are retrieved with `get_reports`:

``` r
reports_overall <- get_reports()
glimpse(reports_overall)
#> Rows: 715
#> Columns: 22
#> $ last_updated                <dttm> 2022-01-07 20:00:00, 2022-01-07 20:00:00,~
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
#> $ last_updated      <dttm> 2022-01-07 20:00:00, 2022-01-07 20:00:00, 2022-01-0~
#> $ date              <date> 2021-01-01, 2021-01-02, 2021-01-03, 2021-01-04, 202~
#> $ change_fatalities <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
#> $ total_fatalities  <int> 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, ~
```

## To-do

-   Consider adding `memoise` functionality to avoid repeated API
    requests.
