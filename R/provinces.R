#' Get provinces and territories
#'
#' @return A data frame with a row per province/territory.
#' @export
#'
#' @examples
#'
#' get_provinces()
#'
#' @importFrom dplyr bind_rows mutate
#' @importFrom rlang .data
get_provinces <- function() {
  base_url <- "https://api.covid19tracker.ca/provinces"
  api_params <- ""
  url <- paste0(base_url, api_params)

  content_parsed <- get_content_parsed(url)

  dplyr::bind_rows(content_parsed) %>%
    dplyr::mutate(
      geographic = .data$geographic == 1,
      updated_at = as.POSIXct(.data$updated_at)
    )
}
