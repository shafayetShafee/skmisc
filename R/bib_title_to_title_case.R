#' Convert the title of each bibentry of a bib file to title case.
#'
#' @param bib_file_path character, path to a `.bib` file.
#'
#' @param output_bib_file character, path to a `.bib` file that will contain
#' the transformed bibentries with title-cased title.
#'
#' @param overwrite Logical. Should an existing output file be overwritten?
#'   Defaults to `FALSE`. If `FALSE` and the file already exists, the function
#'   will abort with an informative message. If `TRUE`, the existing file will
#'   be replaced.
#'
#' @return `output_bib_file` as a character string, invisibly.
#'
#' @examples
#' bib_file <- system.file("extdata", "ref.bib", package = "skmisc")
#' tmp_output_file <- tempfile(fileext = ".bib")
#' bib_title_to_title_case(bib_file_path = bib_file, output_bib_file = tmp_output_file)
#' cat(readLines(tmp_output_file), sep = "\n")
#'
#' @export
bib_title_to_title_case <- function(bib_file_path, output_bib_file, overwrite=FALSE) {
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

  bib_df <- RefManageR::ReadBib(bib_file_path) |> as.data.frame()

  if ("title" %in% names(bib_df)) {
    bib_df$title <- safe_title_case(bib_df$title, component = 'title')
  }

  if ("booktitle" %in% names(bib_df)) {
    bib_df$booktitle <- safe_title_case(bib_df$booktitle, component = 'booktitle')
  }

  if ("journal" %in% names(bib_df)) {
    bib_df$journal <- safe_title_case(bib_df$journal, component = 'journal')
  }

  RefManageR::WriteBib(
    RefManageR::as.BibEntry(bib_df),
    file = output_bib_file,
    verbose = FALSE
  )

  invisible(output_bib_file)
}
