#' Get Citymapper's mobility index
#'
#' @description
#' As of mid-March Citymapper has launched a City Mobility index to observe which
#' cities are following lockdown measures during COVID-19 pandemic. Data is
#' calculated comparing the number of trips planned on the app to a typical usage
#'   period. \href{https://citymapper.com/cmi/about}{Here} for a detailed description.
#'
#' @param start_date First observed day with format YYYY-MM-DD
#' @param end_date Last observed day with format YYYY-MM-DD
#' @param city (optional) A vector containing specific cities to filter for (e.g "milan").
#'   This obviously follow Citymapper's \href{https://citymapper.com/cities?lang=en}{coverage}.
#' @param cache (bool) cache results to filesystem
#' @param weekly Get weekly data (default is daily)
#' @param verbose Show download progress bar
#'
#' @return A data frame containing the following columns:
#'   \itemize{
#'     \item \code{big_change}: (bool) Whether there was a consisten change with previous day.
#'     \item \code{cange_from_previous}: Difference with previous day.
#'     \item \code{date}: Observation date
#'     \item \code{type}: Weekly or daily observation.
#'     \item \code{region_id}: Region slug.
#'     \item \code{value}: Index value.
#'     \item \code{city_name}: Name of oberved city
#'   }
#'
#' @importFrom httr RETRY GET add_headers progress
#' @importFrom dplyr mutate filter select left_join
#' @importFrom rlang .data
#'
#' @export
get_mob_idx <- function(start_date = "2020-01-01",
                        end_date = Sys.Date(),
                        city = NA,
                        cache = TRUE,
                        weekly = FALSE,
                        verbose = FALSE) {

  # Add progress bar if verbose
  if (verbose) {
    prog_bar <- httr::progress(type = "down", con = stdout())
  } else {
    prog_bar <- NULL
  }

  download_data <- function() {
    httr::RETRY(
      "GET",
      url = 'https://citymapper.com/api/gobot_tab/data',
      add_headers("https://github.com/andodet/citymappR/"),
      prog_bar
    ) %>%
      content()
  }

  # Cache results if not otherwise specified
  if (cache) {
    data <- cache_call(FUN = download_data)
    res <- data()
  } else {
    res <- download_data()
  }

  # Parse locations
  locations <- res$regions %>%
    parse_response() %>%
    dplyr::select(.data$id, city_name = .data$name)

  # Output final `data.frame`
  res_df <- res$datapoints %>%
    parse_response() %>%
    dplyr::mutate(date = as.Date(date)) %>%
    dplyr::rename(type = .data$name) %>%  # Rename to avoid colnames clashes in join
    dplyr::left_join(locations, by = c('region_id' = 'id')) %>%
    dplyr::filter(date >= start_date,
                  date <= end_date
    )

  if (!is.na(city)) {
    res_df <- res_df %>%
      filter(tolower(.data$city_name) %in% city)
  }

  if (weekly) {
    res_df <- res_df %>%
      filter(.data$type == 'seven_day')
  } else {
    res_df <- res_df %>%
      filter(.data$type == 'one_day')
  }

  return(res_df)
}


#' Helper to parse Citymapper's response into a dataframe
#'
#' @param res a response as returned from Citymapper's api
#' @return a data frame
#'
#' @importFrom data.table rbindlist
#' @noRd
#'
parse_response <- function(res) {
  parsed <- res %>%
    data.table::rbindlist(fill = TRUE) %>%
    as.data.frame()

  return(parsed)
}
