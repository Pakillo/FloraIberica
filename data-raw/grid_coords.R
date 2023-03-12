library(FloraIberica)
grid.pts <- unique.data.frame(Distributions[, c("lng", "lat")]) # 6301 unique points
grid.sf <- sf::st_as_sf(grid.pts, coords = c("lng", "lat"), crs = 4326)
usethis::use_data(grid.sf, internal = TRUE)
