# Create a structured article template for a specified journal

Generate an article template for a given journal using
[`rmarkdown::draft`](https://pkgs.rstudio.com/rmarkdown/reference/draft.html)
from the `rticles` package. The function checks whether the journal is
supported, creates needed directories and files, and formats the
`<journal_name>_article.Rmd` file with section chunks and an abstract.

## Usage

``` r
create_article_template(journal_name)
```

## Arguments

- journal_name:

  A character string naming the journal for which the article template
  will be created. It must be one of the journals listed by
  [`rticles::journals()`](https://pkgs.rstudio.com/rticles/reference/journals.html).

## Value

This function returns no value. It creates the directory structure for
the article template, including the required `Rmd` files for sections
and the abstract.

## Examples

``` r
if (FALSE) { # \dontrun{
create_article_template("arxiv")
} # }
```
