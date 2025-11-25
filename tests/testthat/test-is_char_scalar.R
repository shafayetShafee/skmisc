test_that("is_char_scalar() validates normal character scalars", {
  expect_true(is_char_scalar("hello"))
  expect_true(is_char_scalar("a"))
  expect_true(is_char_scalar("  hi  ")) # whitespace trimmed
})

test_that("is_char_scalar() rejects empty or whitespace-only strings", {
  expect_false(is_char_scalar(""))
  expect_false(is_char_scalar("   "))
})

test_that("is_char_scalar() rejects invalid inputs", {
  expect_false(is_char_scalar(NULL))
  expect_false(is_char_scalar(NA))
  expect_false(is_char_scalar(character(0)))
  expect_false(is_char_scalar(list()))
  expect_false(is_char_scalar(NA_character_))
})

test_that("is_char_scalar() rejects non-character types", {
  expect_false(is_char_scalar(1))
  expect_false(is_char_scalar(TRUE))
  expect_false(is_char_scalar(factor("x")))
  expect_false(is_char_scalar(c("a", "b")))
  expect_false(is_char_scalar(list("a")))
})
