test_that("get_reports works", {
  request_sleep()
  reports_overall <- get_reports()
  expect_equal(ncol(reports_overall), 24)
  expect_equal(
    reports_overall$date,
    seq.Date(min(reports_overall$date), max(reports_overall$date), by = "day")
  )

  request_sleep()
  reports_province <- get_reports(split = "province")
  expect_equal(dplyr::n_distinct(reports_province$province), 13)
  expect_equal(min(reports_province$date), min(reports_overall$date))
  expect_equal(max(reports_province$date), max(reports_overall$date))

  request_sleep()
  provinces <- get_provinces()
  # Timestamps `updated_at` from provinces, and `last_updated` from reports
  #  should be equal
  expect_mapequal(
    provinces %>% dplyr::pull(updated_at, name = code),
    reports_province %>%
      dplyr::distinct(province, last_updated) %>%
      dplyr::pull(last_updated, name = province)
  )

  request_sleep()
  reports_ns_on_nv <- get_reports(province = c("NS", "ON", "nU", "test"))
  expect_equal(
    unique(reports_ns_on_nv$province), c("NS", "ON", "NU")
  )
  expect_equal(
    reports_province %>% dplyr::filter(province == "NS"),
    reports_ns_on_nv %>% dplyr::filter(province == "NS")
  )

  request_sleep()
  expect_error(get_reports(split = "region"), "arg")

  request_sleep()
  reports_592_2407_3561 <- get_reports(region = c(592, "2407", 3561))
  expect_equal(
    unique(reports_592_2407_3561$hr_uid),
    c(592, 2407, 3561)
  )

  request_sleep()
  reports_criticals <- get_reports(split = "province", stat = "criticals")
  expect_equal(ncol(reports_criticals), 5)
  expect_setequal(names(reports_criticals),
                  c("province", "last_updated", "date",
                    "change_criticals", "total_criticals"))

  request_sleep()
  report_20210720 <- get_reports(province = "MB", date = "2021-07-20")
  expect_equal(report_20210720$date, as.Date("2021-07-20"))
  expect_equal(report_20210720$province, "MB")

  request_sleep()
  report_date_range <- get_reports(region = 3570,
                                   after = "2021-10-28", before = "2021-11-02")
  expect_equal(min(report_date_range$date), as.Date("2021-10-28"))
  expect_equal(max(report_date_range$date), as.Date("2021-11-02"))

})
