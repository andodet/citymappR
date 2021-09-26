library(testthat)

# vcr_configure(dir = tempdir(), log = TRUE, log_opts = list(file = "console"))


test_that("get_travel_time returns an `int`", {
  vcr::use_cassette("get_travel_time", {
    res <- get_travel_time(coords[1], coords[2])
  }, match_requests_on = c("query"))
  expect_type(res, "integer")
})
