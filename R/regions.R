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

#' Get sub-regions
#'
#' @param subregion_code Specifiy one or more sub-regions to be returned.
#'
#' @return A data frame with a row per sub-region.
#' @export
#'
#' @examples
#'
#' get_subregions()
#' get_subregions("AB001")
#' get_subregions(c("SK003", "SK005"))
#'
#' @importFrom dplyr bind_rows
#' @importFrom purrr map_dfr
get_subregions <- function(subregion_code = NULL) {
  base_url <- "https://api.covid19tracker.ca/sub-regions"

  if (is.null(subregion_code)) {
    url <- base_url
  } else {
    url <- paste0(base_url, "/", subregion_code)
  }

  purrr::map_dfr(
    url,
    function(url) {
      content_parsed <- get_content_parsed(url)
      dplyr::bind_rows(content_parsed$data)
    }
  )
}
