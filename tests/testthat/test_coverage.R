library(testthat)


test_that("check_coverage returns a `bool`", {
  vcr::use_cassette("check_coverage", {
    res <- check_coverage(coords[1])
  })
  expect_true(res)
})


test_that("Check coverage returnsa a list of bools", {
  vcr::use_cassette("check_coverage_list", {
    res <- check_coverage(coords)
  })
  expect_vector(res)
})


vcr::use_cassette("check_coverage_notoken", {
  test_that("check_coverage errors out with no token", {
    expect_error(check_coverage(coords, api_token = ""))
  })
})
