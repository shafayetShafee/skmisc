#' @title Convert the title, booktitle, journal name of each bibentry of a bib file to title case.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `bib_title_to_title_case()` has been deprecated in **v0.3.0** and will be
#' removed in a future release.
#' Please use [bib_title_case()] instead.
#'
#' This function remains as a compatibility wrapper and simply forwards all
#' arguments to `bib_title_case()`.
#'
#' @details
#' This function takes any arguments (`...`) and passes them directly to
#' [bib_title_case()]. See that function's documentation for full argument
#' details.
#'
#' @return
#' The return value of [bib_title_case()].
#'
#' @seealso [bib_title_case()]
#'
#' @keywords internal
#' @export
bib_title_to_title_case <- function(...) {
  lifecycle::deprecate_warn(
    when = "0.3.0",
    what = "bib_title_to_title_case()",
    with = "bib_title_case()"
  )
  bib_title_case(...)
}
