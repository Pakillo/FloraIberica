test_that("is_endemic works as expected", {
  expect_false(is_endemic("Laurus"))
  expect_false(is_endemic("Aconitum"))
  expect_true(is_endemic("Aconitum", "variegatum"))
  expect_false(is_endemic("Aconitum", "napellus"))
  expect_equal(is_endemic("Aconitum", "napellus", c("vulgare", "castellanum", "lusitanicum")),
               structure(c(`Aconitum napellus castellanum` = TRUE,
                           `Aconitum napellus lusitanicum` = FALSE,
                           `Aconitum napellus vulgare` = FALSE),
                         dim = 3L, dimnames = list(
                             c("Aconitum napellus castellanum", "Aconitum napellus lusitanicum",
                               "Aconitum napellus vulgare"))))
})
