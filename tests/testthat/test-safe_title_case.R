test_that("safe_title_case converts to title case for simple titles", {
  out <- safe_title_case("a simple title")
  expect_equal(out, "{A Simple Title}")
  expect_match(out, "^\\{.*\\}$")
})


test_that("safe_title_case preserves protected brace segments", {
  title <- "a study on {RNA sequencing} methods"
  out <- safe_title_case(title, "title")

  expect_true(grepl("\\{RNA sequencing\\}", out))
  expect_true(grepl("^\\{A Study on \\{RNA sequencing\\} Methods\\}$", out))
})


test_that("safe_title_case handles multiple protected segments", {
  title <- "analysis of {DNA} and {RNA} workflows"
  out <- safe_title_case(title, "title")

  expect_true(grepl("\\{DNA\\}", out))
  expect_true(grepl("\\{RNA\\}", out))
  expect_equal(out, "{Analysis of {DNA} and {RNA} Workflows}")
})


test_that("safe_title_case leaves nested brace content untouched", {
  title <- "study of {{Deep Learning}} models"
  out <- safe_title_case(title, "title")

  expect_equal(out, "{Study of {{Deep Learning}} Models}")
})


test_that("safe_title_case handles empty strings", {
  expect_snapshot({
    safe_title_case("", "title")
  })
})

# fmt: skip
test_that(
  desc = "safe_title_case warns and substitutes empty string for invalid input",
  code = {
    expect_snapshot({
      safe_title_case(1, "title")
    })
  }
)


test_that("safe_title_case works for multiple titles in a vector", {
  titles <- c("first title", "second entry")
  out <- safe_title_case(titles, "title")

  expect_equal(out, c("{First Title}", "{Second Entry}"))
})
