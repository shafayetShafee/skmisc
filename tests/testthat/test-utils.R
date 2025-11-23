# Test for `skmisc:::is_char_scalar` --------------------------------------

test_that("is_char_scalar() returns TRUE for valid single characters", {
  expect_true(is_char_scalar("a"))
  expect_true(is_char_scalar("hello"))
  expect_true(is_char_scalar(" ")) # space is a valid non-empty character
})

# adding `desc`, `code` so that texts contained with 80 line-width bound
# non-standard !?
test_that(
  desc = "is_char_scalar() returns FALSE for empty or NA characters or NULL",
  code = {
    expect_false(is_char_scalar(""))
    expect_false(is_char_scalar(NA_character_))
    expect_false(is_char_scalar(NULL))
  }
)

test_that("is_char_scalar() returns FALSE for non-character inputs", {
  expect_false(is_char_scalar(1))
  expect_false(is_char_scalar(TRUE))
  expect_false(is_char_scalar(list("a")))
  expect_false(is_char_scalar(factor("a")))
})

test_that(
  desc = "is_char_scalar() returns FALSE for multi-length character vectors",
  code = {
    expect_false(is_char_scalar(c("a", "b")))
    expect_false(is_char_scalar(character(0)))
  }
)


# Tests for skmisc:::stri_squish ------------------------------------------

test_that("stri_squish basic behaviour works", {
  expect_equal(stri_squish("   hello   world  "), "hello world")
  expect_equal(stri_squish("foo\t\t\tbar\n\nbaz   "), "foo bar baz")
  expect_equal(stri_squish("  a   b  c "), "a b c")
})

test_that("stri_squish handles edge cases correctly", {
  expect_equal(stri_squish(""), "")
  expect_equal(stri_squish("     "), "")
  expect_equal(stri_squish(NA_character_), NA_character_)
})

test_that("stri_squish is vectorised", {
  x <- c("  a  ", "b\t\tc\n", "   ", NA, "d e ")
  expect_equal(
    stri_squish(x),
    c("a", "b c", "", NA, "d e")
  )
})


# Test for `skmisc:::wrap_braces_once` ------------------------------------

test_that("wrap_braces_once wraps unwrapped strings", {
  expect_equal(wrap_braces_once("hello"), "{hello}")
  expect_equal(wrap_braces_once("Title Case"), "{Title Case}")
})

test_that("wrap_braces_once trims whitespace before wrapping", {
  expect_equal(wrap_braces_once("  hello  "), "{hello}")
  expect_equal(wrap_braces_once("\thello\n"), "{hello}")
})

test_that("wrap_braces_once leaves already-wrapped strings unchanged", {
  expect_equal(wrap_braces_once("{hello}"), "{hello}")
  expect_equal(wrap_braces_once("{Title Case}"), "{Title Case}")
})

test_that("wrap_braces_once handles empty or odd cases gracefully", {
  expect_equal(wrap_braces_once("{}"), "{}")
  expect_equal(wrap_braces_once("{ }"), "{ }")
})

test_that("wrap_braces_once treats nested braces as already wrapped", {
  expect_equal(wrap_braces_once("{{hello}}"), "{{hello}}")
})


# Tests for skmisc:::clean_condition_message ------------------------------

test_that(
  desc = "clean_condition_message works with errors, warnings and messages",
  code = {
    err <- try(stop("  Error: something went wrong  "), silent = TRUE)
    warn <- simpleWarning("Warning:  deprecated function ")
    msg <- simpleMessage("  just a message here  ")

    expect_equal(clean_condition_message(err), "something went wrong")
    expect_equal(clean_condition_message(warn), "deprecated function")
    expect_equal(clean_condition_message(msg), "just a message here")
  }
)

test_that(
  desc = "prefixes are removed correctly (with/without colon, mixed case)",
  code = {
    e1 <- simpleError("Error: bad thing")
    e2 <- simpleError("error: another bad thing")
    e3 <- simpleError("ERROR bad thing too")

    expect_equal(clean_condition_message(e1), "bad thing")
    expect_equal(clean_condition_message(e2), "another bad thing")
    expect_equal(clean_condition_message(e3), "bad thing too")
  }
)


test_that("whitespace is properly squished and trimmed", {
  cond <- simpleError("   Error:\t\t multiple   spaces   \n\n here  ")
  expect_equal(clean_condition_message(cond), "multiple spaces here")
})


test_that("empty messages return NA", {
  empty_err <- simpleError("")
  space_err <- simpleError("   \t\n   ")
  null_err <- simpleError(character(0))

  expect_equal(clean_condition_message(empty_err), NA_character_)
  expect_equal(clean_condition_message(space_err), NA_character_)
  expect_true(is.na(clean_condition_message(null_err)))
})


test_that(
  desc = "works with tryCatch-captured errors (class 'try-error' + condition)",
  code = {
    result <- try(stop("my custom error"), silent = TRUE)
    expect_true(inherits(result, "try-error"))

    cond <- attr(result, "condition")
    expect_equal(clean_condition_message(cond), "my custom error")
  }
)


# Tests for skmisc:::drop_string_na ---------------------------------------

test_that("drop_string_na removes NA, 'NA', and empty strings", {
  x <- c("a", NA, "b", "", "NA", "c", " ", "d")

  expect_equal(
    drop_string_na(x),
    c("a", "b", "c", " ", "d")
  )
})

test_that("drop_string_na works with clean input", {
  expect_equal(drop_string_na("hello"), "hello")
  expect_equal(drop_string_na(c("x", "y", "z")), c("x", "y", "z"))
})

test_that("drop_string_na returns empty vector when all are removed", {
  expect_equal(drop_string_na(c("", "NA", NA)), character(0))
  expect_equal(drop_string_na(character(0)), character(0))
})

test_that("drop_string_na preserves spaces and other whitespace", {
  expect_equal(
    drop_string_na(c("  hi  ", "\t", "   ")),
    c("  hi  ", "\t", "   ")
  )
})
