test_that("get_regions works", {
  request_sleep()
  regions <- get_regions()
  expect_true("hr_uid" %in% names(regions))
  expect_equal(nrow(regions), 92)
  expect_equal(dplyr::n_distinct(regions$province), 13)
})

test_that("get_subregions works", {
  request_sleep()
  subregions <- get_subregions()
  expect_equal(nrow(subregions), 806)
  expect_equal(dplyr::n_distinct(subregions$province), 6)

  request_sleep()
  subregions_3 <- get_subregions(c("ON322", "SK010", "MB029", "test"))
  expect_setequal(unique(subregions_3$province), c("ON", "SK", "MB"))
})
