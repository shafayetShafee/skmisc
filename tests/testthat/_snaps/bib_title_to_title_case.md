# Invalid Input file name (snapshot)

    Code
      bib_title_to_title_case(input_file_name, "test.bib")
    Condition
      Error in `vapply()`:
      ! values must be type 'character',
       but FUN(X[[1]]) result is type 'double'

# Non readable Input file

    Code
      bib_title_to_title_case(input_file_name, "test.bib")
    Condition
      Error in `bib_title_to_title_case()`:
      ! Invalid path: '43bib'
      x File is not readable

# Invalid Output file

    Code
      bib_title_to_title_case(input_file_name, 43)
    Condition
      Error in `vapply()`:
      ! values must be type 'character',
       but FUN(X[[1]]) result is type 'double'

