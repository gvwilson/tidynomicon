---
title: The Tidyverse
output: md_document
permalink: /tidyverse/
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

## Reading Data

We begin by looking at the file `tidy/infant_hiv.csv`,
a tidied version of data on the percentage of infants born to women with HIV
who received an HIV test themselves within two months of birth.
The original data comes from the UNICEF site at <https://data.unicef.org/resources/dataset/hiv-aids-statistical-tables/>,
and this file contains:

```
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


```python
import pandas as pd
data = pd.read_csv('tidy/infant_hiv.csv')
print(data)
```

```
##      country  year  estimate    hi    lo
## 0        AFG  2009       NaN   NaN   NaN
## 1        AFG  2010       NaN   NaN   NaN
## 2        AFG  2011       NaN   NaN   NaN
## 3        AFG  2012       NaN   NaN   NaN
## 4        AFG  2013       NaN   NaN   NaN
## 5        AFG  2014       NaN   NaN   NaN
## 6        AFG  2015       NaN   NaN   NaN
## 7        AFG  2016       NaN   NaN   NaN
## 8        AFG  2017       NaN   NaN   NaN
## 9        AGO  2009       NaN   NaN   NaN
## 10       AGO  2010      0.03  0.04  0.02
## 11       AGO  2011      0.05  0.07  0.04
## 12       AGO  2012      0.06  0.08  0.05
## 13       AGO  2013      0.15  0.20  0.12
## 14       AGO  2014      0.10  0.14  0.08
## 15       AGO  2015      0.06  0.08  0.05
## 16       AGO  2016      0.01  0.02  0.01
## 17       AGO  2017      0.01  0.02  0.01
## 18       AIA  2009       NaN   NaN   NaN
## 19       AIA  2010       NaN   NaN   NaN
## 20       AIA  2011       NaN   NaN   NaN
## 21       AIA  2012       NaN   NaN   NaN
## 22       AIA  2013       NaN   NaN   NaN
## 23       AIA  2014       NaN   NaN   NaN
## 24       AIA  2015       NaN   NaN   NaN
## 25       AIA  2016       NaN   NaN   NaN
## 26       AIA  2017       NaN   NaN   NaN
## 27       ALB  2009       NaN   NaN   NaN
## 28       ALB  2010       NaN   NaN   NaN
## 29       ALB  2011       NaN   NaN   NaN
## ...      ...   ...       ...   ...   ...
## 1698     YEM  2015       NaN   NaN   NaN
## 1699     YEM  2016       NaN   NaN   NaN
## 1700     YEM  2017       NaN   NaN   NaN
## 1701     ZAF  2009       NaN   NaN   NaN
## 1702     ZAF  2010      0.66  0.88  0.56
## 1703     ZAF  2011      0.65  0.86  0.54
## 1704     ZAF  2012      0.89  0.95  0.75
## 1705     ZAF  2013      0.75  0.95  0.63
## 1706     ZAF  2014      0.86  0.95  0.73
## 1707     ZAF  2015      0.95  0.95  0.95
## 1708     ZAF  2016      0.79  0.95  0.67
## 1709     ZAF  2017      0.95  0.95  0.85
## 1710     ZMB  2009      0.59  0.70  0.53
## 1711     ZMB  2010      0.27  0.32  0.24
## 1712     ZMB  2011      0.70  0.84  0.63
## 1713     ZMB  2012      0.74  0.88  0.67
## 1714     ZMB  2013      0.64  0.76  0.57
## 1715     ZMB  2014      0.91  0.95  0.81
## 1716     ZMB  2015      0.43  0.52  0.39
## 1717     ZMB  2016      0.43  0.51  0.39
## 1718     ZMB  2017      0.46  0.54  0.41
## 1719     ZWE  2009       NaN   NaN   NaN
## 1720     ZWE  2010      0.12  0.15  0.10
## 1721     ZWE  2011      0.23  0.28  0.20
## 1722     ZWE  2012      0.38  0.47  0.33
## 1723     ZWE  2013      0.57  0.70  0.49
## 1724     ZWE  2014      0.54  0.67  0.47
## 1725     ZWE  2015      0.59  0.73  0.51
## 1726     ZWE  2016      0.71  0.88  0.62
## 1727     ZWE  2017      0.65  0.81  0.57
## 
## [1728 rows x 5 columns]
```

The equivalent in R is to load the [tidyverse](../glossary/#tidyverse) collection of libraries
and then call the `read_csv` function.
We will go through this in stages, since each produces output.


```r
library(tidyverse)
```
```
Error in library(tidyverse) : there is no package called ‘tidyverse’
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
## Error in contrib.url(repos, "source"): trying to use CRAN without setting a mirror
```

```r
library(tidyverse)
```

Asking for the tidyverse gives us eight libraries (or packages](../glossary/#package)).
One of those, dplyr, defines two functions that mask standard functions in R with the same names.
This is deliberate, and if we need the originals, we can get them with their [fully-qualified names](../glossary/#fully-qualified-name)
`stats::filter` and `stats::lag`.
(Note that R uses `::` to get functions out of packages rather than Python's `.`.)

Once we have the tidyverse loaded,
reading the file looks remarkably like reading the file:


```r
data <- read_csv('tidy/infant_hiv.csv')
```

```
## Parsed with column specification:
## cols(
##   country = col_character(),
##   year = col_integer(),
##   estimate = col_double(),
##   hi = col_double(),
##   lo = col_double()
## )
```

R's `read_csv` tells us more about what it has done than Pandas does.
In particular, it guesses at columns' data types based on the first thousand values,
and then tells us what types it has inferred.
(In a better universe,
people habitually use the first *two* rows of their spreadsheets for name *and units*,
but we do not live there.)

We can now look at what `read_csv` has produced.


```r
data
```

```
## # A tibble: 1,728 x 5
##    country  year estimate    hi    lo
##    <chr>   <int>    <dbl> <dbl> <dbl>
##  1 AFG      2009       NA    NA    NA
##  2 AFG      2010       NA    NA    NA
##  3 AFG      2011       NA    NA    NA
##  4 AFG      2012       NA    NA    NA
##  5 AFG      2013       NA    NA    NA
##  6 AFG      2014       NA    NA    NA
##  7 AFG      2015       NA    NA    NA
##  8 AFG      2016       NA    NA    NA
##  9 AFG      2017       NA    NA    NA
## 10 AGO      2009       NA    NA    NA
## # ... with 1,718 more rows
```

This is a [tibble](../glossary/#tibble),
which is the tidyverse's enhanced version of R's `data.frame`.
It organizes data into named columns,
each having one value for each row.

## Data Inspection

We often have a quick look at the content of a table to remind ourselves what it contains.
Pandas does this using methods whose names are borrowed from the Unix shell's `head` and `tail` commands:


```python
print(data.head())
```

```
##   country  year  estimate  hi  lo
## 0     AFG  2009       NaN NaN NaN
## 1     AFG  2010       NaN NaN NaN
## 2     AFG  2011       NaN NaN NaN
## 3     AFG  2012       NaN NaN NaN
## 4     AFG  2013       NaN NaN NaN
```

```python
print(data.tail())
```

```
##      country  year  estimate    hi    lo
## 1723     ZWE  2013      0.57  0.70  0.49
## 1724     ZWE  2014      0.54  0.67  0.47
## 1725     ZWE  2015      0.59  0.73  0.51
## 1726     ZWE  2016      0.71  0.88  0.62
## 1727     ZWE  2017      0.65  0.81  0.57
```

R has similarly-named functions (not methods):


```r
head(data)
```

```
## # A tibble: 6 x 5
##   country  year estimate    hi    lo
##   <chr>   <int>    <dbl> <dbl> <dbl>
## 1 AFG      2009       NA    NA    NA
## 2 AFG      2010       NA    NA    NA
## 3 AFG      2011       NA    NA    NA
## 4 AFG      2012       NA    NA    NA
## 5 AFG      2013       NA    NA    NA
## 6 AFG      2014       NA    NA    NA
```

```r
tail(data)
```

```
## # A tibble: 6 x 5
##   country  year estimate    hi    lo
##   <chr>   <int>    <dbl> <dbl> <dbl>
## 1 ZWE      2012    0.38   0.47 0.33 
## 2 ZWE      2013    0.570  0.7  0.49 
## 3 ZWE      2014    0.54   0.67 0.47 
## 4 ZWE      2015    0.59   0.73 0.51 
## 5 ZWE      2016    0.71   0.88 0.62 
## 6 ZWE      2017    0.65   0.81 0.570
```

Let's have a closer look at that last command's output:


```r
tail(data)
```

```
## # A tibble: 6 x 5
##   country  year estimate    hi    lo
##   <chr>   <int>    <dbl> <dbl> <dbl>
## 1 ZWE      2012    0.38   0.47 0.33 
## 2 ZWE      2013    0.570  0.7  0.49 
## 3 ZWE      2014    0.54   0.67 0.47 
## 4 ZWE      2015    0.59   0.73 0.51 
## 5 ZWE      2016    0.71   0.88 0.62 
## 6 ZWE      2017    0.65   0.81 0.570
```

Note that the row numbers printed by `tail` are [relative](../glossary/#relative-line-number) to the output,
not [absolute](../glossary/#absolute-line-number) to the table.
This is different from Pandas,
which retains the original row numbers.
(Notice also that R starts numbering from 1.)
What about overall information?


```python
print(data.info())
```

```
## <class 'pandas.core.frame.DataFrame'>
## RangeIndex: 1728 entries, 0 to 1727
## Data columns (total 5 columns):
## country     1728 non-null object
## year        1728 non-null int64
## estimate    728 non-null float64
## hi          728 non-null float64
## lo          728 non-null float64
## dtypes: float64(3), int64(1), object(1)
## memory usage: 67.6+ KB
## None
```


```r
summary(data)
```

```
##    country               year         estimate           hi        
##  Length:1728        Min.   :2009   Min.   :0.000   Min.   :0.0000  
##  Class :character   1st Qu.:2011   1st Qu.:0.100   1st Qu.:0.1400  
##  Mode  :character   Median :2013   Median :0.340   Median :0.4350  
##                     Mean   :2013   Mean   :0.387   Mean   :0.4614  
##                     3rd Qu.:2015   3rd Qu.:0.620   3rd Qu.:0.7625  
##                     Max.   :2017   Max.   :0.950   Max.   :0.9500  
##                                    NA's   :1000    NA's   :1000    
##        lo        
##  Min.   :0.0000  
##  1st Qu.:0.0800  
##  Median :0.2600  
##  Mean   :0.3221  
##  3rd Qu.:0.5100  
##  Max.   :0.9500  
##  NA's   :1000
```

Your display of R's summary may or may not wrap,
depending on how large a screen the older acolytes have allowed you.

## Indexing

A Pandas DataFrame is a collection of series (also called columns),
each containing the values of a single observed variable.
Columns in R tibbles are, not coincidentally, the same.


```python
print(data['estimate'])
```

```
## 0        NaN
## 1        NaN
## 2        NaN
## 3        NaN
## 4        NaN
## 5        NaN
## 6        NaN
## 7        NaN
## 8        NaN
## 9        NaN
## 10      0.03
## 11      0.05
## 12      0.06
## 13      0.15
## 14      0.10
## 15      0.06
## 16      0.01
## 17      0.01
## 18       NaN
## 19       NaN
## 20       NaN
## 21       NaN
## 22       NaN
## 23       NaN
## 24       NaN
## 25       NaN
## 26       NaN
## 27       NaN
## 28       NaN
## 29       NaN
##         ... 
## 1698     NaN
## 1699     NaN
## 1700     NaN
## 1701     NaN
## 1702    0.66
## 1703    0.65
## 1704    0.89
## 1705    0.75
## 1706    0.86
## 1707    0.95
## 1708    0.79
## 1709    0.95
## 1710    0.59
## 1711    0.27
## 1712    0.70
## 1713    0.74
## 1714    0.64
## 1715    0.91
## 1716    0.43
## 1717    0.43
## 1718    0.46
## 1719     NaN
## 1720    0.12
## 1721    0.23
## 1722    0.38
## 1723    0.57
## 1724    0.54
## 1725    0.59
## 1726    0.71
## 1727    0.65
## Name: estimate, Length: 1728, dtype: float64
```

We would get exactly the same output in Python with `data.estimate`,
i.e.,
with an attribute name rather than a string subscript.
The same tricks work in R:


```r
data['estimate']
```

```
## # A tibble: 1,728 x 1
##    estimate
##       <dbl>
##  1       NA
##  2       NA
##  3       NA
##  4       NA
##  5       NA
##  6       NA
##  7       NA
##  8       NA
##  9       NA
## 10       NA
## # ... with 1,718 more rows
```

However, R's `data$estimate` provides all the data:


```r
data$estimate
```

```
##    [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.03 0.05 0.06
##   [14] 0.15 0.10 0.06 0.01 0.01   NA   NA   NA   NA   NA   NA   NA   NA
##   [27]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [40]   NA   NA   NA   NA   NA   NA   NA   NA 0.13 0.12 0.12 0.52 0.53
##   [53] 0.67 0.66   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [66]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [79]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.26
##   [92] 0.24 0.38 0.55 0.61 0.74 0.83 0.75 0.74   NA 0.10 0.10 0.11 0.18
##  [105] 0.12 0.02 0.12 0.20   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [118]   NA   NA 0.10 0.09 0.12 0.26 0.27 0.25 0.32 0.03 0.09 0.13 0.19
##  [131] 0.25 0.30 0.28 0.15 0.16   NA 0.02 0.02 0.02 0.03 0.15 0.10 0.17
##  [144] 0.14   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [157]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [170]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.95 0.95
##  [183] 0.95 0.95 0.95 0.95 0.80 0.95 0.87 0.77 0.75 0.72 0.51 0.55 0.50
##  [196] 0.62 0.37 0.36 0.07 0.46 0.46 0.46 0.46 0.44 0.43 0.42 0.40 0.25
##  [209] 0.25 0.46 0.25 0.45 0.45 0.46 0.46 0.45   NA   NA   NA   NA   NA
##  [222]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [235]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.53 0.35 0.36
##  [248] 0.48 0.41 0.45 0.47 0.50 0.01 0.01 0.07 0.05 0.03 0.09 0.12 0.21
##  [261] 0.23   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [274]   NA   NA   NA   NA   NA   NA   NA   NA 0.64 0.56 0.67 0.77 0.92
##  [287] 0.70 0.85   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.22
##  [300] 0.03 0.19 0.12 0.33 0.28 0.39 0.40 0.27 0.20 0.25 0.30 0.32 0.36
##  [313] 0.33 0.53 0.51   NA 0.03 0.05 0.07 0.10 0.14 0.16 0.20 0.34 0.08
##  [326] 0.07 0.03 0.05 0.04 0.00 0.01 0.02 0.03   NA   NA   NA   NA   NA
##  [339]   NA   NA   NA   NA 0.05 0.10 0.18 0.22 0.30 0.37 0.45 0.44 0.48
##  [352]   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.95 0.95 0.95 0.76
##  [365] 0.85 0.94 0.70 0.94 0.93 0.92 0.69 0.66 0.89 0.66 0.78 0.79 0.64
##  [378] 0.71 0.83 0.95 0.95 0.95 0.95 0.92 0.95 0.95 0.95   NA   NA   NA
##  [391]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [404]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [417] 0.02 0.08 0.08 0.02 0.08 0.10 0.10   NA   NA   NA   NA   NA   NA
##  [430]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.28
##  [443] 0.10 0.43 0.46 0.64 0.95 0.95 0.72 0.80   NA   NA 0.38 0.23 0.55
##  [456] 0.27 0.23 0.33 0.61 0.01 0.01 0.95 0.87 0.21 0.87 0.54 0.70 0.69
##  [469] 0.04 0.05 0.04 0.04 0.04 0.05 0.07 0.10 0.11   NA   NA   NA   NA
##  [482] 0.27 0.39 0.36 0.39 0.15   NA   NA   NA   NA   NA   NA   NA   NA
##  [495]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.04 0.40 0.15
##  [508] 0.24 0.24 0.25 0.31 0.45 0.38   NA   NA   NA   NA   NA   NA   NA
##  [521]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [534]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [547]   NA   NA   NA   NA 0.06 0.27 0.28 0.16 0.20 0.24 0.24 0.04   NA
##  [560]   NA   NA   NA   NA   NA   NA   NA   NA 0.61 0.82 0.69 0.62 0.58
##  [573] 0.74 0.77 0.79 0.84   NA 0.01 0.11 0.09 0.19 0.15 0.20 0.31 0.30
##  [586]   NA 0.05 0.06 0.00 0.06 0.07 0.04 0.39 0.11   NA   NA   NA   NA
##  [599]   NA 0.08 0.11 0.12 0.12   NA   NA 0.00 0.03 0.05 0.24 0.35 0.36
##  [612] 0.36   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [625]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [638]   NA   NA   NA   NA 0.19 0.17 0.11 0.15 0.15 0.15 0.17   NA 0.27
##  [651] 0.47 0.38 0.32 0.60 0.55 0.54 0.53 0.61 0.69 0.89 0.43 0.47 0.49
##  [664] 0.40 0.60 0.59   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [677]   NA 0.04 0.39 0.35 0.36 0.32 0.35 0.40   NA   NA   NA   NA   NA
##  [690]   NA   NA   NA   NA   NA   NA   NA   NA 0.04 0.05 0.06 0.02 0.01
##  [703]   NA 0.06 0.07 0.08 0.09 0.10 0.25 0.27 0.23   NA   NA   NA   NA
##  [716]   NA   NA   NA   NA   NA 0.02 0.13 0.03 0.09 0.12 0.15 0.20 0.23
##  [729] 0.31   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [742]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [755]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [768] 0.63   NA 0.68 0.59   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [781]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.95
##  [794] 0.95 0.95 0.95 0.95 0.95 0.84 0.76 0.82   NA 0.75 0.46 0.45 0.45
##  [807] 0.74 0.51 0.56 0.51   NA   NA 0.03 0.11 0.11 0.38 0.33 0.66 0.70
##  [820]   NA 0.45 0.62 0.34 0.37 0.37 0.79 0.74 0.64   NA   NA   NA   NA
##  [833]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [846]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.01 0.08
##  [859] 0.06 0.10 0.03 0.03 0.07 0.07   NA   NA   NA   NA   NA   NA   NA
##  [872]   NA   NA 0.05 0.05 0.17 0.28 0.31 0.13   NA   NA   NA   NA   NA
##  [885]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [898]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.43
##  [911] 0.95 0.95 0.70 0.47 0.51 0.87 0.58 0.51   NA   NA   NA   NA   NA
##  [924]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [937]   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.02 0.21 0.21 0.68
##  [950] 0.65 0.62 0.61 0.59 0.57 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
##  [963] 0.95   NA   NA 0.00 0.01   NA   NA   NA   NA   NA   NA   NA   NA
##  [976]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [989]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1002]   NA   NA   NA   NA   NA   NA   NA 0.08 0.08 0.08 0.10 0.08 0.06
## [1015] 0.03 0.11 0.11   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1028] 0.01 0.04 0.05 0.09 0.12 0.15 0.26 0.28   NA   NA   NA   NA   NA
## [1041]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1054]   NA 0.31 0.36 0.30 0.31 0.38 0.41 0.44 0.50   NA   NA   NA   NA
## [1067]   NA   NA   NA 0.08 0.08   NA   NA   NA   NA   NA   NA   NA   NA
## [1080]   NA   NA   NA   NA 0.06 0.17 0.21 0.20 0.31 0.52 0.37 0.61 0.68
## [1093] 0.68 0.77 0.87 0.75 0.69 0.95   NA 0.57 0.85 0.59 0.55 0.91 0.17
## [1106] 0.53 0.95   NA   NA   NA 0.01 0.09 0.02 0.11 0.05 0.10 0.04 0.06
## [1119] 0.07 0.06 0.05 0.06 0.10 0.11 0.12 0.50 0.38 0.95 0.47 0.57 0.51
## [1132] 0.65 0.60 0.75   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1145]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1158]   NA   NA   NA   NA 0.02 0.03 0.05 0.09 0.05 0.08 0.21 0.26 0.45
## [1171]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1184]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1197]   NA 0.01 0.01 0.01 0.00 0.01 0.01 0.00 0.00 0.01   NA 0.30 0.39
## [1210] 0.20 0.39 0.45 0.55 0.51 0.49   NA   NA 0.13 0.25 0.36 0.29 0.63
## [1223] 0.41 0.78 0.01 0.03 0.05 0.03 0.00 0.02 0.03 0.04 0.05   NA   NA
## [1236]   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.23 0.18 0.53 0.30
## [1249] 0.37 0.36 0.35   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1262]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1275]   NA   NA   NA   NA   NA 0.27 0.34 0.50 0.39 0.38 0.47 0.52 0.52
## [1288]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1301]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.64 0.58 0.54
## [1314] 0.84 0.58 0.73 0.74 0.81 0.83 0.87 0.84 0.90 0.85   NA   NA   NA
## [1327]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1340]   NA   NA 0.11 0.11 0.09 0.10 0.12 0.12 0.16 0.13 0.23   NA   NA
## [1353]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1366]   NA   NA   NA   NA 0.01 0.01 0.02 0.25 0.02 0.03 0.06 0.07   NA
## [1379] 0.28 0.28 0.02 0.31 0.40 0.40 0.35 0.34   NA   NA   NA   NA   NA
## [1392]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1405]   NA   NA   NA   NA   NA   NA 0.01 0.03 0.10   NA   NA   NA   NA
## [1418]   NA   NA   NA   NA   NA 0.09 0.09 0.09 0.34 0.58 0.81 0.95 0.95
## [1431] 0.67   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1444]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1457]   NA   NA   NA 0.50 0.93 0.95 0.87 0.84 0.88 0.82 0.81   NA   NA
## [1470]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1483]   NA   NA   NA   NA 0.03 0.02 0.06 0.06 0.07 0.05 0.05 0.05 0.07
## [1496] 0.14 0.05 0.11 0.11 0.16 0.17 0.36 0.36   NA 0.54 0.56 0.64 0.68
## [1509] 0.70 0.92 0.92 0.94 0.01 0.04 0.08 0.11 0.14 0.14 0.30 0.21 0.43
## [1522]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1535]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1548]   NA   NA   NA   NA 0.37 0.50 0.95 0.83 0.90 0.94   NA   NA 0.16
## [1561] 0.14 0.18 0.33 0.40 0.31 0.13   NA   NA   NA   NA   NA   NA   NA
## [1574]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.13 0.24
## [1587] 0.30 0.29 0.29 0.39 0.38 0.39 0.36 0.08 0.13 0.38 0.45 0.50 0.69
## [1600] 0.43 0.35 0.48 0.78 0.95 0.81 0.88 0.95 0.78 0.47 0.55 0.48   NA
## [1613]   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.62 0.68 0.85 0.95
## [1626] 0.95 0.95 0.90 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1639] 0.00 0.12 0.58 0.54 0.48 0.84 0.76 0.74 0.56   NA   NA   NA   NA
## [1652]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1665]   NA   NA   NA 0.31 0.30 0.63 0.41 0.49 0.49 0.31   NA   NA   NA
## [1678]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1691]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.66
## [1704] 0.65 0.89 0.75 0.86 0.95 0.79 0.95 0.59 0.27 0.70 0.74 0.64 0.91
## [1717] 0.43 0.43 0.46   NA 0.12 0.23 0.38 0.57 0.54 0.59 0.71 0.65
```

Again, note that the boxed number on the left is the start index of that row.

What about single values?
Remembering to count from zero from Python and as humans do for R,
we have:


```python
print(data.estimate[11])
```

```
## 0.05
```

```r
data$estimate[12]
```

```
## [1] 0.05
```

Ah—everything in R is a vector,
so we get a vector of one value as an output rather than a single value.


```python
print(len(data.estimate[11]))
```

```
## TypeError: object of type 'numpy.float64' has no len()
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
```

```r
length(data$estimate[12])
```

```
## [1] 1
```

And yes, ranges work:


```python
print(data.estimate[5:15])
```

```
## 5      NaN
## 6      NaN
## 7      NaN
## 8      NaN
## 9      NaN
## 10    0.03
## 11    0.05
## 12    0.06
## 13    0.15
## 14    0.10
## Name: estimate, dtype: float64
```

```r
data$estimate[6:15]
```

```
##  [1]   NA   NA   NA   NA   NA 0.03 0.05 0.06 0.15 0.10
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
## 0       AFG
## 1       AFG
## 2       AFG
## 3       AFG
## 4       AFG
## 5       AFG
## 6       AFG
## 7       AFG
## 8       AFG
## 9       AGO
## 10      AGO
## 11      AGO
## 12      AGO
## 13      AGO
## 14      AGO
## 15      AGO
## 16      AGO
## 17      AGO
## 18      AIA
## 19      AIA
## 20      AIA
## 21      AIA
## 22      AIA
## 23      AIA
## 24      AIA
## 25      AIA
## 26      AIA
## 27      ALB
## 28      ALB
## 29      ALB
##        ... 
## 1698    YEM
## 1699    YEM
## 1700    YEM
## 1701    ZAF
## 1702    ZAF
## 1703    ZAF
## 1704    ZAF
## 1705    ZAF
## 1706    ZAF
## 1707    ZAF
## 1708    ZAF
## 1709    ZAF
## 1710    ZMB
## 1711    ZMB
## 1712    ZMB
## 1713    ZMB
## 1714    ZMB
## 1715    ZMB
## 1716    ZMB
## 1717    ZMB
## 1718    ZMB
## 1719    ZWE
## 1720    ZWE
## 1721    ZWE
## 1722    ZWE
## 1723    ZWE
## 1724    ZWE
## 1725    ZWE
## 1726    ZWE
## 1727    ZWE
## Name: country, Length: 1728, dtype: object
```

Since this is a column, it can be indexed:


```python
print(data.iloc[:, 0][0])
```

```
## AFG
```

In R, a single index is interpreted as the column index:


```r
data[1]
```

```
## # A tibble: 1,728 x 1
##    country
##    <chr>  
##  1 AFG    
##  2 AFG    
##  3 AFG    
##  4 AFG    
##  5 AFG    
##  6 AFG    
##  7 AFG    
##  8 AFG    
##  9 AFG    
## 10 AGO    
## # ... with 1,718 more rows
```

But notice that the output is not a vector, but another tibble (i.e., an N-row, 1-column structure).
This means that adding another index does column-wise indexing on that tibble:


```r
data[1][1]
```

```
## # A tibble: 1,728 x 1
##    country
##    <chr>  
##  1 AFG    
##  2 AFG    
##  3 AFG    
##  4 AFG    
##  5 AFG    
##  6 AFG    
##  7 AFG    
##  8 AFG    
##  9 AFG    
## 10 AGO    
## # ... with 1,718 more rows
```

How then are we to get the first mention of Afghanistan?
The answer is to use [double square brackets](../glossary/#double-square-brackets) to strip away one level of structure:


```r
data[[1]]
```

```
##    [1] "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AGO" "AGO"
##   [12] "AGO" "AGO" "AGO" "AGO" "AGO" "AGO" "AGO" "AIA" "AIA" "AIA" "AIA"
##   [23] "AIA" "AIA" "AIA" "AIA" "AIA" "ALB" "ALB" "ALB" "ALB" "ALB" "ALB"
##   [34] "ALB" "ALB" "ALB" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE" "ARE"
##   [45] "ARE" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARG" "ARM"
##   [56] "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ARM" "ATG" "ATG" "ATG"
##   [67] "ATG" "ATG" "ATG" "ATG" "ATG" "ATG" "AUS" "AUS" "AUS" "AUS" "AUS"
##   [78] "AUS" "AUS" "AUS" "AUS" "AUT" "AUT" "AUT" "AUT" "AUT" "AUT" "AUT"
##   [89] "AUT" "AUT" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE" "AZE"
##  [100] "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BDI" "BEL" "BEL"
##  [111] "BEL" "BEL" "BEL" "BEL" "BEL" "BEL" "BEL" "BEN" "BEN" "BEN" "BEN"
##  [122] "BEN" "BEN" "BEN" "BEN" "BEN" "BFA" "BFA" "BFA" "BFA" "BFA" "BFA"
##  [133] "BFA" "BFA" "BFA" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD" "BGD"
##  [144] "BGD" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BGR" "BHR"
##  [155] "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHR" "BHS" "BHS" "BHS"
##  [166] "BHS" "BHS" "BHS" "BHS" "BHS" "BHS" "BIH" "BIH" "BIH" "BIH" "BIH"
##  [177] "BIH" "BIH" "BIH" "BIH" "BLR" "BLR" "BLR" "BLR" "BLR" "BLR" "BLR"
##  [188] "BLR" "BLR" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ" "BLZ"
##  [199] "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BOL" "BRA" "BRA"
##  [210] "BRA" "BRA" "BRA" "BRA" "BRA" "BRA" "BRA" "BRB" "BRB" "BRB" "BRB"
##  [221] "BRB" "BRB" "BRB" "BRB" "BRB" "BRN" "BRN" "BRN" "BRN" "BRN" "BRN"
##  [232] "BRN" "BRN" "BRN" "BTN" "BTN" "BTN" "BTN" "BTN" "BTN" "BTN" "BTN"
##  [243] "BTN" "BWA" "BWA" "BWA" "BWA" "BWA" "BWA" "BWA" "BWA" "BWA" "CAF"
##  [254] "CAF" "CAF" "CAF" "CAF" "CAF" "CAF" "CAF" "CAF" "CAN" "CAN" "CAN"
##  [265] "CAN" "CAN" "CAN" "CAN" "CAN" "CAN" "CHE" "CHE" "CHE" "CHE" "CHE"
##  [276] "CHE" "CHE" "CHE" "CHE" "CHL" "CHL" "CHL" "CHL" "CHL" "CHL" "CHL"
##  [287] "CHL" "CHL" "CHN" "CHN" "CHN" "CHN" "CHN" "CHN" "CHN" "CHN" "CHN"
##  [298] "CIV" "CIV" "CIV" "CIV" "CIV" "CIV" "CIV" "CIV" "CIV" "CMR" "CMR"
##  [309] "CMR" "CMR" "CMR" "CMR" "CMR" "CMR" "CMR" "COD" "COD" "COD" "COD"
##  [320] "COD" "COD" "COD" "COD" "COD" "COG" "COG" "COG" "COG" "COG" "COG"
##  [331] "COG" "COG" "COG" "COK" "COK" "COK" "COK" "COK" "COK" "COK" "COK"
##  [342] "COK" "COL" "COL" "COL" "COL" "COL" "COL" "COL" "COL" "COL" "COM"
##  [353] "COM" "COM" "COM" "COM" "COM" "COM" "COM" "COM" "CPV" "CPV" "CPV"
##  [364] "CPV" "CPV" "CPV" "CPV" "CPV" "CPV" "CRI" "CRI" "CRI" "CRI" "CRI"
##  [375] "CRI" "CRI" "CRI" "CRI" "CUB" "CUB" "CUB" "CUB" "CUB" "CUB" "CUB"
##  [386] "CUB" "CUB" "CYP" "CYP" "CYP" "CYP" "CYP" "CYP" "CYP" "CYP" "CYP"
##  [397] "CZE" "CZE" "CZE" "CZE" "CZE" "CZE" "CZE" "CZE" "CZE" "DEU" "DEU"
##  [408] "DEU" "DEU" "DEU" "DEU" "DEU" "DEU" "DEU" "DJI" "DJI" "DJI" "DJI"
##  [419] "DJI" "DJI" "DJI" "DJI" "DJI" "DMA" "DMA" "DMA" "DMA" "DMA" "DMA"
##  [430] "DMA" "DMA" "DMA" "DNK" "DNK" "DNK" "DNK" "DNK" "DNK" "DNK" "DNK"
##  [441] "DNK" "DOM" "DOM" "DOM" "DOM" "DOM" "DOM" "DOM" "DOM" "DOM" "DZA"
##  [452] "DZA" "DZA" "DZA" "DZA" "DZA" "DZA" "DZA" "DZA" "ECU" "ECU" "ECU"
##  [463] "ECU" "ECU" "ECU" "ECU" "ECU" "ECU" "EGY" "EGY" "EGY" "EGY" "EGY"
##  [474] "EGY" "EGY" "EGY" "EGY" "ERI" "ERI" "ERI" "ERI" "ERI" "ERI" "ERI"
##  [485] "ERI" "ERI" "ESP" "ESP" "ESP" "ESP" "ESP" "ESP" "ESP" "ESP" "ESP"
##  [496] "EST" "EST" "EST" "EST" "EST" "EST" "EST" "EST" "EST" "ETH" "ETH"
##  [507] "ETH" "ETH" "ETH" "ETH" "ETH" "ETH" "ETH" "FIN" "FIN" "FIN" "FIN"
##  [518] "FIN" "FIN" "FIN" "FIN" "FIN" "FJI" "FJI" "FJI" "FJI" "FJI" "FJI"
##  [529] "FJI" "FJI" "FJI" "FRA" "FRA" "FRA" "FRA" "FRA" "FRA" "FRA" "FRA"
##  [540] "FRA" "FSM" "FSM" "FSM" "FSM" "FSM" "FSM" "FSM" "FSM" "FSM" "GAB"
##  [551] "GAB" "GAB" "GAB" "GAB" "GAB" "GAB" "GAB" "GAB" "GBR" "GBR" "GBR"
##  [562] "GBR" "GBR" "GBR" "GBR" "GBR" "GBR" "GEO" "GEO" "GEO" "GEO" "GEO"
##  [573] "GEO" "GEO" "GEO" "GEO" "GHA" "GHA" "GHA" "GHA" "GHA" "GHA" "GHA"
##  [584] "GHA" "GHA" "GIN" "GIN" "GIN" "GIN" "GIN" "GIN" "GIN" "GIN" "GIN"
##  [595] "GMB" "GMB" "GMB" "GMB" "GMB" "GMB" "GMB" "GMB" "GMB" "GNB" "GNB"
##  [606] "GNB" "GNB" "GNB" "GNB" "GNB" "GNB" "GNB" "GNQ" "GNQ" "GNQ" "GNQ"
##  [617] "GNQ" "GNQ" "GNQ" "GNQ" "GNQ" "GRC" "GRC" "GRC" "GRC" "GRC" "GRC"
##  [628] "GRC" "GRC" "GRC" "GRD" "GRD" "GRD" "GRD" "GRD" "GRD" "GRD" "GRD"
##  [639] "GRD" "GTM" "GTM" "GTM" "GTM" "GTM" "GTM" "GTM" "GTM" "GTM" "GUY"
##  [650] "GUY" "GUY" "GUY" "GUY" "GUY" "GUY" "GUY" "GUY" "HND" "HND" "HND"
##  [661] "HND" "HND" "HND" "HND" "HND" "HND" "HRV" "HRV" "HRV" "HRV" "HRV"
##  [672] "HRV" "HRV" "HRV" "HRV" "HTI" "HTI" "HTI" "HTI" "HTI" "HTI" "HTI"
##  [683] "HTI" "HTI" "HUN" "HUN" "HUN" "HUN" "HUN" "HUN" "HUN" "HUN" "HUN"
##  [694] "IDN" "IDN" "IDN" "IDN" "IDN" "IDN" "IDN" "IDN" "IDN" "IND" "IND"
##  [705] "IND" "IND" "IND" "IND" "IND" "IND" "IND" "IRL" "IRL" "IRL" "IRL"
##  [716] "IRL" "IRL" "IRL" "IRL" "IRL" "IRN" "IRN" "IRN" "IRN" "IRN" "IRN"
##  [727] "IRN" "IRN" "IRN" "IRQ" "IRQ" "IRQ" "IRQ" "IRQ" "IRQ" "IRQ" "IRQ"
##  [738] "IRQ" "ISL" "ISL" "ISL" "ISL" "ISL" "ISL" "ISL" "ISL" "ISL" "ISR"
##  [749] "ISR" "ISR" "ISR" "ISR" "ISR" "ISR" "ISR" "ISR" "ITA" "ITA" "ITA"
##  [760] "ITA" "ITA" "ITA" "ITA" "ITA" "ITA" "JAM" "JAM" "JAM" "JAM" "JAM"
##  [771] "JAM" "JAM" "JAM" "JAM" "JOR" "JOR" "JOR" "JOR" "JOR" "JOR" "JOR"
##  [782] "JOR" "JOR" "JPN" "JPN" "JPN" "JPN" "JPN" "JPN" "JPN" "JPN" "JPN"
##  [793] "KAZ" "KAZ" "KAZ" "KAZ" "KAZ" "KAZ" "KAZ" "KAZ" "KAZ" "KEN" "KEN"
##  [804] "KEN" "KEN" "KEN" "KEN" "KEN" "KEN" "KEN" "KGZ" "KGZ" "KGZ" "KGZ"
##  [815] "KGZ" "KGZ" "KGZ" "KGZ" "KGZ" "KHM" "KHM" "KHM" "KHM" "KHM" "KHM"
##  [826] "KHM" "KHM" "KHM" "KIR" "KIR" "KIR" "KIR" "KIR" "KIR" "KIR" "KIR"
##  [837] "KIR" "KNA" "KNA" "KNA" "KNA" "KNA" "KNA" "KNA" "KNA" "KNA" "KOR"
##  [848] "KOR" "KOR" "KOR" "KOR" "KOR" "KOR" "KOR" "KOR" "LAO" "LAO" "LAO"
##  [859] "LAO" "LAO" "LAO" "LAO" "LAO" "LAO" "LBN" "LBN" "LBN" "LBN" "LBN"
##  [870] "LBN" "LBN" "LBN" "LBN" "LBR" "LBR" "LBR" "LBR" "LBR" "LBR" "LBR"
##  [881] "LBR" "LBR" "LBY" "LBY" "LBY" "LBY" "LBY" "LBY" "LBY" "LBY" "LBY"
##  [892] "LCA" "LCA" "LCA" "LCA" "LCA" "LCA" "LCA" "LCA" "LCA" "LKA" "LKA"
##  [903] "LKA" "LKA" "LKA" "LKA" "LKA" "LKA" "LKA" "LSO" "LSO" "LSO" "LSO"
##  [914] "LSO" "LSO" "LSO" "LSO" "LSO" "LTU" "LTU" "LTU" "LTU" "LTU" "LTU"
##  [925] "LTU" "LTU" "LTU" "LUX" "LUX" "LUX" "LUX" "LUX" "LUX" "LUX" "LUX"
##  [936] "LUX" "LVA" "LVA" "LVA" "LVA" "LVA" "LVA" "LVA" "LVA" "LVA" "MAR"
##  [947] "MAR" "MAR" "MAR" "MAR" "MAR" "MAR" "MAR" "MAR" "MDA" "MDA" "MDA"
##  [958] "MDA" "MDA" "MDA" "MDA" "MDA" "MDA" "MDG" "MDG" "MDG" "MDG" "MDG"
##  [969] "MDG" "MDG" "MDG" "MDG" "MDV" "MDV" "MDV" "MDV" "MDV" "MDV" "MDV"
##  [980] "MDV" "MDV" "MEX" "MEX" "MEX" "MEX" "MEX" "MEX" "MEX" "MEX" "MEX"
##  [991] "MHL" "MHL" "MHL" "MHL" "MHL" "MHL" "MHL" "MHL" "MHL" "MKD" "MKD"
## [1002] "MKD" "MKD" "MKD" "MKD" "MKD" "MKD" "MKD" "MLI" "MLI" "MLI" "MLI"
## [1013] "MLI" "MLI" "MLI" "MLI" "MLI" "MLT" "MLT" "MLT" "MLT" "MLT" "MLT"
## [1024] "MLT" "MLT" "MLT" "MMR" "MMR" "MMR" "MMR" "MMR" "MMR" "MMR" "MMR"
## [1035] "MMR" "MNE" "MNE" "MNE" "MNE" "MNE" "MNE" "MNE" "MNE" "MNE" "MNG"
## [1046] "MNG" "MNG" "MNG" "MNG" "MNG" "MNG" "MNG" "MNG" "MOZ" "MOZ" "MOZ"
## [1057] "MOZ" "MOZ" "MOZ" "MOZ" "MOZ" "MOZ" "MRT" "MRT" "MRT" "MRT" "MRT"
## [1068] "MRT" "MRT" "MRT" "MRT" "MUS" "MUS" "MUS" "MUS" "MUS" "MUS" "MUS"
## [1079] "MUS" "MUS" "MWI" "MWI" "MWI" "MWI" "MWI" "MWI" "MWI" "MWI" "MWI"
## [1090] "MYS" "MYS" "MYS" "MYS" "MYS" "MYS" "MYS" "MYS" "MYS" "NAM" "NAM"
## [1101] "NAM" "NAM" "NAM" "NAM" "NAM" "NAM" "NAM" "NER" "NER" "NER" "NER"
## [1112] "NER" "NER" "NER" "NER" "NER" "NGA" "NGA" "NGA" "NGA" "NGA" "NGA"
## [1123] "NGA" "NGA" "NGA" "NIC" "NIC" "NIC" "NIC" "NIC" "NIC" "NIC" "NIC"
## [1134] "NIC" "NIU" "NIU" "NIU" "NIU" "NIU" "NIU" "NIU" "NIU" "NIU" "NLD"
## [1145] "NLD" "NLD" "NLD" "NLD" "NLD" "NLD" "NLD" "NLD" "NOR" "NOR" "NOR"
## [1156] "NOR" "NOR" "NOR" "NOR" "NOR" "NOR" "NPL" "NPL" "NPL" "NPL" "NPL"
## [1167] "NPL" "NPL" "NPL" "NPL" "NRU" "NRU" "NRU" "NRU" "NRU" "NRU" "NRU"
## [1178] "NRU" "NRU" "NZL" "NZL" "NZL" "NZL" "NZL" "NZL" "NZL" "NZL" "NZL"
## [1189] "OMN" "OMN" "OMN" "OMN" "OMN" "OMN" "OMN" "OMN" "OMN" "PAK" "PAK"
## [1200] "PAK" "PAK" "PAK" "PAK" "PAK" "PAK" "PAK" "PAN" "PAN" "PAN" "PAN"
## [1211] "PAN" "PAN" "PAN" "PAN" "PAN" "PER" "PER" "PER" "PER" "PER" "PER"
## [1222] "PER" "PER" "PER" "PHL" "PHL" "PHL" "PHL" "PHL" "PHL" "PHL" "PHL"
## [1233] "PHL" "PLW" "PLW" "PLW" "PLW" "PLW" "PLW" "PLW" "PLW" "PLW" "PNG"
## [1244] "PNG" "PNG" "PNG" "PNG" "PNG" "PNG" "PNG" "PNG" "POL" "POL" "POL"
## [1255] "POL" "POL" "POL" "POL" "POL" "POL" "PRK" "PRK" "PRK" "PRK" "PRK"
## [1266] "PRK" "PRK" "PRK" "PRK" "PRT" "PRT" "PRT" "PRT" "PRT" "PRT" "PRT"
## [1277] "PRT" "PRT" "PRY" "PRY" "PRY" "PRY" "PRY" "PRY" "PRY" "PRY" "PRY"
## [1288] "PSE" "PSE" "PSE" "PSE" "PSE" "PSE" "PSE" "PSE" "PSE" "ROU" "ROU"
## [1299] "ROU" "ROU" "ROU" "ROU" "ROU" "ROU" "ROU" "RUS" "RUS" "RUS" "RUS"
## [1310] "RUS" "RUS" "RUS" "RUS" "RUS" "RWA" "RWA" "RWA" "RWA" "RWA" "RWA"
## [1321] "RWA" "RWA" "RWA" "SAU" "SAU" "SAU" "SAU" "SAU" "SAU" "SAU" "SAU"
## [1332] "SAU" "SDN" "SDN" "SDN" "SDN" "SDN" "SDN" "SDN" "SDN" "SDN" "SEN"
## [1343] "SEN" "SEN" "SEN" "SEN" "SEN" "SEN" "SEN" "SEN" "SGP" "SGP" "SGP"
## [1354] "SGP" "SGP" "SGP" "SGP" "SGP" "SGP" "SLB" "SLB" "SLB" "SLB" "SLB"
## [1365] "SLB" "SLB" "SLB" "SLB" "SLE" "SLE" "SLE" "SLE" "SLE" "SLE" "SLE"
## [1376] "SLE" "SLE" "SLV" "SLV" "SLV" "SLV" "SLV" "SLV" "SLV" "SLV" "SLV"
## [1387] "SOM" "SOM" "SOM" "SOM" "SOM" "SOM" "SOM" "SOM" "SOM" "SRB" "SRB"
## [1398] "SRB" "SRB" "SRB" "SRB" "SRB" "SRB" "SRB" "SSD" "SSD" "SSD" "SSD"
## [1409] "SSD" "SSD" "SSD" "SSD" "SSD" "STP" "STP" "STP" "STP" "STP" "STP"
## [1420] "STP" "STP" "STP" "SUR" "SUR" "SUR" "SUR" "SUR" "SUR" "SUR" "SUR"
## [1431] "SUR" "SVK" "SVK" "SVK" "SVK" "SVK" "SVK" "SVK" "SVK" "SVK" "SVN"
## [1442] "SVN" "SVN" "SVN" "SVN" "SVN" "SVN" "SVN" "SVN" "SWE" "SWE" "SWE"
## [1453] "SWE" "SWE" "SWE" "SWE" "SWE" "SWE" "SWZ" "SWZ" "SWZ" "SWZ" "SWZ"
## [1464] "SWZ" "SWZ" "SWZ" "SWZ" "SYC" "SYC" "SYC" "SYC" "SYC" "SYC" "SYC"
## [1475] "SYC" "SYC" "SYR" "SYR" "SYR" "SYR" "SYR" "SYR" "SYR" "SYR" "SYR"
## [1486] "TCD" "TCD" "TCD" "TCD" "TCD" "TCD" "TCD" "TCD" "TCD" "TGO" "TGO"
## [1497] "TGO" "TGO" "TGO" "TGO" "TGO" "TGO" "TGO" "THA" "THA" "THA" "THA"
## [1508] "THA" "THA" "THA" "THA" "THA" "TJK" "TJK" "TJK" "TJK" "TJK" "TJK"
## [1519] "TJK" "TJK" "TJK" "TKM" "TKM" "TKM" "TKM" "TKM" "TKM" "TKM" "TKM"
## [1530] "TKM" "TLS" "TLS" "TLS" "TLS" "TLS" "TLS" "TLS" "TLS" "TLS" "TON"
## [1541] "TON" "TON" "TON" "TON" "TON" "TON" "TON" "TON" "TTO" "TTO" "TTO"
## [1552] "TTO" "TTO" "TTO" "TTO" "TTO" "TTO" "TUN" "TUN" "TUN" "TUN" "TUN"
## [1563] "TUN" "TUN" "TUN" "TUN" "TUR" "TUR" "TUR" "TUR" "TUR" "TUR" "TUR"
## [1574] "TUR" "TUR" "TUV" "TUV" "TUV" "TUV" "TUV" "TUV" "TUV" "TUV" "TUV"
## [1585] "TZA" "TZA" "TZA" "TZA" "TZA" "TZA" "TZA" "TZA" "TZA" "UGA" "UGA"
## [1596] "UGA" "UGA" "UGA" "UGA" "UGA" "UGA" "UGA" "UKR" "UKR" "UKR" "UKR"
## [1607] "UKR" "UKR" "UKR" "UKR" "UKR" "UNK" "UNK" "UNK" "UNK" "UNK" "UNK"
## [1618] "UNK" "UNK" "UNK" "URY" "URY" "URY" "URY" "URY" "URY" "URY" "URY"
## [1629] "URY" "USA" "USA" "USA" "USA" "USA" "USA" "USA" "USA" "USA" "UZB"
## [1640] "UZB" "UZB" "UZB" "UZB" "UZB" "UZB" "UZB" "UZB" "VCT" "VCT" "VCT"
## [1651] "VCT" "VCT" "VCT" "VCT" "VCT" "VCT" "VEN" "VEN" "VEN" "VEN" "VEN"
## [1662] "VEN" "VEN" "VEN" "VEN" "VNM" "VNM" "VNM" "VNM" "VNM" "VNM" "VNM"
## [1673] "VNM" "VNM" "VUT" "VUT" "VUT" "VUT" "VUT" "VUT" "VUT" "VUT" "VUT"
## [1684] "WSM" "WSM" "WSM" "WSM" "WSM" "WSM" "WSM" "WSM" "WSM" "YEM" "YEM"
## [1695] "YEM" "YEM" "YEM" "YEM" "YEM" "YEM" "YEM" "ZAF" "ZAF" "ZAF" "ZAF"
## [1706] "ZAF" "ZAF" "ZAF" "ZAF" "ZAF" "ZMB" "ZMB" "ZMB" "ZMB" "ZMB" "ZMB"
## [1717] "ZMB" "ZMB" "ZMB" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE"
## [1728] "ZWE"
```

This is now a plain old vector, so it can be indexed with [single square brackets](../glossary/#single-square-brackets):


```r
data[[1]][1]
```

```
## [1] "AFG"
```

But that too is a vector, so it can of course be indexed as well (for some value of "of course"):


```r
data[[1]][1][1]
```

```
## [1] "AFG"
```

Thus,
`data[1][[1]]` produces a tibble,
then selects the first column vector from it,
so it still gives us a vector.
*This is not madness.*
It is merely…differently sane.

## Basic Statistics

What is the average estimate?
We start by grabbing that column for convenience:


```python
estimates = data.estimate
print(len(estimates))
```

```
## 1728
```

```python
print(estimates.mean())
```

```
## 0.3870192307692308
```

This translates almost directly to R:


```r
estimates <- data$estimate
length(estimates)
```

```
## [1] 1728
```

```r
mean(estimates)
```

```
## [1] NA
```

It seems that the void is always there, waiting for us…
Let's fix this in R first:


```r
mean(estimates, na.rm=TRUE)
```

```
## [1] 0.3870192
```

And then try to get the statistically correct behavior in Pandas:


```python
print(estimates.mean(skipna=False))
```

```
## nan
```

Many functions in R use `na.rm` to control whether `NA`s are removed or not.
(Remember, the `.` character is just another part of the name)
R's default behavior is to leave `NA`s in, and then to include them in [aggregate](../glossary/#aggregation) computations.
Python's is to get rid of missing values early and work with what's left,
which makes translating code from one language to the next much more interesting than it might otherwise be.
But other than that, the statistics works the same way in Python:


```python
print(estimates.min())
```

```
## 0.0
```

```python
print(estimates.max())
```

```
## 0.95
```

```python
print(estimates.std())
```

```
## 0.3034511074214113
```

Here are the equivalent computations in R:


```r
min(estimates, na.rm=TRUE)
```

```
## [1] 0
```

```r
max(estimates, na.rm=TRUE)
```

```
## [1] 0.95
```

```r
sd(estimates, na.rm=TRUE)
```

```
## [1] 0.3034511
```

A good use of aggregation is to check the quality of the data.
For example,
we can ask if there are any records where some of the estimate, the low value, or the high value are missing,
but not all of them:


```python
print((data.hi.isnull() != data.lo.isnull()).any())
```

```
## False
```


```r
any(is.na(data$hi) != is.na(data$lo))
```

```
## [1] FALSE
```

## Filtering

By "[filtering](../glossary/#filter)", we mean "selecting records by value".
As discussed [earlier](../beginnings/),
the simplest approach is to use a vector of logical values to keep only the values corresponding to `TRUE`.
In Python, this is:


```python
maximal = estimates[estimates >= 0.95]
print(len(maximal))
```

```
## 52
```

And in R:


```r
maximal <- estimates[estimates >= 0.95]
length(maximal)
```

```
## [1] 1052
```

The difference is unexpected.
Let's have a closer look at the result in Python:


```python
print(maximal)
```

```
## 180     0.95
## 181     0.95
## 182     0.95
## 183     0.95
## 184     0.95
## 185     0.95
## 187     0.95
## 360     0.95
## 361     0.95
## 362     0.95
## 379     0.95
## 380     0.95
## 381     0.95
## 382     0.95
## 384     0.95
## 385     0.95
## 386     0.95
## 446     0.95
## 447     0.95
## 461     0.95
## 792     0.95
## 793     0.95
## 794     0.95
## 795     0.95
## 796     0.95
## 797     0.95
## 910     0.95
## 911     0.95
## 954     0.95
## 955     0.95
## 956     0.95
## 957     0.95
## 958     0.95
## 959     0.95
## 960     0.95
## 961     0.95
## 962     0.95
## 1097    0.95
## 1106    0.95
## 1127    0.95
## 1428    0.95
## 1429    0.95
## 1461    0.95
## 1553    0.95
## 1603    0.95
## 1606    0.95
## 1624    0.95
## 1625    0.95
## 1626    0.95
## 1628    0.95
## 1707    0.95
## 1709    0.95
## Name: estimate, dtype: float64
```

And in R:


```r
maximal
```

```
##    [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [14]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [27]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [40]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [53]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [66]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [79]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##   [92]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [105]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [118]   NA   NA   NA   NA   NA   NA   NA 0.95 0.95 0.95 0.95 0.95 0.95
##  [131] 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [144]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [157]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [170]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [183]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [196]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [209] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95   NA   NA   NA
##  [222]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [235]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [248]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [261]   NA   NA   NA   NA   NA 0.95 0.95   NA   NA 0.95   NA   NA   NA
##  [274]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [287]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [300]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [313]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [326]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [339]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [352]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [365]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [378]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [391]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [404]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [417]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [430]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [443]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [456]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [469]   NA   NA   NA 0.95 0.95 0.95 0.95 0.95 0.95   NA   NA   NA   NA
##  [482]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [495]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [508]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [521]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [534]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [547]   NA   NA 0.95 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [560]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [573]   NA   NA   NA   NA   NA 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
##  [586] 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [599]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [612]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [625]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [638]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [651]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [664]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [677]   NA 0.95   NA 0.95   NA   NA   NA 0.95   NA   NA   NA   NA   NA
##  [690]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [703]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [716]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [729]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [742]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [755]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [768]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [781]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [794]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [807]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [820]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [833]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [846]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [859]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [872]   NA   NA   NA 0.95 0.95   NA   NA   NA   NA   NA   NA   NA   NA
##  [885]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [898]   NA   NA   NA   NA   NA   NA   NA 0.95   NA   NA   NA   NA   NA
##  [911]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [924]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [937]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [950]   NA   NA   NA   NA   NA   NA 0.95   NA   NA   NA   NA   NA   NA
##  [963]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [976]   NA 0.95 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
##  [989] 0.95 0.95 0.95 0.95   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1002]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1015]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1028]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
## [1041]   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.95 0.95   NA
```

It appears that R has kept the unknown values in order to highlight just how little we know—just how little
we *can* know.
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
##  [1]  181  182  183  184  185  186  188  361  362  363  380  381  382  383
## [15]  385  386  387  447  448  462  793  794  795  796  797  798  911  912
## [29]  955  956  957  958  959  960  961  962  963 1098 1107 1128 1429 1430
## [43] 1462 1554 1604 1607 1625 1626 1627 1629 1708 1710
```

And as a quick check:


```r
length(which(estimates >= 0.95))
```

```
## [1] 52
```

So now we can index our vector with the result of the `which`:


```r
maximal <- estimates[which(estimates >= 0.95)]
maximal
```

```
##  [1] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
## [15] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
## [29] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
## [43] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
```

But should we do this?
Those `NA`s are important information,
and should not be discarded so blithely.
What we should *really* be doing is using the tools the tidyverse provides
rather than clever indexing tricks.
These behave consistently across a wide scale of problems
and encourage use of patterns that make it easier for others to understand our programs.

## Tidy Code

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
## # A tibble: 183 x 5
##    country  year estimate    hi    lo
##    <chr>   <int>    <dbl> <dbl> <dbl>
##  1 ARG      2016     0.67  0.77  0.61
##  2 ARG      2017     0.66  0.77  0.6 
##  3 AZE      2014     0.74  0.95  0.53
##  4 AZE      2015     0.83  0.95  0.64
##  5 AZE      2016     0.75  0.95  0.56
##  6 AZE      2017     0.74  0.95  0.56
##  7 BLR      2009     0.95  0.95  0.95
##  8 BLR      2010     0.95  0.95  0.95
##  9 BLR      2011     0.95  0.95  0.91
## 10 BLR      2012     0.95  0.95  0.95
## # ... with 173 more rows
```

Notice that the expression is `lo > 0.5` rather than `"lo" > 0.5`.
The latter expression returns the entire table
because the string `"lo"` is greater than the number 0.5 everywhere.
But wait:
how is it that `lo` can be used on its own?
It is the name of a column, but there is no variable called `lo`.

The answer is that R uses [lazy evaluation](../glossary/#lazy-evaluation) of arguments.
Arguments aren't evaluated until they're needed,
so the function `filter` actually gets the expression `lo > 0.5`,
which allows it to check that there's a column called `lo` and then use it appropriately.
This is much tidier than `filter(data, data$lo > 0.5)` or `filter(data, "lo > 0.5")`,
and is *not* some kind of eldritch wizardry.
Many languages rely on lazy evaluation,
and when used circumspectly,
it allows us to produce code that is easier to read.

But we can do even better by using the [pipe operator](../glossary/#pipe-operator) `%>%`,
which is about to become your new best friend:


```r
data %>% filter(lo > 0.5)
```

```
## # A tibble: 183 x 5
##    country  year estimate    hi    lo
##    <chr>   <int>    <dbl> <dbl> <dbl>
##  1 ARG      2016     0.67  0.77  0.61
##  2 ARG      2017     0.66  0.77  0.6 
##  3 AZE      2014     0.74  0.95  0.53
##  4 AZE      2015     0.83  0.95  0.64
##  5 AZE      2016     0.75  0.95  0.56
##  6 AZE      2017     0.74  0.95  0.56
##  7 BLR      2009     0.95  0.95  0.95
##  8 BLR      2010     0.95  0.95  0.95
##  9 BLR      2011     0.95  0.95  0.91
## 10 BLR      2012     0.95  0.95  0.95
## # ... with 173 more rows
```

This may not seem like much of an improvement,
but neither does a Unix pipe consisting of `cat filename.txt | head`.
What about this?


```r
filter(data, (estimate != 0.95) & (lo > 0.5) & (hi <= (lo + 0.1)))
```

```
## # A tibble: 1 x 5
##   country  year estimate    hi    lo
##   <chr>   <int>    <dbl> <dbl> <dbl>
## 1 TTO      2017     0.94  0.95  0.86
```

It uses the vectorized "and" operator `&` twice,
and parsing the condition takes a human being at least a few seconds.
Its tidyverse equivalent is:


```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.1))
```

```
## # A tibble: 1 x 5
##   country  year estimate    hi    lo
##   <chr>   <int>    <dbl> <dbl> <dbl>
## 1 TTO      2017     0.94  0.95  0.86
```

Breaking the condition into stages like this doesn't always make reading easier,
but it often helps development and testing.

Let's increase the band from 10% to 20%:


```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.2))
```

```
## # A tibble: 55 x 5
##    country  year estimate    hi    lo
##    <chr>   <int>    <dbl> <dbl> <dbl>
##  1 ARG      2016     0.67  0.77  0.61
##  2 ARG      2017     0.66  0.77  0.6 
##  3 CHL      2011     0.64  0.72  0.56
##  4 CHL      2013     0.67  0.77  0.59
##  5 CHL      2014     0.77  0.87  0.67
##  6 CHL      2015     0.92  0.95  0.79
##  7 CHL      2016     0.7   0.79  0.62
##  8 CHL      2017     0.85  0.95  0.76
##  9 CPV      2014     0.94  0.95  0.76
## 10 CPV      2016     0.94  0.95  0.76
## # ... with 45 more rows
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
## # A tibble: 55 x 5
##    country  year estimate    hi    lo
##    <chr>   <int>    <dbl> <dbl> <dbl>
##  1 TTO      2017     0.94  0.95  0.86
##  2 SWZ      2011     0.93  0.95  0.84
##  3 CUB      2014     0.92  0.95  0.83
##  4 TTO      2016     0.9   0.95  0.83
##  5 CRI      2009     0.92  0.95  0.81
##  6 CRI      2012     0.89  0.95  0.81
##  7 NAM      2014     0.91  0.95  0.81
##  8 URY      2016     0.9   0.95  0.81
##  9 ZMB      2014     0.91  0.95  0.81
## 10 KAZ      2015     0.84  0.95  0.8 
## # ... with 45 more rows
```

We can now [select](../glossary/#selection) the three columns we care about:


```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(year, lo, hi)
```

```
## Warning: `overscope_eval_next()` is soft-deprecated as of rlang 0.2.0.
## Please use `eval_tidy()` with a data mask instead
## This warning is displayed once per session.
```

```
## # A tibble: 55 x 3
##     year    lo    hi
##    <int> <dbl> <dbl>
##  1  2017  0.86  0.95
##  2  2011  0.84  0.95
##  3  2014  0.83  0.95
##  4  2016  0.83  0.95
##  5  2009  0.81  0.95
##  6  2012  0.81  0.95
##  7  2014  0.81  0.95
##  8  2016  0.81  0.95
##  9  2014  0.81  0.95
## 10  2015  0.8   0.95
## # ... with 45 more rows
```

Once again,
we are using the unquoted column names `year`, `lo`, and `hi`
and letting R's lazy evaluation take care of the details for us.

Rather than selecting these three columns,
we can [select *out*](../glossary/#negative-selection) the columns we're not interested in by negating their names.
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
## # A tibble: 55 x 3
##     year    hi    lo
##    <int> <dbl> <dbl>
##  1  2017  0.95  0.86
##  2  2011  0.95  0.84
##  3  2014  0.95  0.83
##  4  2016  0.95  0.83
##  5  2009  0.95  0.81
##  6  2012  0.95  0.81
##  7  2014  0.95  0.81
##  8  2016  0.95  0.81
##  9  2014  0.95  0.81
## 10  2015  0.95  0.8 
## # ... with 45 more rows
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
## # A tibble: 55 x 4
##     year    hi    lo difference
##    <int> <dbl> <dbl>      <dbl>
##  1  2017  0.95  0.86     0.0900
##  2  2011  0.95  0.84     0.110 
##  3  2014  0.95  0.83     0.12  
##  4  2016  0.95  0.83     0.12  
##  5  2009  0.95  0.81     0.140 
##  6  2012  0.95  0.81     0.140 
##  7  2014  0.95  0.81     0.140 
##  8  2016  0.95  0.81     0.140 
##  9  2014  0.95  0.81     0.140 
## 10  2015  0.95  0.8      0.150 
## # ... with 45 more rows
```

Does the difference between high and low estimates vary by year?
To answer that question,
we use `group_by` to [group](../glossary/#grouping) records by value
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
## # A tibble: 9 x 3
##    year `n()` `mean(year)`
##   <int> <int>        <dbl>
## 1  2009     3         2009
## 2  2010     3         2010
## 3  2011     5         2011
## 4  2012     5         2012
## 5  2013     6         2013
## 6  2014    10         2014
## 7  2015     6         2015
## 8  2016    10         2016
## 9  2017     7         2017
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
## # A tibble: 9 x 3
##    year count ave_diff
##   <int> <int>    <dbl>
## 1  2009     3     2009
## 2  2010     3     2010
## 3  2011     5     2011
## 4  2012     5     2012
## 5  2013     6     2013
## 6  2014    10     2014
## 7  2015     6     2015
## 8  2016    10     2016
## 9  2017     7     2017
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
## /Users/gvwilson/anaconda3/lib/python3.6/site-packages/pandas/core/groupby/groupby.py:4658: FutureWarning: using a dict with renaming is deprecated and will be removed in a future version
##   return super(DataFrameGroupBy, self).aggregate(arg, *args, **kwargs)
```

```python
print(grouped)
```

```
##      difference      
##        ave_diff count
## year                 
## 2009   0.170000     3
## 2010   0.186667     3
## 2011   0.168000     5
## 2012   0.186000     5
## 2013   0.183333     6
## 2014   0.168000    10
## 2015   0.161667     6
## 2016   0.166000    10
## 2017   0.152857     7
```

There are other ways to tackle this problem with Pandas,
but the tidyverse approach produces code that I find more readable.

{% include links.md %}
