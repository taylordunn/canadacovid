#' Get health regions
#'
#' @return A data frame with a row per health region.
#' @export
#'
#' @examples
#'
#' get_regions()
#'
#' @importFrom dplyr bind_rows mutate
#' @importFrom rlang .data
get_regions <- function() {
  base_url <- "https://api.covid19tracker.ca/regions"
  api_params <- ""
  url <- paste0(base_url, api_params)

  content_parsed <- get_content_parsed(url)

  dplyr::bind_rows(content_parsed$data)
}
