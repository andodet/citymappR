#' Checks if one or multiple points are in covered area
#'
#' Checks if multiple points fall within Citymapper's covered areas. It accepts multiple
#'   Multiple inputs can be passed in a vector or list format.
#' It is good practice to refresh this values regularly as covered areas might change over time.
#'
#' @inheritParams citymappr_setup
#' @param points List or vector containing geographical coordinates of the start point in WGS84 \code{'<latitude>,<longitude>'} format.
#' @return A vector containing boolean responses for each point in \code{points}
#'
#' @examples
#' \dontrun{
#' point <- "41.889083,12.470514"
#'
#' check_coverage(point)
#  [1] TRUE
#' }
#'
#' @importFrom magrittr %>%
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom httr RETRY POST content stop_for_status add_headers
#'
#' @export
check_coverage <- function(points,
                           api_token=Sys.getenv("CITYMAPPER_API_TOKEN")) {

  # Check if api token has been provided
  if (api_token == "") {
    stop("Citymapper API token not found, please provide one.
         Check ?citymappr_setup on how to pass the api token")
  }

  if (length(points) > 1) {

    # Handle lists
    if(is.list(points)) {
      points <- unlist(points)
    }

    points_payload <- data.frame(coord = points)

    points_payload$coord <- lapply(
      strsplit(as.character(points), ","),
      as.numeric
    )

    points_payload <- toJSON(list(`points` = points_payload))

    resp <- RETRY("POST", url = paste0("https://developer.citymapper.com/api/1/coverage/?key=",
                                       api_token),
                  add_headers("https://github.com/andodet/citymappR/"),
                  body = points_payload,
                  encode="json"
                  )

    stop_for_status(resp)

    return(
      fromJSON(
        content(resp, "text"))[["points"]]["covered"] %>%
        .$covered  # Return vector
      )

  } else {

    resp <- RETRY("GET",
                  url="https://developer.citymapper.com/api/1/singlepointcoverage/",
                  add_headers("https://github.com/andodet/citymappR/"),
                  query = list(key = api_token,
                               coord = points)
            )

    stop_for_status(resp)

    return(
      fromJSON(
        content(resp, "text"))[["points"]]$covered
    )

  }

}

