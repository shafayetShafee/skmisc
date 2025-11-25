# Check whether an object is a valid numeric scalar

This function checks whether an object
[`is_numeric_scalar()`](https://shafayetshafee.github.io/skmisc/reference/is_numeric_scalar.md).
If the check fails, a formatted error is raised using
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).

## Usage

``` r
check_numeric_scalar(x)
```

## Arguments

- x:

  An R object to check.

## Value

Invisibly returns `TRUE` on check pass. Throws a error of class
[`rlang::rlang_error`](https://rlang.r-lib.org/reference/rlang_error.html)
on check fail.

## Examples

``` r
check_numeric_scalar(5)       # passes
check_numeric_scalar(0.1)     # passes
if (FALSE) { # \dontrun{
check_numeric_scalar(NA)      # throws error
check_numeric_scalar(NULL)    # throws error
check_numeric_scalar(c(1,2))  # throws error
check_numeric_scalar("5")     # throws error
} # }
```
