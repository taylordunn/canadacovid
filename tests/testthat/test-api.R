test_that("get_content_parsed works", {
  request_sleep()
  expect_warning(get_content_parsed("provinces"), "base")

  request_sleep()
  expect_error(
    get_content_parsed("https://api.covid19tracker.ca/provices"), "API"
  )

  request_sleep()
  provinces <- get_content_parsed("https://api.covid19tracker.ca/provinces")
  expect_type(provinces, "list")
  expect_equal(lengths(provinces), rep(12, 16))
})
