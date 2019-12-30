# citymappR 🚎️
<!-- badges: start -->

[![CircleCI build status](https://circleci.com/gh/andodet/citymappR.svg?style=svg)](https://circleci.com/gh/andodet/citymappR)
<!-- badges: end -->

A simple [Citymapper's API](https://citymapper.com/api) wrapper written in R

## Installation

You can install the package running the following command:
```r
remotes::install_github("andodet/citymappR")

# Or using devtools
devtools::install_github("andodet/citymappR")
```

## Usage

The package provides access to Citymapper's API endpoints:

- `citymapper_setup`: initialise Citymapper's api token. Check `?citymapper_setup` for different ways of passing the api token.
- `check_coverage`: check if a geographical point falls within Citymapper's covered area.
- `get_travel_time`: comptes travel time between two points using public transport.

Below you can find a minimal example of how both functions can be used.

```r
library(citymappR)

# Set Citymapper's api key
citymappr_setup()

start_point <- "41.889083,12.470514"
end_point <- "41.899009,12.477243"

check_start <- check_coverage(start_point)
check_end <- check_coverage(end_point)

#   check_start
#   A tibble: 1 x 2
#   covered coord              
#   <lgl>   <chr>              
# 1 TRUE    41.899009,12.477243


travel_time <- get_travel_time(start_coord = start_point,
                               end_coord = end_point)

travel_time  # [1] 21
```

## Disclaimer

This package has been developed to familiarise with `httr` package, `jsonlite` and unit testing.  
PRs or issues are more than appreciated.
