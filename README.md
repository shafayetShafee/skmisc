
# skmisc (Shafayet Khan Miscellaneous) <a href="https://shafayetshafee.github.io/skmisc/"><img src="man/figures/logo.svg" align="right" height="139" alt="skmisc website" /></a>

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://choosealicense.com/licenses/mit/)
[![CRAN
status](https://www.r-pkg.org/badges/version/skmisc)](https://CRAN.R-project.org/package=skmisc)
[![Codecov test
coverage](https://codecov.io/gh/shafayetShafee/skmisc/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shafayetShafee/skmisc?branch=main)
[![R-CMD-check](https://github.com/shafayetShafee/skmisc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shafayetShafee/skmisc/actions/workflows/R-CMD-check.yaml)

The goal of `{skmisc}` is to provide some function that makes certain
workflows easier. Currently, the only function that might be useful to
anyone (who use Rmarkdown + LaTex) is `skmisc::create_article_template`.

## Installation

`{skmisc}` is not on CRAN yet. You can install the development version
of `{skmisc}` from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("shafayetShafee/skmisc")
```

or,

``` r
# install.packages("remotes")
remotes::install_github("shafayetShafee/skmisc")
```

## Example

### Create a Structured Article Template for a Journal Supported by `{rticles}`

Suppose you want to format your manuscript following the *Statistics in
Medicine (SIM)* style using the R package
[`rticles`](https://pkgs.rstudio.com/rticles/reference/article.html#sim-article).
The standard approach is:

``` r
rmarkdown::draft(
    "sim_article", 
    template = "sim", 
    package = "rticles",
    create_dir = TRUE,
    edit = FALSE
)
```

This creates a directory named `sim_article` in your working directory,
containing all the files required for the *SIM* format. The structure
looks like this:

``` bash
sim_article
├── bibfile.bib
├── Fonts
│   └── Stix
├── LETTERSP.STY
├── skeleton.log
├── sim_article.Rmd
├── WileyNJD-AMA.bst
└── WileyNJD-v5.cls
```

This works well, but the structure has one limitation: you must write
your entire manuscript in a single Rmd file. However, I personally
prefer keeping different major sections in separate Rmd files for better
organization and modular editing.

That motivated the creation of the following function:

``` r
skmisc::create_article_template("sim")
```

Running this will create the directory `sim_article` with a more modular
structure:

``` bash
sim_article
├── abstract.Rmd
├── bibfile.bib
├── Example.Rmd
├── Fonts
│   └── Stix
├── LETTERSP.STY
├── sections
│   ├── section01.Rmd
│   ├── section02.Rmd
│   ├── section03.Rmd
│   ├── section04.Rmd
│   └── section05.Rmd
├── sim_article.Rmd
├── skeleton.log
├── WileyNJD-AMA.bst
└── WileyNJD-v5.cls
```

In this layout, each major section lives in its own Rmd file, which the
main file (`sim_article.Rmd`) includes as child documents. For example
(non-essential YAML omitted):

<pre>
---
<..TRUNCATED..>
abstract: |
    &#96;r paste(readLines("abstract.Rmd"), collapse = "\n  ")&#96;
<..TRUNCATED..>
---
&#10;&#96;&#96;&#96;{r section01, child="sections/section01.Rmd"}
&#96;&#96;&#96;
&#10;&#96;&#96;&#96;{r section02, child="sections/section02.Rmd"}
&#96;&#96;&#96;
&#10;&#96;&#96;&#96;{r section03, child="sections/section03.Rmd"}
&#96;&#96;&#96;
&#10;&#96;&#96;&#96;{r section04, child="sections/section04.Rmd"}
&#96;&#96;&#96;
&#10;&#96;&#96;&#96;{r section05, child="sections/section05.Rmd"}
&#96;&#96;&#96;
</pre>

To check the formatted pdf out, you just knit this main
`sim_article.Rmd` file. This structure allows you to keep your
manuscript clean, organized, and modular. Useful, innit? 🙂

> \[!NOTE\] The function `skmisc::create_article_template()` is a
> convenient wrapper around `rmarkdown::draft()` that lets you use any
> `{rticles}` journal format while working with multiple Rmd files. If
> you prefer the traditional single-file workflow, you should simply use
> `rmarkdown::draft()` with `{rticles}` directly.

### Converting the title of bib entries in a bib file to title case

``` r
library(skmisc)

bib_file <- system.file("extdata", "ref.bib", package = "skmisc")

# The original bib entries
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

# Convert all supported components (default)
tmp_all <- tempfile(fileext = ".bib")
bib_title_to_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_all
)
#> ! Invalid booktitle string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
#> ! Invalid journal string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
cat(readLines(tmp_all), sep = "\n")
#> @Article{merlo2005brief,
#>   title = {{NA}},
#>   author = {Juan Merlo and Basile Chaix and Min Yang and John Lynch and Lennart R{\r a}stam},
#>   journal = {{NA}},
#>   volume = {59},
#>   number = {6},
#>   pages = {443--449},
#>   year = {2005},
#>   publisher = {BMJ Publishing Group Ltd},
#>   booktitle = {{NA}},
#> }
#> 
#> @InProceedings{hox1998multilevel,
#>   title = {{NA}},
#>   author = {Joop Hox},
#>   journal = {{NA}},
#>   pages = {147--154},
#>   year = {1998},
#>   booktitle = {{Classification, Data Analysis, and Data Highways: Proceedings of the 21st Annual Conference of the Gesellschaft F{\"u}r Klassifikation eV, University of Potsdam, March 12--14, 1997}},
#>   organization = {Springer},
#> }

# Convert only the title field
tmp_title_only <- tempfile(fileext = ".bib")
bib_title_to_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_title_only,
  components = "title"
)

# Convert title and journal fields only
tmp_title_journal <- tempfile(fileext = ".bib")
bib_title_to_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_title_journal,
  components = c("title", "journal")
)
#> ! Invalid journal string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
```

## Code of Conduct

Please note that the skmisc project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
