---
layout: default
permalink: /
---

<div align="center">
  <h1><em>{{site.title}}</em></h1>
  <h2><em>A Brief Introduction to R for Python Programmers</em></h2>
  <img src="{{'/files/cthulhu-200x177.png' | relative_url}}" />
  <p><em>"Speak not to me of madness, you who count from zero."</em></p>
</div>

{% include toc.html %}

## Audience

**Padma**, 27, has been building performance dashboards for a logistics company using Django and D3.
The company has just hired some data scientists who use R,
and she would like to try building some dashboards in Shiny.
She isn't a statistical expert,
but she's comfortable doing linear regression and basic time series analysis on web traffic,
and now wants to learn enough about R to tidy up the analysts' code and make them shine.

Derived constraints:

- Learners understand loops, conditionals, writing and calling functions, lists, and dictionaries,
  can load and use libraries,
  can use classes and objects,
  but have never used generic functions and will need a refresher on higher-order functions.
- Learners understand mean, variation, correlation, and other basic statistical concepts,
  but are not familiar with advanced machine learning tools.
- Learners are comfortable creating and interpreting plots of various kinds.
- Learners have experience with spreadsheets
  and with writing database queries that use filtering, aggregation, and joins,
  but have not designed database schemas.
- Learners have built web applications
  and are familiar with version control systems and unit testing.
- Learners currently use a text editor like Emacs or Sublime rather than an IDE.
- Learners are willing to spend an hour on the basics of the language,
  both because they understand the utility and as a safety blanket,
  but will then be impatient to start tackling real tasks.

## Learners' Questions

- What are R's basic data types and how do they compare to Python's?
- How do conditionals and loops work in R compared to Python?
- How do indexing and attribute access work in R?
- How do I create functions and libraries?
- How do I find and install libraries and get help on them?
- How do I process text with regular expressions?
- How do I store and manipulate tabular data?
- How do I load a tabular dataset and calculate simple statistics for each column?
- How do I filter, aggregate, and join datasets?
- How do I create plots?
- How do I write readable programs in R?
- How do I test R programs?
- How do I create packages that other people can install?

## Exercises

### Warming Up

These exercises will familiarize you with some of the core features of R.
Do all of the work interactively in RStudio until told to do otherwise.

1.  Create a vector `small` containing the numbers 1 to 5.
2.  Use it to create another vector `large` containing numbers ten times as large.
3.  Use these two vectors to create a third vector `combined` with the sum of the two vectors.
4.  Assign the average and standard deviation of `combined` to `combined_ave` and `combined_std`.
5.  Create a vector `shifted` by subtracting the mean of `combined` from each value of `combined`.
6.  Create a logical vector `mask` showing where values of `shifted` are within one standard deviation of zero.
7.  Increase the magnitude of the values in `shifted` that are within one standard deviation of zero by 10%.
8.  Write a function `fiddle` that takes a non-empty numeric vector as input and performs Steps 2-7 above.
9.  Save your function in a file called `fiddle.R`.
10. Restart RStudio, load the saved function `fiddle`, and apply it to a vector containing the numbers 3 to 7.
11. Apply `fiddle` to an empty vector.
12. Modify the saved version of `fiddle` so that it returns `NULL` if its input is not a non-empty numeric vector.
13. Test your changes by giving `fiddle` a vector with the strings ("3", "4", "5", "6", "7").

### That's Odd

This section explores some of the differences between the features of R and Python.

1.  Explain the difference between `[...]` and `[[...]]`
    and give examples of situations in which they return different results.
2.  Explain what a factor is,
    create factors,
    and loop over the names of the columns in a tibble.
3.  Create a data structure holding the type of each column in a tibble.
    What data structure do you have to use to hold this information and why?
4.  Explain what `matrix(rnorm(n * length(mu), mean = mu), ncol = n)` does and how it does it.

### Selecting, Filtering, and Aggregating Data

Read the CSV data set `solution/infant_hiv.csv` into a tibble.
Use tidyverse functions to answer the following questions:

1. How many distinct countries are in the data?
1. Which countries reported an estimate for 2009?
1. Which countries reported an estimate for every year from 2009 to 2017?
1. What were the average estimates for 2014, 2015, and 2016?
1. How many countries didn't report estimates for one or more years?
1. Which countries never reported a low figure less than 50%?
1. Which countries reported a low figure greater than or equal to the estimate, and in which year(s)?

### Tidying Data

Look at the CSV file `raw/infant_hiv.csv`
(which are taken from the Excel spreadsheet located in the same directory).
Write an R script that tidies this data and store the results in `tidy/infant_hiv.csv`.
Compare your result to the file used in previous exercises.

### Using RStudio

Use RStudio's data importer to read `raw/infant_hiv.csv`.
Using both it and the interactive debugger,
rebuild your previous import script from scratch.

### Making Reusable Code

Look at the three CSV files `maternal_health/raw/*.csv`
(which are taken from the Excel spreadsheet located in the same directory).
Using your solution to the previous exercise as a starting point,
write some helper functions to help you tidy up CSV files that are formatted this way,
and then use those functions in an R script that tidies these three files
and stores the results in `maternal_health/tidy/*.csv`.

### Combining Data

Using the tidied `maternal_health` data files from the previous exercise,
create and save a single tidy data set that has fraction of birth at health facilities,
fraction that have skilled attendants present,
and fraction of Caesarean sections
by country and year.

### Plotting

Using the combined data set created in the previous exercise,
create a scatter plot showing the relationship in each country
between the fraction of births at health facilities
and the fraction that have skilled attendants present,
coloring points according to the fraction of Caesarean sections.
