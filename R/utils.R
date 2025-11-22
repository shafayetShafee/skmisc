#' Check if x is a single, non-NA character
#'
#' @param x any object
#' @return TRUE if x is a single, non-NA character, FALSE otherwise
#' @keywords internal
is_char_scalar <- function(x) {
  (!is.null(x)) && is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
}

#' Trim unnecessary white-spaces from a string.
#'
#' @param x string
#' @return trimmed string
#'
#' @keywords internal
stri_squish <- function(x) {
  stringi::stri_trim_both(stringi::stri_replace_all_regex(x, "\\s+", " "))
}


#' Wrap a string in braces if not already wrapped
#'
#' This internal helper ensures that a string is enclosed in a single pair
#' of curly braces `{}`. If the input string already starts and ends with
#' braces, it is returned unchanged. Leading and trailing whitespace is
#' trimmed before the check.
#'
#' @param title A character scalar representing a string to wrap.
#'
#' @return A character scalar wrapped in braces, or unchanged if already wrapped.
#'
#' @keywords internal
wrap_braces_once <- function(title) {
  title <- trimws(title)
  if (grepl("^\\{.*\\}$", title)) {
    return(title)
  } else {
    return(paste0("{", title, "}"))
  }
}

