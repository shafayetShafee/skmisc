write_bib <- function(content, file = tempfile(fileext = ".bib")) {
  writeLines(content, file)
  file
}


test_that("safe_read_bib successfully reads a valid BibTeX file", {
  bib_content <- "
  @article{merlo2005brief,
    title={A brief conceptual tutorial},
    author={Merlo, Juan},
    journal={Journal},
    year={2005}
  }"

  path <- write_bib(bib_content)
  expect_silent(result <- safe_read_bib(path))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_true(all(c("title", "author", "year") %in% names(result)))
})


test_that("safe_read_bib returns NULL and aborts on completely unreadable file", {
  path <- write_bib("this is not bibtex at all")
  expect_error(
    safe_read_bib(path),
    regexp = "Occurred when reading the BibTeX file",
    class = "rlang_error"
  )
})


test_that("missing required fields for @article triggers error", {
  # @article requires at least: author, title, journal, year
  cases <- list(
    # missing author
    "@article{key, title = {T}, journal = {J}, year = {2020}}",
    # missing title
    "@article{key, author = {A}, journal = {J}, year = {2020}}",
    # missing journal
    "@article{key, author = {A}, title = {T}, year = {2020}}",
    # missing year
    "@article{key, author = {A}, title = {T}, journal = {J}}"
  )

  for (bib in cases) {
    path <- write_bib(bib)
    expect_error(
      safe_read_bib(path),
      regexp = "Occurred when reading the BibTeX file",
      class = "rlang_error"
    )
  }
})


test_that("missing required fields for @inproceedings triggers error", {
  # @inproceedings requires: author, title, booktitle, year
  cases <- list(
    "@inproceedings{key, title = {T}, booktitle = {B}, year = {2020}}",
    "@inproceedings{key, author = {A}, booktitle = {B}, year = {2020}}",
    "@inproceedings{key, author = {A}, title = {T}, year = {2020}}",
    "@inproceedings{key, author = {A}, title = {T}, booktitle = {B}}"
  )

  for (bib in cases) {
    path <- write_bib(bib)
    expect_error(
      safe_read_bib(path),
      regexp = "Occurred when reading the BibTeX file"
    )
  }
})


test_that("empty file or only comments returns error (all entries ignored)", {
  cases <- c(
    "% just a comment",
    "", # completely empty
    "   \n   \t   ", # whitespace only
    "@comment{this is ignored}"
  )

  for (content in cases) {
    path <- write_bib(content)
    expect_error(
      safe_read_bib(path),
      class = "rlang_error"
    )
  }
})


test_that("non-existent file triggers clear error", {
  expect_error(
    safe_read_bib("this_file_does_not_exist_at_all.bib"),
    class = "rlang_error"
  )
})


test_that("file path with spaces and special chars works", {
  bib_content <- "@misc{test, title = {Works with spaces}}"
  path <- write_bib(
    bib_content,
    file = tempfile(pattern = "my bib file ", fileext = ".bib")
  )
  expect_s3_class(safe_read_bib(path), "data.frame")
})


test_that("safe_read_bib handles multiple entries and filters ignored ones", {
  bib_content <- "
  @article{good1,
    title={Good Title},
    author={Author A},
    journal={J1},
    year={2020}
  }

  @article{bad2,
    author={Missing title but has author},
    journal={J2},
    year={2021}
  }"

  path <- write_bib(bib_content)

  result <- safe_read_bib(path)

  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) >= 1)
  expect_true(all(c("title", "author", "year") %in% names(result)))

  expect_snapshot({
    safe_read_bib(path)
  })
})


test_that("safe_read_bib errors gracefully on malformed BibTeX", {
  bad_bib <- "
  @article{oops
    title = {Missing comma and brace}
  "

  path <- write_bib(bad_bib)

  expect_error(
    safe_read_bib(path),
    regexp = "Occurred when reading the BibTeX file",
    class = "rlang_error"
  )
})
