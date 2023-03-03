#' Is taxon endemic?
#'
#' Is taxon endemic of the Iberian Peninsula and/or Balearic Islands?
#' That is, not present naturally elsewhere in the world.
#'
#' @details For a genus to be considered endemic, all its species must be endemic.
#' Likewise, for a species to be considered endemic, all its subspecies must be endemic.
#'
#' @inheritParams is_present
#'
#' @return A logical vector
#' @export
#'
#' @examples
#' is_endemic("Laurus")
#' is_endemic("Aconitum")
#' is_endemic("Aconitum", "variegatum")
#' is_endemic("Aconitum", "napellus")
#' is_endemic("Aconitum", "napellus", c("vulgare", "castellanum", "lusitanicum"))
is_endemic <- function(genus = NULL, species = NULL, subspecies = NULL, gbif.id = NULL) {

  ## Checks
  if (!is.null(gbif.id)) {
    if (!all(is_present(gbif.id = gbif.id))) {
      stop("One or more taxa not present in the database. Please check with is_present")
    }
  }

  if (is.null(gbif.id)) {
    if (!all(is_present(genus = genus, species = species, subspecies = subspecies))) {
      stop("One or more taxa not present in the database. Please check with is_present")
    }
  }

  # data("Taxa")

  ## Find out

  if (!is.null(gbif.id)) {

    df <- subset(Taxa, GBIF_id %in% gbif.id)
    out <- tapply(df$Endemic, df$GBIF_id, function(x) {all(x)})

  }

  if (is.null(gbif.id)) {

    if (is.null(species) & is.null(subspecies)) {
      # To be an endemic genus, all spp must be endemic
      df <- subset(Taxa, Genus %in% genus)
      out <- tapply(df$Endemic, df$Genus, function(x) {all(x)})
    }

    if (!is.null(species) & is.null(subspecies)) {
      # To be an endemic species, all subspp must be endemic
      df <- subset(Taxa, Genus %in% genus & Species %in% species)
      out <- tapply(df$Endemic, df$Species, function(x) {all(x)})
      names(out) <- paste(genus, names(out))
    }

    if (!is.null(subspecies)) {
      df <- subset(Taxa, Genus %in% genus & Species %in% species & Subspecies %in% subspecies)
      out <- tapply(df$Endemic, df$Subspecies, function(x) {all(x)})
      names(out) <- paste(genus, species, names(out))
    }

  }

  return(out)

}


