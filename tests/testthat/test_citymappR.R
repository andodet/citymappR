
citymappr_setup(api_token = Sys.getenv("CITYMAPPER_API_TOKEN"))

ids <- c(123, 456)
coords <- c("41.899009,12.477243",
            "41.889083,12.470514")

test_that("Junk input throws an error", {

  expect_error(
    check_coverage("wrong_input"),
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


test_that("Check coverage (multi) returns a dataframe", {

  df <- data.frame(coord = c("41.899009,12.477243",
                             "41.8891, 12.4705"))

  expect_s3_class(check_coverage_multi(df), "data.frame")
  expect_equal(colnames(check_coverage_multi(df)), c("covered", "coord"))


  df_id <- data.frame(id = ids, coord = coords)

  expect_s3_class(check_coverage_multi(df_id), "data.frame")
  expect_equal(colnames(check_coverage_multi(df_id)), c("covered", "id", "coord"))

})
