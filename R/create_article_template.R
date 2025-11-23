#' Create a structured article template directory for a specified journal
#'
#' Generates a ready-to-use article template for a journal supported by the
#' **`rticles`** package. The function creates the draft with
#' [rmarkdown::draft()], sets up a clean directory structure (a separate
#' `sections/` folder and an `abstract.Rmd` file), moves the abstract texts out
#' of the YAML front-matter, inserts child-document chunks for five default
#' sections, and formats the `<journal_name>_article.Rmd` file with
#' section chunks and an abstract.
#'
#' @param journal_name Character string giving the name of the journal.
#'   Must be one of the journals returned by [rticles::journals()].
#'
#' @return Invisibly returns the path to the created directory. The function is
#'   called primarily for its side effect of creating files on disk.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_article_template("arxiv")
#' create_article_template("peerj")
#' }
create_article_template <- function(journal_name) {
  supported_journals <- rticles::journals()

  if (!journal_name %in% supported_journals) {
    # nolint start: object_usage_linter
    supported_journals_formatted <- cli::cli_vec(
      x = supported_journals,
      style = list(
        "vec-sep" = ", ",
        "vec-last" = " and ",
        "vec-trunc" = length(supported_journals)
      )
    )

    err_msg <- "The jounal name '{.strong {journal_name}}' is not supported."

    inf_msg_journal_list <- paste0(
      "Please use one of the following journal names: ",
      "{.val {supported_journals_formatted}}"
    )

    rticles_url <- "https://pkgs.rstudio.com/rticles/reference/journals.html"
    inf_msg_details <- "For details, see {.url {rticles_url}}"
    # nolint end

    cli::cli_abort(
      c(
        "x" = err_msg,
        "i" = inf_msg_journal_list,
        "i" = inf_msg_details
      ),
      wrap = TRUE
    )
  }

  draft_dir <- fs::path(paste0(journal_name, "_article"))
  rmarkdown::draft(
    file = draft_dir,
    template = journal_name,
    package = "rticles",
    create_dir = TRUE,
    edit = FALSE
  )

  article_rmd_filename <- paste0(journal_name, "_article.Rmd")
  article_file <- fs::path(draft_dir, article_rmd_filename)
  example_file <- fs::path(draft_dir, "Example.Rmd")

  fs::file_create(example_file)
  fs::file_copy(article_file, example_file, overwrite = TRUE)

  sections_dir <- fs::path(draft_dir, "sections")
  fs::dir_create(sections_dir)

  section_files <- paste0("section0", 1:5, ".Rmd")
  section_paths <- fs::path(sections_dir, section_files)
  fs::file_create(section_paths)

  abstract_file <- fs::path(draft_dir, "abstract.Rmd")
  fs::file_create(abstract_file)

  yaml_content <- rmarkdown::yaml_front_matter(article_file)

  if (!is.null(yaml_content$abstract) && nzchar(yaml_content$abstract)) {
    writeLines(yaml_content$abstract, abstract_file)
  } else {
    lorem_ipsum_text <- stringi::stri_rand_lipsum(n_paragraphs = 1)
    writeLines(lorem_ipsum_text, abstract_file)
  }

  yaml_content$abstract <- paste0(
    '`r paste(readLines("abstract.Rmd"), ',
    'collapse = "\\n  ")`',
    "\n"
  )

  yaml_str <- paste0("---\n", yaml::as.yaml(yaml_content), "---")

  child_chunks <- c(
    '```{r section01, child="sections/section01.Rmd"}\n```',
    "",
    '```{r section02, child="sections/section02.Rmd"}\n```',
    "",
    '```{r section03, child="sections/section03.Rmd"}\n```',
    "",
    '```{r section04, child="sections/section04.Rmd"}\n```',
    "",
    '```{r section05, child="sections/section05.Rmd"}\n```'
  )

  new_article_content <- c(yaml_str, "", child_chunks)
  writeLines(new_article_content, article_file)

  success_msg <- paste0(
    "Article template for '{.strong {journal_name}}' created successfully ",
    "in the directory {.path {fs::path_abs(draft_dir)}}"
  )

  cli::cli_inform(c(
    "v" = success_msg,
    "i" = "Directory structure: "
  ))

  fs::dir_tree(path = draft_dir, recurse = TRUE)
  invisible(draft_dir)
}
