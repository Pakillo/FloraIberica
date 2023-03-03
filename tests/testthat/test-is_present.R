test_that("is_present works as expected", {
  expect_true(is_present("Laurus"))
  expect_true(is_present("Laurus", "nobilis"))
  expect_false(is_present("Laurus", "azorica"))
  expect_equal(is_present("Laurus", c("nobilis", "azorica")),
               c(`Laurus nobilis` = TRUE, `Laurus azorica` = FALSE))
})
