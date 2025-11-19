# Invalid Input file name (snapshot)

    Code
      bib_title_to_title_case(input_file_name, "test.bib")
    Condition
      Error in `bib_title_to_title_case()`:
      ! Invalid input for `bib_file_path`.
      x It must be a non-NA character scalar.

# Non readable Input file

    Code
      bib_title_to_title_case(input_file_name, "test.bib")
    Condition
      Error in `bib_title_to_title_case()`:
      ! Invalid path: '43bib'
      x File does not exist or is not readable.

# Invalid Output file

    Code
      bib_title_to_title_case(input_file_name, 43)
    Condition
      Error in `bib_title_to_title_case()`:
      ! Invalid `output_bib_file` argument.
      x It must be a single, non-NA character string.

