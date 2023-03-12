test_that("get_checklist works", {

  out <- get_checklist(c(-5, 40))

  expect_equal(head(out),
               structure(list(Genus = c("Acer", "Adenocarpus", "Adenocarpus", "Allium", "Alnus", "Alyssum"),
                              Species = c("monspessulanum", "aureus", "complicatus", "scorzonerifolium", "glutinosa", "fastigiatum"),
                              Subspecies = c("monspessulanum", NA, NA, NA, NA, NA)),
                         row.names = c(1L, 2L, 4L, 5L, 6L, 7L), class = "data.frame"))

  expect_equal(tail(out),
               structure(list(Genus = c("Trifolium", "Ulmus", "Verbena", "Vicia", "Viola", "Vitis"),
                              Species = c("repens", "minor", "officinalis", "disperma", "kitaibeliana", "vinifera"),
                              Subspecies = c(NA_character_, NA_character_, NA_character_, NA_character_, NA_character_, NA_character_)),
                         row.names = c(208L, 209L, 211L, 212L, 213L, 214L), class = "data.frame"))

  expect_equal(nrow(out), 178)

})
