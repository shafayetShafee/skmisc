#' @title Check whether an object is a valid boolean scalar
#'
#' @description
#' This function checks whether an object [is_bool_scalar()]. If the check
#' fails, a formatted error is raised using [`cli::cli_abort()`].
#'
#' @param x An R object to check.
#'
#' @return Invisibly returns `TRUE` on check pass. Throws a error of class
#'   [`rlang::rlang_error`] on check fail.
#'
#' @examples
#' check_bool_scalar(TRUE)          # passes
#' check_bool_scalar(FALSE)         # passes
#' \dontrun{
#' check_bool_scalar(NA)            # throws error
#' check_bool_scalar(c(TRUE,FALSE)) # throws error
#' check_bool_scalar("TRUE")        # throws error
#' }
#'
#' @export
check_bool_scalar <- function(x) {
  if (!is_bool_scalar(x)) {
    err_msg <- "{.var x}} must be a scaler boolean (`TRUE` or `FALSE`)"
    cli::cli_abort(c("x" = err_msg), call = NULL)
  }
  invisible(TRUE)
}


#' @title Check whether an object is a valid character scalar
#'
#' @description
#' This function checks whether an object [is_char_scalar()]. If the check
#' fails, a formatted error is raised using [`cli::cli_abort()`].
#'
#' @param x An R object to check.
#'
#' @return Invisibly returns `TRUE` on check pass. Throws a error of class
#'   [`rlang::rlang_error`] on check fail.
#'
#' @examples
#' check_char_scalar("hello")      # passes
#' check_char_scalar("  hi  ")     # passes
#' \dontrun{
#' check_char_scalar("")           # error
#' check_char_scalar("   ")        # error
#' check_char_scalar(42)           # error
#' check_char_scalar(c("a", "b"))  # error
#' check_char_scalar(NA)           # error
#' check_char_scalar(NULL)         # error
#' }
#'
#' @export
check_char_scalar <- function(x) {
  if (!is_char_scalar(x)) {
    err_msg <- "{.var x} must be a single, non-empty character string."
    cli::cli_abort(c("x" = err_msg), call = NULL)
  }
  invisible(TRUE)
}


#' @title Check whether an object is a valid numeric scalar
#'
#' @description
#' This function checks whether an object [is_numeric_scalar()]. If the check
#' fails, a formatted error is raised using [`cli::cli_abort()`].
#'
#' @param x An R object to check.
#'
#' @return Invisibly returns `TRUE` on check pass. Throws a error of class
#'   [`rlang::rlang_error`] on check fail.
#'
#' @examples
#' check_numeric_scalar(5)       # passes
#' check_numeric_scalar(0.1)     # passes
#' \dontrun{
#' check_numeric_scalar(NA)      # throws error
#' check_numeric_scalar(NULL)    # throws error
#' check_numeric_scalar(c(1,2))  # throws error
#' check_numeric_scalar("5")     # throws error
#' }
#'
#' @export
check_numeric_scalar <- function(x) {
  if (!is_numeric_scalar(x)) {
    err_msg <- paste0(
      "{.var x} must be a single, ",
      "non-missing and finite numeric value."
    )
    cli::cli_abort(c("x" = err_msg), call = NULL)
  }
  invisible(TRUE)
}


#' @title Check a numeric value against a single bound
#'
#' @description
#' This function validates that a numeric variable satisfies a specified
#' bound. It allows you to check lower or upper bounds, and to choose whether
#' the bound is inclusive or exclusive. If the value does not meet the bound,
#' a styled error is raised using [`cli::cli_abort()`].
#'
#' @param val Numeric variable to check.
#' @param bound Numeric bound to compare against.
#' @param include Logical; if `TRUE`, the bound is inclusive (>= or <=),
#'   otherwise exclusive (> or <). Default is TRUE.
#' @param is_lower Logical; if TRUE, `bound` is treated as a lower bound,
#'   otherwise as an upper bound. Default is TRUE.
#'
#' @return Invisibly returns `TRUE`. Throws an error of class
#'   [`rlang::rlang_error`] if the variable violates the bound.
#'
#' @examples
#' check_bound(0.5, 0)                # passes, lower bound inclusive
#' check_bound(0.5, 1, is_lower = FALSE) # passes, upper bound not relevant
#' \dontrun{
#' check_bound(-0.1, 0)              # throws error
#' check_bound(1.1, 1)               # throws error
#' }
#'
#' @export
check_bound <- function(val, bound, include = TRUE, is_lower = TRUE) {
  check_numeric_scalar(val)
  check_numeric_scalar(bound)
  check_bool_scalar(include)
  check_bool_scalar(is_lower)

  sym <- if (include) {
    if (is_lower) cli::symbol$geq else cli::symbol$leq
  } else {
    if (is_lower) ">" else "<"
  }

  ok <- if (include) {
    if (is_lower) val >= bound else val <= bound
  } else {
    if (is_lower) val > bound else val < bound
  }

  if (!ok) {
    cli::cli_abort(
      c("x" = "{.var x} must be {sym} {bound}."),
      call = NULL
    )
  }
  invisible(TRUE)
}


#' @title Check whether a variable is within a specified numerical bounds.
#'
#' @param x The variable to validate.
#' @param lower Numerical lower bound. Default 0.
#' @param upper Numerical upper bound. Default 1.
#' @param lower_include Logical; if `TRUE`, the lower bound is inclusive,
#'   otherwise exclusive. Default is TRUE.
#' @param upper_include Logical; if `TRUE`, the upper bound is inclusive,
#'   otherwise exclusive. Default is TRUE.
#'
#' @return Invisibly returns TRUE if all checks pass; Otherwise, throws
#'    an error of class [rlang::rlang_error].
#'
#' @examples
#' check_numeric_bound(0.5) # within [0, 1]
#' check_numeric_bound(0, lower_include = TRUE)
#' check_numeric_bound(1, upper_include = TRUE)
#'
#' # Exclusive bounds
#' check_numeric_bound(0.5, lower_include = FALSE, upper_include = FALSE)
#'
#' # Custom bounds
#' check_numeric_bound(10, lower = 5, upper = 20)
#'
#' \dontrun{
#' # Error cases:
#' check_numeric_bound(NA)
#' check_numeric_bound("a")
#' check_numeric_bound(2, upper = 1)
#' check_numeric_bound(0, lower_include = FALSE)
#' }
#'
#' @export
check_numeric_bound <- function(
  x,
  lower = 0,
  upper = 1,
  lower_include = TRUE,
  upper_include = TRUE
) {
  check_numeric_scalar(x)
  check_numeric_scalar(lower)
  check_numeric_scalar(upper)
  check_bool_scalar(lower_include)
  check_bool_scalar(upper_include)

  check_bound(x, lower, lower_include, is_lower = TRUE)
  check_bound(x, upper, upper_include, is_lower = FALSE)

  invisible(TRUE)
}
