# Test whether an object is considered invalid

This function tests whether an R object should be considered invalid. An
object is invalid if it meets any of the following conditions:

- it is [`base::missing()`](https://rdrr.io/r/base/missing.html),

- it is `NULL`,

- it has zero length,

- it inherits from class `"try-error"`,

- it inherits from class `"simpleError"`,

- it is a list whose elements are *all* invalid (checked recursively),
  or

- it is an atomic vector whose elements are *all* `NA`.

## Usage

``` r
is_invalid(x)
```

## Arguments

- x:

  An R object to check.

## Value

A logical scalar: `TRUE` if the object is invalid, `FALSE` otherwise.

## Details

Lists are validated recursively: a list is invalid only if *every*
element in that list is invalid. Atomic vectors are considered invalid
only when *all* values are `NA`.

## Examples

``` r
is_invalid(NULL)                 # TRUE
#> [1] TRUE
is_invalid(character(0))         # TRUE
#> [1] TRUE
is_invalid(c(NA, NA))            # TRUE
#> [1] TRUE
is_invalid(c(1, NA))             # FALSE
#> [1] FALSE

is_invalid(list(NA, NULL))       # TRUE
#> [1] TRUE
is_invalid(list(NA, 5))          # FALSE
#> [1] FALSE

# try-error example
err1 <- try(stop("err"), silent = TRUE)
is_invalid(err1)                 # TRUE
#> [1] TRUE

# simpleError example
err2 <- simpleError("oops")
is_invalid(err2)                 # TRUE
#> [1] TRUE

is_invalid(5)                    # FALSE
#> [1] FALSE
is_invalid("txt")                # FALSE
#> [1] FALSE
```
