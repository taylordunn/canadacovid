#' Get health regions
#'
#' Returns a list of health regions in the COVID-19 tracker.
#' By default (`hr_uid` and `province` `NULL`), returns all 92 regions.
#'
#' @param hr_uid One or more health region UIDs (e.g. 3553) to return.
#' @param province One or more provinces to return.
#'
#' @return A data frame with a row per health region.
#' @export
#'
#' @examples
#'
#' get_regions()
#' get_regions(hr_uid = c("2414", 591))
#' get_regions(province = c("ns", "SK"))
#' @importFrom dplyr bind_rows
#' @importFrom purrr map_dfr
get_regions <- function(hr_uid = NULL, province = NULL) {
  base_url <- "https://api.covid19tracker.ca/"
  if (!is.null(hr_uid)) {
    url <- paste0(base_url, "regions/", hr_uid)
  } else if (!is.null(province)) {
    url <- paste0(base_url, "province/", province, "/regions")
  } else {
    url <- paste0(base_url, "regions")
  }

  purrr::map_dfr(
    url,
    function(url) {
      content_parsed <- get_content_parsed(url)
      if (!is.null(province)) {
        dplyr::bind_rows(content_parsed)
      } else {
        dplyr::bind_rows(content_parsed$data)
      }
    }
  )
}

#' Get sub-regions
#'
#' Returns a list of sub-regions in the COVID-19 tracker.
#' By default, returns all 805 sub-regions.
#'
#' @param subregion_code One or more sub-regions to be returned.
#'
#' @return A data frame with a row per sub-region.
#' @export
#'
#' @examples
#'
#' get_subregions()
#' get_subregions("AB001")
#' get_subregions(c("SK003", "SK005"))
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
