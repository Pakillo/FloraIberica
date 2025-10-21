#' Is taxon present in the Iberian Peninsula and/or Balearic Islands?
#'
#' @param genus character. One or more genera to check for presence. Required,
#' unless `gbif.id` is provided.
#' @param species character. Optional. One or more species names to check for presence.
#' The length of `genus` must equal that of `species`, unless length(genus) == 1,
#' in which case it will be assumed that all species belong to that same genus.
#' @param subspecies character. Optional. One or more subspecies names to check for presence.
#' The length of `species` must equal that of `subspecies`, unless length(species) == 1,
#' in which case it will be assumed that all subspecies belong to that same species.
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
#' is_present("Laurus", c("nobilis", "communis"))
#' is_present("Laurus", "nobilis", subspecies = "excelsa")
#' is_present(gbif.id = "3034015")
is_present <- function(genus = NULL,
                       species = NULL,
                       subspecies = NULL,
                       gbif.id = NULL) {


  if (!is.null(gbif.id)) {

    out <- gbif.id %in% Taxa$GBIF_id
    names(out) <- gbif.id

  }

  if (is.null(gbif.id)) {

    ## Checks ##

    if (is.null(genus)) {
      stop("genus must be provided")
    }


    if (!is.null(subspecies)) {

      if (is.null(species)) {
      stop("If providing subspecies, species must be provided too")
      }

      if (length(species) == 1) {
        # if there's only one species, assume all subspecies belong to that species
        species <- rep(species, length.out = length(subspecies))
      }

      stopifnot(length(species) == length(subspecies))

    }



    if (!is.null(species)) {

      if (length(genus) == 1) {
        # if there's only one genus, assume all species belong to that genus
        genus <- rep(genus, length.out = length(species))
      }

      stopifnot(length(genus) == length(species))

    }




    ## Find out if taxa are present ##

    # if only genus is provided, check genus
    if (is.null(species) & is.null(subspecies)) {
      out <- genus %in% Taxa$Genus
    }

    # if genus and species are provided, check both
    if (!is.null(species) & is.null(subspecies)) {
      out <- vector(mode = "logical", length = length(species))
      for (i in seq_along(species)) {
        out[i] <- ifelse(any(Taxa$Genus == genus[i] & Taxa$Species == species[i],
                               na.rm = TRUE),
                           TRUE,
                           FALSE)
      }
    }

    if (!is.null(subspecies)) {
      out <- vector(mode = "logical", length = length(subspecies))
      for (i in seq_along(subspecies)) {
        out[i] <- ifelse(any(Taxa$Genus == genus[i] & Taxa$Species == species[i] &
                                 Taxa$Subspecies == subspecies[i], na.rm = TRUE),
                           TRUE,
                           FALSE)
      }
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
