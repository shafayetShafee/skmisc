#' @title Test whether an object is considered invalid
#'
#' @description
#' This function tests whether an R object should be considered invalid. An
#' object is invalid if it meets any of the following conditions:
#'
#' - it is [base::missing()],
#' - it is `NULL`,
#' - it has zero length,
#' - it inherits from class `"try-error"`,
#' - it inherits from class `"simpleError"`,
#' - it is a list whose elements are *all* invalid (checked recursively), or
#' - it is an atomic vector whose elements are *all* `NA`.
#'
#' @details
#' Lists are validated recursively: a list is invalid only if *every* element
#' in that list is invalid. Atomic vectors are considered invalid only when
#' *all* values are `NA`.
#'
#' @param x An R object to check.
#'
#' @return A logical scalar: `TRUE` if the object is invalid, `FALSE` otherwise.
#'
#' @examples
#' is_invalid(NULL)                 # TRUE
#' is_invalid(character(0))         # TRUE
#' is_invalid(c(NA, NA))            # TRUE
#' is_invalid(c(1, NA))             # FALSE
#'
#' is_invalid(list(NA, NULL))       # TRUE
#' is_invalid(list(NA, 5))          # FALSE
#'
#' # try-error example
#' err1 <- try(stop("err"), silent = TRUE)
#' is_invalid(err1)                 # TRUE
#'
#' # simpleError example
#' err2 <- simpleError("oops")
#' is_invalid(err2)                 # TRUE
#'
#' is_invalid(5)                    # FALSE
#' is_invalid("txt")                # FALSE
#'
#' @export
is_invalid <- function(x) {
  if (
    missing(x) ||
      is.null(x) ||
      length(x) == 0 ||
      inherits(x, "try-error") ||
      inherits(x, "simpleError")
  ) {
    return(TRUE)
  }

  if (is.list(x)) {
    return(all(vapply(x, is_invalid, logical(1))))
  }

  if (is.atomic(x)) {
    return(all(is.na(x)))
  }

  FALSE
}


#' @title Test whether an object is strictly a boolean scalar
#'
#' @description
#' This function checks whether `x` is *exactly* `TRUE` or *exactly* `FALSE`.
#' It uses [`base::identical()`] to ensure strict checking of type, length, and
#' value. Values that are missing, invalid (per [is_invalid()]), or not a
#' single logical scalar always return `FALSE`.
#'
#' @param x An R object to check.
#'
#' @return A logical scalar: `TRUE` if `x` is exactly `TRUE` or `FALSE`,
#'   otherwise `FALSE`.
#'
#' @examples
#' is_bool_scalar(TRUE)                 # TRUE
#' is_bool_scalar(FALSE)                # TRUE
#' is_bool_scalar(NA)                   # FALSE
#' is_bool_scalar(c(TRUE, FALSE))       # FALSE
#' is_bool_scalar("TRUE")               # FALSE
#' is_bool_scalar(1L)                   # FALSE
#'
#' @export
is_bool_scalar <- function(x) {
  if (is_invalid(x)) {
    return(FALSE)
  }

  identical(x, TRUE) || identical(x, FALSE)
}


#' @title Test whether an object is a single, non-empty character string
#'
#' @description
#' This function checks whether an object is a scalar character string that is
#' not `NULL`, not `NA`, and not empty after trimming whitespace. The function
#' relies on [is_invalid()] to detect unusable inputs such as `NULL`,
#' zero-length vectors, and error objects.
#'
#' @param x Any R object to validate.
#'
#' @return `TRUE` if `x` is a single, non-missing, non-empty character
#'   string after trimming; otherwise `FALSE`.
#'
#' @examples
#' is_char_scalar("hello")     # TRUE
#' is_char_scalar("  hi  ")    # TRUE
#' is_char_scalar("   ")       # FALSE
#' is_char_scalar("")          # FALSE
#' is_char_scalar(1)           # FALSE
#' is_char_scalar(NA)          # FALSE
#' is_char_scalar(NULL)        # FALSE
#'
#' @export
is_char_scalar <- function(x) {
  if (is_invalid(x)) {
    return(FALSE)
  }

  is.character(x) &&
    length(x) == 1L &&
    !is.na(x) &&
    nzchar(trimws(x))
}


#' Check whether an object is a valid numeric scalar
#'
#' This function tests whether the input is a valid numeric scalar: not
#' `NULL`, not `NA`, not non-finite, and of length one. It first checks for
#' invalid inputs using [is_invalid()], then verifies that the value is
#' numeric, of length one, and finite.
#'
#' @param x An object to test.
#'
#' @return `TRUE` if `x` is a valid numeric scalar; otherwise `FALSE`.
#'
#' @examples
#' is_numeric_scalar(1)       # TRUE
#' is_numeric_scalar(3.14)    # TRUE
#' is_numeric_scalar(NA)      # FALSE
#' is_numeric_scalar(NULL)    # FALSE
#' is_numeric_scalar(c(1, 2)) # FALSE
#' is_numeric_scalar(Inf)     # FALSE
#'
#' @export
is_numeric_scalar <- function(x) {
  if (is_invalid(x)) {
    return(FALSE)
  }

  is.numeric(x) &&
    length(x) == 1 &&
    is.finite(x)
}
