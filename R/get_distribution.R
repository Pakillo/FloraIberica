#' Get the distribution of one or more plant taxa
#'
#' @inheritParams is_present
#' @param sf Logical. Return a spatial (sf) or a plain dataframe?
#'
#' @return An sf object if sf = TRUE, a plain dataframe otherwise.
#' @export
#'
#' @examples
#' abies <- get_distribution("Abies")
#' abies
#' unique(abies$Species)  # including all species in the genus
#'
#' pinsapo <- get_distribution("Abies", "pinsapo")
#' pinsapo
get_distribution <- function(genus = NULL, species = NULL, subspecies = NULL,
                             sf = TRUE) {

  ## Checks
  if (!all(is_present(genus = genus, species = species, subspecies = subspecies))) {
    stop("One or more taxa not present in the database. Please check with is_present")
  }


  ## Filter data

  data("Distributions")

  if (is.null(species) & is.null(subspecies)) {
    distrib <- subset(Distributions, Genus %in% genus)
  }

  if (!is.null(species) & is.null(subspecies)) {
    distrib <- subset(Distributions, Genus %in% genus & Species %in% species)
  }

  if (!is.null(subspecies)) {
    distrib <- subset(Distributions, Genus %in% genus & Species %in% species & Subspecies %in% subspecies)
  }

  if (nrow(distrib) < 1) {
    warning("No records returned. Please check the taxonomic names provided")
  }


  ## Convert to sf
  if (isTRUE(sf)) {
    distrib <- sf::st_as_sf(distrib, crs = 4326, coords = c("lng", "lat"))
  }

  invisible(distrib)


}
