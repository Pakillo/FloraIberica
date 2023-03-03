
library(sf)

#### Obtain data ##############################################

## Obtain Iberian Peninsula contour
# remotes::install_github("ropensci/rnaturalearthhires")
IberianPeninsula <- st_as_sf(rnaturalearthhires::countries10) |>
  dplyr::filter(ISO_A2 == "ES" | ISO_A2 == "PT") |>
  st_crop(c(xmin = -10, xmax = 4.33, ymin = 35.8, ymax = 43.77)) |>
  st_geometry()
#plot(IberianPeninsula)
# usethis::use_data(IberianPeninsula)
save(IberianPeninsula, file = "data/IberianPeninsula.rda")


## Download AFLIBER data
download.file("https://iramosgutierrez.github.io/afliber/database/AFLIBER_Distributions.csv",
              destfile = "data-raw/AFLIBER_Distributions.csv",
              mode = "wb")

download.file("https://iramosgutierrez.github.io/afliber/database/AFLIBER_Checklist.csv",
              destfile = "data-raw/AFLIBER_Checklist.csv",
              mode = "wb")



#########################################################


## Read species data
Taxa <- readr::read_csv("data-raw/AFLIBER_Checklist.csv")
usethis::use_data(Taxa)
# save(Taxa, file = "data/Taxa.rda")

## Read distribution data
distr <- readr::read_csv("data-raw/AFLIBER_Distributions.csv")

## Split Taxon into genus, species, subsp
distr <- tidyr::separate(distr,
                         col = Taxon,
                         into = c("Genus", "Species", "Subspecies"),
                         sep = " ")

## Transform MGRS into lonlat
# see https://ecologicaconciencia.wordpress.com/2013/10/13/species-occurrence-data-converting-utmmgrs-coordinates-to-geographic-coordinates/
distr$UTM <- paste0(substr(distr$UTM.cell, start = 1, stop = 5),
                    substr(distr$UTM.cell, start = 6, stop = 6) <- paste0(substr(distr$UTM.cell, start = 6, stop = 6), "5"),
                    substr(distr$UTM.cell, start = 7, stop = 7) <- paste0(substr(distr$UTM.cell, start = 7, stop = 7), "5"))
lonlat <- mgrs::mgrs_to_latlng(distr$UTM, include_mgrs_ref = FALSE)
# Given original 10x10 km grid resolution, can remove decimals from point coordinates
lonlat$lat <- round(lonlat$lat, digits = 3)
lonlat$lng <- round(lonlat$lng, digits = 3)
distr <- data.frame(distr, lonlat)
Distributions <- subset(distr, select = c(Genus, Species, Subspecies, lng, lat))
# save(Distributions, file = "data/Distributions.rda")
usethis::use_data(Distributions)

#########################################################



plot(lau.sf$geometry, pch = 15, col = "medium sea green", main = "Laurus nobilis")
plot(sp.pt, add = T, border = "grey30")




