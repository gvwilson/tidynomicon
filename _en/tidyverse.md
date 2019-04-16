---
title: The Tidyverse
output: md_document
questions:
  - "How do I install packages in R?"
  - "How do I load packages in R?"
  - "How do a read a CSV file in R?"
  - "How does R store tabular data?"
  - "How does R decide what data types to use for columns in CSV data?"
  - "How can I inspect tabular data that I have loaded or created?"
  - "How can I select sections of tabular data?"
  - "How can I extract vectors from tables?"
  - "How can I calculate basic statistics on tabular data?"
  - "How does R treat missing data when calculating aggregate statistics?"
  - "How can I control how R treats missing data when calculating aggregate statistics?"
  - "What tools does the tidyverse provide for selecting, rearranging, changing, and summarizing tabular data?"
  - "How should I combine tidyverse operations?"
objectives:
  - "Install and load packages in R."
  - "Read CSV data with R."
  - "Explain what a tibble is and how tibbles related to data frames and matrices."
  - "Describe how `read_csv` infers data types for columns in tabular datasets."
  - "Name and use three functions for inspects tibbles."
  - "Select subsets of tabular data using column names, scalar indices, ranges, and logical expressions."
  - "Explain the difference between indexing with `[` and with `[[`."
  - "Name and use four functions for calculating aggregate statistics on tabular data."
  - "Explain how these functions treat `NA` by default, and how to change that behavior."
  - "Name, describe, and use a tidyverse function for choosing rows by value from tabular data."
  - "Name, describe, and use a tidyverse function for reordering rows of tabular data."
  - "Name, describe, and use a tidyverse function for selecting columns of tabular data."
  - "Name, describe, and use a tidyverse function for calculating new columns from existing ones."
  - "Name, describe, and use a tidyverse function for grouping rows of tabular data."
  - "Name, describe, and use a tidyverse function for aggregating grouped or ungrouped rows of tabular data."
keypoints:
  - "`install.packages('name')` installs packages."
  - "`library(name)` (without quoting the name) loads a package."
  - "`library(tidyverse)` loads the entire collection of tidyverse libraries at once."
  - "`read_csv(filename)` reads CSV files that use the string 'NA' to represent missing values."
  - "`read_csv` infers each column's data types based on the first thousand values it reads."
  - "A tibble is the tidyverse's version of a data frame, which represents tabular data."
  - "`head(tibble)` and `tail(tibble)` inspect the first and last few rows of a tibble."
  - "`summary(tibble)` displays a summary of a tibble's structure and values."
  - "`tibble$column` selects a column from a tibble, returning a vector as a result."
  - "`tibble['column']` selects a column from a tibble, returning a tibble as a result."
  - "`tibble[,c]` selects column `c` from a tibble, returning a tibble as a result."
  - "`tibble[r,]` selects row `r` from a tibble, returning a tibble as a result."
  - "Use ranges and logical vectors as indices to select multiple rows/columns or specific rows/columns from a tibble."
  - "`tibble[[c]]` selects column `c` from a tibble, returning a vector as a result."
  - "`min(...)`, `mean(...)`, `max(...)`, and `std(...)` calculates the minimum, mean, maximum, and standard deviation of data."
  - "These aggregate functions include `NA`s in their calculations, and so will produce `NA` if the input data contains any."
  - "Use `func(data, na.rm = TRUE)` to remove `NA`s from data before calculations are done (but make sure this is statistically justified)."
  - "`filter(tibble, condition)` selects rows from a tibble that pass a logical test on their values."
  - "`arrange(tibble, column)` or `arrange(desc(column))` arrange rows according to values in a column (the latter in descending order)."
  - "`select(tibble, column, column, ...)` selects columns from a tibble."
  - "`select(tibble, -column)` selects *out* a column from a tibble."
  - "`mutate(tibble, name = expression, name = expression, ...)` adds new columns to a tibble using values from existing columns."
  - "`group_by(tibble, column, column, ...)` groups rows that have the same values in the specified columns."
  - "`summarize(tibble, name = expression, name = expression)` aggregates tibble values (by groups if the rows have been grouped)."
  - "`tibble %>% function(arguments)` performs the same operation as `function(tibble, arguments)`."
  - "Use `%>%` to create pipelines in which the left side of each `%>%` becomes the first argument of the next stage."
---



There is no point in becoming fluent in Enochian if you do not then summon a Dweller Beneath at the time of the new moon.
Similarly,
there is no point learning a language designed for data manipulation if you do not then bend data to your will.

## How do I read data?

We begin by looking at the file `tidy/infant_hiv.csv`,
a tidied version of data on the percentage of infants born to women with HIV
who received an HIV test themselves within two months of birth.
The original data comes from the UNICEF site at <https://data.unicef.org/resources/dataset/hiv-aids-statistical-tables/>,
and this file contains:

```text
country,year,estimate,hi,lo
AFG,2009,NA,NA,NA
AFG,2010,NA,NA,NA
...
AFG,2017,NA,NA,NA
AGO,2009,NA,NA,NA
AGO,2010,0.03,0.04,0.02
AGO,2011,0.05,0.07,0.04
AGO,2012,0.06,0.08,0.05
...
ZWE,2016,0.71,0.88,0.62
ZWE,2017,0.65,0.81,0.57
```

The actual file has many more rows and no ellipses.
It uses `NA` to show missing data rather than (for example) `-`, a space, or a blank,
and its values are interpreted as follows:

| Header | Datatype | Description |
|---|---|---|
| country | char | ISO3 country code of country reporting data |
| year | integer | year CE for which data reported |
| estimate | double/NA | estimated percentage of measurement |
| hi | double/NA | high end of range |
| lo | double/NA | low end of range |

We can load this data in Python like this:


```python
import pandas as pd
data = pd.read_csv('tidy/infant_hiv.csv')
print(data)
```

```
     country  year  estimate    hi    lo
0        AFG  2009       NaN   NaN   NaN
1        AFG  2010       NaN   NaN   NaN
2        AFG  2011       NaN   NaN   NaN
3        AFG  2012       NaN   NaN   NaN
4        AFG  2013       NaN   NaN   NaN
5        AFG  2014       NaN   NaN   NaN
6        AFG  2015       NaN   NaN   NaN
7        AFG  2016       NaN   NaN   NaN
8        AFG  2017       NaN   NaN   NaN
9        AGO  2009       NaN   NaN   NaN
10       AGO  2010      0.03  0.04  0.02
11       AGO  2011      0.05  0.07  0.04
12       AGO  2012      0.06  0.08  0.05
13       AGO  2013      0.15  0.20  0.12
14       AGO  2014      0.10  0.14  0.08
15       AGO  2015      0.06  0.08  0.05
16       AGO  2016      0.01  0.02  0.01
17       AGO  2017      0.01  0.02  0.01
18       AIA  2009       NaN   NaN   NaN
...
```

The equivalent in R is to load the [tidyverse](#g:tidyverse) collection of libraries
and then call the `read_csv` function.
We will go through this in stages, since each produces output.


```r
library(tidyverse)
```
```text
Error in library(tidyverse) : there is no package called 'tidyverse'
```

Ah.
We must install this (which we only need to do once per machine) and then load it.
Note that to install, we give `install.packages` a string,
but to use,
we simply give the name of the library we want:


```r
install.packages("tidyverse")
```

```
Error in contrib.url(repos, "source"): trying to use CRAN without setting a mirror
```

```r
library(tidyverse)
```

```
── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
```

```
✔ ggplot2 3.1.0     ✔ readr   1.1.1
✔ tibble  2.0.1     ✔ dplyr   0.7.8
✔ tidyr   0.8.2     ✔ forcats 0.3.0
```

```
Warning: package 'tibble' was built under R version 3.5.2
```

```
── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```

Asking for the tidyverse gives us eight libraries (or [packages](#g:package)).
One of those, dplyr, defines two functions that mask standard functions in R with the same names.
This is deliberate, and if we need the originals, we can get them with their [fully-qualified names](#g:fully-qualified-name)
`stats::filter` and `stats::lag`.
(Note that R uses `::` to get functions out of packages rather than Python's `.`.)

Once we have the tidyverse loaded,
reading the file looks remarkably like reading the file:


```r
data <- read_csv('tidy/infant_hiv.csv')
```

```
Parsed with column specification:
cols(
  country = col_character(),
  year = col_integer(),
  estimate = col_double(),
  hi = col_double(),
  lo = col_double()
)
```

R's `read_csv` tells us more about what it has done than Pandas does.
In particular, it guesses the data types of columns based on the first thousand values
and then tells us what types it has inferred.
(In a better universe,
people would habitually use the first *two* rows of their spreadsheets for name *and units*,
but we do not live there.)

We can now look at what `read_csv` has produced.


```r
data
```

```
# A tibble: 1,728 x 5
   country  year estimate    hi    lo
   <chr>   <int>    <dbl> <dbl> <dbl>
 1 AFG      2009       NA    NA    NA
 2 AFG      2010       NA    NA    NA
 3 AFG      2011       NA    NA    NA
 4 AFG      2012       NA    NA    NA
 5 AFG      2013       NA    NA    NA
 6 AFG      2014       NA    NA    NA
 7 AFG      2015       NA    NA    NA
 8 AFG      2016       NA    NA    NA
 9 AFG      2017       NA    NA    NA
10 AGO      2009       NA    NA    NA
# … with 1,718 more rows
```

This is a [tibble](#g:tibble),
which is the tidyverse's enhanced version of R's `data.frame`.
It organizes data into named columns,
each having one value for each row.

## How do I inspect data?

We often have a quick look at the content of a table to remind ourselves what it contains.
Pandas does this using methods whose names are borrowed from the Unix shell's `head` and `tail` commands:


```python
print(data.head())
```

```
  country  year  estimate  hi  lo
0     AFG  2009       NaN NaN NaN
1     AFG  2010       NaN NaN NaN
2     AFG  2011       NaN NaN NaN
3     AFG  2012       NaN NaN NaN
4     AFG  2013       NaN NaN NaN
```

```python
print(data.tail())
```

```
     country  year  estimate    hi    lo
1723     ZWE  2013      0.57  0.70  0.49
1724     ZWE  2014      0.54  0.67  0.47
1725     ZWE  2015      0.59  0.73  0.51
1726     ZWE  2016      0.71  0.88  0.62
1727     ZWE  2017      0.65  0.81  0.57
```

R has similarly-named functions (not methods):


```r
head(data)
```

```
# A tibble: 6 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 AFG      2009       NA    NA    NA
2 AFG      2010       NA    NA    NA
3 AFG      2011       NA    NA    NA
4 AFG      2012       NA    NA    NA
5 AFG      2013       NA    NA    NA
6 AFG      2014       NA    NA    NA
```

```r
tail(data)
```

```
# A tibble: 6 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 ZWE      2012    0.38   0.47 0.33 
2 ZWE      2013    0.570  0.7  0.49 
3 ZWE      2014    0.54   0.67 0.47 
4 ZWE      2015    0.59   0.73 0.51 
5 ZWE      2016    0.71   0.88 0.62 
6 ZWE      2017    0.65   0.81 0.570
```

Let's have a closer look at that last command's output:


```r
tail(data)
```

```
# A tibble: 6 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 ZWE      2012    0.38   0.47 0.33 
2 ZWE      2013    0.570  0.7  0.49 
3 ZWE      2014    0.54   0.67 0.47 
4 ZWE      2015    0.59   0.73 0.51 
5 ZWE      2016    0.71   0.88 0.62 
6 ZWE      2017    0.65   0.81 0.570
```

Note that the row numbers printed by `tail` are [relative](#g:relative-row-number) to the output,
not [absolute](#g:absolute-row-number) to the table.
This is different from Pandas,
which retains the original row numbers.
(Notice also that R starts numbering from 1.)
What about overall information?


```python
print(data.info())
```

```
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1728 entries, 0 to 1727
Data columns (total 5 columns):
country     1728 non-null object
year        1728 non-null int64
estimate    728 non-null float64
hi          728 non-null float64
lo          728 non-null float64
dtypes: float64(3), int64(1), object(1)
memory usage: 67.6+ KB
None
```


```r
summary(data)
```

```
   country               year         estimate           hi        
 Length:1728        Min.   :2009   Min.   :0.000   Min.   :0.0000  
 Class :character   1st Qu.:2011   1st Qu.:0.100   1st Qu.:0.1400  
 Mode  :character   Median :2013   Median :0.340   Median :0.4350  
                    Mean   :2013   Mean   :0.387   Mean   :0.4614  
                    3rd Qu.:2015   3rd Qu.:0.620   3rd Qu.:0.7625  
                    Max.   :2017   Max.   :0.950   Max.   :0.9500  
                                   NA's   :1000    NA's   :1000    
       lo        
 Min.   :0.0000  
 1st Qu.:0.0800  
 Median :0.2600  
 Mean   :0.3221  
 3rd Qu.:0.5100  
 Max.   :0.9500  
 NA's   :1000    
```

Your display of R's summary may or may not wrap,
depending on how large a screen the older acolytes have allowed you.

## How do I index rows and columns?

A Pandas DataFrame is a collection of series (also called columns),
each containing the values of a single observed variable.
Columns in R tibbles are, not coincidentally, the same.


```python
print(data['estimate'])
```

```
0        NaN
1        NaN
2        NaN
3        NaN
4        NaN
5        NaN
6        NaN
7        NaN
8        NaN
9        NaN
10      0.03
11      0.05
12      0.06
13      0.15
14      0.10
15      0.06
16      0.01
17      0.01
18       NaN
19       NaN
...
```

We would get exactly the same output in Python with `data.estimate`,
i.e.,
with an attribute name rather than a string subscript.
The same tricks work in R:


```r
data['estimate']
```

```
# A tibble: 1,728 x 1
   estimate
      <dbl>
 1       NA
 2       NA
 3       NA
 4       NA
 5       NA
 6       NA
 7       NA
 8       NA
 9       NA
10       NA
# … with 1,718 more rows
```

However, R's `data$estimate` provides all the data:


```r
data$estimate
```

```
   [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.03 0.05 0.06
  [14] 0.15 0.10 0.06 0.01 0.01   NA   NA   NA   NA   NA   NA   NA   NA
  [27]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [40]   NA   NA   NA   NA   NA   NA   NA   NA 0.13 0.12 0.12 0.52 0.53
  [53] 0.67 0.66   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [66]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [79]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.26
  [92] 0.24 0.38 0.55 0.61 0.74 0.83 0.75 0.74   NA 0.10 0.10 0.11 0.18
 [105] 0.12 0.02 0.12 0.20   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [118]   NA   NA 0.10 0.09 0.12 0.26 0.27 0.25 0.32 0.03 0.09 0.13 0.19
 [131] 0.25 0.30 0.28 0.15 0.16   NA 0.02 0.02 0.02 0.03 0.15 0.10 0.17
 [144] 0.14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [157]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [170]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.95 0.95
 [183] 0.95 0.95 0.95 0.95 0.80 0.95 0.87 0.77 0.75 0.72 0.51 0.55 0.50
 [196] 0.62 0.37 0.36 0.07 0.46 0.46 0.46 0.46 0.44 0.43 0.42 0.40 0.25
 [209] 0.25 0.46 0.25 0.45 0.45 0.46 0.46 0.45   NA   NA   NA   NA   NA
 [222]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [235]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.53 0.35 0.36
 [248] 0.48 0.41 0.45 0.47 0.50 0.01 0.01 0.07 0.05 0.03 0.09 0.12 0.21
...
```

Again, note that the boxed number on the left is the start index of that row.

What about single values?
Remembering to count from zero from Python and as humans do for R,
we have:


```python
print(data.estimate[11])
```

```
0.05
```

```r
data$estimate[12]
```

```
[1] 0.05
```

Ah---everything in R is a vector,
so we get a vector of one value as an output rather than a single value.


```python
print(len(data.estimate[11]))
```

```
TypeError: object of type 'numpy.float64' has no len()

Detailed traceback: 
  File "<string>", line 1, in <module>
```

```r
length(data$estimate[12])
```

```
[1] 1
```

And yes, ranges work:


```python
print(data.estimate[5:15])
```

```
5      NaN
6      NaN
7      NaN
8      NaN
9      NaN
10    0.03
11    0.05
12    0.06
13    0.15
14    0.10
Name: estimate, dtype: float64
```

```r
data$estimate[6:15]
```

```
 [1]   NA   NA   NA   NA   NA 0.03 0.05 0.06 0.15 0.10
```

Note that the upper bound is the same, because it's inclusive in R and exclusive in Python.
Note also that neither library prevents us from selecting a range of data that spans logical groups such as countries,
which is why selecting by row number is usually a sign of innocence, insouciance, or desperation.

We can select by column number as well.
Pandas uses the rather clumsy `object.iloc[rows, columns]`, with the usual `:` shortcut for "entire range":


```python
print(data.iloc[:, 0])
```

```
0       AFG
1       AFG
2       AFG
3       AFG
4       AFG
5       AFG
6       AFG
7       AFG
8       AFG
9       AGO
10      AGO
11      AGO
12      AGO
13      AGO
14      AGO
15      AGO
16      AGO
17      AGO
18      AIA
19      AIA
...
```

Since this is a column, it can be indexed:


```python
print(data.iloc[:, 0][0])
```

```
AFG
```

In R, a single index is interpreted as the column index:


```r
data[1]
```

```
# A tibble: 1,728 x 1
   country
   <chr>  
 1 AFG    
 2 AFG    
 3 AFG    
 4 AFG    
 5 AFG    
 6 AFG    
 7 AFG    
 8 AFG    
 9 AFG    
10 AGO    
# … with 1,718 more rows
```

But notice that the output is not a vector, but another tibble (i.e., a table with N rows and one column).
This means that adding another index does column-wise indexing on that tibble:


```r
data[1][1]
```

```
# A tibble: 1,728 x 1
   country
   <chr>  
 1 AFG    
 2 AFG    
 3 AFG    
 4 AFG    
 5 AFG    
 6 AFG    
 7 AFG    
 8 AFG    
 9 AFG    
10 AGO    
# … with 1,718 more rows
```

How then are we to get the first mention of Afghanistan?
The answer is to use [double square brackets](#g:double-square-brackets) to strip away one level of structure:


```r
data[[1]]
```

```
   [1] "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AGO" "AGO"
  [12] "AGO" "AGO" "AGO" "AGO" "AGO" "AGO" "AGO" "AIA" "AIA" "AIA" "AIA"
  [23] "AIA" "AIA" "AIA" "AIA" "AIA" "ALB" "ALB" "ALB" "ALB" "ALB" "ALB"
  [34] "ALB" "ALB" "ALB" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE"
  [45] "ARE" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARM"
  [56] "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ATG" "ATG" "ATG"
  [67] "ATG" "ATG" "ATG" "ATG" "ATG" "ATG" "AUS" "AUS" "AUS" "AUS" "AUS"
  [78] "AUS" "AUS" "AUS" "AUS" "AUT" "AUT" "AUT" "AUT" "AUT" "AUT" "AUT"
  [89] "AUT" "AUT" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE"
 [100] "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BEL" "BEL"
 [111] "BEL" "BEL" "BEL" "BEL" "BEL" "BEL" "BEL" "BEN" "BEN" "BEN" "BEN"
 [122] "BEN" "BEN" "BEN" "BEN" "BEN" "BFA" "BFA" "BFA" "BFA" "BFA" "BFA"
 [133] "BFA" "BFA" "BFA" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD"
 [144] "BGD" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BHR"
 [155] "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHS" "BHS" "BHS"
 [166] "BHS" "BHS" "BHS" "BHS" "BHS" "BHS" "BIH" "BIH" "BIH" "BIH" "BIH"
 [177] "BIH" "BIH" "BIH" "BIH" "BLR" "BLR" "BLR" "BLR" "BLR" "BLR" "BLR"
 [188] "BLR" "BLR" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ"
 [199] "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BRA" "BRA"
 [210] "BRA" "BRA" "BRA" "BRA" "BRA" "BRA" "BRA" "BRB" "BRB" "BRB" "BRB"
...
```

This is now a plain old vector, so it can be indexed with [single square brackets](#g:single-square-brackets):


```r
data[[1]][1]
```

```
[1] "AFG"
```

But that too is a vector, so it can of course be indexed as well (for some value of "of course"):


```r
data[[1]][1][1]
```

```
[1] "AFG"
```

Thus,
`data[1][[1]]` produces a tibble,
then selects the first column vector from it,
so it still gives us a vector.
*This is not madness.*
It is merely...differently sane.


> **Subsetting data frames:**
> When we are working with data frames (including tibbles),
> subsetting with a single vector selects columns, not rows,
> because data frames are stored as lists of columns.
> This means that `df[1:2]` selects two columns from `df`.
> However, in `df[2:3, 1:2]`, the first index selects rows, while the second selects columns.

## How do I calculate basic statistics?

What is the average estimate?
We start by grabbing that column for convenience:


```python
estimates = data.estimate
print(len(estimates))
```

```
1728
```

```python
print(estimates.mean())
```

```
0.3870192307692308
```

This translates almost directly to R:


```r
estimates <- data$estimate
length(estimates)
```

```
[1] 1728
```

```r
mean(estimates)
```

```
[1] NA
```

The void is always there, waiting for us...
Let's fix this in R first:


```r
mean(estimates, na.rm=TRUE)
```

```
[1] 0.3870192
```

And then try to get the statistically correct behavior in Pandas:


```python
print(estimates.mean(skipna=False))
```

```
nan
```

Many functions in R use `na.rm` to control whether `NA`s are removed or not.
(Remember, the `.` character is just another part of the name)
R's default behavior is to leave `NA`s in, and then to include them in [aggregate](#g:aggregation) computations.
Python's is to get rid of missing values early and work with what's left,
which makes translating code from one language to the next much more interesting than it might otherwise be.
But other than that, the statistics works the same way in Python:


```python
print(estimates.min())
```

```
0.0
```

```python
print(estimates.max())
```

```
0.95
```

```python
print(estimates.std())
```

```
0.3034511074214113
```

Here are the equivalent computations in R:


```r
min(estimates, na.rm=TRUE)
```

```
[1] 0
```

```r
max(estimates, na.rm=TRUE)
```

```
[1] 0.95
```

```r
sd(estimates, na.rm=TRUE)
```

```
[1] 0.3034511
```

A good use of aggregation is to check the quality of the data.
For example,
we can ask if there are any records where some of the estimate, the low value, or the high value are missing,
but not all of them:


```python
print((data.hi.isnull() != data.lo.isnull()).any())
```

```
False
```

```r
any(is.na(data$hi) != is.na(data$lo))
```

```
[1] FALSE
```

## How do I filter data?

By "[filtering](#g:filter)", we mean "selecting records by value".
As discussed in [s:basics](#REF),
the simplest approach is to use a vector of logical values to keep only the values corresponding to `TRUE`.
In Python, this is:


```python
maximal = estimates[estimates >= 0.95]
print(len(maximal))
```

```
52
```

And in R:


```r
maximal <- estimates[estimates >= 0.95]
length(maximal)
```

```
[1] 1052
```

The difference is unexpected.
Let's have a closer look at the result in Python:


```python
print(maximal)
```

```
180     0.95
181     0.95
182     0.95
183     0.95
184     0.95
185     0.95
187     0.95
360     0.95
361     0.95
362     0.95
379     0.95
380     0.95
381     0.95
382     0.95
384     0.95
385     0.95
386     0.95
446     0.95
447     0.95
461     0.95
...
```

And in R:


```r
maximal
```

```
   [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [14]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [27]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [40]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [53]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [66]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [79]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [92]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [105]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [118]   NA   NA   NA   NA   NA   NA   NA 0.95 0.95 0.95 0.95 0.95 0.95
 [131] 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [144]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [157]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [170]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [183]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [196]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [209] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95   NA   NA   NA
 [222]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [235]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
 [248]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
...
```

It appears that R has kept the unknown values in order to highlight just how little we know.
More precisely,
wherever there was an `NA` in the original data
there is an `NA` in the logical vector
and hence an `NA` in the final vector.
Let us then turn to `which` to get a vector of indices at which a vector contains `TRUE`.
This function does not return indices for `FALSE` or `NA`:


```r
which(estimates >= 0.95)
```

```
 [1]  181  182  183  184  185  186  188  361  362  363  380  381  382  383
[15]  385  386  387  447  448  462  793  794  795  796  797  798  911  912
[29]  955  956  957  958  959  960  961  962  963 1098 1107 1128 1429 1430
[43] 1462 1554 1604 1607 1625 1626 1627 1629 1708 1710
```

And as a quick check:


```r
length(which(estimates >= 0.95))
```

```
[1] 52
```

So now we can index our vector with the result of the `which`:


```r
maximal <- estimates[which(estimates >= 0.95)]
maximal
```

```
 [1] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
[15] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
[29] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
[43] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
```

But should we do this?
Those `NA`s are important information,
and should not be discarded so blithely.
What we should *really* be doing is using the tools the tidyverse provides
rather than clever indexing tricks.
These behave consistently across a wide scale of problems
and encourage use of patterns that make it easier for others to understand our programs.

## How do I write tidy code?

The five basic data transformation operations in the tidyverse are:

- `filter`: choose observations (rows) by value(s)
- `arrange`: reorder rows
- `select`: choose variables (columns) by name
- `mutate`: derive new variables from existing ones
- `summarize`: combine many values to create a single new value

`filter(tibble, ...criteria...)` keeps rows that pass all of the specified criteria:


```r
filter(data, lo > 0.5)
```

```
# A tibble: 183 x 5
   country  year estimate    hi    lo
   <chr>   <int>    <dbl> <dbl> <dbl>
 1 ARG      2016     0.67  0.77  0.61
 2 ARG      2017     0.66  0.77  0.6 
 3 AZE      2014     0.74  0.95  0.53
 4 AZE      2015     0.83  0.95  0.64
 5 AZE      2016     0.75  0.95  0.56
 6 AZE      2017     0.74  0.95  0.56
 7 BLR      2009     0.95  0.95  0.95
 8 BLR      2010     0.95  0.95  0.95
 9 BLR      2011     0.95  0.95  0.91
10 BLR      2012     0.95  0.95  0.95
# … with 173 more rows
```

Notice that the expression is `lo > 0.5` rather than `"lo" > 0.5`.
The latter expression returns the entire table
because the string `"lo"` is greater than the number 0.5 everywhere.

But wait:
how is it that `lo` can be used on its own?
It is the name of a column, but there is no variable called `lo`.
The answer is that R uses [lazy evaluation](#g:lazy-evaluation) of arguments.
Arguments aren't evaluated until they're needed,
so the function `filter` actually gets the expression `lo > 0.5`,
which allows it to check that there's a column called `lo` and then use it appropriately.
This is much tidier than `filter(data, data$lo > 0.5)` or `filter(data, "lo > 0.5")`,
and is *not* some kind of eldritch wizardry.
Many languages rely on lazy evaluation,
and when used circumspectly,
it allows us to produce code that is easier to read.

But we can do even better by using the [pipe operator](#g:pipe-operator) `%>%`,
which is about to become your new best friend:


```r
data %>% filter(lo > 0.5)
```

```
# A tibble: 183 x 5
   country  year estimate    hi    lo
   <chr>   <int>    <dbl> <dbl> <dbl>
 1 ARG      2016     0.67  0.77  0.61
 2 ARG      2017     0.66  0.77  0.6 
 3 AZE      2014     0.74  0.95  0.53
 4 AZE      2015     0.83  0.95  0.64
 5 AZE      2016     0.75  0.95  0.56
 6 AZE      2017     0.74  0.95  0.56
 7 BLR      2009     0.95  0.95  0.95
 8 BLR      2010     0.95  0.95  0.95
 9 BLR      2011     0.95  0.95  0.91
10 BLR      2012     0.95  0.95  0.95
# … with 173 more rows
```

This may not seem like much of an improvement,
but neither does a Unix pipe consisting of `cat filename.txt | head`.
What about this?


```r
filter(data, (estimate != 0.95) & (lo > 0.5) & (hi <= (lo + 0.1)))
```

```
# A tibble: 1 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 TTO      2017     0.94  0.95  0.86
```

It uses the vectorized "and" operator `&` twice,
and parsing the condition takes a human being at least a few seconds.
Its tidyverse equivalent is:


```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.1))
```

```
# A tibble: 1 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 TTO      2017     0.94  0.95  0.86
```

Breaking the condition into stages like this often makes reading and testing much easier,
and encourages incremental write-test-extend development.

Let's increase the band from 10% to 20%:


```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.2))
```

```
# A tibble: 55 x 5
   country  year estimate    hi    lo
   <chr>   <int>    <dbl> <dbl> <dbl>
 1 ARG      2016     0.67  0.77  0.61
 2 ARG      2017     0.66  0.77  0.6 
 3 CHL      2011     0.64  0.72  0.56
 4 CHL      2013     0.67  0.77  0.59
 5 CHL      2014     0.77  0.87  0.67
 6 CHL      2015     0.92  0.95  0.79
 7 CHL      2016     0.7   0.79  0.62
 8 CHL      2017     0.85  0.95  0.76
 9 CPV      2014     0.94  0.95  0.76
10 CPV      2016     0.94  0.95  0.76
# … with 45 more rows
```

And then order by `lo` in descending order,
breaking the line the way the [tidyverse style guide][tidyverse-style] recommends:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo))
```

```
# A tibble: 55 x 5
   country  year estimate    hi    lo
   <chr>   <int>    <dbl> <dbl> <dbl>
 1 TTO      2017     0.94  0.95  0.86
 2 SWZ      2011     0.93  0.95  0.84
 3 CUB      2014     0.92  0.95  0.83
 4 TTO      2016     0.9   0.95  0.83
 5 CRI      2009     0.92  0.95  0.81
 6 CRI      2012     0.89  0.95  0.81
 7 NAM      2014     0.91  0.95  0.81
 8 URY      2016     0.9   0.95  0.81
 9 ZMB      2014     0.91  0.95  0.81
10 KAZ      2015     0.84  0.95  0.8 
# … with 45 more rows
```

We can now [select](#g:select) the three columns we care about:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(year, lo, hi)
```

```
# A tibble: 55 x 3
    year    lo    hi
   <int> <dbl> <dbl>
 1  2017  0.86  0.95
 2  2011  0.84  0.95
 3  2014  0.83  0.95
 4  2016  0.83  0.95
 5  2009  0.81  0.95
 6  2012  0.81  0.95
 7  2014  0.81  0.95
 8  2016  0.81  0.95
 9  2014  0.81  0.95
10  2015  0.8   0.95
# … with 45 more rows
```

Once again,
we are using the unquoted column names `year`, `lo`, and `hi`
and letting R's lazy evaluation take care of the details for us.

Rather than selecting these three columns,
we can [select *out*](#g:negative-selection) the columns we're not interested in by negating their names.
This leaves the columns that are kept in their original order,
rather than putting `lo` before `hi`,
which won't matter if we later select by name,
but *will* if we ever want to select by position:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(-country, -estimate)
```

```
# A tibble: 55 x 3
    year    hi    lo
   <int> <dbl> <dbl>
 1  2017  0.95  0.86
 2  2011  0.95  0.84
 3  2014  0.95  0.83
 4  2016  0.95  0.83
 5  2009  0.95  0.81
 6  2012  0.95  0.81
 7  2014  0.95  0.81
 8  2016  0.95  0.81
 9  2014  0.95  0.81
10  2015  0.95  0.8 
# … with 45 more rows
```

Giddy with power,
we now add a column containing the difference between the low and high values.
This can be done using either `mutate`,
which adds new columns to the end of an existing tibble,
or with `transmute`,
which creates a new tibble containing only the columns we explicitly ask for.
Since we want to keep `hi` and `lo`,
we decide to use `mutate`:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(-country, -estimate) %>%
  mutate(difference = hi - lo)
```

```
# A tibble: 55 x 4
    year    hi    lo difference
   <int> <dbl> <dbl>      <dbl>
 1  2017  0.95  0.86     0.0900
 2  2011  0.95  0.84     0.110 
 3  2014  0.95  0.83     0.12  
 4  2016  0.95  0.83     0.12  
 5  2009  0.95  0.81     0.140 
 6  2012  0.95  0.81     0.140 
 7  2014  0.95  0.81     0.140 
 8  2016  0.95  0.81     0.140 
 9  2014  0.95  0.81     0.140 
10  2015  0.95  0.8      0.150 
# … with 45 more rows
```

Does the difference between high and low estimates vary by year?
To answer that question,
we use `group_by` to [group](#g:group) records by value
and then `summarize` to aggregate within groups.
We might as well get rid of the `arrange` and `select` calls in our pipeline at this point,
since we're not using them,
and count how many records contributed to each aggregation using `n()`:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  mutate(difference = hi - lo) %>%
  group_by(year) %>%
  summarize(n(), mean(year))
```

```
# A tibble: 9 x 3
   year `n()` `mean(year)`
  <int> <int>        <dbl>
1  2009     3         2009
2  2010     3         2010
3  2011     5         2011
4  2012     5         2012
5  2013     6         2013
6  2014    10         2014
7  2015     6         2015
8  2016    10         2016
9  2017     7         2017
```

Let's do that again with more meaningful names for the final table's columns:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  mutate(difference = hi - lo) %>%
  group_by(year) %>%
  summarize(count = n(), ave_diff = mean(year))
```

```
# A tibble: 9 x 3
   year count ave_diff
  <int> <int>    <dbl>
1  2009     3     2009
2  2010     3     2010
3  2011     5     2011
4  2012     5     2012
5  2013     6     2013
6  2014    10     2014
7  2015     6     2015
8  2016    10     2016
9  2017     7     2017
```

(We could also add a call to `rename`,
but for small tables like this,
setting column names on the fly is perfectly comprehensible.)

Now,
how might we do this with Pandas?
On approach is to use a single multi-part `.query` to select data
and store the result in a variable so that we can refer to the `hi` and `lo` columns twice
without repeating the filtering expression.
We then group by year and aggregate, again using strings for column names:


```python
data = pd.read_csv('tidy/infant_hiv.csv')
data = data.query('(estimate != 0.95) & (lo > 0.5) & (hi <= (lo + 0.2))')
data = data.assign(difference = (data.hi - data.lo))
grouped = data.groupby('year').agg({'difference' : {'ave_diff' : 'mean', 'count' : 'count'}})
```

```
/Users/gvwilson/anaconda3/lib/python3.6/site-packages/pandas/core/groupby/groupby.py:4658: FutureWarning: using a dict with renaming is deprecated and will be removed in a future version
  return super(DataFrameGroupBy, self).aggregate(arg, *args, **kwargs)
```

```python
print(grouped)
```

```
     difference      
       ave_diff count
year                 
2009   0.170000     3
2010   0.186667     3
2011   0.168000     5
2012   0.186000     5
2013   0.183333     6
2014   0.168000    10
2015   0.161667     6
2016   0.166000    10
2017   0.152857     7
```

There are other ways to tackle this problem with Pandas,
but the tidyverse approach produces code that I find more readable.

{% include links.md %}
