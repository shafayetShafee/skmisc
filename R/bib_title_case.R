#' Convert the title, booktitle, journal name of each bibentry of a bib file to title case.
#'
#' @param bib_file_path character, path to a `.bib` file.
#'
#' @param output_bib_file character, path to a `.bib` file that will contain
#' the transformed bib-entries with title-cased title.
#'
#' @param components Character vector specifying which BibTeX fields should be
#'   converted to title case. Valid values include `"title"`, `"booktitle"`,
#'   and `"journal"`. The special value `"all"` (the default) applies the
#'   transformation to all supported fields.
#'
#'   Only the fields listed in `components` *and* present in the input `.bib`
#'   file will be modified. Fields not included in `components` are left
#'   unchanged.
#'
#'   Examples:
#'   - `components = "all"` (default): modify `"title"`, `"booktitle"`, `"journal"`
#'   - `components = "title"`: modify only article titles
#'   - `components = c("title", "journal")`: modify both title and journal fields
#'
#' @param overwrite Logical. Should an existing output file be overwritten?
#'   Defaults to `FALSE`. If `FALSE` and the file already exists, the function
#'   will abort with an informative message. If `TRUE`, the existing file will
#'   be replaced.
#'
#' @return `output_bib_file` as a character string, invisibly.
#'
#' @examples
#' # Example .bib file included with the package
#' bib_file <- system.file("extdata", "ref.bib", package = "skmisc")
#'
#' # Temporary output file
#' tmp_output_file <- tempfile(fileext = ".bib")
#'
#' # Convert all supported components (default)
#' bib_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_output_file
#' )
#' cat(readLines(tmp_output_file), sep = "\n")
#'
#' # Convert only the title field
#' tmp_title_only <- tempfile(fileext = ".bib")
#' bib_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_title_only,
#'   components = "title"
#' )
#'
#' # Convert title and journal fields only
#' tmp_title_journal <- tempfile(fileext = ".bib")
#' bib_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_title_journal,
#'   components = c("title", "journal")
#' )
#'
#' @export
bib_title_case <- function(bib_file_path, output_bib_file, components="all", overwrite=FALSE) {
  if (!is_char_scalar(bib_file_path)) {
    cli::cli_abort(c(
      "!" = "Invalid input for `bib_file_path`.",
      "x" = "It must be a non-NA character scalar."
    ))
  }

  if (!fs::file_exists(bib_file_path) || !fs::file_access(bib_file_path, "read")) {
    cli::cli_abort(c(
      "!" = "Invalid path: {.path {bib_file_path}}",
      "x" = "File does not exist or is not readable."
    ))
  }

  if (!fs::is_file(bib_file_path)) {
    cli::cli_abort(c(
      "!" = "Invalid input path: {.path {bib_file_path}}",
      "x" = "The path exists but is not a file."
    ))
  }

  if (fs::path_ext(bib_file_path) != "bib") {
    cli::cli_abort(c(
      "!" = "Invalid file type: {.path {bib_file_path}}",
      "x" = "Input file must have extension '.bib'."
    ))
  }

  if (!is_char_scalar(output_bib_file)) {
    cli::cli_abort(c(
      "!" = "Invalid `output_bib_file` argument.",
      "x" = "It must be a single, non-NA character string."
    ))
  }

  output_dir <- fs::path_dir(output_bib_file)

  if (!fs::dir_exists(output_dir)) {
    cli::cli_abort(c(
      "x" = "Output directory does not exist: {.path {output_dir}}",
      "i" = "Provide an existing directory or create it first."
    ))
  }

  if (!fs::file_access(output_dir, "write")) {
    cli::cli_abort(c(
      "!" = "Cannot write to output directory: {.path {output_dir}}",
      "x" = "Write permission denied."
    ))
  }

  if (fs::path_ext(output_bib_file) != "bib") {
    cli::cli_abort(c(
      "!" = "Invalid output file: {.path {output_bib_file}}",
      "x" = "Output file must have extension '{.emph .bib}'."
    ))
  }

  if (fs::file_exists(output_bib_file) && !overwrite) {
    cli::cli_abort(c(
      "x" = "Output file already exists: {.path {output_bib_file}}",
      "i" = "Set {.code overwrite = TRUE} to replace it"
    ))
  }

  valid_components <- c("title", "booktitle", "journal")

  if (identical(components, "all")) {
    components <- valid_components
  } else {
    if (!is.character(components) || anyNA(components)) {
      cli::cli_abort(c(
        "!" = "Invalid `components` argument.",
        "x" = "`components` must be '{.emph all}' or a character vector containing any combination of {.var valid_components}"
      ))
    }

    unknown <- setdiff(components, valid_components)
    if (length(unknown) > 0) {
      cli::cli_abort(c(
        "!" = "Unknown components supplied.",
        "x" = "Invalid field{?s}: {unknown}",
        "i" = "Valid components are: {.val {c('all', valid_components)}}."
      ))
    }
  }

  bib_df <- safe_read_bib(bib_file_path = bib_file_path)

  for (comp in components) {
    if (comp %in% names(bib_df)) {
      bib_df[[comp]] <- safe_title_case(bib_df[[comp]], component = comp)
    }
  }

  safe_write_bib(
    bib_df = bib_df,
    output_bib_file = output_bib_file
  )

  invisible(output_bib_file)
}


#' Safely convert titles to title case, preserving protected braces
#'
#' @param titles character vector of BibTeX titles
#' @param component Either of 'title', 'booktitle' or 'journal'
#' @return character vector of titles, wrapped in single braces, with protected content intact
#' @keywords internal
#' @noRd
safe_title_case <- function(titles, component=NULL) {
  vapply(titles, function(title) {
    title <- trimws(title)

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

    title_case <- sub(
      pattern = "^\\b([[:alpha:]])",
      replacement = "\\U\\1",
      x = tools::toTitleCase(placeholder_title),
      perl = TRUE
    )

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


#' @title Safely read a BibTeX file with formatted diagnostics
#'
#' @description
#' This internal helper wraps [RefManageR::ReadBib()] with structured
#' condition handling to provide robust error, warning, and message reporting
#' using the {cli} package.
#'
#' @details
#' The function attempts to read and parse a BibTeX file into a data frame.
#' On success, the parsed entries are returned. If parsing results in ignored or
#' empty entries, or if any fatal error occurs, a formatted diagnostic is emitted
#' and the function aborts. Warnings and messages from RefManageR are displayed
#' with {cli} formatting but do not stop execution.
#'
#' @param bib_file_path Path to a BibTeX (.bib) file to be read.
#'
#' @return
#' A data frame of parsed BibTeX fields on success.
#' The function aborts with a formatted error message on failure.
#'
#' @keywords internal
#' @noRd
safe_read_bib <- function(bib_file_path) {
  withCallingHandlers({
    tryCatch({
      bib_entries <- RefManageR::ReadBib(file = bib_file_path)
      bib_fields <- RefManageR::fields(bib_entries)

      if(length(bib_fields) > 0) {
        bib_df <- as.data.frame(bib_entries)
        return(bib_df)
      } else {
        stop(
          "All of the bib entries are ignored while parsing the file due to some reason",
          call. = FALSE
        )
      }
    },
    error = function(e) {
      err_msg <- clean_condition_message(e)
      cli::cli_abort(drop_string_NA(c(
        "x" = cli::col_red("Occurred when reading the BibTeX file: {.file {bib_file_path}}"),
        "!" = glue::glue("{err_msg}")
      )), call = NULL)
    })

  },
  warning = function(w) {
    warn_msg <- clean_condition_message(w)
    cli::cli_warn(drop_string_NA(c(
      "!" = cli::col_yellow("Occured when reading the BibTeX file: {.file {bib_file_path}}"),
      "i" = glue::glue("{warn_msg}")
    )))
    invokeRestart("muffleWarning")
  },
  message = function(m) {
    msg <- clean_condition_message(m)
    cli::cli_inform(na.omit(c("*" = cli::col_blue("{msg}"))))
    invokeRestart("muffleMessage")
  }
 )
}


#' Safely write a BibTeX file with formatted diagnostics
#'
#' This internal helper wraps \code{textRefManageR::WriteBib()} in a
#' \code{tryCatch()} block to provide robust handling of errors, warnings,
#' and messages using the \pkg{cli} package for formatted output.
#'
#' On success, the function writes the BibTeX file and returns \code{TRUE}.
#' If an error occurs, a formatted diagnostic is emitted and \code{FALSE} is
#' returned. Warnings and messages are displayed but do not affect the
#' return value.
#'
#' @param bib_df A data frame of BibTeX fields suitable for conversion via
#'   \code{RefManageR::as.BibEntry()}.
#' @param output_bib_file A file path where the BibTeX file will be written.
#'
#' @return Logical scalar: \code{TRUE} on success, \code{FALSE} on error.
#'
#' @keywords internal
#' @noRd
safe_write_bib <- function(bib_df, output_bib_file) {
  withCallingHandlers({
    tryCatch({
      RefManageR::WriteBib(
        RefManageR::as.BibEntry(bib_df),
        file = output_bib_file,
        verbose = FALSE
      )
    },
    error = function(e) {
      err_msg <- clean_condition_message(e)
      cli::cli_abort(drop_string_NA(c(
        "x" = cli::col_red("Occurred when writing the BibTeX file: {.file {output_bib_file}}"),
        "!" = glue::glue("{err_msg}")
      )), call = NULL)
    }
   )
  },
  warning = function(w) {
    warn_msg <- clean_condition_message(w)
    cli::cli_warn(drop_string_NA(c(
      "!" = cli::col_yellow("Warning while writing the BibTeX file: {.file {output_bib_file}}"),
      "!" = glue::glue("{warn_msg}")
    )))
    invokeRestart("muffleWarning")
  },
  message = function(m) {
    msg <- clean_condition_message(m)
    cli::cli_inform(na.omit(c("*" = cli::col_blue("{msg}"))))
    invokeRestart("muffleMessage")
  }
 )
}
