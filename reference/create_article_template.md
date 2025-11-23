# Create a structured article template directory for a specified journal

Generates a ready-to-use article template for a journal supported by the
**`rticles`** package. The function creates the draft with
[`rmarkdown::draft()`](https://pkgs.rstudio.com/rmarkdown/reference/draft.html),
sets up a clean directory structure (a separate `sections/` folder and
an `abstract.Rmd` file), moves the abstract texts out of the YAML
front-matter, inserts child-document chunks for five default sections,
and formats the `<journal_name>_article.Rmd` file with section chunks
and an abstract.

## Usage

``` r
create_article_template(journal_name)
```

## Arguments

- journal_name:

  Character string giving the name of the journal. Must be one of the
  journals returned by
  [`rticles::journals()`](https://pkgs.rstudio.com/rticles/reference/journals.html).

## Value

Invisibly returns the path to the created directory. The function is
called primarily for its side effect of creating files on disk.

## Examples

``` r
if (FALSE) { # \dontrun{
create_article_template("arxiv")
create_article_template("peerj")
} # }
```
