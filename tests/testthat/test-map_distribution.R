## Made with chatGPT

# Unit tests for map_distribution function

test_that("taxo.level must be one of genus, species, or subspecies", {
  expect_error(map_distribution(taxo.level = "family"))
})

test_that("Either distrib.sf or genus must be provided at least", {
  expect_error(map_distribution())
})

test_that("distrib.sf must be a sf object", {
  expect_error(map_distribution(distrib.sf = data.frame()))
})

test_that("No taxa to be mapped", {
  expect_error(map_distribution(genus = "Nonexistent"))
})

test_that("ggplot object returned", {
  map <- map_distribution(genus = "Abies")
  expect_s3_class(map, "gg")
})








