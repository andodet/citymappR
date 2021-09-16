library(testthat)


test_that("Env variable is set when passing token", {

  token <- "my_cool_api_token"
  citymappr_setup(api_token = token)

  env <- Sys.getenv("CITYMAPPER_API_TOKEN")
  expect_equal(env, token)

})


test_that("Env variable is set when providing a file", {
  citymappr_setup(config_file = ".helper_setup")

  expect_equal(Sys.getenv("CITYMAPPER_API_TOKEN"), "a_fake_api_token")
})


test_that("No file or token throw an error", {
  expect_error(
    citymappr_setup()
  )
})
