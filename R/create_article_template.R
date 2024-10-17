#' Create a Structured Article Template for a Specified Journal
#'
#' This function generates an article template for the specified journal using the
#' \code{rmarkdown::draft} function from the \code{rticles} package. It checks whether
#' the journal is supported, creates the necessary directories and files, and formats
#' the \code{Article.Rmd} file by adding section chunks and an abstract.
#'
#' @param journal_name A character string specifying the journal for which the article
#' template will be created. It must be one of the supported journals listed by
#' \code{rticles::journals()}.
#'
#' @return This function does not return a value. It creates a directory structure for
#' the article template, including the necessary \code{Rmd} files for sections and the abstract.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' create_article_template("arxiv")
#' }
create_article_template <- function(journal_name) {

  supported_journals <- rticles::journals()

  if (!journal_name %in% supported_journals) {
    stop(paste(
      "The journal name '", journal_name,
      "' is not supported.\nPlease use one of the following journal names:\n",
      paste(supported_journals, collapse = ", ")
    ), call. = FALSE)
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

    lorem_ipsum_text <- paste0(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
      "Aenean ut elit odio. Donec fermentum tellus neque, vitae ",
      "fringilla orci pretium vitae. Fusce maximus finibus facilisis. ",
      "Donec ut ullamcorper turpis. Donec ut porta ipsum. Nullam ",
      "cursus mauris a sapien ornare pulvinar. Aenean malesuada ",
      "molestie erat quis mattis. Praesent scelerisque posuere ",
      "faucibus. Praesent nunc nulla, ullamcorper ut ullamcorper ",
      "sed, molestie ut est. Donec consequat libero nisi, non ",
      "semper velit vulputate et. Quisque eleifend tincidunt ligula, ",
      "bibendum finibus massa cursus eget. Curabitur aliquet ",
      "vehicula quam non pulvinar. Aliquam facilisis tortor nec purus ",
      "finibus, sit amet elementum eros sodales. Ut porta porttitor ",
      "vestibulum. Integer molestie, leo ut maximus aliquam, velit ",
      "dui iaculis nibh, eget hendrerit purus risus sit amet dolor. Sed ",
      "sed tincidunt ex. Curabitur imperdiet egestas tellus in iaculis. ",
      "Maecenas ante neque, pretium vel nisl at, lobortis lacinia ",
      "neque. In gravida elit vel volutpat imperdiet. Sed ut nulla arcu. ",
      "Proin blandit interdum ex sit amet laoreet. Phasellus efficitur, ",
      "sem hendrerit mattis dapibus, nunc tellus ornare nisi, nec ",
      "eleifend enim nibh ac ipsum. Aenean tincidunt nisl sit amet ",
      "facilisis faucibus. Donec odio erat, bibendum eu imperdiet sed, ",
      "gravida luctus turpis."
    )
    writeLines(lorem_ipsum_text, abstract_file)
  }

  yaml_content$abstract <- "`r paste(readLines(\"abstract.Rmd\"), collapse = \"\\n  \")`\n"
  yaml_str <- paste0("---\n", yaml::as.yaml(yaml_content), "---")


  child_chunks <- c(
    '```{r section01, child="sections/section01.Rmd"}\n```', "",
    '```{r section02, child="sections/section02.Rmd"}\n```', "",
    '```{r section03, child="sections/section03.Rmd"}\n```', "",
    '```{r section04, child="sections/section04.Rmd"}\n```', "",
    '```{r section05, child="sections/section05.Rmd"}\n```'
  )

  new_article_content <- c(yaml_str, "", child_chunks)
  writeLines(new_article_content, article_file)

  message("Article structure for ", journal_name, " created successfully!")
}
