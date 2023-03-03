
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FloraIberica

<!-- badges: start -->
<!-- badges: end -->

FloraIberica facilitates checking taxonomic and distribution data for
the c. 6500 vascular plant species present in the Iberian Peninsula and
Balearic Islands, based on the [AFLIBER
database](https://doi.org/10.1111/geb.13363).

## Installation

You can install the development version of FloraIberica like so:

``` r
remotes::install_github("Pakillo/FloraIberica")
```

## Examples

``` r
library(FloraIberica)
```

### Checking if taxa are present

``` r
is_present(genus = "Laurus", species = c("nobilis", "azorica"))
#> Laurus nobilis Laurus azorica 
#>           TRUE          FALSE
```

### Checking if taxa are endemic

``` r
is_endemic(genus = "Aconitum", species = "napellus", 
           subspecies = c("vulgare", "castellanum", "lusitanicum"))
#> Aconitum napellus castellanum Aconitum napellus lusitanicum 
#>                          TRUE                         FALSE 
#>     Aconitum napellus vulgare 
#>                         FALSE
```

### Getting the distribution of plant taxa

``` r
get_distribution("Abies", "pinsapo")
```

### Making distribution maps

#### Single taxon

``` r
laurus.sf <- get_distribution("Laurus", "nobilis")
map_distribution(laurus.sf)
```

#### Many taxa

Iberian *Abies*:

``` r
abies.sf <- get_distribution("Abies")
map_distribution(abies.sf)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
map_distribution(abies.sf, facet = TRUE, ncol = 1)
```

<img src="man/figures/README-unnamed-chunk-6-2.png" width="100%" />

Iberian Pines:

``` r
library(ggplot2)
pinus <- get_distribution("Pinus")
mapa <- map_distribution(pinus, facet = TRUE, ncol = 2)
mapa + theme(axis.text = element_text(size = 6))
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

## Citation

``` r
print(citation("FloraIberica"), style = "text")
```

Ramos‐Gutiérrez, Ignacio, Lima, Herlander, Pajarón, Santiago,
Romero‐Zarco, Carlos, Sáez, Llorenç, Pataro, Luciano, Molina‐Venegas,
Rafael, Rodríguez, Á. M, Moreno‐Saiz, Carlos J (2021). “Atlas of the
vascular flora of the Iberian Peninsula biodiversity hotspot (AFLIBER).”
*Global Ecology and Biogeography*, *30*, 1951-1957.
<https://onlinelibrary.wiley.com/doi/10.1111/geb.13363>.

Rodríguez-Sánchez F (2023). *FloraIberica: Taxonomic information and
distribution data for the vascular plant species present in the Iberian
Peninsula and/or Balearic Islands*.
<https://pakillo.github.io/FloraIberica>.
