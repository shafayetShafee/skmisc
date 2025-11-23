# skmisc 0.4.0

* Added many checks and tests for `create_article_template` and `bib_title_case`
* Modularized & refactored the `bib_title_case` for better testing and made the 
  function robust in the process.
* Enhanced the function error, warning or simple messages.
* Linted the package code using `lintr` and formatted the code using `air`

# skmisc 0.3.0

* Renamed the funciton `bib_title_to_title_case` to `bib_title_case` and used
  `lifecycle::deprecate_warn`.

# skmisc 0.2.0

## Function `bib_title_to_title_case`

* Added `components` argument to selectively title-case fields (`"title"`, `"booktitle"`, 
  `"journal"`) or `"all"` fields ("all" by default).
* Added `overwrite` argument to control whether existing output files are replaced.
* Used safe_title_case() helper to protect text inside braces and safely apply title case.
* Input/output validation improved using `{fs}` and `{cli}` for robust error messages.
* Refactored component processing to a loop: fast, safe, avoids code duplication.
* Internal helpers `is_char_scalar()` and `wrap_braces_once()` added.

# skmisc 0.1.3

* Updated `bib_title_to_title_case` to use multi-line cli message formatting.
* Added `cli` message formatting in create_article_template.
* Started using R package [`cli`](https://cli.r-lib.org/) to format package messages consistently.


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
