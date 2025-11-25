# Test whether an object is a single, non-empty character string

This function checks whether an object is a scalar character string that
is not `NULL`, not `NA`, and not empty after trimming whitespace. The
function relies on
[`is_invalid()`](https://shafayetshafee.github.io/skmisc/reference/is_invalid.md)
to detect unusable inputs such as `NULL`, zero-length vectors, and error
objects.

## Usage

``` r
is_char_scalar(x)
```

## Arguments

- x:

  Any R object to validate.

## Value

`TRUE` if `x` is a single, non-missing, non-empty character string after
trimming; otherwise `FALSE`.

## Examples

``` r
is_char_scalar("hello")     # TRUE
#> [1] TRUE
is_char_scalar("  hi  ")    # TRUE
#> [1] TRUE
is_char_scalar("   ")       # FALSE
#> [1] FALSE
is_char_scalar("")          # FALSE
#> [1] FALSE
is_char_scalar(1)           # FALSE
#> [1] FALSE
is_char_scalar(NA)          # FALSE
#> [1] FALSE
is_char_scalar(NULL)        # FALSE
#> [1] FALSE
```
