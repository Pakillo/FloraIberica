test_that("get_distribution works as expected", {

  abies.sf <- get_distribution("Abies")
  abies <- get_distribution("Abies", sf = FALSE)

  expect_s3_class(abies.sf, "sf")
  expect_s3_class(abies, "data.frame")

  expect_equal(unique(abies$Genus), "Abies")
  expect_equal(unique(abies$Species), c("alba", "pinsapo"))
})
