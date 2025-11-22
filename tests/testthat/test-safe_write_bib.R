create_example_bib_df <- function() {
  tmp <- tempfile(fileext = ".bib")
  writeLines(
    c(
      "@book{knuth1984,",
      "  author    = {Knuth, Donald E.},",
      "  title     = {The TeXbook},",
      "  year      = {1984},",
      "  publisher = {Addison-Wesley}",
      "}",
      "",
      "@article{merlo2005,",
      "  author  = {Merlo, Juan and others},",
      "  title   = {A brief tutorial},",
      "  journal = {JECH},",
      "  year    = {2005}",
      "}"
    ),
    tmp
  )
  as.data.frame(RefManageR::ReadBib(tmp))
}


empty_bib_df <- function() {
  as.data.frame(RefManageR::as.BibEntry(character(0)))
}


bib_df_with_zero_row <- function() {
  df <- create_example_bib_df()
  df[0, ]
}


bib_df_with_dup_key <- function() {
  tmp <- tempfile(fileext = ".bib")
  writeLines(
    c(
      "@article{dup1,",
      "  author  = {A},",
      "  title   = {One},",
      "  journal = {J},",
      "  year    = {2020}",
      "}",
      "",
      "@article{dup1,",
      "  author  = {B},",
      "  title   = {Two},",
      "  journal = {J},",
      "  year    = {2021}",
      "}"
    ),
    tmp
  )

  as.data.frame(RefManageR::ReadBib(tmp))
}


test_that("safe_write_bib succeeds with valid data and returns invisible(TRUE)", {
  df <- create_example_bib_df()
  tmp <- tempfile(fileext = ".bib")
  res <- safe_write_bib(df, tmp)

  expect_message(
    res <- safe_write_bib(df, tmp),
    regexp = "Successfully wrote BibTeX file",
    class = "rlang_message"
  )

  expect_true(res)
  expect_true(file.exists(tmp))
  expect_gt(file.info(tmp)$size, 50)
  expect_silent(RefManageR::ReadBib(tmp))
})


test_that("safe_write_bib aborts when bibliography has zero entries (no 'bibtype' column)", {
  bad_empty_df <- empty_bib_df()

  tmp <- tempfile(fileext = ".bib")

  expect_error(
    safe_write_bib(bad_empty_df, tmp),
    regexp = "Occurred when writing the BibTeX file",
    class = "rlang_error"
  )
  expect_false(file.exists(tmp))
})


test_that("safe_write_bib aborts on zero-row df with bibtype column", {
  df <- bib_df_with_zero_row()
  tmp <- tempfile(fileext = ".bib")

  expect_error(
    safe_write_bib(zero_row_df, tmp),
    regexp = "Occurred when writing the BibTeX file",
    class = "rlang_error"
  )
  expect_false(file.exists(tmp))
})


test_that("safe_write_bib aborts when output directory does not exist", {
  df <- create_example_bib_df()
  bad_path <- file.path(tempdir(), "this_directory_does_not_exist_12345", "out.bib")

  expect_error(
    suppressWarnings(safe_write_bib(df, bad_path)),
    regexp = "cannot open the connection",
    class = "rlang_error"
  )
})


test_that("safe_write_bib aborts on permission denied (read-only file)", {
  df <- create_example_bib_df()
  tmp <- tempfile(fileext = ".bib")
  writeLines("% dummy", tmp)
  Sys.chmod(tmp, mode = "0444") # read-only

  expect_error(
    suppressWarnings(safe_write_bib(df, tmp)),
    regexp = "cannot open the connection"
  )

  Sys.chmod(tmp, mode = "0644")
  unlink(tmp)
})


test_that("safe_write_bib aborts on non-data.frame inputs", {
  tmp <- tempfile(fileext = ".bib")

  expect_error(
    safe_write_bib(NULL, tmp),
    regexp = "Occurred when writing",
    class = "rlang_error"
  )
  expect_error(
    safe_write_bib(list(a = 1), tmp),
    regexp = "Occurred when writing",
    class = "rlang_error"
  )
  expect_error(
    safe_write_bib("hello", tmp),
    regexp = "Occurred when writing",
    class = "rlang_error"
  )
})
