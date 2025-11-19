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
#' bib_title_to_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_output_file
#' )
#' cat(readLines(tmp_output_file), sep = "\n")
#'
#' # Convert only the title field
#' tmp_title_only <- tempfile(fileext = ".bib")
#' bib_title_to_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_title_only,
#'   components = "title"
#' )
#'
#' # Convert title and journal fields only
#' tmp_title_journal <- tempfile(fileext = ".bib")
#' bib_title_to_title_case(
#'   bib_file_path = bib_file,
#'   output_bib_file = tmp_title_journal,
#'   components = c("title", "journal")
#' )
#'
#' @export
bib_title_to_title_case <- function(bib_file_path, output_bib_file, components="all", overwrite=FALSE) {
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

  bib_df <- RefManageR::ReadBib(bib_file_path) |> as.data.frame()

  for (comp in components) {
    if (comp %in% names(bib_df)) {
      bib_df[[comp]] <- safe_title_case(bib_df[[comp]], component = comp)
    }
  }

  RefManageR::WriteBib(
    RefManageR::as.BibEntry(bib_df),
    file = output_bib_file,
    verbose = FALSE
  )

  invisible(output_bib_file)
}
