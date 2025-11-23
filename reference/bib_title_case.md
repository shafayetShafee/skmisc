# Convert the title, booktitle, journal name of each bibentry of a bib file to title case.

Convert the title, booktitle, journal name of each bibentry of a bib
file to title case.

## Usage

``` r
bib_title_case(
  bib_file_path,
  output_bib_file,
  components = "all",
  overwrite = FALSE
)
```

## Arguments

- bib_file_path:

  character, path to a `.bib` file.

- output_bib_file:

  character, path to a `.bib` file that will contain the transformed
  bib-entries with title-cased title.

- components:

  Character vector specifying which BibTeX fields should be converted to
  title case. Valid values include `"title"`, `"booktitle"`, and
  `"journal"`. The special value `"all"` (the default) applies the
  transformation to all supported fields.

  Only the fields listed in `components` *and* present in the input
  `.bib` file will be modified. Fields not included in `components` are
  left unchanged.

  Examples:

  - `components = "all"` (default): modify title, booktitle, and journal
    name

  - `components = "title"`: modify only article titles

  - `components = c("title", "journal")`: modify both title and journal
    name

- overwrite:

  Logical. Should an existing output file be overwritten? Defaults to
  `FALSE`. If `FALSE` and the file already exists, the function will
  abort with an informative message. If `TRUE`, the existing file will
  be replaced.

## Value

`output_bib_file` as a character string, invisibly.

## Examples

``` r
# Example .bib file included with the package
bib_file <- system.file("extdata", "ref.bib", package = "skmisc")

# Temporary output file
tmp_output_file <- tempfile(fileext = ".bib")

# Convert all supported components (default)
bib_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_output_file
)
#> ! Invalid booktitle string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
#> ! Invalid journal string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
#> ✔ Successfully wrote BibTeX file: /tmp/RtmpWc7emL/file182f64b4d314.bib
cat(readLines(tmp_output_file), sep = "\n")
#> @Article{merlo2005brief,
#>   title = {{A Brief Conceptual Tutorial of Multilevel Analysis in Social Epidemiology: Linking the Statistical Concept of Clustering to the Idea of Contextual Phenomenon}},
#>   author = {Juan Merlo and Basile Chaix and Min Yang and John Lynch and Lennart R{\r a}stam},
#>   journal = {{Journal of Epidemiology \& Community Health}},
#>   volume = {59},
#>   number = {6},
#>   pages = {443--449},
#>   year = {2005},
#>   publisher = {BMJ Publishing Group Ltd},
#>   booktitle = {{}},
#> }
#> 
#> @InProceedings{hox1998multilevel,
#>   title = {{Multilevel Modeling: When and Why}},
#>   author = {Joop Hox},
#>   journal = {{}},
#>   pages = {147--154},
#>   year = {1998},
#>   booktitle = {{Classification, Data Analysis, and Data Highways: Proceedings of the 21st Annual Conference of the Gesellschaft F{\"u}r Klassifikation eV, University of Potsdam, March 12--14, 1997}},
#>   organization = {Springer},
#> }

# Convert only the title field
tmp_title_only <- tempfile(fileext = ".bib")
bib_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_title_only,
  components = "title"
)
#> ✔ Successfully wrote BibTeX file: /tmp/RtmpWc7emL/file182f30f16e6f.bib

# Convert title and journal fields only
tmp_title_journal <- tempfile(fileext = ".bib")
bib_title_case(
  bib_file_path = bib_file,
  output_bib_file = tmp_title_journal,
  components = c("title", "journal")
)
#> ! Invalid journal string: NA in the bib file
#> ! Expected a single, non-NA character string; using empty string instead
#> ✔ Successfully wrote BibTeX file: /tmp/RtmpWc7emL/file182f37565062.bib
```
