test_that("get_regions works", {
  request_sleep()
  regions <- get_regions()
  expect_true("hr_uid" %in% names(regions))
  expect_equal(nrow(regions), 92)
  expect_equal(dplyr::n_distinct(regions$province), 13)

  request_sleep()
  regions_2418_3534 <- get_regions(hr_uid = c(2418, "3534"))
  expect_equal(regions_2418_3534$hr_uid, c(2418, 3534))

  request_sleep()
  regions_mb_bc <- get_regions(province = c("mb", "bC"))
  expect_equal(unique(regions_mb_bc$province), c("MB", "BC"))
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
