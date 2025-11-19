# Changelog

## skmisc 0.1.3

- Updated `bib_title_to_title_case` to use multi-line cli message
  formatting.
- Added `cli` message formatting in create_article_template.
- Started using R package [`cli`](https://cli.r-lib.org/) to format
  package messages consistently.

## skmisc 0.1.2

- Added the
  [`create_article_template()`](https://shafayetshafee.github.io/skmisc/reference/create_article_template.md)
  function that generates an article template for the specified journal
  using the
  [`rmarkdown::draft`](https://pkgs.rstudio.com/rmarkdown/reference/draft.html)
  function from the `rticles` package. It checks whether the journal is
  supported, creates the necessary directories and files, and formats
  the article rmarkdown file by adding section chunks and an abstract.

## skmisc 0.1.1

- Modified the
  [`bib_title_to_title_case()`](https://shafayetshafee.github.io/skmisc/reference/bib_title_to_title_case.md)
  by adding curly brackets in title so that title casing gets preserved.

## skmisc 0.1.0

- Added the first function
  [`bib_title_to_title_case()`](https://shafayetshafee.github.io/skmisc/reference/bib_title_to_title_case.md)
