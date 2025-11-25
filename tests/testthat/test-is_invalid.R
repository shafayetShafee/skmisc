test_that("is_invalid() detects basic invalid cases", {
  expect_true(is_invalid(NULL))
  expect_true(is_invalid(character(0)))
  expect_true(is_invalid(numeric(0)))
  expect_true(is_invalid(list()))
  expect_true(is_invalid(c(NA, NA)))
})

test_that("is_invalid() handles lists recursively", {
  expect_true(is_invalid(list(NA, NULL)))
  expect_false(is_invalid(list(NA, 5)))
  expect_false(is_invalid(list(NULL, "a")))
  expect_false(is_invalid(list(list(NULL), list(1))))
})

test_that("is_invalid() handles try-error and simpleError", {
  err1 <- try(stop("boom"), silent = TRUE)
  expect_true(is_invalid(err1))

  err2 <- simpleError("oops")
  expect_true(is_invalid(err2))
})

test_that("is_invalid() identifies valid objects correctly", {
  expect_false(is_invalid(1))
  expect_false(is_invalid("a"))
  expect_false(is_invalid(c(1, NA)))
  expect_false(is_invalid(list(5)))
})
