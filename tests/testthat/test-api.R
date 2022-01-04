test_that("get_content_parsed works", {
  Sys.sleep(1)
  expect_warning(get_content_parsed("provinces"), "base")
  Sys.sleep(1)
  expect_error(
    get_content_parsed("https://api.covid19tracker.ca/provices"), "API"
  )

  Sys.sleep(1)
  provinces <- get_content_parsed("https://api.covid19tracker.ca/provinces")
  expect_true(is.list(provinces))
  expect_equal(lengths(provinces), rep(12, 16))
})
