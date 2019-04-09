---
title: "Glossary"
---

**Absolute row number**{:#g:absolute-row-number}:
:   the sequential index of a row in a table,
    regardless of what sections of the table is being displayed.

**Aggregation**{:#g:aggregation}:
:   to combine many values into one,
    e.g.,
    by summing a set of numbers or concatenating a set of strings.

**Alias**{:#g:alias}:
:   to have two (or more) references to the same physical data.

**Anonymous function**{:#g:anonymous-function}:
:   a function that has not been assigned a name.
    Anonymous functions are usually quite short,
    and are usually defined where they are used,
    e.g.,
    as callbacks.

**Attribute**{:#g:attribute}:
:   a name-value pair associated with an object,
    used to store metadata about the object
    such as an array's dimensions.

**Catch (exception)**{:#g:catch-exception}:
:   to accept responsibility for handling an error
    or other unexpected event.
    R prefers "[handling](#g:handle-condition) a [condition](#g:condition)"
    to "catching an [exception](#g:exception)".

**Condition**{:#g:condition}:
:   an error or other unexpected event that disrupts the normal flow of control.
    See also [handle](#g:handle-condition).

**Constructor (class)**{:#g:constructor}:
:   a function that creates an object of a particular class.
    In the [S3](#g:S3) object system,
    constructors are a convention rather than a requirement.

**Copy-on-modify**{:#g:copy-on-modify}:
:   the practice of creating a new copy of [aliased](#g:alias) data
    whenever there is an attempt to modify it
    so that each reference will believe theirs is the only one.

**Double square brackets**{:#g:double-square-brackets}:
:   an index enclosed in `[[...]]`,
    used to return a single value of the underlying type.
    See also [single square brackets](#g:single-square-brackets).

**Eager evaluation**{:#g:eager-evaluation}:
:   evaluating an expression as soon as it is formed.

**Empty vector**{:#g:empty-vector}:
:   a vector that contains no elements.
    Empty vectors have a type such as logical or character,
    and are *not* the same as [null](#g:null).

**Environment**{:#g:environment}:
:   a structure that stores a set of variable names and the values they refer to.

**Error**{:#g:error}:
:   the most severe type of built-in [condition](#g:condition) in R.

**Evaluating function**{:#g:evaluating-function}:
:   a function that takes arguments as values.
    Most functions are evaluating functions.

**Evaluation**{:#g:evaluation}:
:   the process of taking a complex expression such as `1+2*3/4`
    and turning it into a single irreducible value.

**Exception**{:#g:exception}:
:   an object containing information about an error,
    or the condition that led to the error.
    R prefers "[handling](#g:handle-condition) a [condition](#g:condition)"
    to "[catching](#g:catch-exception) an [exception](#g:exception)".

**Filter**{:#g:filter}:
:   to choose a set of records according to the values they contain.

**Fully qualified name**{:#g:fully-qualified-name}:
:   an unambiguous name of the form <code><em>package</em>::<em>thing</em></code>.

**Functional programming**{:#g:functional-programming}:
:   a style of programming in which functions transform data rather than modifying it.
    Functional programming relies heavily on [higher-order functions](#g:higher-order-function).

**Generic function**{:#g:generic-function}:
:   a collection of functions with similar purpose,
    each operating on a different class of data.

**Global environment**{:#g:global-environment}:
:   the [environment](#g:environment) that holds top-level definitions in R,
    e.g.,
    those written directly in the interpreter.

**Group**{:#g:group}:
:   to divide data into subsets according to some criteria
    while leaving records in a single structure.

**Handle (a condition)**{:#g:handle-condition}:
:   to accept responsibility for handling an error
    or other unexpected event.
    R prefers "handling a [condition](#g:condition)"
    to "[catching](#g:catch-exception) an [exception](#g:exception)".

**Helper (class)**{:#g:helper}:
:   in [S3](#g:S3),
    a function that [constructs](#g:constructor) and [validates](#g:validator)
    an instance of a class.

**Heterogeneous**{:#g:heterogeneous}:
:   potentially containing data of different types.
    Most vectors in R are [homogeneous](#g:homogeneous),
    but lists can be heterogeneous.

**Higher-order function**{:#g:higher-order-function}:
:   a function that takes one or more other functions as parameters.
    Higher-order functions such as `map` are commonly used in [functional programming](#g:functional-programming).

**Homogeneous**{:#g:homogeneous}:
:   containing data of only a single type.
    Most vectors in R are homogeneous.

**Hubris**{:#g:hubris}:
:   excessive pride or self-confidence.
    See also [unit test](#g:unit-test) (lack of).

**ISO3 country code**{:#g:iso3-country-code}:
:   a three-letter code defined by ISO 3166-1 that identifies a specific country,
    dependent territory,
    or other geopolitical entity.

**Lazy evaluation**{:#g:lazy-evaluation}:
:   delaying evaluation of an expression until the value is actually needed
    (or at least until after the point where it is first encountered).

**List comprehension**{:#g:list-comprehension}:
:   an expression that generates a new list from an existing one via an implicit loop.

**Logical indexing**{:#g:logical-indexing}:
:   to index a vector or other structure with a vector of Booleans,
    keeping only the values that correspond to true values.

**Message**{:#g:message}:
:   the least severe type of built-in [condition](#g:condition) in R.

**Method**{:#g:method}:
:   an implementation of a [generic function](#g:generic-function)
    that handles objects of a specific class.

**NA**{:#g:NA}:
:   a special value used to represent data that is Not Available.

**Name collision**{:#g:name-collision}:
:   a situation in which the same name has been used in two different packages
    which are then used together,
    leading to ambiguity.

**Negative selection**{:#g:negative-selection}:
:   to specify the elements of a vector or other data structure that *aren't* desired
    by negating their indices.

**Null**{:#g:null}:
:   a special value used to represent a missing object.
    `NULL` is not the same as `NA`,
    and neither is the same as an [empty vector](#g:empty-vector).

**Package**{:#g:package}:
:   a collection of code, data, and documentation
    that can be distributed and re-used.

**Pipe operator**{:#g:pipe-operator}:
:   the `%>%` used to make the output of one function the input of the next.

**Promise**{:#g:promise}:
:   a data structure used to record an unevaluated expression for lazy evaluation.

**Quosure**{:#g:quosure}:
:   a data structure containing an unevaluated expression and its environment.

**Quoting function**{:#g:quoting-function}:
:   a function that is passed expressions rather than the values of those expressions.

**Raise (exception)**{:#g:raise-exception}:
:   a way of indicating that something has gone wrong in a program,
    or that some other unexpected event has occurred.
    R prefers "[signalling](#g:signal-condition) a [condition](#g:condition)"
    to "raising an [exception](#g:exception)".

**Range expression**{:#g:range-expression}:
:   an expression of the form <code><em>low</em>:<em>high</em></code>
    that is transformed a sequence of consecutive integers.

**Reactive programming**{:#g:reactive-programming}:
:   a style of programming in which actions are triggered by external events.

**Reactive variable**{:#g:reactive-variable}:
:   a variable whose value is automatically updated when some other value or values change.

**Recycle**{:#g:recycle}:
:   to re-use values from a shorter vector in order to generate
    a sequence of the same length as a longer one.

**Relative row number**{:#g:relative-row-number}:
:   the index of a row in a displayed portion of a table,
    which may or may not be the same as the [absolut row number](#g:absolute-row-number)
    within the table.

**S3**{:#g:S3}:
:   a framework for object-oriented programming in R.

**Scalar**{:#g:scalar}:
:   a single value of a particular type, such as 1 or "a".
    Scalars don't really exist in R;
    values that appear to be scalars are actually vectors of unit length.

**Select**{:#g:select}:
:   to choose entire columns from a table by name or location.

**Setup (testing)**{:#g:testing-setup}:
:   code that is automatically run once before each [unit test](#g:unit-test).

**Signal (a condition)**{:#g:signal-condition}:
:   a way of indicating that something has gone wrong in a program,
    or that some other unexpected event has occurred.
    R prefers "signalling a [condition](#g:condition)"
    to "[raising](#g:raise-exception) an [exception](#g:exception)".

**Single square brackets**{:#g:single-square-brackets}:
:   an index enclosed in `[...]`,
    used to select a structure from another structure.
    See also [double square brackets](#g:double-square-brackets).

**Storage allocation**{:#g:storage-allocation}:
:   setting aside a block of memory for future use.

**Teardown (testing)**{:#g:testing-teardown}:
:   code that is automatically run once after each [unit test](#g:unit-test).

**Test fixture**{:#g:test-fixture}:
:   the data structures, files, or other artefacts on which a [unit test](#g:unit-test) operates.

**Test runner**{:#g:test-runner}:
:   a software tool that finds and runs [unit tests](#g:unit-test).

**Tibble**{:#g:tibble}:
:   a modern replacement for R's data frame,
    which stores tabular data in columns and rows,
    defined and used in the [tidyverse](#g:tidyverse).

**Tidyverse**{:#g:tidyverse}:
:   a collection of R packages for operating on tabular data in consistent ways.

**Unit test**{:#g:unit-test}:
:   a function that tests one aspect or property of a piece of software.

**Validator (class)**{:#g:validator}:
:   a function that checks the consistency of an [S3](#g:S3) object.

**Variable arguments**{:#g:variable-arguments}:
:   in a function,
    the ability to take any number of arguments.
    R uses `...` to capture the "extra" arguments.

**Vector**{:#g:vector}:
:   a sequence of values,
    usually of [homogeneous](#g:homogeneous) type.
    Vectors are *the* fundamental data structure in R;
    [scalars](#g:scalar) are actually vectors of unit length.

**Vectorize**{:#g:vectorize}:
:   to write code so that operations are performed on entire vectors,
    rather than element-by-element within loops.

**Warning**{:#g:warning}:
:   a built-in [condition](#g:condition) in R of middling severity.

**Widget**{:#g:widget}:
:   an interactive control element in an user interface.

{% include links.md %}
