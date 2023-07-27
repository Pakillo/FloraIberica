#' Map taxa distributions
#'
#' Get a map with the distribution of one or more taxa. Must provide either
#' an `sf` object (as returned by [get_distribution()]) or genus, species, subspecies...
#'
#' @param distrib.sf An sf object as returned by [get_distribution()].
#' @inheritParams is_present
#' @param taxo.level character Taxonomic level to show in the map. Either 'genus',
#' 'species' (default) or 'subspecies'. If 'subspecies' argument is provided,
#' taxo.level is automatically changed to 'subspecies'.
#' @param facet Logical. For multiple taxa, make a single map with all taxa together,
#' or make a multipanel (facetted) figure with one panel per taxa?
#' @param colour character. When there is >1 taxon, only used if facet = TRUE.
#' @param include.name Logical. When there is a single taxon to map, use taxon
#' name as title?
#' @param ... Further params to be passed to [ggplot2::facet_wrap()] if facet = TRUE,
#' or to [ggplot2::geom_sf()] if facet = FALSE.
#'
#' @import ggplot2
#'
#' @return A map and ggplot2 object
#' @export
#'
#' @examples
#' laurus <- get_distribution("Laurus", "nobilis")
#' map_distribution(laurus)
#'
#' map_distribution(genus = "Laurus", species = "nobilis")
#'
#' abies <- get_distribution("Abies")
#' map_distribution(abies)
#' map_distribution(abies, facet = TRUE, ncol = 1)
#' map_distribution(abies, taxo.level = "genus")
#'
#' # Map all the subspecies of a species
#' map_distribution(genus = "Berberis", species = "vulgaris", taxo.level = "subspecies")
#' map_distribution(genus = "Berberis", species = "vulgaris", subspecies = "seroi")

map_distribution <- function(distrib.sf = NULL,
                             genus = NULL,
                             species = NULL,
                             subspecies = NULL,
                             taxo.level = "species",
                             facet = FALSE,
                             colour = "medium sea green",
                             include.name = TRUE,
                             ...
                             ) {

  ## Checks

  stopifnot(is.character(taxo.level))

  if (!taxo.level %in% c("genus", "species", "subspecies")) {
    stop("taxo.level must be one of genus, species, or subspecies")
  }

  if (is.null(distrib.sf) & is.null(genus)) {
    stop("Either distrib.sf or genus must be provided at least")
  }

  if (!is.null(distrib.sf) & !inherits(distrib.sf, "sf")) {
    stop("distrib.sf must be a sf object")
  }

  if (is.null(distrib.sf)) {
    distrib.sf <- get_distribution(genus = genus, species = species,
                                   subspecies = subspecies, sf = TRUE)
  }

  if (!is.null(subspecies)) {
    if (taxo.level != "subspecies") {
      message("Since subspecies are provided, changing taxo.level to 'subspecies'")
      taxo.level <- "subspecies"
    }
  }

  if (!is.null(species)) {
    if (taxo.level == "genus") {
      message("Since species are provided, changing taxo.level to 'species'")
      taxo.level <- "species"
    }
  }

  if (taxo.level == "species") {
    distrib.sf$Subspecies <- NA
  }

  if (taxo.level == "genus") {
    distrib.sf$Subspecies <- NA
    distrib.sf$Species <- NA
  }

  distrib.sf$Taxon <- paste(distrib.sf$Genus, distrib.sf$Species, distrib.sf$Subspecies)
  distrib.sf$Taxon <- gsub("NA", "", distrib.sf$Taxon)

  distrib.sf <- subset(distrib.sf, select = -UTM.cell)
  ntaxa <- unique.data.frame(sf::st_drop_geometry(distrib.sf))

  if (nrow(ntaxa) < 1) {
    stop("No taxa to be mapped")
  }

  if (nrow(ntaxa) == 1) {
    mapa <- map_one_taxon(distrib.sf, colour = colour, include.name = include.name, ...)
  }

  if (nrow(ntaxa) > 1) {
    mapa <- map_many_taxa(distrib.sf, facet = facet, colour = colour, ...)
  }

  return(mapa)

}



map_one_taxon <- function(distrib.sf = NULL,
                          colour = "medium sea green",
                          include.name = TRUE,
                          ...) {

  ntaxa <- unique.data.frame(sf::st_drop_geometry(distrib.sf))

  if (nrow(ntaxa) > 1) {
    stop("This function aimed for mapping a single taxon. Use map_many_taxa instead")
  }

  mapa <- ggplot() +
    geom_sf(data = distrib.sf, pch = 15, col = colour, ...) +
    geom_sf(data = IberianPeninsula, fill = NA) +
    theme_bw()

  if (isTRUE(include.name)) {
    mapa <- mapa +
      labs(title = distrib.sf$Taxon)
  }

  return(mapa)

}


map_many_taxa <- function(distrib.sf = NULL,
                          facet = FALSE,
                          colour = "medium sea green",
                          ...) {

  ntaxa <- unique.data.frame(sf::st_drop_geometry(distrib.sf))

  if (nrow(ntaxa) < 2) {
    stop("This function aimed for mapping many taxa. Use map_one_taxon instead")
  }

  if (!isTRUE(facet)) {
    mapa <- ggplot() +
      geom_sf(aes(col = Taxon), data = distrib.sf, pch = 15, ...) +
      geom_sf(data = IberianPeninsula, fill = NA) +
      theme_bw() +
      theme(legend.title = element_blank())
  }


  if (isTRUE(facet)) {

    mapa <- ggplot() +
      facet_wrap(~Taxon, ...) +
      geom_sf(col = colour, data = distrib.sf, pch = 15, size = 0.7) +
      geom_sf(data = IberianPeninsula, fill = NA) +
      theme_bw() +
      theme(strip.background = element_blank())

  }

  return(mapa)


}
