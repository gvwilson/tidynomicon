---
title: "Testing"
output: md_document
permalink: /testing/
---

Mistakes were made in [the previous tutorial](../cleanup/).
It would be [hubris](../glossary/#hubris) to believe that we will not make more as we continue to clean this data.
What will guide us safely through these dark caverns and back into the light of day?

The answer is testing.
We must test our assumptions, test our code, test our very *being* if we are to advance.
Luckily for us,
R provides tools for this purpose not unlike those available in Python.

## The Problem

We have been given several more CSV files to clean up.
The first,
`raw/at_health_facilities.csv`,
shows the percentage of births at health facilities by country, year, and mother's age.
It comes from the same UNICEF website as our previous data,
but has a different set of problems.
Here are its first few lines:

```
,,GLOBAL DATABASES,,,,,,,,,,,,,
,,[data.unicef.org],,,,,,,,,,,,,
,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,
Indicator:,Delivered in health facilities,,,,,,,,,,,,,,
Unit:,Percentage,,,,,,,,,,,,,,
,,,,Mother's age,,,,,,,,,,,
iso3,Country/areas,year,Total ,age 15-17,age 18-19,age less than 20,age more than 20,age 20-34,age 35-49,Source,Source year,,,,
AFG,Afghanistan,2010, 	33 , 	25 , 	29 , 	28 , 	31 , 	31 , 	31 ,MICS,2010,,,,
ALB,Albania,2005, 	98 , 	100 , 	96 , 	97 , 	98 , 	99 , 	92 ,MICS,2005,,,,
ALB,Albania,2008, 	98 , 	94 , 	98 , 	97 , 	98 , 	98 , 	99 ,DHS,2008,,,,
...
```

and its last:

```
ZWE,Zimbabwe,2005, 	66 , 	64 , 	64 , 	64 , 	67 , 	69 , 	53 ,DHS,2005,,,,
ZWE,Zimbabwe,2009, 	58 , 	49 , 	59 , 	55 , 	59 , 	60 , 	52 ,MICS,2009,,,,
ZWE,Zimbabwe,2010, 	64 , 	56 , 	66 , 	62 , 	64 , 	65 , 	60 ,DHS,2010,,,,
ZWE,Zimbabwe,2014, 	80 , 	82 , 	82 , 	82 , 	79 , 	80 , 	77 ,MICS,2014,,,,
,,,,,,,,,,,,,,,
Definition:,Percentage of births delivered in a health facility.,,,,,,,,,,,,,,
,"The indicator refers to women who had a live birth in a recent time period, generally two years for MICS and five years for DHS.",,,,,,,,,,,,,,
,,,,,,,,,,,,,,,
Note:,"Database include reanalyzed data from DHS and MICS, using a reference period of two years before the survey.",,,,,,,,,,,,,,
,Includes surveys which microdata were available as of April 2016. ,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,
Source:,"UNICEF global databases 2016 based on DHS, MICS .",,,,,,,,,,,,,,
,,,,,,,,,,,,,,,
Contact us:,data@unicef.org,,,,,,,,,,,,,,
```

There are three files in this collection,
all exported from the same Excel spreadsheet.
Rather than writing a separate script for each,
we should create a tool that will handle them all.
At first glance,
the problems we need to solve to do this are:

1.  Each file may contain a different number of records,
    so our tool should select rows by content rather than by absolute row number.
2.  Each file may contain a different set of columns,
    so our tool should select those that always appear by name
    and somehow infer the location of the rest.

These two requirements will make our program significantly more complicated,
so we should tackle each with its own testable function.

## Testing

The standard testing library for R is [testthat](https://github.com/r-lib/testthat).
Like Python's [unittest](https://docs.python.org/3/library/unittest.html) library,
it is a member of the [xUnit](https://en.wikipedia.org/wiki/XUnit) family
of [unit testing](../glossary/#unit-test) libraries:

1.  Each test consists of a single function that tests a single property or behavior of the system.
2.  Tests are collected into files with prescribed names that can be found by a [test runner](../glossary/#test-runner).
3.  Shared [setup](../glossary/#testing-setup) and [teardown](../glossary/#testing-teardown) steps are put in functions of their own.

Let's load it and write our first test:


```r
library(testthat)
```

```
## 
## Attaching package: 'testthat'
```

```
## The following object is masked from 'package:dplyr':
## 
##     matches
```

```
## The following object is masked from 'package:purrr':
## 
##     is_null
```

```r
test_that("Zero equals itself", { expect_equal(0, 0) })
```

As is conventional with xUnit-style testing libraries,
no news is good news:
if a test passes,
it doesn't produce output because it doesn't need our attention.
Let's try something that ought to fail:


```r
test_that("Zero equals one", { expect_equal(0, 1) })
```

```
## Error: Test failed: 'Zero equals one'
## * 0 not equal to 1.
## 1/1 mismatches
## [1] 0 - 1 == -1
```

Good:
we can draw some comfort from the fact that They have not yet changed the fundamental rules of arithmetic.
But what are the curly braces around `expect_equal` for?
The answer is that they create a code block of some sort for `test_that` to run.
We can run `expect_equal` on its own:


```r
expect_equal(0, 1)
```

```
## Error: 0 not equal to 1.
## 1/1 mismatches
## [1] 0 - 1 == -1
```

but that doesn't produce a summary of how many tests passed or failed.
Passing a block of code to `test_that` also allows us to check several things in one test:


```r
test_that("Testing two things", {
  expect_equal(0, 0)
  expect_equal(0, 1)
})
```

```
## Error: Test failed: 'Testing two things'
## * 0 not equal to 1.
## 1/1 mismatches
## [1] 0 - 1 == -1
```

Note that a block of code is *not* the same thing as an [anonymous function](../glossary/#anonymous-function),
which is why running this block of code does nothing:


```r
test_that("Using an anonymous function", function(){
  print("In our anonymous function")
  expect_equal(0, 1)
})
```

But running blocks of tests by hand is a bad practice no matter what is in them.
What we should do instead is put related tests in files,
then put those files in a directory called `tests`.
We can then run some or all of those tests with a single command.

To start,
let's create `tests/test_example.R`:


```r
library(testthat)
context("Demonstrating the testing library")

test_that("Testing a number with itself", {
  expect_equal(0, 0)
  expect_equal(-1, -1)
  expect_equal(Inf, Inf)
})

test_that("Testing different numbers", {
  expect_equal(0, 1)
})

test_that("Testing with a tolerance", {
  expect_equal(0, 0.01, tolerance = 0.05, scale = 1)
  expect_equal(0, 0.01, tolerance = 0.005, scale = 1)
})

test_that("Testing character vectors", {
  expect_equal("abc", "XYZ")
  expect_equal("abc", "ABC")
})
```

The first line loads the testthat package,
which gives us our tools.
The call to `context` on the second line gives this set of tests a name for reporting purposes.
After that,
we add as many calls to `test_that` as we want,
each with a name and a block of code.
We can now run this file from within RStudio:


```r
test_dir("tests")
```

```
## ✔ | OK F W S | Context
## ⠏ |  0       | Demonstrating the testing library⠋ |  1       | Demonstrating the testing library⠙ |  2       | Demonstrating the testing library⠹ |  3       | Demonstrating the testing library⠸ |  3 1     | Demonstrating the testing library⠼ |  4 1     | Demonstrating the testing library⠴ |  4 2     | Demonstrating the testing library⠦ |  4 3     | Demonstrating the testing library⠧ |  4 4     | Demonstrating the testing library✖ |  4 4     | Demonstrating the testing library
## ───────────────────────────────────────────────────────────────────────────
## test_example.R:11: failure: Testing different numbers
## 0 not equal to 1.
## 1/1 mismatches
## [1] 0 - 1 == -1
## 
## test_example.R:16: failure: Testing with a tolerance
## 0 not equal to 0.01.
## 1/1 mismatches
## [1] 0 - 0.01 == -0.01
## 
## test_example.R:20: failure: Testing character vectors
## "abc" not equal to "XYZ".
## 1/1 mismatches
## x[1]: "abc"
## y[1]: "XYZ"
## 
## test_example.R:21: failure: Testing character vectors
## "abc" not equal to "ABC".
## 1/1 mismatches
## x[1]: "abc"
## y[1]: "ABC"
## ───────────────────────────────────────────────────────────────────────────
## ⠏ |  0       | Finding empty rows⠋ |  0 1     | Finding empty rows⠙ |  0 2     | Finding empty rows⠹ |  1 2     | Finding empty rows✖ |  1 2     | Finding empty rows
## ───────────────────────────────────────────────────────────────────────────
## test_find_empty_a.R:9: failure: A single non-empty row is not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## 
## test_find_empty_a.R:14: failure: Half-empty rows are not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## ───────────────────────────────────────────────────────────────────────────
## ⠏ |  0       | Testing properties of tibbles⠋ |  1       | Testing properties of tibbles✔ |  1       | Testing properties of tibbles
## 
## ══ Results ════════════════════════════════════════════════════════════════
## OK:       6
## Failed:   6
## Warnings: 0
## Skipped:  0
```

A bit of care is needed when interpreting these results.
There are four `test_that` calls,
but eight actual checks,
and the number of successes and failures is counted by recording the results of the latter,
not the former.

What then is the purpose of `test_that`?
Why not just use `expect_equal` and its kin,
such as `expect_true`, `expect_false`, `expect_length`, and so on?
The answer is that it allows us to do one operation and then check several things afterward.
Let's create another file called `tests/test_tibble.R`:


```r
library(tidyverse)
library(testthat)
context("Testing properties of tibbles")

test_that("Tibble columns are given the name 'value'", {
  t <- c(TRUE, FALSE) %>% as.tibble()
  expect_equal(names(t), "value")
})
```

(We don't actually have to call our test files `test_something.R`,
but `test_dir` and the rest of R's testing infrastructure expect us to.
Similarly,
we don't have to put them in a `tests` directory,
but gibbering incoherence is likely to ensue if we do not.)
Now let's run all of our tests:


```r
test_dir("tests")
```

```
## ✔ | OK F W S | Context
## ⠏ |  0       | Demonstrating the testing library⠋ |  1       | Demonstrating the testing library⠙ |  2       | Demonstrating the testing library⠹ |  3       | Demonstrating the testing library⠸ |  3 1     | Demonstrating the testing library⠼ |  4 1     | Demonstrating the testing library⠴ |  4 2     | Demonstrating the testing library⠦ |  4 3     | Demonstrating the testing library⠧ |  4 4     | Demonstrating the testing library✖ |  4 4     | Demonstrating the testing library
## ───────────────────────────────────────────────────────────────────────────
## test_example.R:11: failure: Testing different numbers
## 0 not equal to 1.
## 1/1 mismatches
## [1] 0 - 1 == -1
## 
## test_example.R:16: failure: Testing with a tolerance
## 0 not equal to 0.01.
## 1/1 mismatches
## [1] 0 - 0.01 == -0.01
## 
## test_example.R:20: failure: Testing character vectors
## "abc" not equal to "XYZ".
## 1/1 mismatches
## x[1]: "abc"
## y[1]: "XYZ"
## 
## test_example.R:21: failure: Testing character vectors
## "abc" not equal to "ABC".
## 1/1 mismatches
## x[1]: "abc"
## y[1]: "ABC"
## ───────────────────────────────────────────────────────────────────────────
## ⠏ |  0       | Finding empty rows⠋ |  0 1     | Finding empty rows⠙ |  0 2     | Finding empty rows⠹ |  1 2     | Finding empty rows✖ |  1 2     | Finding empty rows
## ───────────────────────────────────────────────────────────────────────────
## test_find_empty_a.R:9: failure: A single non-empty row is not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## 
## test_find_empty_a.R:14: failure: Half-empty rows are not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## ───────────────────────────────────────────────────────────────────────────
## ⠏ |  0       | Testing properties of tibbles⠋ |  1       | Testing properties of tibbles✔ |  1       | Testing properties of tibbles
## 
## ══ Results ════════════════════════════════════════════════════════════════
## OK:       6
## Failed:   6
## Warnings: 0
## Skipped:  0
```

That's rather a lot of output.
Happily,
we can provide a `filter` argument to `test_dir`:


```r
test_dir("tests", filter = "test_tibble.R")
```

```
## Error in test_files(paths, reporter = reporter, env = env, stop_on_failure = stop_on_failure, : No matching test file in dir
```

Ah.
It turns out that `filter` is applied to filenames *after* the leading `test_` and the trailing `.R` have been removed.
Let's try again:


```r
test_dir("tests", filter = "tibble")
```

```
## ✔ | OK F W S | Context
## ⠏ |  0       | Testing properties of tibbles⠋ |  1       | Testing properties of tibbles✔ |  1       | Testing properties of tibbles
## 
## ══ Results ════════════════════════════════════════════════════════════════
## OK:       1
## Failed:   0
## Warnings: 0
## Skipped:  0
```

That's better,
and it illustrates our earlier point about the importance of following conventions.

## Warming Up

To give ourselves something to test,
let's create a file called `scripts/find_empty_01.R`
that defines a single function `find_empty_rows` that identifies all the empty rows in a CSV file.
Our first implementation is:


```r
find_empty_rows <- function(source) {
  data <- read_csv(source)
  empty <- data %>%
    pmap(function(...) {
      args <- list(...)
      all(is.na(args) | (args == ""))
    })
  data %>%
    transmute(id = row_number()) %>%
    filter(as.logical(empty)) %>%
    pull(id)
}
```

This is complex enough to merit line-by-line exegesis:

1.  Define the function with one argument `source`, from which we shall read.
2.  Read tabular data from that source and assign the resulting tibble to `data`.
3.  Begin a pipeline that will assign something to the variable `empty`.
    1.  Use `pmap` to map a function across each row of the tibble.
        Since we don't know how many columns are in each row,
        we use `...` to take any number of arguments.
    2.  Convert the variable number of arguments to a list.
    3.  Check to see if all of those arguments are either `NA` or the empty string.
    4.  Close the mapped function's definition.
4.  Start another pipeline.
    This one's result isn't assigned to a variable,
    so whatever it produces will be the value returned by `find_empty_rows`.
    1.  Construct a tibble that contains only the row numbers of the original table in a column called `id`.
    2.  Filter those row numbers to keep only those corresponding to rows that were entirely empty.
        The `as.logical` call inside `filter` is needed because the value returned by `pmap`
        (which we stored in `empty`)
        is a list, not a logical vector.
    3.  Use `pull` to get the one column we want from the filtered tibble as a vector.

There is a lot going on here,
particularly if you are (as I am at the time of writing)
new to R
and needed help to figure out that `pmap` is the function this problem wants.
But now that we have it,
we can do this:


```r
library(tidyverse)
source("scripts/find_empty_01.R")
find_empty_rows("a,b\n1,2\n,\n5,6")
```

```
## [1] 2
```

The `source` function reads R code from the given source.
Using this inside an RMarkdown file is usually a bad idea,
since the generated HTML or PDF won't show readers what code we loaded and ran.
On the other hand,
if we are creating command-line tools for use on clusters or in other batch processing modes,
and are careful to display the code in a nearby block,
the stain on our soul is excusable.

The more interesting part of this example is the call to `find_empty_rows`.
Instead of giving it the name of a file,
we have given it the text of the CSV we want parsed.
This is then passed to `read_csv`,
which (according to documentation that only took us 15 minutes to realize we had already seen)
interprets its first argument as a filename *or*
as the actual text to be parsed if it contains a newline character.
This allows us to write put the [test fixture](../glossary/#test-fixture)
right there in the code as a literal string,
which experience shows is to understand and maintain
than having test data in separate files.

Our function seems to work,
but we can make it more pipelinesque:


```r
find_empty_rows <- function(source) {
  read_csv(source) %>%
    pmap_lgl(function(...) {
      args <- list(...)
      all(is.na(args) | (args == ""))
    }) %>%
    tibble(empty = .) %>%
    mutate(id = row_number()) %>%
    filter(empty) %>%
    pull(id)
}
```

Going line by line once again:

1.  Define a function with one argument called `source`, from which we shall once again read.
2.  Read from that source to fill the pipeline.
3.  Map our test for emptiness across each row, returning a logical vector as a result.
    (`pmap_lgl` is a derivative of `pmap` that always casts its result to logical.
    Similar functions like `pmap_dbl` return vectors of other types,
    and many other tidyverse functions have strongly-typed variants as well.)
4.  Turn that logical vector into a single-column tibble,
    giving that column the name "empty".
    We explain the use of `.` below.
5.  Add a second column with row numbers.
6.  Discard rows that aren't empty.
7.  Return a vector of the remaining row IDs.

> **Wat?**
>
> Buried in the middle of the pipe shown above is the expression:
>
> `tibble(empty = .)`
>
> In this context, `.` means "whatever is on the left side of the `%>%` operator",
> i.e., whatever would normally be passed as the first argument to this function.
> Without this,
> we have no easy way to give the sole column of our newly-constructed tibble a name.
> This use of `.` takes advantage of a feature left over from the formula syntax
> created in the early days of R's predecessor, S;
> in other contexts, `.` is just a very poorly named variable.

Here's our first batch of tests:


```r
library(tidyverse)
library(testthat)
context("Finding empty rows")

source("../scripts/find_empty_02.R")

test_that("A single non-empty row is not mistakenly detected", {
  result <- find_empty_rows("a\n1")
  expect_equal(result, NULL)
})

test_that("Half-empty rows are not mistakenly detected", {
  result <- find_empty_rows("a,b\n,2")
  expect_equal(result, NULL)
})

test_that("An empty row in the middle is found", {
  result <- find_empty_rows("a,b\n1,2\n,\n5,6")
  expect_equal(result, c(2L))
})
```

And here's what happens when we run this file with `test_dir`:


```r
test_dir("tests", "find_empty_a")
```

```
## ✔ | OK F W S | Context
## ⠏ |  0       | Finding empty rows⠋ |  0 1     | Finding empty rows⠙ |  0 2     | Finding empty rows⠹ |  1 2     | Finding empty rows✖ |  1 2     | Finding empty rows
## ───────────────────────────────────────────────────────────────────────────
## test_find_empty_a.R:9: failure: A single non-empty row is not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## 
## test_find_empty_a.R:14: failure: Half-empty rows are not mistakenly detected
## `result` not equal to NULL.
## Types not compatible: integer is not NULL
## ───────────────────────────────────────────────────────────────────────────
## 
## ══ Results ════════════════════════════════════════════════════════════════
## OK:       1
## Failed:   2
## Warnings: 0
## Skipped:  0
## 
## I believe in you!
```

This is perplexing:
we expected that if there were no empty rows,
our function would return `NULL`.
Let's look more closely:


```r
find_empty_rows("a\n1")
```

```
## integer(0)
```

Ah:
we are being given an integer vector of zero length rather than `NULL`.
Let's have a closer look at the properties of this strange beast:


```r
print("is integer(0) equal to NULL")
```

```
## [1] "is integer(0) equal to NULL"
```

```r
integer(0) == NULL
```

```
## logical(0)
```

```r
print("any(logical(0))")
```

```
## [1] "any(logical(0))"
```

```r
any(logical(0))
```

```
## [1] FALSE
```

```r
print("all(logical(0))")
```

```
## [1] "all(logical(0))"
```

```r
all(logical(0))
```

```
## [1] TRUE
```

All right.
If we compare `c(1L, 2L)` to `NULL`, we expect `c(FALSE, FALSE)`,
so it's reasonable to get a zero-length logical vector as a result when we compare `NULL` to an integer vector with no elements.
The fact that `any` of an empty logical vector is `FALSE` isn't really surprising either---none of the elements are `TRUE`,
so it would be hard to say that any of them are.
But `all` of an empty vector being `TRUE` is…unexpected.
The reasoning is apparently that none of the (nonexistent) elements are `FALSE`,
but honestly,
at this point we are veering dangerously close to [JavaScript Logic](https://www.destroyallsoftware.com/talks/wat),
so we will accept this behavior and move on.
