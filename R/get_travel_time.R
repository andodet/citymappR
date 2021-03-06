#' Get travel time between two points
#'
#' Computes estimated travel time between two points using public transport.
#' If \code{time} and \code{time_type} are not specified, time of travel will be assumed
#'     to be the same time at which the request is made.
#'
#' @param start_coord Geographical coordinates of the start point in WGS84 '<latitude>,<longitude>' format.
#' @param end_coord Geographical coordinates of the arrival point in WGS84 '<latitude>,<longitude>' format.
#' @param time A date & time in ISO-8601 format (e.g \code{2014-11-06T19:00:02-0500}).
#'   If omitted travel time will be computed for travel at the time of the request.
#' @param time_type Required if `time` is provided. At the moment the only defined type
#'   is `arrival`, it computes the travel time for arriving at `end_coord` at the given time.
#' @inheritParams citymappr_setup
#' @return Estimated travel time in minutes (int).
#'
#' @examples
#' \dontrun{
#' get_travel_time(start_coord = "45.448643,9.207645",
#'                 end_coord = "45.452349,9.180225")
#' }
#'
#' @author Andrea Dodet, \email{an.dodet@gmail.com}
#'
#' @importFrom httr RETRY GET stop_for_status content add_headers
#' @importFrom jsonlite fromJSON
#'
#' @export
get_travel_time <- function(start_coord,
                            end_coord,
                            time=get_iso8601_ts(),
                            time_type="arrival",
                            api_token = Sys.getenv("CITYMAPPER_API_TOKEN")) {

 # Check if api token has been provided
  if (api_token == "") {
    stop("Citymapper API token not found, please provide one.
         Check ?citymappr_setup on how to pass the api token")
  }

  resp <-RETRY("GET",
               url = "https://developer.citymapper.com/api/1/traveltime/",
               add_headers("https://github.com/andodet/citymappR/"),
               query = list(
                 key = api_token,
                 startcoord = start_coord,
                 endcoord = end_coord,
                 time = time,
                 time_type = time_type
                 )
               )

  stop_for_status(resp)

  return(
    fromJSON(
      content(resp, "text"))$travel_time_minutes
  )

}
