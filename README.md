
<!-- README.md is generated from README.Rmd. Please edit that file -->

# skmisc (Shafayet Khan Miscellaneous)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/skmisc)](https://CRAN.R-project.org/package=skmisc)
<!-- badges: end -->

The goal of `{skmisc}` is to provide some function that makes certain
workflows easier.

## Installation

`{skmisc}` is not on CRAN yet. You can install the development version
of `{skmisc}` from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("shafayetShafee/skmisc")
```

## Example

### Converting the title of bib entries in a bib file to title case

``` r
library(skmisc)

bib_file <- system.file("extdata", "ref.bib", package = "skmisc")

# The title of each bib entry is in sentence case.
cat(readLines(bib_file), sep = "\n")
#> @article{merlo2005brief,
#>   title={A brief conceptual tutorial of multilevel analysis in social epidemiology: linking the statistical concept of clustering to the idea of contextual phenomenon},
#>   author={Merlo, Juan and Chaix, Basile and Yang, Min and Lynch, John and R{\aa}stam, Lennart},
#>   journal={Journal of Epidemiology \& Community Health},
#>   volume={59},
#>   number={6},
#>   pages={443--449},
#>   year={2005},
#>   publisher={BMJ Publishing Group Ltd}
#> }
#> 
#> @inproceedings{hox1998multilevel,
#>   title={Multilevel modeling: When and why},
#>   author={Hox, Joop},
#>   booktitle={Classification, data analysis, and data highways: proceedings of the 21st Annual Conference of the Gesellschaft f{\"u}r Klassifikation eV, University of Potsdam, March 12--14, 1997},
#>   pages={147--154},
#>   year={1998},
#>   organization={Springer}
#> }

# converting the titles to title case.
tmp_output_file <- tempfile(fileext = ".bib")
bib_title_to_title_case(bib_file_path = bib_file, output_bib_file = tmp_output_file)
#> Writing 2 Bibtex entries ... OK
#> Results written to file '/var/folders/bt/zy40546n0xdbzb8m95yscnh00000gn/T//Rtmpb8fwWd/file786795c799f.bib'

cat(readLines(tmp_output_file), sep = "\n")
#> @Article{merlo2005brief,
#>   title = {A Brief Conceptual Tutorial of Multilevel Analysis in Social Epidemiology: Linking the Statistical Concept of Clustering to the Idea of Contextual Phenomenon},
#>   author = {Juan Merlo and Basile Chaix and Min Yang and John Lynch and Lennart R{\r a}stam},
#>   journal = {Journal of Epidemiology \& Community Health},
#>   volume = {59},
#>   number = {6},
#>   pages = {443--449},
#>   year = {2005},
#>   publisher = {BMJ Publishing Group Ltd},
#> }
#> 
#> @InProceedings{hox1998multilevel,
#>   title = {Multilevel Modeling: When and Why},
#>   author = {Joop Hox},
#>   pages = {147--154},
#>   year = {1998},
#>   booktitle = {Classification, Data Analysis, and Data Highways: Proceedings of the 21st Annual Conference of the Gesellschaft F{\"U}r Klassifikation eV, University of Potsdam, March 12--14, 1997},
#>   organization = {Springer},
#> }
```

## Code of Conduct

Please note that the skmisc project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
