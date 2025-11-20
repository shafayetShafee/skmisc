# Wrap a string in braces if not already wrapped

This internal helper ensures that a string is enclosed in a single pair
of curly braces [`{}`](https://rdrr.io/r/base/Paren.html). If the input
string already starts and ends with braces, it is returned unchanged.
Leading and trailing whitespace is trimmed before the check.

## Usage

``` r
wrap_braces_once(title)
```

## Arguments

- title:

  A character scalar representing a string to wrap.

## Value

A character scalar wrapped in braces, or unchanged if already wrapped.
