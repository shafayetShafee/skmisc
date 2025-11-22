# safe_title_case handles empty strings

    Code
      safe_title_case("", "title")
    Message
      ! Invalid title string: "" in the bib file
      ! Expected a single, non-NA character string; using empty string instead
    Output
      [1] "{}"

# safe_title_case warns and substitutes empty string for invalid input

    Code
      safe_title_case(1, "title")
    Output
      [1] "{1}"

