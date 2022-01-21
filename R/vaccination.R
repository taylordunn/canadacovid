#' Get sub-region vaccination data
#'
#' Runs a GET request of sub-region vaccination data from the COVID-19 tracker
#' API, and returns parsed data.
#' The `dates` argument specifies the time frame of the data: "current"
#' (the default; latest report for each sub-region), "recent"
#' (15 most recent reports for each sub-region), and "all" (returns all reports
#' for one or more sub-regions specified by the `subregion_code` argument).
#' To get a list of available sub-regions, use the function `get_subregions()`.
#'
#' Note that sub-region vaccination data is only for select provinces and
#' territories. Also the percentages reported differ between percent of total
#' population, and percent of eligible population.
#' See the API documentation for more details:
#' https://api.covid19tracker.ca/docs/1.0/vaccinations.
#'
#' @param dates One of "current", "recent", or "all" to specify the time frame
#'   of the reports returned. If choosing "all" reports, must also provide one
#'   or more sub-region codes.
#' @param subregion_code One or more sub-region codes. Returns all reports for
#'   those sub-regions (even if `dates` is not "all")
#'
#' @return A data frame with one row per sub-region report.
#' @export
#'
#' @examples
#'
#' get_subregion_vaccination_data()
#' get_subregion_vaccination_data("recent")
#' get_subregion_vaccination_data("all", subregion_code = c("ON382", "SK007"))
#' @importFrom dplyr bind_cols bind_rows mutate
#' @importFrom purrr map_dfr
#' @importFrom tidyselect matches
get_subregion_vaccination_data <- function(dates = c("current", "recent", "all"),
                                           subregion_code = NULL) {
  dates <- match.arg(dates)
  base_url <- "https://api.covid19tracker.ca/reports/sub-regions/"
  dates_path <- switch(dates,
    current = "summary",
    recent = "recent",
    all = ""
  )
  url <- paste0(base_url, dates_path)

  if (is.null(subregion_code)) {
    if (dates == "all") {
      stop("Must specify sub-region(s) to return all vaccination reports.")
    }
    content_parsed <- get_content_parsed(url)

    vaccination_data <- dplyr::bind_cols(
      content_parsed["last_updated"],
      dplyr::bind_rows(content_parsed$data)
    )
  } else {
    vaccination_data <- purrr::map_dfr(
      subregion_code,
      function(subregion_code) {
        url <- paste0(url, subregion_code)
        content_parsed <- get_content_parsed(url)

        dplyr::bind_cols(
          content_parsed["sub_region"],
          dplyr::bind_rows(content_parsed$data)
        )
      }
    )
  }

  vaccination_data %>%
    dplyr::mutate(
      dplyr::across(tidyselect::matches("^total"), as.integer),
      dplyr::across(tidyselect::matches("^percent"), as.numeric),
      dplyr::across(tidyselect::matches("latest_date"), as.Date),
      dplyr::across(tidyselect::matches("last_updated"),
                    ~ as.POSIXct(.x, tz = "America/Regina"))
    )
}

#' Get vaccination data
#'
#' Runs a GET request of vaccination data from the COVID-19 tracker API, and
#' returns parsed data.
#' Data may be returned as `type` = "summary" (the most recent data) or
#' `type` = "reports" (day-to-day reports).
#' Via the `split` argument, data may be "overall" (all provinces/territories
#' combined), by "province", or by "region".
#' Alternatively, provide one or more two-letter codes (e.g. "AB") to `province`
#' to return reports for specific provinces, or one or more numeric `region`
#' codes (e.g. "1204") to return specific health regions.
#'
#' @param type One of "summary" (most recent data) or "reports" (day-to-day
#'   data).
#' @param split One of "overall", "province", or "region" to specify how the
#'   data is split. An "overall" summary or report gives cumulative numbers
#'   across Canada. Splitting by "province" returns data for all
#'   provinces/territories. Splitting by "region" is only available for
#'   "summary" data, and returns data for all health regions.
#' @param province One or more province/territory codes ("AB", "BC", "MB", "NB",
#'   "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT") to get reports.
#'   Upper, lower and mixed case strings are accepted.
#' @param region One or more health region IDs to get reports. Numeric and
#'   character values are accepted.
#' @param fill_dates When TRUE, the response fills in any missing dates with
#'   blank entries.
#' @param stat Returns only the specified statistics, e.g. "cases".
#' @param date Returns reports from only the specified date,
#'   in YYYY-MM-DD format.
#' @param after Returns reports from only on or after the specified date,
#'   in YYYY-MM-DD format.
#' @param before Returns reports from only on or before the specified date,
#'   in YYYY-MM-DD format.
#'
#' @return A data frame containing the vaccinations data. Includes
#'   a `province` variable if data is split by province, and a `hr_uid` variable
#'   if data is split by health region.
#' @export
#'
#' @examples
#'
#' get_vaccination_data()
#' get_vaccination_data(split = "province")
#' get_vaccination_data(type = "reports", split = "overall")
#' get_vaccination_data(type = "reports", split = "overall",
#'                      date = "2021-12-25")
#' @importFrom dplyr select
#' @importFrom tidyselect matches
get_vaccination_data <- function(type = c("summary", "reports"),
                                 split = c("overall", "province", "region"),
                                 province = NULL, region = NULL,
                                 fill_dates = NULL, stat = NULL, date = NULL,
                                 after = NULL, before = NULL) {
  type <- match.arg(type)
  split <- match.arg(split)

  if (type == "summary") {
    vaccination_data <- get_summary(split)
  } else {
    # Getting reports for each region sends too many requests to the API
    if (split == "region") {
      stop(paste(
        "For `type` = 'reports', only `split` = 'overall' and 'province'",
        "are available."
      ))
    }

    vaccination_data <- get_reports(
      split, province, region, fill_dates, stat,
      date, after, before
    )
  }

  vaccination_data %>%
    dplyr::select(
      tidyselect::matches("province|hr_uid"),
      tidyselect::matches("date|last_updated"),
      tidyselect::matches("vacc|boost")
    )
}
