library(magrittr)

#' Current timestamp in ISO8601 format
#'
#' @keywords internal
#' @noRd
# TODO: specify by which function this is needed.
get_iso8601_ts <- function() {
    as.POSIXct(Sys.Date()) %>%
      format("%Y-%m-%dT%H:%M:%S%z")
}
