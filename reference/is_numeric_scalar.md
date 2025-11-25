# Check whether an object is a valid numeric scalar

This function tests whether the input is a valid numeric scalar: not
`NULL`, not `NA`, not non-finite, and of length one. It first checks for
invalid inputs using
[`is_invalid()`](https://shafayetshafee.github.io/skmisc/reference/is_invalid.md),
then verifies that the value is numeric, of length one, and finite.

## Usage

``` r
is_numeric_scalar(x)
```

## Arguments

- x:

  An object to test.

## Value

`TRUE` if `x` is a valid numeric scalar; otherwise `FALSE`.

## Examples

``` r
is_numeric_scalar(1)       # TRUE
#> [1] TRUE
is_numeric_scalar(3.14)    # TRUE
#> [1] TRUE
is_numeric_scalar(NA)      # FALSE
#> [1] FALSE
is_numeric_scalar(NULL)    # FALSE
#> [1] FALSE
is_numeric_scalar(c(1, 2)) # FALSE
#> [1] FALSE
is_numeric_scalar(Inf)     # FALSE
#> [1] FALSE
```
