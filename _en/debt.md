---
title: "Intellectual Debt"
output: md_document
questions:
  - "What grievous sin can I most easily avoid when using R?"
  - "How can I pipeline functions when the incoming data doesn't belong in the first parameter's position?"
  - "Why does assigning to elements of data structures sometimes appear not to change them?"
  - "How does R handle errors, and how can I handle them myself?"
objectives:
  - "Explain what the formula operator `~` was created for and what other uses it has."
  - "Describe and use `.`, `.x`, `.y, `..1`, `..2`, and other convenience parameters."
  - "Define copy-on-modify and explain its use in R."
keypoints:
  - "Don't use `setwd`."
  - "The formula operator `~` delays evaluation of its operand or operands."
  - "`~` was created to allow users to pass formulas into functions, but is used more generally to delay evaluation."
  - "Some tidyverse functions define `.` to be the whole data, `.x` and `.y` to be the first and second arguments, and `..N` to be the N'th argument."
  - "These convenience parameters are primarily used when the data being passed to a pipelined function needs to go somewhere other than in the first parameter's slot."
  - "'Copy-on-modify' means that data is aliased until something attempts to modify it, at which point it duplicated, so that data always appears to be unchanged."
---



We have accumulated some intellectual debt in the previous lessons,
and we should clear some of before we go on to new topics.

## Why shouldn't I use `setwd`?

Because [reasons][bryan-setwd].

**But...**

No. Use the [here package][here-package].

## How do I write formulas?

One feature of R that doesn't have an exact parallel in Python
is the formula operator `~` (tilde).
Its original (and still most common) purpose is to provide a convenient syntax
for expressing the formulas used in fitting linear regression models.
The basic format of these formulas is `response ~ predictor`,
where `response` and `predictor` depend on the variables in the program.
For example, `Y ~ X` means,
"`Y` is modeled as a function of `X`",
so `lm(Y ~ X)` means "fit a linear model that regresses `Y` on `X`".

What makes `~` work is lazy evaluation:
what actually gets passed to `lm` in the example above is a formula object
that stores the expression representing the left side of the `~`,
the expression representing the right side,
and the environment in which they are to be evaluated.
This means that we can write something like:


```r
fit <- lm(Z ~ X + Y)
```

to mean "fit `Z` to both `X` and `Y`", or:


```r
fit <- lm(Z ~ . - X, data = D)
```

to mean "fit `Z` to all the variables in the data frame `D` *except* the variable `X`."
(Here, we use the shorthand `.` to mean "the data being manipulated".)

But `~` can also be used as a unary operator,
because its true effect is to delay computation.
For example,
we can use it in the function `tribble` to give names to columns
as we create a tibble on the fly:


```r
temp <- tribble(
  ~left, ~right,
  1,     10,
  2,     20
)
temp
```

```
# A tibble: 2 x 2
   left right
  <dbl> <dbl>
1     1    10
2     2    20
```

Used cautiously and with restraint,
lazy evaluation allows us to accomplish marvels.
Used unwisely---well,
there's no reason for us to dwell on that,
particularly not after what happened to poor Higgins...

## What the hell are factors?

Another feature of R that doesn't have an exact analog in Python is **factors**.
In statistics, a factor is a categorical variable such as "flavor",
which can be "vanilla", "chocolate", "strawberry", or "mustard".
Factors can be represented as strings,
but storing the same string many times wastes space and is inefficient
(since comparing strings takes longer than comparing numbers).
What R and other languages therefore do is store each string once
and associate it with a numeric key,
so that internally, "mustard" is the number 4 in the lookup table for "flavor",
but is presented as "mustard" rather than 4.
(Just to keep us on our toes,
R allows factors to be either ordered or unordered.)

This is useful, but brings with it some problems:

1.  On the statistical side,
    it encourages people to put messy reality into tidy but misleading boxes.
    For example, it's unfortunately still common for forms to require people to identify themselves
    as either "male" or "female",
    which is [scientifically](https://www.quora.com/Scientifically-how-many-sexes-genders-are-there)
    [incorrect](https://www.joshuakennon.com/the-six-common-biological-sexes-in-humans/).
    Similarly, census forms that ask questions about racial or ethnic identity often leave people scratching their heads,
    since they don't fit into any of the categories on offer.
2.  On the computational side,
    some functions in R automatically convert strings to factors by default.
    This makes sense when working with statistical data---in most cases,
    a column in which the same strings are repeated many times is categorical---but
    it is usually not the right choice in other situations.
    This has surprised enough people the years that the tidyverse goes the other way
    and only creates factors when asked to.

Let's work through a small example.
Suppose we've read a CSV file and wound up with this table:


```r
raw <- tribble(
  ~person, ~flavor, ~ranking,
  "Lhawang", "strawberry", 1.7,
  "Lhawang", "chocolate",  2.5,
  "Lhawang", "mustard",    0.2,
  "Khadee",  "strawberry", 2.1,
  "Khadee", "chocolate",   2.4,
  "Khadee", "vanilla",     3.9,
  "Haddad", "strawberry",  1.8,
  "Haddad", "vanilla",     2.1
)
raw
```

```
# A tibble: 8 x 3
  person  flavor     ranking
  <chr>   <chr>        <dbl>
1 Lhawang strawberry     1.7
2 Lhawang chocolate      2.5
3 Lhawang mustard        0.2
4 Khadee  strawberry     2.1
5 Khadee  chocolate      2.4
6 Khadee  vanilla        3.9
7 Haddad  strawberry     1.8
8 Haddad  vanilla        2.1
```

Let's aggregate using flavor values so that we can check our factor-based aggregating later:


```r
raw %>% group_by(flavor) %>% summarize(number = n(), average = mean(ranking))
```

```
# A tibble: 4 x 3
  flavor     number average
  <chr>       <int>   <dbl>
1 chocolate       2    2.45
2 mustard         1    0.2 
3 strawberry      3    1.87
4 vanilla         2    3   
```


It probably doesn't make sense to turn the `person` column into factors,
since names are actually character strings,
but the `flavor` column is a good candidate:


```r
raw <- mutate_at(raw, vars(flavor), as.factor)
raw
```

```
# A tibble: 8 x 3
  person  flavor     ranking
  <chr>   <fct>        <dbl>
1 Lhawang strawberry     1.7
2 Lhawang chocolate      2.5
3 Lhawang mustard        0.2
4 Khadee  strawberry     2.1
5 Khadee  chocolate      2.4
6 Khadee  vanilla        3.9
7 Haddad  strawberry     1.8
8 Haddad  vanilla        2.1
```

We can still aggregate as we did before:


```r
raw %>% group_by(flavor) %>% summarize(number = n(), average = mean(ranking))
```

```
# A tibble: 4 x 3
  flavor     number average
  <fct>       <int>   <dbl>
1 chocolate       2    2.45
2 mustard         1    0.2 
3 strawberry      3    1.87
4 vanilla         2    3   
```

We can also impose an ordering on the factor's elements:


```r
raw <- raw %>% mutate(flavor = fct_relevel(flavor, "chocolate", "strawberry", "vanilla", "mustard"))
```

This changes the order in which they are displayed after grouping:


```r
raw %>% group_by(flavor) %>% summarize(number = n(), average = mean(ranking))
```

```
# A tibble: 4 x 3
  flavor     number average
  <fct>       <int>   <dbl>
1 chocolate       2    2.45
2 strawberry      3    1.87
3 vanilla         2    3   
4 mustard         1    0.2 
```

And also changes the order of bars in a bar chart:


```r
raw %>%
  group_by(flavor) %>%
  summarize(number = n(), average = mean(ranking)) %>%
  ggplot() +
  geom_col(mapping = aes(x = flavor, y = average))
```

![plot of chunk simple_bar_chart](../figures/debt//simple_bar_chart-1.png)


To learn more about how factors work and how to use them when analyzing categorical data,
please see [this paper](https://peerj.com/preprints/3163/) by McNamara and Horton.

## How do I refer to various arguments in a pipeline?

When we put a function in a pipeline using `%>%`,
that operator calls the function with the incoming data as the first argument,
so `data %>% func(arg)` is the same as `func(data, arg)`.
This is fine when we want the incoming data to be the first argument,
but what if we want it to be second?  Or third?

One possibility is to save the result so far in a temporary variable
and then start a second pipe:


```r
data <- tribble(
  ~left, ~right,
  1,     NA,
  2,     20
)
empties <- data %>%
  pmap_lgl(function(...) {
    args <- list(...)
    any(is.na(args))
  })
data %>%
  transmute(id = row_number()) %>%
  filter(empties) %>%
  pull(id)
```

```
[1] 1
```

This builds a logical vector `empties` with as many entries as `data` has rows,
then filters data according to which of the entries in the vector are `TRUE`.

A better practice is to use the parameter name `.`,
which means "the incoming data".
In some functions (e.g., a two-argument function being used in `map`)
we can use `.x` and `.y`,
and for more arguments,
we can use `..1`, `..2`, and so on:


```r
data %>%
  pmap_lgl(function(...) {
    args <- list(...)
    any(is.na(args))
  }) %>%
  tibble(empty = .) %>%
  mutate(id = row_number()) %>%
  filter(empty) %>%
  pull(id)
```

```
[1] 1
```

In this model,
we create the logical vector,
then turn it into a tibble with one column called `empty`
(which is what `empty = .` does in `tibble`'s constructor).
After that,
it's easy to add another column with row numbers,
filter,
and pull out the row numbers.
We used this method in [the warm-up exercise in the previous lesson](../#s:testing-warmup).

And while we're here:
`row_number` doesn't do what its name suggests.
We're better off using `rowid_to_column`:


```r
data %>% rowid_to_column()
```

```
# A tibble: 2 x 3
  rowid  left right
  <int> <dbl> <dbl>
1     1     1    NA
2     2     2    20
```

## How does R give the appearance of immutable data?

Another feature of R that can surprise the unwary is [copy-on-modify](#g:copy-on-modify),
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
before modification, first is red green blue and second is red green blue 
```

```r
first[[1]] <- "sulphurous"
cat("after modification, first is", first, "and second is", second, "\n")
```

```
after modification, first is sulphurous green blue and second is red green blue 
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
after modification
```

```r
first
```

```
# A tibble: 2 x 2
   left right
  <dbl> <dbl>
1   999   202
2   303   404
```

```r
second
```

```
# A tibble: 2 x 2
   left right
  <dbl> <dbl>
1   101   202
2   303   404
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

Attaching package: 'pryr'
```

```
The following objects are masked from 'package:purrr':

    compose, partial
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
[1] "<0x7f99ad6a8e08>"
```

```r
first$left[[1]] <- 999
```

```
tracemem[0x7f99ad6a8e08 -> 0x7f99b084aa88]: eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit 
tracemem[0x7f99b084aa88 -> 0x7f99b084aa08]: eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit 
tracemem[0x7f99b084aa08 -> 0x7f99b084a908]: $<-.data.frame $<- eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit 
tracemem[0x7f99b084a908 -> 0x7f99b084a888]: $<-.data.frame $<- eval eval withVisible withCallingHandlers doTryCatch tryCatchOne tryCatchList tryCatch try handle timing_fn evaluate_call <Anonymous> evaluate in_dir block_exec call_block process_group.block process_group withCallingHandlers process_file knit 
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
left column is initially at 0x7f99b084aa48 
```

```r
first$left[[2]] <- 888
cat("after modification, the original column is still at", address(left), "\n")
```

```
after modification, the original column is still at 0x7f99b084aa48 
```

```r
temp <- first$left # another alias
cat("but the first column of the tibble is at", address(temp), "\n")
```

```
but the first column of the tibble is at 0x7f99b007c0c8 
```

(We need to use [aliases](#g:alias) because `address(first$left)` doesn't work:
the argument needs to be a variable name.)

R's copy-on-modify semantics is particularly important when writing functions.
If we modify an argument inside a function,
that modification isn't visible to the caller,
so even functions that appear to modify structures usually don't.
("Usually", because there are exceptions, but we must stray off the path to find them.)

## What else should I worry about?

Ralph Waldo Emerson once wrote, "A foolish consistency is the hobgoblin of little minds."
Here, then, are few of the hobgoblins I've encountered on my journey through R.

**The `order` function:**
The function `order` generates indices to pull values into place rather than push them,
i.e.,
`order(x)[i]` is the index in `x` of the element that belongs at location `i`.
For example:


```r
order(c("g", "c", "t", "a"))
```

```
[1] 4 2 1 3
```
shows that the value at location 4 (the `"a"`) belongs in the first spot of the vector;
it does *not* mean that the value in the first location (the `"g"`) belongs in location 4.

**One of a set of values:**
The function `one_of` is a handy way to specify several values for matching
without complicated Boolean conditionals.
For example,
`gather(data, key = "year", value = "cases", one_of(c("1999", "2000")))`
collects data for the years 1999 and 2000.

**Functions and columns:**
There's a function called `n`.
It's not the same thing as a column called `n`.


```r
data <- tribble(
  ~a, ~n,
  1,  10,
  2,  20
)
data %>% summarize(total = sum(n))
```

```
# A tibble: 1 x 1
  total
  <dbl>
1    30
```

```r
data %>% summarize(total = sum(n()))
```

```
# A tibble: 1 x 1
  total
  <int>
1     2
```

{% include links.md %}
