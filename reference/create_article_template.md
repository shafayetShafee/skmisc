# Create a Structured Article Template for a Specified Journal

This function generates an article template for the specified journal
using the
[`rmarkdown::draft`](https://pkgs.rstudio.com/rmarkdown/reference/draft.html)
function from the `rticles` package. It checks whether the journal is
supported, creates the necessary directories and files, and formats the
`<journal_name>_article.Rmd` file by adding section chunks and an
abstract.

## Usage

``` r
create_article_template(journal_name)
```

## Arguments

- journal_name:

  A character string specifying the journal for which the article
  template will be created. It must be one of the supported journals
  listed by
  [`rticles::journals()`](https://pkgs.rstudio.com/rticles/reference/journals.html).

## Value

This function does not return a value. It creates a directory structure
for the article template, including the necessary `Rmd` files for
sections and the abstract.

## Examples

``` r
if (FALSE) { # \dontrun{
create_article_template("arxiv")
} # }
```
