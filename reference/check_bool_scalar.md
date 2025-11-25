# Check whether an object is a valid boolean scalar

This function checks whether an object
[`is_bool_scalar()`](https://shafayetshafee.github.io/skmisc/reference/is_bool_scalar.md).
If the check fails, a formatted error is raised using
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).

## Usage

``` r
check_bool_scalar(x)
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
check_bool_scalar(TRUE)          # passes
check_bool_scalar(FALSE)         # passes
if (FALSE) { # \dontrun{
check_bool_scalar(NA)            # throws error
check_bool_scalar(c(TRUE,FALSE)) # throws error
check_bool_scalar("TRUE")        # throws error
} # }
```
