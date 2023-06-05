#' Get a zonal checklist
#'
#' Get a checklist of the vascular plants growing near a given point or polygon.
#'
#' @param zone A vector of two numbers giving the point longitude and latitude (in that order),
#' an `sf` object with a single point coordinate, or a polygon `sf` object.
#' @param sf Logical. If FALSE (default) return a dataframe with the checklist.
#' If TRUE, return an `sf` object with the coordinates where each taxa is found.
#' Note these point coordinates represent the centre of 10 km resolution UTM grid cells,
#' not the actual location of these plants.
#'
#' @return A dataframe or sf object
#' @note As the original data (AFLIBER database) have 10-km resolution, the
#' resulting checklist may include taxa present within 10 km distance of the point or
#' polygon.
#' @export
#'
#' @examples
#' sitio <- c(-5, 40)
#' head(get_checklist(sitio))
#'
get_checklist <- function(zone = NULL, sf = FALSE) {

  ## Check arguments ##

  if (is.vector(zone, mode = "numeric")) {
    stopifnot(length(zone) == 2)
    zone <- data.frame(lon = zone[1], lat = zone[2])
    zone <- sf::st_as_sf(zone, coords = c("lon", "lat"), crs = 4326)
  }

  if (inherits(zone, "sf")) {

    if (sf::st_crs(zone)$input != "EPSG:4326") {
      stop("zone must have geographical coordinates (EPSG:4326)")
    }

    ## check that zone coordinates fall within AFLIBER data
    bb.zone <- sf::st_bbox(zone)
    bb.ip <- sf::st_bbox(IberianPeninsula)
    if (bb.zone$xmin < bb.ip$xmin - 0.1 |
        bb.zone$xmax > bb.ip$xmax + 0.1 |
        bb.zone$ymin < bb.ip$ymin - 0.1 |
        bb.zone$ymax > bb.ip$ymax + 0.1
        ) {
      stop("zone coordinates fall out of the study area")
    }
  }

  if (all(sf::st_geometry_type(zone) == "POINT")) {
    if (nrow(zone) > 1) {
      stop("zone must contain the coordinates of a single point")
    }
  }


  ## Load spp distributions
  distr <- sf::st_as_sf(Distributions, coords = c("lng", "lat"), crs = 4326)


  ## Find grid points to be included
  # grid.sf is an internal dataset with the coordinates of all the unique points
  # Here we find all points within 7 km of the given point or polygon
  # sqrt(5000^2 + 5000^2) = 7071 m  (maximum distance from corner to 10x10 km grid cell centre)
  pts.near <- suppressMessages(
    unlist(nngeo::st_nn(zone, grid.sf, k = nrow(grid.sf), maxdist = 7000,
                        progress = FALSE))
  )


  if (length(pts.near) < 1) {
    message("These coordinates could not be matched to any grid cell. Please check them")
  }

  if (length(pts.near) > 0) {

    pts.sf <- grid.sf[pts.near, ]  # points to get taxa from

    requireNamespace("dplyr", quietly = TRUE)  # st_filter seems to require dplyr
    spp <- sf::st_filter(distr, pts.sf)   # filter Distributions dataset to those points only

    if (!isTRUE(sf)) {
      spp <- sf::st_drop_geometry(spp)
      spp <- subset(spp, select = -UTM.cell)
      spp <- unique.data.frame(spp)
    }

    return(spp)

  }

}


