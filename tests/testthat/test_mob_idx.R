library(testthat)


test_that("get_mob_idx returns a non-empty dataframe", {
  vcr::use_cassette("get_mob_idx", {
    res <- get_mob_idx()
  })

  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
})

