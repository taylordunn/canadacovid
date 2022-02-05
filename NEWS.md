# canadacovid 0.3.3

* Added a `NEWS.md` file to track changes to the package.
* Fixed a bug where the `last_updated` variable was being parsed incorrectly in `get_reports()`, `get_summary()`, `get_subregion_vaccination_data()` and `get_vaccine_age_groups()`.
* The `get_provinces()` function now returns `updated_at` in the CST timezone in order to be consistent with the other tables. To do this, the `lubridate` package has been added under `Imports` for the `with_tz()` function.
* The API now returns two additional variables `change_boosters_2` and `total_boosters_2`. Adjusted the tests (`test-reports`, `test-summary` and `test-vaccination`) to account for the new variables.
