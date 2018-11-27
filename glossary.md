---
title: "Glossary"
layout: default
permalink: "/glossary/"
---

*Absolute row number*{:#absolute-row-number}:
the sequential index of a row in a table,
regardless of what sections of the table is being displayed.

*Aggregation*{:#aggregation}:
to combine many values into one,
e.g.,
by summing a set of numbers or concatenating a set of strings.

*Alias*{:#alias}:
to have two (or more) references to the same physical data.

*Anonymous function*{:#anonymous-function}:
a function that has not been assigned a name.
Anonymous functions are usually quite short,
and are usually defined where they are used,
e.g.,
as callbacks.

*Attribute*{:#attribute}:
a name-value pair associated with an object,
used to store metadata about the object
such as an array's dimensions.

*Catch (exception)*{:#catch-exception}:
to accept responsibility for handling an error
or other unexpected event.
R prefers "[handling](#handle) a [condition](#condition)"
to "catching an [exception](#exception)".

*Condition*{:#condition}:
an error or other unexpected event that disrupts the normal flow of control.
See also [handle](#handle).

*Constructor (class)*{:#constructor}:
a function that creates an object of a particular class.
In the [S3](#S3) object system,
constructors are a convention rather than a requirement.

*Copy-on-modify*{:#copy-on-modify}:
the practice of creating a new copy of [aliased](#alias) data
whenever there is an attempt to modify it
so that each reference will believe theirs is the only one.

*Double square brackets*{:#double-square-brackets}:
an index enclosed in `[[...]]`,
used to return a single value of the underlying type.
See also [single square brackets](#single-square-brackets).

*Eager evaluation*{:#eager-evaluation}:
evaluating an expression as soon as it is formed.

*Empty vector*{:#empty-vector}:
a vector that contains no elements.
Empty vectors have a type such as logical or character,
and are *not* the same as [null](#null).

*Environment*{:#environment}:
a structure that stores a set of variable names and the values they refer to.

*Error*{:#error}:
the most severe type of built-in [condition](#condition) in R.

*Evaluation*{:#evaluation}:
the process of taking a complex expression such as `1+2*3/4`
and turning it into a single irreducible value.

*Evaluating function*{:#evaluating-function}:
a function that takes arguments as values.
Most functions are evaluating functions.

*Exception*{:#exception}:
an object containing information about an error,
or the condition that led to the error.
R prefers "[handling](#handle) a [condition](#condition)"
to "[catching](#catch) an exception".

*Filter*{:#filter}:
to choose a set of records according to the values they contain.

*Fully qualified name*{:#fully-qualified-name}:
an unambiguous name of the form <code><em>package</em>::<em>thing</em></code>.

*Functional programming*{:#functional-programming}:
a style of programming in which functions transform data rather than modifying it.
Functional programming relies heavily on [higher-order functions](#higher-order function).

*Generic function*{:#generic-function}:
a collection of functions with similar purpose,
each operating on a different class of data.

*Global environment*{:#global-environment}:
the [environment](#environment) that holds top-level definitions in R,
e.g.,
those written directly in the interpreter.

*Group*{:#group}:
to divide data into subsets according to some criteria
while leaving records in a single structure.

*Handle (a condition)*{:#signal-handle}:
to accept responsibility for handling an error
or other unexpected event.
R prefers "handling a [condition](#condition)"
to "[catching](#catch) an [exception](#exception)".

*Helper (class)*{:#helper}:
in [S3](#S3),
a function that [constructs](#constructor) and [validates](#validator)
an instance of a class.

*Heterogeneous*{:#heterogeneous}:
potentially containing data of different types.
Most vectors in R are [homogeneous](#homogeneous),
but lists can be heterogeneous.

*Higher-order function*{:#higher-order-function}:
a function that takes one or more other functions as parameters.
Higher-order functions such as `map` are commonly used in [functional programming](#functional-programming).

*Homogeneous*{:#homogeneous}:
containing data of only a single type.
Most vectors in R are homogeneous.

*Hubris*{:#hubris}:
excessive pride or self-confidence.
See also [unit test](#unit-test) (lack of).

*ISO3 country code*{:#iso3-country-code}:
a three-letter code defined by ISO 3166-1 that identifies a specific country,
dependent territory,
or other geopolitical entity.

*Lazy evaluation*{:#lazy-evaluation}:
delaying evaluation of an expression until the value is actually needed
(or at least until after the point where it is first encountered).

*List comprehension*{:#list-comprehension}:
an expression that generates a new list from an existing one via an implicit loop.

*Logical indexing*{:#logical-indexing}:
to index a vector or other structure with a vector of Booleans,
keeping only the values that correspond to true values.

*Message*{:#message}:
the least severe type of built-in [condition](#condition) in R.

*Method*{:#method}:
an implementation of a [generic function](#generic-function)
that handles objects of a specific class.

*NA*{:#NA}:
a special value used to represent data that is Not Available.

*Name collision*{:#name-collision}:
a situation in which the same name has been used in two different packages
which are then used together,
leading to ambiguity.

*Negative selection*{:#negative-selection}:
to specify the elements of a vector or other data structure that *aren't* desired
by negating their indices.

*Null*{:#null}:
a special value used to represent a missing object.
`NULL` is not the same as `NA`,
and neither is the same as an [empty vector](#empty-vector).

*Quosure*{:#quosure}:
a data structure containing an unevaluated expression and its environment.

*Quoting function*{:#quoting-function}:
a function that is passed expressions rather than the values of those expressions.

*Package*{:#package}:
a collection of code, data, and documentation
that can be distributed and re-used.

*Pipe operator*{:#pipe-operator}:
the `%>%` used to make the output of one function the input of the next.

*Promise*{:#promise}:
a data structure used to record an unevaluated expression for lazy evaluation.

*Raise (exception)*{:#raise-exception}:
a way of indicating that something has gone wrong in a program,
or that some other unexpected event has occurred.
R prefers "[signalling](#signal) a [condition](#condition)"
to "raising an [exception](#exception)".

*Range expression*{:#range-expression}:
an expression of the form <code><em>low</em>:<em>high</em></code>
that is transformed a sequence of consecutive integers.

*Recycle*{:#recycle}:
to re-use values from a shorter vector in order to generate
a sequence of the same length as a longer one.

*Relative row number*{:#relative-row-number}:
the index of a row in a displayed portion of a table,
which may or may not be the same as the [absolut row number](#absolute-row-number)
within the table.

*Scalar*{:#scalar}:
a single value of a particular type, such as 1 or "a".
Scalars don't really exist in R;
values that appear to be scalars are actually vectors of unit length.

*Select*{:#select}:
to choose entire columns from a table by name or location.

*Setup (testing)*{:#testing-setup}:
code that is automatically run once before each [unit test](#unit-test).

*Signal (a condition)*{:#signal-condition}:
a way of indicating that something has gone wrong in a program,
or that some other unexpected event has occurred.
R prefers "signalling a [condition](#condition)"
to "[raising](#raise) an [exception](#exception)".

*Single square brackets*{:#single-square-brackets}:
an index enclosed in `[...]`,
used to select a structure from another structure.
See also [double square brackets](#double-square-brackets).

*Storage allocation*{:#storage-allocation}:
setting aside a block of memory for future use.

*Teardown (testing)*{:#testing-teardown}:
code that is automatically run once after each [unit test](#unit-test).

*Test fixture*{:#test-fixture}:
the data structures, files, or other artefacts on which a [unit test](#unit-test) operates.

*Test runner*{:#test-runner}:
a software tool that finds and runs [unit tests](#unit-test).

*Tibble*{:#tibble}:
a modern replacement for R's data frame,
which stores tabular data in columns and rows,
defined and used in the [tidyverse](#tidyverse).

*Tidyverse*{:#tidyverse}:
a collection of R packages for operating on tabular data in consistent ways.

*Unit test*{:#unit-test}:
a function that tests one aspect or property of a piece of software.

*Validator (class)*{:#validator}:
a function that checks the consistency of an [S3](#S3) object.

*Variable arguments*{:#variable-arguments}:
in a function,
the ability to take any number of arguments.
R uses `...` to capture the "extra" arguments.

*Vector*{:#vector}:
a sequence of values,
usually of [homogeneous](#homogeneous) type.
Vectors are *the* fundamental data structure in R;
[scalars](#scalar) are actually vectors of unit length.

*Vectorize*{:#vectorize}:
to write code so that operations are performed on entire vectors,
rather than element-by-element within loops.

*Warning*{:#warning}:
a built-in [condition](#condition) in R of middling severity.
