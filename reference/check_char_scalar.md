# Check whether an object is a valid character scalar

This function checks whether an object
[`is_char_scalar()`](https://shafayetshafee.github.io/skmisc/reference/is_char_scalar.md).
If the check fails, a formatted error is raised using
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).

## Usage

``` r
check_char_scalar(x)
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
check_char_scalar("hello")      # passes
check_char_scalar("  hi  ")     # passes
if (FALSE) { # \dontrun{
check_char_scalar("")           # error
check_char_scalar("   ")        # error
check_char_scalar(42)           # error
check_char_scalar(c("a", "b"))  # error
check_char_scalar(NA)           # error
check_char_scalar(NULL)         # error
} # }
```
