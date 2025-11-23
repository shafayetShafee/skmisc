test_that("unsupported journal triggers cli_abort", {
  unsupported <- "not_a_journal"
  expect_error(
    create_article_template(unsupported),
    regexp = "not supported",
    class = "rlang_error"
  )
})


test_that("template directory and required files are created", {
  skip_if_not_installed("withr")

  tmp <- withr::local_tempdir()
  withr::local_dir(tmp)

  journal <- "arxiv"
  create_article_template(journal)

  draft_dir <- fs::path(tmp, paste0(journal, "_article"))
  expect_true(fs::dir_exists(draft_dir))

  sections_dir <- fs::path(draft_dir, "sections")
  expect_true(fs::dir_exists(sections_dir))

  section_files <- fs::path(sections_dir, paste0("section0", 1:5, ".Rmd"))
  expect_true(all(fs::file_exists(section_files)))

  abstract_file <- fs::path(draft_dir, "abstract.Rmd")
  expect_true(fs::file_exists(abstract_file))

  example_file <- fs::path(draft_dir, "Example.Rmd")
  expect_true(fs::file_exists(example_file))

  article_file <- fs::path(draft_dir, paste0(journal, "_article.Rmd"))
  expect_true(fs::file_exists(article_file))
})


test_that("YAML abstract and child chunks are correctly added", {
  skip_if_not_installed("withr")

  tmp <- withr::local_tempdir()
  withr::local_dir(tmp)

  journal <- "arxiv"
  create_article_template(journal)

  draft_dir <- fs::path(tmp, paste0(journal, "_article"))
  article_file <- fs::path(draft_dir, paste0(journal, "_article.Rmd"))

  content <- readLines(article_file)

  # YAML header starts and ends with ---
  expect_true(any(grepl("^---", content)))
  expect_true(any(grepl("---$", content)))

  # Abstract replaced by inline child expression
  expect_true(any(grepl("`r paste\\(readLines\\(\"abstract.Rmd\"\\)", content)))

  # Section child chunks appended
  for (i in 1:5) {
    expect_true(
      any(grepl(paste0('child="sections/section0', i, '.Rmd"'), content)),
      info = paste("Section", i, "child chunk missing")
    )
  }
})
