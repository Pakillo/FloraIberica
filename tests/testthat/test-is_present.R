test_that("is_present works as expected", {
  expect_true(is_present("Laurus"))
  expect_true(is_present("Laurus", "nobilis"))
  expect_false(is_present("Laurus", "azorica"))
  expect_equal(is_present("Laurus", c("nobilis", "azorica")),
               c(`Laurus nobilis` = TRUE, `Laurus azorica` = FALSE))
  expect_equal(is_present(genus = c("Laurus", "Abies"), c("nobilis", "pinsapo")),
               c(`Laurus nobilis` = TRUE, `Abies pinsapo` = TRUE))
  expect_error(is_present(genus = c("Laurus", "Abies"), species = "nobilis"))

  expect_false(is_present(genus = "Laurus", species = "communis"))
  expect_equal(is_present("Laurus", c("nobilis", "communis")),
               c(`Laurus nobilis` = TRUE, `Laurus communis` = FALSE))
})
