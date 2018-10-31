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

## `setwd`

Don't use `setwd`.

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

This is not wrong:
it just draws on a different tradition in programming
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

## Copy-on-Modify

Another feature of R that can surprise the unwary is [copy-on-modify](../glossary/#copy-on-modify),
which means that if two or more variables refer to the same data
and that data is updated via one variable,
R automatically makes a copy so that the other variable's value doesn't change.
Here's a simple example:


```r
first <- c("red", "green", "blue")
second <- first
cat("before modification, first is", first, "and second is", second, "\n")
```

```
## before modification, first is red green blue and second is red green blue
```

```r
first[[1]] <- "sulphurous"
cat("after modification, first is", first, "and second is", second, "\n")
```

```
## after modification, first is sulphurous green blue and second is red green blue
```

This is true of nested structures as well:


```r
first <- tribble(
  ~left, ~right,
  101,   202,
  303,   404)
second <- first
first$left[[1]] <- 999
cat("after modification\n")
```

```
## after modification
```

```r
first
```

```
## # A tibble: 2 x 2
##    left right
##   <dbl> <dbl>
## 1   999   202
## 2   303   404
```

```r
second
```

```
## # A tibble: 2 x 2
##    left right
##   <dbl> <dbl>
## 1   101   202
## 2   303   404
```

In this case,
the entire `left` column of `first` has been replaced:
tibbles (and data frames) are stored as lists of vectors,
so changing any value in a column triggers construction of a new column vector.

We can watch this happen using the pryr library:


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
first <- tribble(
  ~left, ~right,
  101,   202,
  303,   404
)
tracemem(first)
```

```
## [1] "<0x7f8649c19a08>"
```

```r
first$left[[1]] <- 999
```

```
## tracemem[0x7f8649c19a08 -> 0x7f86418f1288]: eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit .f map process main 
## tracemem[0x7f86418f1288 -> 0x7f863ffa4d88]: eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit .f map process main 
## tracemem[0x7f863ffa4d88 -> 0x7f863ff9ae88]: $<-.data.frame $<- eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit .f map process main 
## tracemem[0x7f863ff9ae88 -> 0x7f863fe8eac8]: $<-.data.frame $<- eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit .f map process main
```

```r
untracemem(first)
```

This rather cryptic output tell us the address of the tibble,
then notifies us of changes to the tibble and its contents.
We can accomplish something a little more readable using `address`:


```r
left <- first$left # alias
cat("left column is initially at", address(left), "\n")
```

```
## left column is initially at 0x7f86418ebd88
```

```r
first$left[[2]] <- 888
cat("after modification, the original column is still at", address(left), "\n")
```

```
## after modification, the original column is still at 0x7f86418ebd88
```

```r
temp <- first$left # another alias
cat("but the first column of the tibble is at", address(temp), "\n")
```

```
## but the first column of the tibble is at 0x7f8648d72488
```

(We need to uses aliases because `address(first$left)` doesn't work:
the argument needs to be a variable name.)

R's copy-on-modify semantics is particularly important when writing functions.
If we modify an argument inside a function,
that modification isn't visible to the caller,
so even functions that appear to modify structures usually don't.
("Usually", because there are exceptions, but we must stray off the path to find them.)

## Conditions

Cautious programmers plan for the unexpected.
In Python,
this is done by [raising](../glossary/#raise-exception) and [catching](../glossary/#catch-exception) [exceptions](../glossary/#exception):


```python
values = [-1, 0, 1]
for i in range(4):
    try:
        reciprocal = 1/values[i]
        print("index {} value {} reciprocal {}".format(i, values[i], reciprocal))
    except ZeroDivisionError:
        print("index {} value {} ZeroDivisionError".format(i, values[i]))
    except Exception as e:
        print("index{} some other Exception: {}".format(i, e))
```

```
## index 0 value -1 reciprocal -1.0
## index 1 value 0 ZeroDivisionError
## index 2 value 1 reciprocal 1.0
## index3 some other Exception: list index out of range
```

Again, R draws on a different tradition.
We say that the operation [signals](../glossary/#signal-condition) a [condition](../glossary/#condition)
that some other piece of code then [handles](../glossary/#signal-handle).
These things are all simpler to do using the rlang library,
so we begin by loading that:


```r
library(rlang)
```

```
## 
## Attaching package: 'rlang'
```

```
## The following object is masked from 'package:pryr':
## 
##     bytes
```

```
## The following objects are masked from 'package:purrr':
## 
##     %@%, %||%, as_function, flatten, flatten_chr, flatten_dbl,
##     flatten_int, flatten_lgl, invoke, list_along, modify, prepend,
##     rep_along, splice
```

The three built-in kinds of conditions are,
in order of increasing severity,
[messages](../glossary/#message), [warnings](../glossary/#warning), and [errors](../glossary/#error).
(There are also interrupts, which are generated by the user pressing Ctrl-C to stop an operation, but we will ignore those.)
We can signal conditions of these three kinds using the functions `message`, `warning`, and `stop`,
each of which takes an error message as a parameter.


```r
message("This is a message.")
```

```
## This is a message.
```

```r
warning("This is a warning.\n")
```

```
## Warning: This is a warning.
```

```r
stop("This is an error.")
```

```
## Error in eval(expr, envir, enclos): This is an error.
```

Note that we have to supply our own line ending for warnings.
Note also that there are only a few situations in which a warning is appropriate:
if something has truly gone wrong,
we should stop,
and if it hasn't,
we should not distract users from more pressing concerns,
like the odd shadows that seem to flicker in the corner of our eye as we examine the artifacts bequeathed to us by our late aunt.

The bluntest of instruments for handling errors is to ignore them.
If a statement is wrapped in `try`,
errors that occur in it are still reported,
but execution continues.
Compare this:


```r
attemptWithoutTry <- function(left, right){
  temp <- left + right
  "result" # returned
}
result <- attemptWithoutTry(1, "two")
```

```
## Error in left + right: non-numeric argument to binary operator
```

```r
cat("result is", result)
```

```
## Error in cat("result is", result): object 'result' not found
```

with this:


```r
attemptUsingTry <- function(left, right){
  temp <- try(left + right)
  "value returned" # returned
}
result <- attemptUsingTry(1, "two")
cat("result is", result)
```

```
## result is value returned
```

If we are *sure* that we wish to incur the risk of silent failure,
we can suppress error messages from `try`:


```r
attemptUsingTryQuietly <- function(left, right){
  temp <- try(left + right, silent = TRUE)
  "result" # returned
}
result <- attemptUsingTryQuietly(1, "two")
cat("result is", result)
```

```
## result is result
```

Do not do this,
for it will,
upon the day,
leave your soul lost and gibbering in an incomprehensible silent hellscape.

Should you wish to handle conditions rather than ignore them,
you may invoke `tryCatch`.
We begin by raising an error explicitly:


```r
tryCatch(
  stop("our message"),
  error = function(cnd) cat("error object is", as.character(cnd))
)
```

```
## error object is Error in doTryCatch(return(expr), name, parentenv, handler): our message
```

(We need to convert the error object `cnd` to character for printing because it is a list of two elements,
the message and the call,
but `cat` only handles character data.)
Let's use this


```r
tryCatch(
  attemptWithoutTry(1, "two"),
  error = function(cnd) cat("error object is", as.character(cnd))
)
```

```
## error object is Error in left + right: non-numeric argument to binary operator
```

We can handle non-fatal errors using `withCallingHandlers`,
and define new types of conditions,
but this is done less often in day-to-day R code than in Python:
see *[Advanced R][advanced-r]* for details.

## A Few Minor Things

What the hell is `~`?
- http://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf
- https://cran.r-project.org/web/packages/lazyeval/vignettes/lazyeval.html

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

```
table4a %>% gather(key = "year", value = "cases", one_of(c("1999", "2000")))
```

Difference between `summarize(..., total = sum(n()))` and `summarize(..., total = sum(n))` (without a function call) in babynames data.

The `here` package https://www.tidyverse.org/articles/2017/12/workflow-vs-script/

Named vectors `c(one = 1, two = 2, three = 3)`

Lists as recursive vectors.

All vectors are column vectors: use `t()` to transpose to row.

`~last(.x) - first(.x)`

Make sure you have devtools 2.0.0 or later and then devtools::build_manual()

{% include links.md %}
