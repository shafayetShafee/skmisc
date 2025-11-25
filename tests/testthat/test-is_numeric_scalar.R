test_that("is_numeric_scalar() validates proper numeric scalars", {
  expect_true(is_numeric_scalar(1))
  expect_true(is_numeric_scalar(3.14))
  expect_true(is_numeric_scalar(0))
})

test_that("is_numeric_scalar() rejects NA, non-finite, or non-scalars", {
  expect_false(is_numeric_scalar(NA))
  expect_false(is_numeric_scalar(Inf))
  expect_false(is_numeric_scalar(-Inf))
  expect_false(is_numeric_scalar(c(1, 2)))
})

test_that("is_numeric_scalar() rejects invalid inputs", {
  expect_false(is_numeric_scalar(NULL))
  expect_false(is_numeric_scalar(character(0)))
  expect_false(is_numeric_scalar(list()))
})

test_that("is_numeric_scalar() rejects non-numeric types", {
  expect_false(is_numeric_scalar("1"))
  expect_false(is_numeric_scalar(TRUE))
  expect_false(is_numeric_scalar(factor(1)))
})
