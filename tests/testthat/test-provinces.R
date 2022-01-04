test_that("get_provinces", {
  request_sleep()
  provinces <- get_provinces()

  expect_equal(nrow(provinces), 16)
  expect_equal(ncol(provinces), 10)
  expect_setequal(provinces$code,
                  c("ON", "QC", "NS", "NB", "MB", "BC", "PE", "SK", "AB",
                    "NL", "NT", "YT", "NU",
                    "_RC", "FA", "NFR"))

})
