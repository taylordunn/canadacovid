
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
[![](https://cranlogs.r-pkg.org/badges/canadacovid)](https://cran.r-project.org/package=canadacovid)
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
#> Columns: 24
#> $ last_updated                <dttm> 2022-05-13 00:21:50
#> $ latest_date                 <date> 2022-05-12
#> $ change_cases                <int> 3637
#> $ change_fatalities           <int> 58
#> $ change_tests                <int> 23459
#> $ change_hospitalizations     <int> -172
#> $ change_criticals            <int> -7
#> $ change_recoveries           <int> 2602
#> $ change_vaccinations         <int> 72858
#> $ change_vaccinated           <int> 2320
#> $ change_boosters_1           <int> 6781
#> $ change_boosters_2           <int> 37530
#> $ change_vaccines_distributed <int> 0
#> $ total_cases                 <int> 3792294
#> $ total_fatalities            <int> 40005
#> $ total_tests                 <int> 59814813
#> $ total_hospitalizations      <int> 6087
#> $ total_criticals             <int> 383
#> $ total_recoveries            <int> 3475157
#> $ total_vaccinations          <int> 84713309
#> $ total_vaccinated            <int> 31343697
#> $ total_boosters_1            <int> 18581632
#> $ total_boosters_2            <int> 2017868
#> $ total_vaccines_distributed  <int> 95355642
```

By default, this returns the aggregate data over all of Canada. Provide
a `split` argument to get a summary by “province” or “region”:

``` r
summary_province <- get_summary(split = "province")
glimpse(summary_province)
#> Rows: 13
#> Columns: 25
#> $ last_updated                <dttm> 2022-05-13 00:21:50, 2022-05-13 00:21:50,…
#> $ province                    <chr> "ON", "QC", "NS", "NB", "MB", "BC", "PE", …
#> $ date                        <chr> "2022-05-12", "2022-05-12", "2022-05-12", …
#> $ change_cases                <int> 2160, 767, 0, 0, 0, 0, 0, 710, 0, 0, 0, 0,…
#> $ change_fatalities           <int> 14, 25, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0
#> $ change_tests                <int> 16360, 0, 0, 0, 0, 0, 0, 7099, 0, 0, 0, 0,…
#> $ change_hospitalizations     <int> -77, -26, 0, 0, 0, 0, 0, -69, 0, 0, 0, 0, 0
#> $ change_criticals            <int> -1, -2, 0, 0, 0, 0, 0, -4, 0, 0, 0, 0, 0
#> $ change_recoveries           <int> 2602, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ change_vaccinations         <int> 29173, 19893, 0, 0, 0, 0, 0, 23792, 0, 0, …
#> $ change_vaccinated           <int> 1380, 465, 0, 0, 0, 0, 0, 475, 0, 0, 0, 0,…
#> $ change_boosters_1           <int> 2771, 2397, 0, 0, 0, 0, 0, 1613, 0, 0, 0, …
#> $ change_boosters_2           <int> 0, 16761, 0, 0, 0, 0, 0, 20769, 0, 0, 0, 0…
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#> $ total_cases                 <int> 1281360, 1055277, 78174, 63490, 140931, 36…
#> $ total_fatalities            <int> 13034, 15226, 336, 406, 1792, 3226, 26, 13…
#> $ total_tests                 <int> 24232283, 16733572, 1777959, 782596, 14783…
#> $ total_hospitalizations      <int> 1451, 1821, 66, 47, 579, 550, 13, 321, 122…
#> $ total_criticals             <int> 175, 60, 17, 6, 28, 39, 0, 16, 37, 5, 0, 0…
#> $ total_recoveries            <int> 1247571, 983050, 43018, 49723, 129338, 307…
#> $ total_vaccinations          <int> 33027991, 20042788, 2235685, 1748729, 2863…
#> $ total_vaccinated            <int> 12182139, 7158529, 842600, 659327, 1108820…
#> $ total_boosters_1            <int> 7337274, 4448891, 503257, 390204, 593160, …
#> $ total_boosters_2            <int> 790774, 971194, 0, 0, 0, 48479, 0, 86119, …
#> $ total_vaccines_distributed  <int> 36042671, 22682919, 2458152, 2149445, 3736…
```

Day-by-day reports are retrieved with `get_reports`:

``` r
reports_overall <- get_reports()
glimpse(reports_overall)
#> Rows: 839
#> Columns: 24
#> $ last_updated                <dttm> 2022-05-13 00:21:50, 2022-05-13 00:21:50,…
#> $ date                        <date> 2020-01-25, 2020-01-26, 2020-01-27, 2020-…
#> $ change_cases                <int> 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 2, 0, …
#> $ change_fatalities           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_tests                <int> 2, 4, 20, 10, 3, 26, 33, 23, 24, 16, 56, 5…
#> $ change_hospitalizations     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_criticals            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_recoveries           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_vaccinations         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_vaccinated           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_boosters_1           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_boosters_2           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ change_vaccines_distributed <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_cases                 <int> 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 5, 7, 7, …
#> $ total_fatalities            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_tests                 <int> 2, 6, 26, 36, 39, 65, 98, 121, 145, 161, 2…
#> $ total_hospitalizations      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_criticals             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_recoveries            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_vaccinations          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_vaccinated            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_boosters_1            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_boosters_2            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ total_vaccines_distributed  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
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
#> $ province          <chr> "NS", "NS", "NS", "NS", "NS", "NS", "NS", "NS", "NS"…
#> $ last_updated      <dttm> 2022-05-12 00:52:17, 2022-05-12 00:52:17, 2022-05-1…
#> $ date              <date> 2021-01-01, 2021-01-02, 2021-01-03, 2021-01-04, 202…
#> $ change_fatalities <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ total_fatalities  <int> 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, …
```

## To-do

-   Consider adding `memoise` functionality to avoid repeated API
    requests.
