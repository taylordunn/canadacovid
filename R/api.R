#' Get content and parse it
#'
#' Sends a GET request to https://api.covid19tracker.ca/.
#' If the request is successful and the returned content is JSON, formats it and
#' returns it parsed (via `jsonlite::fromJSON`).
#'
#' @param url A string URL linking to the API. If it does not contain the base
#'   "https://api.covid19tracker.ca", then `url` will be combined with the base
#'   to attempt to make a valid URL (and return a warning).
#'
#' @return A list.
#' @export
#'
#' @examples
#'
#' get_content_parsed("https://api.covid19tracker.ca/provinces")
#'
#' @importFrom httr GET http_error http_type content
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_detect
get_content_parsed <- function(url) {
  base_url <- "https://api.covid19tracker.ca"
  if (!stringr::str_detect(url, base_url)) {
    url <- paste0(base_url, "/", url)
    warning(
      paste0("Provided URL did not include base (", base_url, ").\n",
             "Combined URL with base for GET request: ", url)
    )
  }

  resp <- httr::GET(url)

  if (httr::http_error(resp)) {
    stop(paste("API requested failed with code", httr::status_code(resp)),
         call. = FALSE)
  }

  if (httr::http_type(resp) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }

  jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"),
                     simplifyVector = FALSE)
}
