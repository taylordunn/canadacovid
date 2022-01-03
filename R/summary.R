#' Get the most recent summary data
#'
#' Runs a GET request of summary data from the COVID-19 tracker API, and
#' returns parsed data.
#' Via the `split` argument, data my be "overall" (all provinces/territories
#' combined), by "province" (one row per province/territory) or by "region"
#' (one row per health region).
#'
#' @param split One of "overall", "province", or "region" to specify how the
#'   data is split.
#'
#' @return A data frame containing the summary data.
#' @export
#'
#' @examples
#'
#' get_summary()
#' get_summary("province")
#' get_summary("region")
#' @importFrom dplyr bind_rows bind_cols mutate across
#' @importFrom tidyselect matches
#' @importFrom rlang .data
get_summary <- function(split = c("overall", "province", "region")) {
  split <- match.arg(split)
  base_url <- "https://api.covid19tracker.ca/summary"
  split_path <- switch(split,
    overall = "",
    province = "/split",
    region = "/split/hr"
  )
  url <- paste0(base_url, split_path)

  content_parsed <- get_content_parsed(url)

  dplyr::bind_cols(
    content_parsed["last_updated"],
    dplyr::bind_rows(content_parsed$data)
  ) %>%
    dplyr::mutate(
      dplyr::across(tidyselect::matches("^change|total"), as.integer),
      dplyr::across(tidyselect::matches("date"), as.Date),
      last_updated = as.POSIXct(.data$last_updated)
    )
}
