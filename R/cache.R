#' Cache function call to filesystem through memoise
#'
#' @param FUN A function to cache
#'
#' @importFrom memoise memoise cache_filesystem
#' @noRd
#'
cache_call <- function(FUN) {
  db <- memoise::cache_filesystem("~/.rcache")
  res <- memoise::memoise(FUN, cache = db)

  return(res)
}
