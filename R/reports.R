#' Get the day-to-day reports
#'
#' Runs a GET request of reports data from the COVID-19 tracker API, and
#' returns parsed data.
#' Via the `split` argument, data may be "overall" (all provinces/territories
#' combined), or by "province".
#' Alternatively, provide one or more two-letter codes (e.g. "AB") to `province`
#' to return reports for specific provinces, or one or more numeric `region`
#' codes (e.g. "1204") to return specific health regions.
#'
#' @param split One of "overall", or "province" to specify how the
#'   data is split. An "overall" report gives cumulative numbers across Canada.
#'   Splitting by "province" returns all reports for all provinces/territories.
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
#' @return A data frame containing the reports data, one row per day. Includes
#'   a `province` variable if data is split by province, and a `hr_uid` variable
#'   if data is split by health region.
#' @export
#'
#' @examples
#'
#' get_reports()
#' get_reports(province = c("AB", "SK"))
#' get_reports(region = 1204)
#' get_reports(region = c("472", 1204), stat = "cases")
#' @importFrom dplyr bind_rows bind_cols mutate across
#' @importFrom tidyselect matches
#' @importFrom rlang .data
#' @importFrom purrr imap_chr map_dfr
#' @importFrom tibble lst
get_reports <- function(split = c("overall", "province"),
                        province = NULL, region = NULL,
                        fill_dates = NULL, stat = NULL, date = NULL,
                        after = NULL, before = NULL) {
  base_url <- "https://api.covid19tracker.ca/reports/"
  province_codes <- c(
    "AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON",
    "PE", "QC", "SK", "YT"
  )

  split <- match.arg(split)
  if (split == "province") province <- province_codes

  parameters <- tibble::lst(fill_dates, stat, date, after, before)
  # Remove NULL parameters
  parameters <- parameters[lengths(parameters) == 1]
  if (length(parameters) > 0) {
    params_url <- purrr::imap_chr(parameters, ~ paste0(.y, "=", tolower(.x))) %>%
      paste(collapse = "&")
    params_url <- paste0("?", params_url)
  } else {
    params_url <- ""
  }

  if (!is.null(province)) {
    province <- match.arg(toupper(province), province_codes, several.ok = TRUE)

    reports <- purrr::map_dfr(
      province,
      function(province) {
        url <- paste0(base_url, "province/", province, params_url)
        content_parsed <- get_content_parsed(url)

        dplyr::bind_cols(
          content_parsed[c("province", "last_updated")],
          dplyr::bind_rows(content_parsed$data)
        )
      }
    )
  } else if (!is.null(region)) {
    reports <- purrr::map_dfr(
      region,
      function(region) {
        url <- paste0(base_url, "regions/", region, params_url)
        content_parsed <- get_content_parsed(url)

        dplyr::bind_cols(
          content_parsed[c("hr_uid", "last_updated")],
          dplyr::bind_rows(content_parsed$data)
        )
      }
    )
  } else {
    content_parsed <- get_content_parsed(paste0(base_url, params_url))
    reports <- dplyr::bind_cols(
      content_parsed["last_updated"],
      dplyr::bind_rows(content_parsed$data)
    )
  }

  reports %>%
    dplyr::mutate(
      dplyr::across(tidyselect::matches("^change|total"), as.integer),
      dplyr::across(tidyselect::matches("^date"), as.Date),
      last_updated = as.POSIXct(.data$last_updated,
                                tz = "America/Regina")
    )
}
