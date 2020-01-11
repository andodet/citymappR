#' Checks if multiple points are in covered area
#'
#' Checks if  multiple points fall within Citymapper's covered areas.
#' It is good practice to refresh this values regularly as covered areas might change.
#'
#' @inheritParams citymappr_setup
#' @param points Dataframe containing geographical coordinates of the start point in WGS84 \code{'<latitude>,<longitude>'} format.
#'   Columns should be set as \code{id (optional)} and \code{coord}.
#' @return A tibble containing boolean responses for each point. IDs column passed in \code{points} will be mirrored back in response.
#'   for quick reference.
#'
#' @examples
#' \dontrun{
#' # Make dataframes with coordinates and (optional) ids
#'
#' }
#'
#' @seealso \code{\link{check_coverage}}
#'
#' @importFrom magrittr %>%
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom httr RETRY POST content stop_for_status add_headers
#' @importFrom tibble as_tibble
#'
#' @export
#TODO: there are problems with json parsin (coords are not parsed as a list)
check_coverage_multi <- function(points,
                                 api_token=Sys.getenv("CITYMAPPER_API_TOKEN")) {

  # Check if api token has been provided
  if (api_token == "") {
    stop("Citymapper API token not found, please provide one.
         Check ?citymappr_setup on how to pass the api token")
  }

  if (!is.data.frame(points)) {
    points <- as_tibble(points)
  }

  # Check if column name respect c("id", "coord") convention
  if(!all(c("coord") %in% names(points))) {
    stop("Dataframe has wrong column names, make sure they are set as c('id', 'coord')")
  }

  # Get input in required JSON format
  points$coord <- lapply(
    strsplit(as.character(points$coord), ","),
    as.numeric
  )

  cured_input <- toJSON(list(`points` = points))

  resp <- RETRY("POST",
                url = paste0("https://developer.citymapper.com/api/1/coverage/?key=",
                             api_token),
                add_headers("https://github.com/andodet/citymappR/"),
                body = cured_input,
                encode="json"
                )

  stop_for_status(resp)

  return(
    fromJSON(
      content(resp, "text"))[["points"]]
    )

}
