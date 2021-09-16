library("vcr") # *Required* as vcr is set up on loading

if (!nzchar(Sys.getenv("CITYMAPPER_API_KEY"))) {
  Sys.setenv("CITYMAPPER_API_KEY" = "foobar")
}

invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("./fixtures"),
  filter_sensitive_data = list("api_key" = Sys.getenv("CITYMAPPER_API_TOKEN"))
))
vcr::check_cassette_names()
