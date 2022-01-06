test_that("get_provinces", {
  request_sleep()
  provinces <- get_provinces()
  expect_equal(nrow(provinces), 13)
  expect_equal(ncol(provinces), 10)
  expect_setequal(provinces$code,
                  c("ON", "QC", "NS", "NB", "MB", "BC", "PE", "SK", "AB",
                    "NL", "NT", "YT", "NU"))

  request_sleep()
  provinces_geo_false <- get_provinces(geo_only = FALSE)

  expect_equal(nrow(provinces_geo_false), 16)
  expect_equal(ncol(provinces_geo_false), 10)
  expect_setequal(provinces_geo_false$code,
                  c("ON", "QC", "NS", "NB", "MB", "BC", "PE", "SK", "AB",
                    "NL", "NT", "YT", "NU",
                    "_RC", "FA", "NFR"))

})
