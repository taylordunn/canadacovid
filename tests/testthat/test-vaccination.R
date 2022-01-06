test_that("get_vaccination_data works", {
  request_sleep()
  vaccination_data_summary <- get_vaccination_data()
  expect_equal(nrow(vaccination_data_summary), 1)
  expect_equal(ncol(vaccination_data_summary), 10)

  request_sleep()
  vaccination_data_report <- get_vaccination_data(type = "reports")
  expect_equal(ncol(vaccination_data_report), 10)
  expect_equal(
    vaccination_data_report$date,
    seq.Date(min(vaccination_data_report$date),
             max(vaccination_data_report$date), by = "day")
  )
  expect_false(any(is.na(vaccination_data_report)))

  request_sleep()
  vaccination_data_summary_region <- get_vaccination_data(split = "region")
  expect_equal(nrow(vaccination_data_summary_region), 92)
  expect_error(get_vaccination_data(type = "reports", split = "region"))

  request_sleep()
  vaccination_data_ns_pe <- get_vaccination_data(type = "reports",
                                                 province = c("NS", "pe"))
  expect_equal(unique(vaccination_data_ns_pe$province), c("NS", "PE"))

  request_sleep()
  expect_equal(nrow(vaccination_data_ns_pe),
               nrow(get_reports(province = c("NS", "pe"))))
})

test_that("get_subregion_vaccination_data works", {
  request_sleep()
  subregion_vaccination_data_current <- get_subregion_vaccination_data()
  expect_equal(nrow(subregion_vaccination_data_current), 806)
  expect_equal(ncol(subregion_vaccination_data_current), 12)

  request_sleep()
  subregions <- get_subregions()
  expect_setequal(unique(subregion_vaccination_data_current$code),
                  subregions$code)

  request_sleep()
  subregion_vaccination_data_recent <-
    get_subregion_vaccination_data(dates = "recent")
  expect_true(nrow(subregion_vaccination_data_recent) > 0)
})
