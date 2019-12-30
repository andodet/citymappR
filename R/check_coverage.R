#' Check if a point is in covered area
#'
#' Checks if a given point falls within Citymapper's covered areas.
#' It is good practice to refresh this value regularly as covered areas might change.
#'
#' @inheritParams citymappr_setup
#' @param point Geographical coordinates of the point in WGS84 \code{'<latitude>,<longitude>'} format.
#' @return A tibble containing boolean responses for each point.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom httr GET content warn_for_status
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr mutate
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' check_coverage("45.448643,9.207645")
#' }
#'
#' @export
check_coverage <- function(point,
                           api_token=Sys.getenv("CITYMAPPER_API_TOKEN")) {

  resp <- GET(url="https://developer.citymapper.com/api/1/singlepointcoverage/",
              query = list(key = api_token,
                           coord = point))

  warn_for_status(resp)

  return(
    fromJSON(
      content(resp, "text"))[["points"]] %>%
      mutate(coord = sapply(.data$coord, paste, collapse = ",")) %>%
      as_tibble()
  )

}
