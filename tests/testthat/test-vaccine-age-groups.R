test_that("get_vaccine_age_groups works", {
  request_sleep()
  vacc_age_overall <- get_vaccine_age_groups()
  expect_equal(dplyr::n_distinct(vacc_age_overall$group), 19)

  request_sleep()
  vacc_age_province <- get_vaccine_age_groups(split = "province")
  expect_equal(dplyr::n_distinct(vacc_age_province$province), 13)

  request_sleep()
  vacc_age_mb_nt <- get_vaccine_age_groups(province = c("test", "mB", "NT"))
  expect_setequal(unique(vacc_age_mb_nt$province), c("MB", "NT"))

  request_sleep()
  vacc_age_ns_18_29 <- get_vaccine_age_groups(province = "NS", group = "18-29")
  expect_setequal(unique(vacc_age_ns_18_29$province), c("NS"))
  expect_setequal(unique(vacc_age_ns_18_29$group), c("18-29"))

  request_sleep()
  vacc_age_80p_date_range <-
    get_vaccine_age_groups(group = "80+",
                           after = "2021-03-20", before = "2021-05-10")
  expect_equal(unique(vacc_age_80p_date_range$group), "80+")
  expect_true(min(vacc_age_80p_date_range$date) >= "2021-03-20")
  expect_true(max(vacc_age_80p_date_range$date) <= "2021-05-10")

  request_sleep()
  vacc_age_not_reported <- get_vaccine_age_groups(group = "not_reported")
  expect_equal(unique(vacc_age_not_reported$group), "Not reported")

  request_sleep()
  expect_error(get_vaccine_age_groups(group = "90+"))
})
