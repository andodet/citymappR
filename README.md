# citymappR 🚎️

![](man/figures/citymappR_logo.png)

<!-- badges: start -->
[![CircleCI](https://circleci.com/gh/andodet/citymappR/tree/master.svg?style=svg)](https://circleci.com/gh/andodet/citymappR/tree/master)
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
- `check_coverage`: check if aone or moregeographical point sfallswithin Citymapper's covered areas.
- `cet_travel_time`: comptues travel time between two points using public transport.

Below you can find a minimal example of how both functions can be used.

```r
library(citymappR)

# Set Citymapper's api key
citymappr_setup()

start_point <- "41.889083,12.470514"
end_point <- "41.899009,12.477243"

# Check coverage for a single point
check_coverage(start_point)
# [1] TRUE

# Accepts vectors or lists with multiple points
points_vec <- as.vector(c(start_point, end_point))
check_coverage(points_vec)
# [1] TRUE TRUE
```
```r
# Get travel time between two points (minutes)
travel_time <- get_travel_time(start_coord = start_point,
                               end_coord = end_point)

travel_time  # [1] 21
```

## Quotas

Citymapper's quotas and usage limits apply to `citymappeR`. At the time of writing, they go as the following for a standard account:

* `check_coverage`: 
    - 10 hit/minute or 1000 hit/day for a single point.
    - 100 hit/minute or 10000 hit/day for multiple points.

## Disclaimer

This package has been developed to familiarise with `httr` package, `jsonlite` and unit testing, PRs or issues are more than appreciated.
