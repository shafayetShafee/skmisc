# Safely convert titles to title case, preserving protected braces

Safely convert titles to title case, preserving protected braces

## Usage

``` r
safe_title_case(titles, component)
```

## Arguments

- titles:

  character vector of BibTeX titles

- component:

  Either of 'title', 'booktitle' or 'journal'

## Value

character vector of titles, wrapped in single braces, with protected
content intact
