#' Is taxon present?
#'
#' Is taxon present in the Iberian Peninsula and/or Balearic Islands?
#'
#' @param genus character. Required. One or more genera to check for presence.
#' @param species character. Optional. One or more species names to check for presence.
#' If >1 species, they must all belong to the same genus.
#' @param subspecies character. Optional. One or more subspecies names to check for presence.
#' If >1 subspecies, they must all belong to the same species.
#' @param gbif.id character. Optional.
#'
#' @return A logical vector
#' @export
#'
#' @examples
#' is_present("Laurus")
#' is_present("Laurus", "nobilis")
#' is_present("Laurus", "azorica")
#' is_present("Laurus", c("nobilis", "azorica"))
#' is_present(gbif.id = "3034015")
is_present <- function(genus = NULL,
                       species = NULL,
                       subspecies = NULL,
                       gbif.id = NULL) {

  data("Species")

  if (!is.null(gbif.id)) {

    out <- gbif.id %in% Species$GBIF_id
    names(out) <- gbif.id

  }

  if (is.null(gbif.id)) {

    ## Checks

    if (is.null(genus)) {
      stop("genus must be provided")
    }

    if (!is.null(species) & length(genus) > 1) {
      stop("If providing species, only one genus allowed per query")
    }

    if (!is.null(subspecies) & is.null(species)) {
      stop("If providing subspecies, species must be provided too")
    }

    if (!is.null(subspecies) & length(species) > 1) {
      stop("If providing subspecies, only one species allowed per query")
    }

    ## Find
    if (is.null(species) & is.null(subspecies)) {
      out <- genus %in% Species$Genus
    }

    if (!is.null(species) & is.null(subspecies)) {
      out <- genus %in% Species$Genus & species %in% Species$Species
    }

    if (!is.null(subspecies)) {
      out <- genus %in% Species$Genus & species %in% Species$Species & subspecies %in% Species$Subspecies
    }

    ## Get taxon name
    taxon <- genus
    if (!is.null(species)) {
      taxon <- paste(taxon, species)
    }
    if (!is.null(subspecies)) {
      taxon <- paste(taxon, subspecies)
    }

    names(out) <- taxon

  }

  return(out)

}
