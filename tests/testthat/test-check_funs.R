test_that("check_bool_scalar() passes for valid logical scalars", {
  expect_invisible(check_bool_scalar(TRUE))
  expect_invisible(check_bool_scalar(FALSE))
})

test_that("check_bool_scalar() throws rlang_error for invalid cases", {
  invalid_values <- list(
    NA,
    NULL,
    c(TRUE, FALSE),
    "TRUE",
    1L,
    list(TRUE)
  )

  for (x in invalid_values) {
    expect_error(
      check_bool_scalar(x),
      class = "rlang_error"
    )
  }
})


test_that("check_char_scalar() passes for valid character scalars", {
  expect_invisible(check_char_scalar("hello"))
  expect_invisible(check_char_scalar("  hi  ")) # trimmed non-empty
})

test_that("check_char_scalar() throws rlang_error for invalid character scalars", {
  invalid_values <- list(
    "",
    "   ",
    NA_character_,
    NULL,
    c("a", "b"),
    42,
    TRUE
  )

  for (x in invalid_values) {
    expect_error(
      check_char_scalar(x),
      class = "rlang_error"
    )
  }
})


test_that("check_numeric_scalar() passes for valid numeric scalars", {
  expect_invisible(check_numeric_scalar(5))
  expect_invisible(check_numeric_scalar(0.1))
  expect_invisible(check_numeric_scalar(1L))
})

test_that("check_numeric_scalar() throws rlang_error for invalid cases", {
  invalid_values <- list(
    NA,
    NULL,
    "5",
    c(1, 2),
    Inf,
    -Inf,
    NaN,
    TRUE
  )

  for (x in invalid_values) {
    expect_error(
      check_numeric_scalar(x),
      class = "rlang_error"
    )
  }
})


# ------------------------------
# check_bound()
# ------------------------------

test_that("check_bound() passes on valid bound checks", {
  expect_invisible(check_bound(1, 0)) # val >= bound
  expect_invisible(check_bound(1, 1)) # equality allowed by default
  expect_invisible(check_bound(1, 0, include = FALSE))
  expect_invisible(check_bound(1, 2, is_lower = FALSE)) # val <= bound
})

test_that("check_bound() errors on invalid bound logic", {
  expect_error(check_bound(-1, 0), class = "rlang_error")
  expect_error(
    check_bound(0, 1, include = FALSE, is_lower = TRUE),
    class = "rlang_error"
  )
  expect_error(check_bound(5, 3, is_lower = FALSE), class = "rlang_error")
})

test_that("check_bound() validates its own inputs", {
  expect_error(check_bound("a", 1), class = "rlang_error")
  expect_error(check_bound(1, "b"), class = "rlang_error")
  expect_error(check_bound(1, 0, include = "x"), class = "rlang_error")
  expect_error(check_bound(1, 0, is_lower = NA), class = "rlang_error")
})


# ------------------------------
# check_numeric_bound()
# ------------------------------

test_that("check_numeric_bound() passes on valid cases", {
  expect_invisible(check_numeric_bound(0.5))
  expect_invisible(check_numeric_bound(0, lower_include = TRUE))
  expect_invisible(check_numeric_bound(1, upper_include = TRUE))
  expect_invisible(
    check_numeric_bound(0.5, lower_include = FALSE, upper_include = FALSE)
  )
  expect_invisible(check_numeric_bound(10, lower = 5, upper = 20))
})

test_that("check_numeric_bound() errors on invalid values", {
  expect_error(check_numeric_bound(NA), class = "rlang_error")
  expect_error(check_numeric_bound("a"), class = "rlang_error")
  expect_error(check_numeric_bound(2, upper = 1), class = "rlang_error")

  expect_error(
    check_numeric_bound(0, lower_include = FALSE),
    class = "rlang_error"
  )
})

test_that("check_numeric_bound() validates bound arguments", {
  expect_error(check_numeric_bound(1, lower = "x"), class = "rlang_error")
  expect_error(check_numeric_bound(1, upper = NULL), class = "rlang_error")

  expect_error(
    check_numeric_bound(1, lower_include = "yes"),
    class = "rlang_error"
  )

  expect_error(
    check_numeric_bound(1, upper_include = NA),
    class = "rlang_error"
  )
})
