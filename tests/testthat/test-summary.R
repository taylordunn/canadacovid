test_that("get_summary works", {
  expect_error(get_summary(split = "provice"), "arg")

  summary_overall <- get_summary()
  expect_equal(nrow(summary_overall), 1)
  expect_equal(ncol(summary_overall), 22)
  expect_false(any(is.na(summary_overall)))

  summary_province <- get_summary(split = "province")
  expect_equal(nrow(summary_province), 13)
  expect_equal(ncol(summary_province), 23)
  expect_false(any(is.na(summary_province)))
  expect_setequal(summary_province$province,
                  c("ON", "QC", "NS", "NB", "MB", "BC", "PE", "SK", "AB",
                    "NL", "NT", "YT", "NU"))

  summary_region <- get_summary(split = "region")
  expect_equal(nrow(summary_region), 92)
})
