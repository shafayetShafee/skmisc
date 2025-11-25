# Test whether an object is strictly a boolean scalar

This function checks whether `x` is *exactly* `TRUE` or *exactly*
`FALSE`. It uses
[`base::identical()`](https://rdrr.io/r/base/identical.html) to ensure
strict checking of type, length, and value. Values that are missing,
invalid (per
[`is_invalid()`](https://shafayetshafee.github.io/skmisc/reference/is_invalid.md)),
or not a single logical scalar always return `FALSE`.

## Usage

``` r
is_bool_scalar(x)
```

## Arguments

- x:

  An R object to check.

## Value

A logical scalar: `TRUE` if `x` is exactly `TRUE` or `FALSE`, otherwise
`FALSE`.

## Examples

``` r
is_bool_scalar(TRUE)                 # TRUE
#> [1] TRUE
is_bool_scalar(FALSE)                # TRUE
#> [1] TRUE
is_bool_scalar(NA)                   # FALSE
#> [1] FALSE
is_bool_scalar(c(TRUE, FALSE))       # FALSE
#> [1] FALSE
is_bool_scalar("TRUE")               # FALSE
#> [1] FALSE
is_bool_scalar(1L)                   # FALSE
#> [1] FALSE
```
