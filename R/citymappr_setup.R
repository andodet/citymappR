#' Setup env variables for Citymapper's API access
#'
#' Initialize the API key \code{citymappR} will send in every request for authentication.
#' If a file is found at the location specified in \code{config_file}, the values will be used.
#'
#' \preformatted{
#' api_token: YOUR_TOKEN_STRING
#' }
#'
#' @param config_file a configuration file in DCF format. See \link{read.dcf}. By default the key
#'   will be searched in the current working directory.
#' @param api_token Citymapper's api key (chr).
#' @param echo display the \code{api_token} (bool), initally set as \code{FALSE}
#' @return An env variable
#'
#' @examples
#' \dontrun{
#' # Reads from default file (i.e ~/.citymappr)
#' citymmappr_setup()
#'
#' # Reads from alternate config file
#' citymappr_setup("~/path/to/config")
#'
#' # The manual way
#' citymappr_setup(api_token = "your_api_string")
#' }
#'
#' @importFrom jsonlite toJSON
#'
#' @export
citymappr_setup <- function(config_file = ".citymappr",
                            api_token = NULL,
                            echo = FALSE) {

  if (file.exists(config_file)) {

    config <- read.dcf(config_file,
                       fields = c("api_token"))

    Sys.setenv(CITYMAPPER_API_TOKEN = config[,"api_token"])

  } else if(!is.null(api_token)) {
    Sys.setenv(CITYMAPPER_API_TOKEN = api_token)
  } else {
    stop("No config file or token provided. Please provide one. Use `?citymappr_setup` for help")
  }

  # Print token if verbose
  if (echo) {
    print(Sys.getenv("CITYMAPPER_API_TOKEN"))
  }

}
