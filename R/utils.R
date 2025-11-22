#' Check if x is a single, non-NA character
#'
#' @param x any object
#' @return TRUE if x is a single, non-NA character, FALSE otherwise
#' @keywords internal
#' @noRd
is_char_scalar <- function(x) {
  (!is.null(x)) && is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
}


#' Trim unnecessary white-spaces from a string.
#'
#' @param x string
#' @return trimmed string
#'
#' @keywords internal
#' @noRd
stri_squish <- function(x) {
  stringi::stri_trim_both(
    stringi::stri_replace_all_regex(x, "\\s+", " ")
  )
}


#' Clean and normalize condition messages
#'
#' This internal helper function takes a condition object (error, warning, or message)
#' and extracts a clean, human-readable message. Leading "Error:" or "Warning:"
#' prefixes are removed and extra whitespace is squished.
#'
#' @param cond A condition object, typically provided by \code{tryCatch} or
#'   \code{withCallingHandlers}.
#'
#' @return A character string with the cleaned message. Returns \code{NA_character_}
#'   if the original message is empty.
#'
#' @keywords internal
#' @noRd
clean_condition_message <- function(cond) {
  cond_msg <- conditionMessage(cond)
  if (nzchar(cond_msg)) {
    tag_removed_text <- sub(
      pattern = "^\\s*(Error|Warning):?\\s*",
      replacement = "",
      x = cond_msg
    )
    clean_msg <- stri_squish(tag_removed_text)
    return(clean_msg)
  } else {
    return(NA_character_)
  }
}


#' Drop NA and empty string elements from a character vector
#'
#' This internal helper removes all elements of a character vector that are
#' \code{NA}, the string \code{"NA"}, or an empty string \code{""}.
#'
#' @param x A character vector.
#'
#' @return A character vector with all \code{NA}, \code{"NA"}, and empty strings removed.
#'
#' @keywords internal
#' @noRd
drop_string_NA <- function(x) {
  x[!is.na(x) & x != "NA" & x != ""]
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
#' @noRd
wrap_braces_once <- function(title) {
  title <- trimws(title)
  if (grepl("^\\{.*\\}$", title)) {
    return(title)
  } else {
    return(paste0("{", title, "}"))
  }
}

