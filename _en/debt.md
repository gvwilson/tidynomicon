---
title: "Intellectual Debt"
output: md_document
permalink: /debt/
questions:
  - "FIXME"
objectives:
  - "FIXME"
keypoints:
  - "FIXME"
---

We have accumulated some intellectual debt in the previous four lessons,
and we should clear some of before we go on to new topics.

## Lazy Evaluation

The biggest difference between Python and R is not that the latter starts counting from 1,
but the fact that R uses [lazy evaluation](../glossary/#lazy-evaluation) for function arguments.
When we write this in Python:


```python
def example(first, second):
    print("first argument is", first)
    print("second argument is", second)
    return first + second
example(1 + 2, 1 / 0)
```

```
## ZeroDivisionError: division by zero
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
```

then the message `"starting example"` never appears because expressions are evaluated in this order:

1.  `1 + 2`
2.  `1 / 0` - and fail without getting to the first `print` statement inside the function.

When we write the equivalent R, however, the behavior is rather different:


```r
example <- function(first, second) {
  cat("first argument is", first, "\n")
  cat("second argument is", second, "\n")
  first + second
}

example(1 + 2, 1 / 0)
```

```
## first argument is 3 
## second argument is Inf
```

```
## [1] Inf
```

because the order of evaluation is:

1.  Call `example`.
2.  Evaluate `first` because the first `cat` call needs it.
3.  Invoke `cat` the first time.
4.  Evaluate `second` because the second `cat` call needs it.
5.  Invoke `cat` a second time.
6.  Add the values of the two expressions and return.

Here's another example:


```r
green <- function() {
  cat("green\n")
  10
}

blue <- function() {
  cat("blue\n")
  20
}

combined <- function(left, right) {
  cat("combined\n")
  left + right
}

combined(green(), blue())
```

```
## combined
## green
## blue
```

```
## [1] 30
```

*This is not wrong.*
It is just different---or rather,
it draws on a different tradition in programming
than languages in the C family (which includes Python).

Lazy evaluation powers many of R's most useful features.
For example,
let's create a tibble whose second column's values are twice those of its first:


```r
t <- tibble(a = 1:3, b = 2 * a)
t
```

```
## # A tibble: 3 x 2
##       a     b
##   <int> <dbl>
## 1     1     2
## 2     2     4
## 3     3     6
```

This works because the expression defining the second column is evaluated *after*
the expression defining the first column.
Without lazy evaluation,
we would be trying to create `b` using `a` in our code (where there isn't a variable called `a`)
rather than inside the function (where `a` will just have been created).
This is why we could write things like:


```r
body <- raw %>%
  select(-ISO3, -Countries)
```

```
## Error in UseMethod("select_"): no applicable method for 'select_' applied to an object of class "function"
```

in our data cleanup example:
`select` can evaluate `-ISO3` and `-Countries` once it knows what the incoming table looks like.

In order to make lazy evaluation work,
R relies heavily on a structure called an [environment](../glossary/#environment),
which holds a set of name-value pairs.
Whenever R needs the value of a variable,
it looks in the function's environment,
then in its [parent environment](../glossary/#parent-envrironment),
and so on until it reaches the [global environment](../glossary/#global-environment).
This is more or less the same thing that Python and other languages do,
but R programs manipulate enviroments explicitly more often than programs in most other languages.
To learn more about this,
see the discussion in *[Advanced R][advanced-r]*.

FIXME: talk about promises from Functions.Rmd

## Copy-on-Modify

FIXME


```r
library(pryr)
```

```
## 
## Attaching package: 'pryr'
```

```
## The following objects are masked from 'package:purrr':
## 
##     compose, partial
```

```r
circular <- list()
inspect(circular)
```

```
## <VECSXP 0x7fd0b821d7e0>
```

```r
tracemem(circular)
```

```
## [1] "<0x7fd0b821d7e0>"
```

```r
circular[[1]] <- circular
```

```
## tracemem[0x7fd0b821d7e0 -> 0x7fd0b833bce8]: eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit .f map process main
```

```r
circular
```

```
## [[1]]
## list()
```

```r
inspect(circular)
```

```
## <VECSXP 0x7fd0ba4c8cf0>
##   <VECSXP 0x7fd0b821d7e0>
```

## Conditions

FIXME: how R and the tidyverse handle conditions.

## A Few Minor Things

What the hell is `~`?

`..1` and `.` and `.f` and the like in tidyverse functions

`c(c(1, 2), c(3, 4))` is `c(1, 2, 3, 4)` (it flattens).

`[` simplifies results to lowest possible dimensionality unless `drop=FALSE`.

After `a <- matrix(1:9, nrow = 3)`, `a[1,1]` is a vector of length 1, while `a[1,]` is also a vector, though of length 3.

With data frames, subsetting with a single vector selects columns (not rows), and `df[1:2]` selects columns, but in `df[2:3, 1:2]`, the first index selects rows, while the second selects columns.

`x[[5]]` (object in car) to `x[5]` (train with one car)

using `[[` with a vector subsets recursively: `b <- list(a = list(b = list(c = list(d = 1))))` and then `b[[c("a", "b", "c", "d")]]`

```
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
```

introduce the `match` function

introduce `order`: these are 'pull' indices: `order(x)[i]` is the index in `x` of the element that belongs at location `i`

point out that `rep(vec1, vec2)` repeats each element of `vec1` exactly `vec2` times

When you use a name in a function call, R ignores non-function objects when looking for that value. For example, in the code below, `g09` takes on two different values:


```r
g09 <- function(x) x + 100
g10 <- function() {
  g09 <- 10
  g09(g09)
}
g10()
```

```
## [1] 110
```

Invisible values

`<<-` operator

{% include links.md %}
