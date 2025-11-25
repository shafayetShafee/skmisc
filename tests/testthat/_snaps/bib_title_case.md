# Invalid Input file name (snapshot)

    Code
      bib_title_case(input_file_name, "test.bib")
    Condition
      Error in `bib_title_case()`:
      x Invalid input for `bib_file_path`.
      i It must be a non-NA character string

# Non readable Input file

    Code
      bib_title_case(input_file_name, "test.bib")
    Condition
      Error in `bib_title_case()`:
      x Invalid path: '43bib'
      i File does not exist or is not readable.

# Invalid Output file

    Code
      bib_title_case(input_file_name, 43)
    Condition
      Error in `bib_title_case()`:
      x Invalid `output_bib_file` argument.
      i It must be a single, non-NA character string.

