#' Check if a point is in covered area
#'
#' Checks if a given point falls within Citymapper's covered areas.
#' It is good practice to refresh this value regularly as covered areas might change.
#'
#' @inheritParams citymappr_setup
#' @param point Geographical coordinates of the point in WGS84 \code{'<latitude>,<longitude>'} format.
#' @return Boolean
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom httr GET content stop_for_status
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

  # Check if api token has been provided
  if (api_token == "") {
    stop("Citymapper API token not found, please provide one.
         Check ?citymappr_setup on how to pass the api token")
  }

  resp <- GET(url="https://developer.citymapper.com/api/1/singlepointcoverage/",
              query = list(key = api_token,
                           coord = point))

  stop_for_status(resp)

  return(
    fromJSON(
      content(resp, "text"))[["points"]]$covered
  )

}
