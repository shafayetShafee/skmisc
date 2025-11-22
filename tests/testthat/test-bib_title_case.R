test_that("Invalid Input file name (snapshot)", {
  input_file_name <- 43
  expect_snapshot(error = TRUE, {
    bib_title_case(input_file_name, "test.bib")
  })
})


test_that("Non readable Input file", {
  input_file_name <- "43bib"
  expect_snapshot(error = TRUE, {
    bib_title_case(input_file_name, "test.bib")
  })
})


test_that("Invalid Output file", {
  input_file_name <- system.file("extdata", "ref.bib", package = "skmisc")
  expect_snapshot(error = TRUE, {
    bib_title_case(input_file_name, 43)
  })
})

