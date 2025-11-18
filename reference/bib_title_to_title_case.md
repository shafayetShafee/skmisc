# Convert the title of each bibentry of a bib file to title case.

Convert the title of each bibentry of a bib file to title case.

## Usage

``` r
bib_title_to_title_case(bib_file_path, output_bib_file)
```

## Arguments

- bib_file_path:

  character, path to a `.bib` file.

- output_bib_file:

  character, path to a `.bib` file that will contain the transformed
  bibentries with title-cased title.

## Value

`bib_file_path` as a character string, invisibly.

## Examples

``` r
bib_file <- system.file("extdata", "ref.bib", package = "skmisc")
tmp_output_file <- tempfile(fileext = ".bib")
bib_title_to_title_case(bib_file_path = bib_file, output_bib_file = tmp_output_file)
#> Writing 2 Bibtex entries ... 
#> OK
#> Results written to file ‘/tmp/RtmpIqqE3c/file181a1f56a23e.bib’
cat(readLines(tmp_output_file), sep = "\n")
#> @Article{merlo2005brief,
#>   title = {{A Brief Conceptual Tutorial of Multilevel Analysis in Social Epidemiology: Linking the Statistical Concept of Clustering to the Idea of Contextual Phenomenon}},
#>   author = {Juan Merlo and Basile Chaix and Min Yang and John Lynch and Lennart R{\r a}stam},
#>   journal = {Journal of Epidemiology \& Community Health},
#>   volume = {59},
#>   number = {6},
#>   pages = {443--449},
#>   year = {2005},
#>   publisher = {BMJ Publishing Group Ltd},
#>   booktitle = {{NA}},
#> }
#> 
#> @InProceedings{hox1998multilevel,
#>   title = {{Multilevel Modeling: When and Why}},
#>   author = {Joop Hox},
#>   pages = {147--154},
#>   year = {1998},
#>   booktitle = {{Classification, Data Analysis, and Data Highways: Proceedings of the 21st Annual Conference of the Gesellschaft F{\"U}r Klassifikation eV, University of Potsdam, March 12--14, 1997}},
#>   organization = {Springer},
#> }
```
