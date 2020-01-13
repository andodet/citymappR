
citymappr_setup(api_token = Sys.getenv("CITYMAPPER_API_TOKEN"))

ids <- c(123, 456)
coords <- c("41.899009,12.477243",
            "41.889083,12.470514")

test_that("Missing API key throws an error", {

  expect_error(check_coverage(points = coords[1],
                              api_token = ""))

  expect_error(get_travel_time(start_coord = coords[1],
                               end_coord = coords[2],
                               api_token = ""))
})

test_that("Junk input throws an error", {
2
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

test_that("check_coverage returns df with multiple input" , {
  expect_true(all(check_coverage(coords)))

  # Test for list inputs
  expect_true(all(check_coverage(as.list(coords))))

})
