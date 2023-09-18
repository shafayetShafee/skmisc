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
#'
#' @export
bib_title_to_title_case <- function(bib_file_path, output_bib_file) {

  if (!is.character(bib_file_path)) {
    stop("Invalid file path: Non-character supplied.", call. = FALSE)
  }

  if (as.numeric(file.access(bib_file_path, mode = 4)) != 0) {
    stop("Invalid file path: File is not readable.", call. = FALSE)
  }

  if (as.numeric(file.access(output_bib_file, mode = 2)) != 0) {
    stop("Invalid file path: File is not writable", call. = FALSE)
  }

  bib_df <-  RefManageR::ReadBib(bib_file_path) |> as.data.frame()
  bib_df$title <- tools::toTitleCase(bib_df$title)
  bib_df$booktitle <- tools::toTitleCase(bib_df$booktitle)
  RefManageR::WriteBib(
    RefManageR::as.BibEntry(bib_df),
    file = bib_file_path
  )
  invisible(bib_file_path)
}
