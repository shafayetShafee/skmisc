# Check whether a variable is within a specified numerical bounds.

Check whether a variable is within a specified numerical bounds.

## Usage

``` r
check_numeric_bound(
  x,
  lower = 0,
  upper = 1,
  lower_include = TRUE,
  upper_include = TRUE
)
```

## Arguments

- x:

  The variable to validate.

- lower:

  Numerical lower bound. Default 0.

- upper:

  Numerical upper bound. Default 1.

- lower_include:

  Logical; if `TRUE`, the lower bound is inclusive, otherwise exclusive.
  Default is TRUE.

- upper_include:

  Logical; if `TRUE`, the upper bound is inclusive, otherwise exclusive.
  Default is TRUE.

## Value

Invisibly returns TRUE if all checks pass; Otherwise, throws an error of
class
[rlang::rlang_error](https://rlang.r-lib.org/reference/rlang_error.html).

## Examples

``` r
check_numeric_bound(0.5) # within [0, 1]
check_numeric_bound(0, lower_include = TRUE)
check_numeric_bound(1, upper_include = TRUE)

# Exclusive bounds
check_numeric_bound(0.5, lower_include = FALSE, upper_include = FALSE)

# Custom bounds
check_numeric_bound(10, lower = 5, upper = 20)

if (FALSE) { # \dontrun{
# Error cases:
check_numeric_bound(NA)
check_numeric_bound("a")
check_numeric_bound(2, upper = 1)
check_numeric_bound(0, lower_include = FALSE)
} # }
```
