% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_coverage.R
\name{check_coverage}
\alias{check_coverage}
\title{Checks if one or multiple points are in covered area}
\usage{
check_coverage(points, api_token = Sys.getenv("CITYMAPPER_API_TOKEN"))
}
\arguments{
\item{points}{List or vector containing geographical coordinates of the start point
in WGS84 \code{'<latitude>,<longitude>'} format.}

\item{api_token}{Citymapper's api key (chr).}
}
\value{
A vector containing boolean responses for each point in \code{points}
}
\description{
Checks if multiple points fall within Citymapper's covered areas.
 Multiple inputs can be passed in a vector or list format.
 It is good practice to refresh this values regularly as covered areas might change over time.
}
\examples{
\dontrun{
point <- "41.889083,12.470514"

check_coverage(point)
}

}
