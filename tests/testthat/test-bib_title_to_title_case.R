test_that("Invalid Input file name", {
  input_file_name <- 43
  expect_error(
    bib_title_to_title_case(input_file_name, "test.bib"),
    "Invalid `bib_file_path` path: Non-character supplied."
  )
})


test_that("Non readable Input file", {
  input_file_name <- "43bib"
  expect_error(
    bib_title_to_title_case(input_file_name, "test.bib"),
    "Invalid `bib_file_path` path: File is not readable."
  )
})


test_that("Invalid Output file", {
  input_file_name <- system.file("extdata", "ref.bib", package = "skmisc")
  expect_error(
    bib_title_to_title_case(input_file_name, 43),
    "Invalid `output_bib_file` path: Non-character supplied."
  )
})

