#' Convert the title of each bibentry of a bib file to title case.
#'
#' @param bib_file_path character, path to a `.bib` file.
#'
#' @param output_bib_file character, path to a `.bib` file that will contain
#' the transformed bibentries with title-cased title.
#'
#' @return `bib_file_path` as a character string, invisibly.
#'
#' @examples
#' bib_file <- system.file("extdata", "ref.bib", package = "skmisc")
#' tmp_output_file <- tempfile(fileext = ".bib")
#' bib_title_to_title_case(bib_file_path = bib_file, output_bib_file = tmp_output_file)
#' cat(readLines(tmp_output_file), sep = "\n")
#'
#' @export
bib_title_to_title_case <- function(bib_file_path, output_bib_file) {

  if (!is.character(bib_file_path)) {
    stop("Invalid `bib_file_path` path: Non-character supplied.", call. = FALSE)
  }

  if (as.numeric(file.access(bib_file_path, mode = 4)) != 0) {
    stop("Invalid `bib_file_path` path: File is not readable.", call. = FALSE)
  }

  if (!is.character(output_bib_file)) {
    stop("Invalid `output_bib_file` path: Non-character supplied.", call. = FALSE)
  }

  bib_df <-  RefManageR::ReadBib(bib_file_path) |> as.data.frame()
  bib_df$title <- tools::toTitleCase(bib_df$title)
  bib_df$booktitle <- tools::toTitleCase(bib_df$booktitle)
  RefManageR::WriteBib(
    RefManageR::as.BibEntry(bib_df),
    file = output_bib_file
  )
  invisible(bib_file_path)
}
