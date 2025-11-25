# Check a numeric value against a single bound

This function validates that a numeric variable satisfies a specified
bound. It allows you to check lower or upper bounds, and to choose
whether the bound is inclusive or exclusive. If the value does not meet
the bound, a styled error is raised using
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).

## Usage

``` r
check_bound(val, bound, include = TRUE, is_lower = TRUE)
```

## Arguments

- val:

  Numeric variable to check.

- bound:

  Numeric bound to compare against.

- include:

  Logical; if `TRUE`, the bound is inclusive (\>= or \<=), otherwise
  exclusive (\> or \<). Default is TRUE.

- is_lower:

  Logical; if TRUE, `bound` is treated as a lower bound, otherwise as an
  upper bound. Default is TRUE.

## Value

Invisibly returns `TRUE`. Throws an error of class
[`rlang::rlang_error`](https://rlang.r-lib.org/reference/rlang_error.html)
if the variable violates the bound.

## Examples

``` r
check_bound(0.5, 0)                # passes, lower bound inclusive
check_bound(0.5, 1, is_lower = FALSE) # passes, upper bound not relevant
if (FALSE) { # \dontrun{
check_bound(-0.1, 0)              # throws error
check_bound(1.1, 1)               # throws error
} # }
```
