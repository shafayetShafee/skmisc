#' @title Test whether an object is strictly a boolean value
#'
#' @description
#' This function tests whether an object is exactly `TRUE` or exactly `FALSE`.
#' It uses [`base::identical()`] to ensure strict checking of type, length, and
#' value, returning `TRUE` only for a single, non-missing logical scalar.
#'
#' @param x An R object to check.
#'
#' @return A logical scalar: TRUE if `x` is exactly `TRUE` or `FALSE` otherwise.
#'
#' @examples
#' is_bool(TRUE)                 # TRUE
#' is_bool(FALSE)                # TRUE
#' is_bool(NA)                   # FALSE
#' is_bool(c(TRUE, FALSE))       # FALSE
#' is_bool("TRUE")               # FALSE
#' is_bool(1L)                   # FALSE
#'
#' @export
is_bool <- function(x) {
  identical(x, TRUE) || identical(x, FALSE)
}



#' @title Test whether an object is considered invalid
#'
#' @description
#' This function tests whether a R object is considered invalid. An object is
#' invalid if it is either of the followings,
#' - [base::missing],
#' - `NULL`,
#' - has zero length,
#' - an object with class `try-error`,
#' - an object with class `simpleError`,
#' - a list whose elements are all invalid (see details) or
#' - an atomic vector whose elements are all `NA`.
#'
#' @details
#' Lists are checked recursively: a list is invalid only when all of its
#' elements are invalid.
#'
#' @param x An R object to check.
#'
#' @return A logical scalar: TRUE if the object is invalid, FALSE otherwise.
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
#' err1 <- try(
#'   stop("err"), silent = TRUE
#' )
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
