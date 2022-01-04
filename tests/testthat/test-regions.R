test_that("get_regions works", {
  regions <- get_regions()
  expect_true("hr_uid" %in% names(regions))
  expect_equal(nrow(regions), 92)
  expect_equal(dplyr::n_distinct(regions$province), 13)
})
