
citymappr_setup(api_token = Sys.getenv("CITYMAPPER_API_TOKEN"))

ids <- c(123, 456)
coords <- c("41.899009,12.477243",
            "41.889083,12.470514")

# Custom test to check for `data.frame` length
expect_longer_than <- function(df, n) {
  act <- quasi_label(rlang::enquo(df), arg = "df")

  act$n <- nrow(act$val)
  expect(
    act$n > n,
    sprintf("%s has length %i, not %i.", act$lab, act$n, n)
  )

  invisible(act$val)
}


test_that("Missing API key throws an error", {

  expect_error(check_coverage(points = coords[1],
                              api_token = ""))

  expect_error(get_travel_time(start_coord = coords[1],
                               end_coord = coords[2],
                               api_token = ""))
})

test_that("Junk input throws an error", {

  expect_error(
    check_coverage("junk input"),
    class = "http_error"
  )

  expect_error(
    get_travel_time(start_coord = "wrong_input",
                    end_coord = "wrong_input"),
    class = "http_error"
    )

})

test_that("Coverage check returns a boolean", {

  expect_equal(
    check_coverage("41.889083,12.470514"),TRUE
    )

})

test_that("check_coverage returns boolean with single input", {
  expect_true(check_coverage(coords[1]))
})

test_that("check_coverage returns vector containing booleans" , {
  expect_true(all(check_coverage(coords)))

  # Test for list inputs
  expect_true(all(check_coverage(as.list(coords))))

})

test_that("mobility index returns a non-empty data frame", {
  res <- suppressWarnings(get_mob_idx())

  expect_s3_class(res, "data.frame")
  expect_longer_than(res, 0)  # Check for non-empty dataframe

})


