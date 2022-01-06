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
      updated_at = as.POSIXct(.data$updated_at)
    )
}
