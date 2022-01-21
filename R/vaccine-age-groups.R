#' Get vaccination reports by age group
#'
#' Runs a GET request of vaccination data by age groups from the COVID-19
#' tracker API, and returns parsed data.
#' Via the `split` argument, data may be "overall" (all provinces/territories
#' combined), or by "province".
#' Alternatively, provide one or more two-letter codes (e.g. "AB") to `province`
#' to return reports for specific provinces.
#'
#' @param split One of "overall", or "province" to specify how the
#'   data is split. An "overall" report gives cumulative numbers across Canada.
#'   Splitting by "province" returns all reports for all provinces/territories.
#' @param province One or more province/territory codes ("AB", "BC", "MB", "NB",
#'   "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT") to get reports.
#'   Upper, lower and mixed case strings are accepted.
#' @param group A specific age group to return, for example: "0-4", "05-11",
#'   "30-39", "80+", "not_reported"
#' @param after Returns reports from only on or after the specified date,
#'   in YYYY-MM-DD format.
#' @param before Returns reports from only on or before the specified date,
#'   in YYYY-MM-DD format.
#'
#' @return A data frame with, one row per age group per date. Includes
#'   a `province` variable if data is split by province.
#' @export
#'
#' @examples
#'
#' get_vaccine_age_groups()
#' get_vaccine_age_groups(split = "province")
#' get_vaccine_age_groups(province = c("AB", "SK"))
#' get_vaccine_age_groups(province = "NS", group = "18-29")
#' get_vaccine_age_groups(group = "80+", after = "2021-12-01")
#' @importFrom dplyr bind_rows bind_cols mutate across
#' @importFrom tidyselect matches
#' @importFrom rlang .data
#' @importFrom purrr imap_chr map_dfr discard
#' @importFrom tibble lst
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr unnest
#' @importFrom utils URLencode
get_vaccine_age_groups <- function(split = c("overall", "province"),
                                   province = NULL,
                                   group = NULL, before = NULL, after = NULL) {
  base_url <- "https://api.covid19tracker.ca/vaccines/age-groups"
  province_codes <- c(
    "AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON",
    "PE", "QC", "SK", "YT"
  )

  split <- match.arg(split)
  if (split == "province") {
    base_url <- paste0(base_url, "/split")
  } else if (!is.null(province)) {
    province <- match.arg(toupper(province), province_codes, several.ok = TRUE)
    base_url <- paste0(base_url, "/province/", province)
  }

  parameters <- tibble::lst(group, before, after)
  # Remove NULL parameters
  parameters <- parameters[lengths(parameters) == 1]
  if (length(parameters) > 0) {
    params_url <- purrr::imap_chr(
      parameters,
      ~ paste0(.y, "=", utils::URLencode(.x, reserved = TRUE))
    ) %>%
      paste(collapse = "&")
    params_url <- paste0("?", params_url)
  } else {
    params_url <- ""
  }

  purrr::map_dfr(
    base_url,
    function(base_url) {
      url <- paste0(base_url, params_url)
      content_parsed <- get_content_parsed(url)

      # Because age ranges can change over time, some data returned is NULL
      #  if the `group` param is used
      if (!is.null(group)) {
        # So discard NULL elements
        content_parsed$data <- purrr::discard(content_parsed$data,
                                              ~ is.null(.x$data))
      }

      if (!is.null(province)) {
        dplyr::bind_cols(
          content_parsed["province"],
          dplyr::bind_rows(content_parsed$data)
        )
      } else {
        dplyr::bind_rows(content_parsed$data)
      }
    }
  ) %>%
    dplyr::mutate(
      data = purrr::map(
        .data$data,
        ~jsonlite::fromJSON(.x) %>% dplyr::bind_rows(.id = "group_code")
      )
    ) %>%
    tidyr::unnest(.data$data) %>%
    dplyr::mutate(dplyr::across(tidyselect::matches("^date"), as.Date))
}
