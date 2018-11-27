---
title: "Values and Vectors"
output: md_document
permalink: /values-and-vectors/
questions:
  - "How do I print things?"
  - "What are R's basic data types?"
  - "How do I find out what type something is?"
  - "How do I name variables in R?"
  - "How do I create and index lists in R?"
  - "How do ranges in R differ from ranges in Python?"
  - "What special values does R use to represent things that aren't there?"
objectives:
  - "Name and describe R's atomic data types and create objects of those types."
  - "Explain what 'scalar' values actually are in R."
  - "Identify correct and incorrect variable names in R."
  - "Create vectors in R and index them to select single values, ranges of values, and selected values."
  - "Explain the difference between `NA` and `NULL` and correctly use tests for each."
keypoints:
  - "Use `print(expression)` to print the value of a single expression."
  - "Variable names may include letters, digits, `.`, and `_`, but `.` should be avoided, as it sometimes has special meaning."
  - "R's atomic data types include logical, integer, double (also called numeric), and character."
  - "R stores collections in homogeneous vectors of atomic types, or in heterogeneous lists."
  - "'Scalars' in R are actually vectors of length 1."
  - "Vectors and lists are created using the function `c(...)`."
  - "Vector indices from 1 to length(vector) select single elements."
  - "Negative indices to vectors deselect elements from the result."
  - "The index 0 on its own selects no elements, creating a vector or list of length 0."
  - "The expression `low:high` creates the vector of integers from `low` to `high` inclusive."
  - "Subscripting a vector with a vector of numbers selects the elements at those locations (possibly with repeats)."
  - "Subscripting a vector with a vector of logicals selects elements where the indexing vector is `TRUE`."
  - "Values from short vectors (such as 'scalars') are repeated to match the lengths of longer vectors."
  - "The special value `NA` represents missing values, and (almost all) operations involving `NA` produce `NA`."
  - "The special values `NULL` represents a nonexistent vector, which is not the same as a vector of length 0."
---



We will begin our tour of R by looking at what kinds of data we can toy with.
To do that,
we need to get set up:

{% include setup.md %}

If you want to run the Pythonic bits of code we present as well as the R,
run `install.packages("reticulate")`
and then set the `RETICULATE_PYTHON` environment variable to point at the version of Python you want to use.
This is necessary because you may have a system-installed version somewhere like `/usr/bin/python`
and a conda-managed version in `~/anaconda3/bin/python`.

## How do I say hello?

We begin with a traditional greeting,
using pink to show Python code and green to show R:


```python
print("Hello, world!")
#> Hello, world!
```


```r
print("Hello, world!")
#> [1] "Hello, world!"
```

Python prints what we asked it to,
but what is that `[1]` in R's output?
Is it perhaps something akin to a line number?
Let's take a closer look by simply evaluating a couple of expressions without calling `print`:


```r
'This is in single quotes.'
#> [1] "This is in single quotes."
"This is in double quotes."
#> [1] "This is in double quotes."
```

That the mysterious `[1]` doesn't appear to be a line number.
Let's ignore it for now and do a little more exploring.

> Note that R uses double quotes to display strings even when we give it a single-quoted string
> (which is no worse than Python using single quotes when we've given it doubles).
> Note also that the current version of RMarkdown doesn't show the values of raw Python expressions:
> while the expression `"Hi!"` in R produces that same text as output even without a `print`,
> omitting the `print` in Python leaves us with no output.
> This will be fixed.

## How do I add numbers?

In Python,
we add numbers using `+`.


```python
print(1 + 2 + 3)
#> 6
```

We can check the type of the result using `type`,
which tells us that our `6` is an integer:


```python
print(type(6))
#> <class 'int'>
```

What does R do?


```r
1 + 2 + 3
#> [1] 6
```

```r
typeof(6)
#> [1] "double"
```

The function is called `typeof` rather than `type`,
and it returns the type's name as a string,
but seems odd for integer addition to produce a double-precision floating-point result.
Let's try an experiment:


```r
typeof(6)
#> [1] "double"
```

Ah: by default,
R represents numbers as floating-point values,
even if they look like integers when written.
We can force a literal value to be an integer by appending an upper-case `L` (which stands for "long integer"):


```r
typeof(6L)
#> [1] "integer"
```

Arithmetic on integers does produce integers:


```r
typeof(1L + 2L + 3L)
#> [1] "integer"
```

and if we want to convert a floating-point number to an integer we can do so:


```r
typeof(as.integer(6))
#> [1] "integer"
```

But wait:
what is that dot doing in that function's name?
Is there an object called `as` with a [method](../glossary/#method) called `integer`?

The answer is "no".
`.` is just another character in R;
like the underscore `_`,
it is used to make names more readable,
but it has no special meaning.

## How do I store many numbers together?

The Elder Gods do not bother to learn most of our names because there are so many of us and we are so...ephemeral.
Similarly, we only give a handful of values in our programs their own names;
we lump the rest together into lists and matrices and more esoteric structure
so that we too can create, manipulate, and dispose of multitudes with a single dark command.

The most common such structure in Python is the list.
We create lists using square brackets,
and assign a list to a variable using `=`.
If the variable does not exist, it is created:


```python
primes = [3, 5, 7, 11]
```

Since assignment is a statement rather than an expression,
it has no result,
so Python does not display anything when this command is run.

The equivalent operation in R uses a function called `c`,
which stands for "column" and which creates a [vector](../glossary/#vector):


```r
primes <- c(3, 5, 7, 11)
```

Assignment is done using a left-pointing arrow `<-`.
(Other forms with their own symbols also exist, but we will not discuss them until [later](../control-flow/).)
Like Python,
R does not display a value after an assignment statement.

Now that we can create vector in R,
we can explain that errant `[1]` in our previous examples.
To begin with,
let's have a look at the lengths of various things in Python:


```python
print(len(primes))
#> 4
```


```python
print(len(4))
#> TypeError: object of type 'int' has no len()
#> 
#> Detailed traceback: 
#>   File "<string>", line 1, in <module>
```

Fair enough:
the length of a list is the number of elements it contains,
and since a [scalar](../glossary/#scalar) value like the integer 4 doesn't contain elements,
it has no length.

What of R's vectors?


```r
length(primes)
#> [1] 4
```

```r
length(4)
#> [1] 1
```

The first result is unproblematic, but the second is surprising.
Let's have a closer look:


```r
typeof(primes)
#> [1] "double"
```

That's also unexpected:
the type of the vector is the type of the elements it contains.
This all becomes clear once we realize that *there are no scalars in R*.
`4` is not a single lonely integer,
but rather a vector of length one containing the value 4.
When we display its value,
the `[1]` is the index of its first value.
We can prove this by creating and displaying a much longer vector:


```r
c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#>  [1]  1  2  3  4  5  6  7  8  9 10  1  2  3  4  5  6  7  8  9 10  1  2  3
#> [24]  4  5  6  7  8  9 10  1  2  3  4  5  6  7  8  9 10
```

In order to help us find out way in our data,
R automatically breaks long lines
and displays the starting index of each line.
These indices also show us that R counts from 1 as humans do,
rather than from zero.
(There are a great many myths about why programming languages do the latter.
[Mike Hoye discovered the truth][hoye-zero].)

## How do I index a ~~list~~ vector?

Python's rules for indexing are simple once you understand them
(a statement which is also true of quantum mechanics).
To avoid confusing indices with values,
let's create a list of color names and index that:


```python
colors = ["eburnean", "glaucous", "wenge"]
print(colors[0])
#> eburnean
```

```python
print(colors[2])
#> wenge
```

```python
colors[3]
#> IndexError: list index out of range
#> 
#> Detailed traceback: 
#>   File "<string>", line 1, in <module>
```

```python
print(colors[-1])
#> wenge
```

Indexing the equivalent vector in R with the indices 1 to 3 produces unsurprising results:


```r
colors <- c("eburnean", "glaucous", "wenge")
colors[1]
#> [1] "eburnean"
```

```r
colors[3]
#> [1] "wenge"
```

What happens if we go off the end?


```r
colors[4]
#> [1] NA
```

R handles gaps in data using the special value [`NA`](../glossary/#NA) (short for "not available"),
and returns this value when we ask for a nonexistent element of a vector.
But it does more than this---much more.
In Python,
a negative index counts backward from the end of a list.
In R,
we use a negative index to indicate a value that we don't want:


```r
colors[-1]
#> [1] "glaucous" "wenge"
```

But wait.
If every value in R is a vector,
then when we use 1 or -1 as an index,
we're actually using a vector to index another one.
What happens if the index itself contains more than one value?


```r
colors[1, 2]
#> Error in colors[1, 2]: incorrect number of dimensions
```

That didn't work because R, like human mathematicians, interprets the subscript `[i, j]` as being row and column indices,
and our vector has only one dimension.
What if we make the subscript a vector using `c`?


```r
colors[c(3, 1, 2)]
#> [1] "wenge"    "eburnean" "glaucous"
```

That works, and allows us to repeat elements:


```r
colors[c(1, 1, 1)]
#> [1] "eburnean" "eburnean" "eburnean"
```

or select out several elements:


```r
colors[c(-1, -2)]
#> [1] "wenge"
```

What we *cannot* do is simultaneously select elements in (with positive indices) and out (with negative ones):


```r
colors[c(1, -1)]
#> Error in colors[c(1, -1)]: only 0's may be mixed with negative subscripts
```

That's suggestive:
what happens if we use 0 as an index?


```r
colors[0]
#> character(0)
```

In order to understand this rather cryptic response,
we can try calling the function `character` ourselves
with a positive argument:


```r
character(3)
#> [1] "" "" ""
```

Ah---it appears that `character(N)` constructs a vector of character strings of the specified length
and fills it with empty strings.
The expression `character(0)` presumably therefore means
"an [empty vector](../glossary/#empty-vector) of type character".
From this,
we conclude that the index 0 doesn't correspond to any elements,
so R gives us back something of the right type but with no content.
As a check,
let's try indexing with 0 and 1 together:


```r
colors[c(0, 1)]
#> [1] "eburnean"
```

So when 0 is mixed with either positive or negative indices, it is ignored,
which will undoubtedly lead to some puzzling bugs.
What if in-bounds and out-of-bounds indices are mixed?


```r
colors[c(1, 10)]
#> [1] "eburnean" NA
```

That is consistent with the behavior of single indices.

## How do I create new vectors from old?

Modern Python encourages programmers to use [list comprehensions](../glossary/#list-comprehension) instead of loops,
e.g.,
to write:


```python
original = [3, 5, 7, 9]
doubled = [2 * x for x in original]
print(doubled)
#> [6, 10, 14, 18]
```

instead of:


```python
doubled = []
for x in original:
  doubled.append(2 * x)
print(doubled)
#> [6, 10, 14, 18]
```

If `original` is a NumPy array,
we can shorten this to:


```python
doubled = 2 * original
```

R provides the same capability in the language itself:


```r
original <- c(3, 5, 7, 9)
doubled <- 2 * original
doubled
#> [1]  6 10 14 18
```

Modern R strongly encourages us to [vectorize](../glossary/#vectorize) computations in this way,
i.e.,
to do operations on whole vectors at once rather than looping over their contents.
To aid this,
all arithmetic operations work element by element on vectors:


```r
tens <- c(10, 20, 30)
hundreds <- c(100, 200, 300)
tens + hundreds / (tens * hundreds)
#> [1] 10.10000 20.05000 30.03333
```

If two vectors of unequal length are used together, the elements of the shorter are [recycled](../glossary/#recycle).
This is straightforward if one of the vectors is a scalar---it is just re-used as many times as necessary---but
can produce odd results if the vectors' lengths aren't even multiples:


```r
thousands <- c(1000, 2000)
hundreds + thousands # hundreds has 3 elements, so 1000 is used twice, but 2000 is only used once
#> Warning in hundreds + thousands: longer object length is not a multiple of
#> shorter object length
#> [1] 1100 2200 1300
```

R also provides vectorized alternatives to `if`-`else` statements.
If we use a vector containing the logical (or Boolean) values `TRUE` and `FALSE` as an index,
it selects elements corresponding to `TRUE` values:


```r
colors # as a reminder
#> [1] "eburnean" "glaucous" "wenge"
colors[c(TRUE, FALSE, TRUE)]
#> [1] "eburnean" "wenge"
```

This is (unsurprisingly) called [logical indexing](../glossary/#logical-indexing),
though to the best of my knowledge illogical indexing is not provided as an alternative.
The function `ifelse` uses this to do what its name suggests:
select a value from one vector if a condition is `TRUE`,
and a corresponding value from another vector if the condition is `FALSE`:


```r
before_letter_m <- colors < "m"
before_letter_m # to show the index
#> [1]  TRUE  TRUE FALSE
ifelse(before_letter_m, colors, c("comes", "after", "m"))
#> [1] "eburnean" "glaucous" "m"
```

All three vectors are of the same length,
and the first (the condition) is almost always constructed using the values of one or both of the other vectors:


```r
ifelse(colors < "m", colors, toupper(colors))
#> [1] "eburnean" "glaucous" "WENGE"
```

## How else does R represent the absence of data?

The special value `NA` means "there's supposed to be a value here but we don't know what it is."
A different value, [`NULL`](../glossary/#null), represents the absence of a vector.
It is not the same as a vector of zero length,
though testing that statement produces a rather odd result:


```r
NULL == integer(0)
#> logical(0)
```

The safe way to test if something is `NULL` is to use the function `is.null`:


```r
is.null(NULL)
#> [1] TRUE
```

Circling back,
the safe way to test whether a value is `NA` is *not* to use direct comparison:


```r
threshold <- 1.75
threshold == NA
#> [1] NA
```

The result is `NA` because if we don't know what the value is,
we can't know if it's equal to `threshold` or not.
Instead,
we should always use the function `is.na`:


```r
is.na(threshold)
#> [1] FALSE
is.na(NA)
#> [1] TRUE
```

{% include links.md %}
