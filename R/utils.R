#' Check if x is a single, non-NA character
#'
#' @param x any object
#' @return TRUE if x is a single, non-NA character, FALSE otherwise
#' @keywords internal
is_char_scalar <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
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


#' Safely convert titles to title case, preserving protected braces
#'
#' @param titles character vector of BibTeX titles
#' @param component Either of 'title', 'booktitle' or 'journal'
#' @return character vector of titles, wrapped in single braces, with protected content intact
#' @keywords internal
safe_title_case <- function(titles, component) {
  vapply(titles, function(title) {
    if (!is_char_scalar(title)) {
      cli::cli_inform(c(
        "!" = "Invalid {component} string: {.val {title}} in the bib file",
        "!" = "Expected a single, non-NA character string; using empty string instead"
      ))
      title <- ""
    }

    protected <- stringi::stri_extract_all_regex(title, "\\{[^{}]+\\}", omit_no_match = TRUE)[[1]]

    placeholder_title <- title
    if (length(protected) > 0) {
      placeholders <- paste0("%%", seq_along(protected), "%%")

      placeholder_title <- stringi::stri_replace_all_fixed(
        placeholder_title,
        protected,
        placeholders,
        vectorize_all = FALSE
      )
    }

    title_case <- tools::toTitleCase(placeholder_title)

    if (length(protected) > 0) {
      title_case <- stringi::stri_replace_all_fixed(
        title_case,
        paste0("%%", seq_along(protected), "%%"),
        protected,
        vectorize_all = FALSE
      )
    }

    wrap_braces_once(title_case)

  }, FUN.VALUE = character(1), USE.NAMES = FALSE)
}
