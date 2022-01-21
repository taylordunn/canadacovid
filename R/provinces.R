#' Get provinces and territories
#'
#' @param geo_only Logical, indicating if only provinces/territories should be
#'   returned. If FALSE, also returned non-geographic entities like
#'   Repatriated Canadians and the Federal Allocation for vaccinations.
#'
#' @return A data frame with a row per province/territory.
#' @export
#'
#' @examples
#'
#' get_provinces()
#' get_provinces(geo_only = FALSE)
#' @importFrom dplyr bind_rows mutate
#' @importFrom rlang .data
#' @importFrom lubridate with_tz
get_provinces <- function(geo_only = TRUE) {
  base_url <- "https://api.covid19tracker.ca/provinces"
  if (geo_only) {
    api_params <- "?geo_only=true"
  } else {
    api_params <- ""
  }
  url <- paste0(base_url, api_params)

  content_parsed <- get_content_parsed(url)

  dplyr::bind_rows(content_parsed) %>%
    dplyr::mutate(
      # Use logical type instead of 0/1
      geographic = .data$geographic == 1,
      # The updated_at timestamp is returned from the API as a string in
      #  ISO8601 format like ""2022-01-13T23:20:45.000000Z"
      # The numbers after the decimal ".000000" are microseconds, which will
      #  always (I assume) be rounded to all zeroes
      # The "Z" character at the end indicates the UTC timezone
      updated_at = strptime(.data$updated_at,
                            format = "%Y-%m-%dT%H:%M:%OSZ",
                            tz = "UTC") %>%
        # In order to be consistent with timestamps from other tables,
        #  convert to America/Regina
        lubridate::with_tz(tz = "America/Regina") %>%
        as.POSIXct()
    )
}
