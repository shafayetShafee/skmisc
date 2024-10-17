# skmisc 0.1.2

* Added the `create_article_template()` function that generates an article template for the
specified journal using the `rmarkdown::draft` function from the `rticles` package. It checks
whether the journal is supported, creates the necessary directories and files, and formats
the article rmarkdown file by adding section chunks and an abstract.

# skmisc 0.1.1

* Modified the `bib_title_to_title_case()` by adding curly brackets in title so 
  that title casing gets preserved.

# skmisc 0.1.0

* Added the first function `bib_title_to_title_case()`
