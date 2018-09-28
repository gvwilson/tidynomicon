# The Tidyverse

See <https://pandas.pydata.org/pandas-docs/stable/comparison_with_r.html>

## Reading Data

- Import Pandas as `pd` (not required but conventional)
- Use `read_csv` with a path
- Start by looking at the file itself

```output
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
- Actual file has many more rows and no ellipses
- `NA` to show missing data rather than (for example) `-` or a space or empty column

```py
import pandas as pd

data = pd.read_csv('tidy/infant_hiv.csv')
data
```
```output
     country  year  estimate    hi    lo
0        AFG  2009       NaN   NaN   NaN
1        AFG  2010       NaN   NaN   NaN
...      ...   ...       ...   ...   ...
8        AFG  2017       NaN   NaN   NaN
9        AGO  2009       NaN   NaN   NaN
10       AGO  2010      0.03  0.04  0.02
...      ...   ...       ...   ...   ...
1726     ZWE  2016      0.71  0.88  0.62
1727     ZWE  2017      0.65  0.81  0.57

[1728 rows x 5 columns]
```

- Again, actual output has many more rows and only one row of ellipses
- Equivalent in R is to load the tidyverse collection of libraries and then call the `read_csv` function
- Go through this in stages, since each produces output

```r
library(tidyverse)
```
```output
── Attaching packages ─────────────────────────────────────── tidyverse 1.2.1 ──
✔ ggplot2 3.0.0     ✔ purrr   0.2.5
✔ tibble  1.4.2     ✔ dplyr   0.7.6
✔ tidyr   0.8.1     ✔ stringr 1.3.1
✔ readr   1.1.1     ✔ forcats 0.3.0
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```

- Asking for the tidyverse gives us eight libraries (or *packages*)
- One of those libraries, dplyr, defines functions that mask standard functions
- This is deliberate, and if we need the originals, we can get them with their fully-qualified names
  - `package::function`
- Reading the file looks remarkably like reading the file

```r
data <- read_csv('tidy/infant_hiv.csv')
```
```output
Parsed with column specification:
cols(
  country = col_character(),
  year = col_integer(),
  estimate = col_double(),
  hi = col_double(),
  lo = col_double()
)
```

- R's `read_csv` tells us more about what it's done than Pandas does
  - Guesses at columns' data types based on the first thousand values
  - In a better universe, people used the first *two* rows of their spreadsheets for name *and units*
- Now have a look at the *tibble*
  - The tidyverse replacement for R's `data.frame`

```r
data
```
```output
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
# ... with 1,718 more rows
```

## Data Inspection

- Often have a quick look at the content of a table to remind ourselves what it contains

```py
data.head()
```
```output
  country  year  estimate  hi  lo
0     AFG  2009       NaN NaN NaN
1     AFG  2010       NaN NaN NaN
2     AFG  2011       NaN NaN NaN
3     AFG  2012       NaN NaN NaN
4     AFG  2013       NaN NaN NaN
```
```py
data.tail()
```
```output
     country  year  estimate    hi    lo
1723     ZWE  2013      0.57  0.70  0.49
1724     ZWE  2014      0.54  0.67  0.47
1725     ZWE  2015      0.59  0.73  0.51
1726     ZWE  2016      0.71  0.88  0.62
1727     ZWE  2017      0.65  0.81  0.57
```

- Equivalent in R

```r
head(data)
```
```output
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
```output
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

- Note that the row numbers printed by R's `tail()` are relative to the output, not absolute to the table
- And that numbering starts from 1
- What about overall information?

```py
data.info()
```
```output
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 1728 entries, 0 to 1727
Data columns (total 5 columns):
country     1728 non-null object
year        1728 non-null int64
estimate    638 non-null float64
hi          728 non-null float64
lo          728 non-null float64
dtypes: float64(3), int64(1), object(1)
memory usage: 67.6+ KB
```

```r
summary(data)
```
```output
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

- Your display may or may not wrap, depending on how large a screen the older acolytes have allowed you

## Indexing

- A DataFrame is a collection of series (also called columns), each containing the values of a single observed variable
- Columns in R tibbles are, not coincidentally, conceptually the same

```py
data['estimate']
```
```output
0        NaN
1        NaN
2        NaN
...      ...
1726    0.51
1727    0.62
Name: estimate, Length: 1728, dtype: float64
```

- Get exactly the same output in Python with `data.estimate`
  - Column names can be accessed using string indices or as attribute names
- Same works in R

```r
data['estimate']
```
```output
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
# ... with 1,718 more rows
```

- However, `data$estimate` provides all the data

```r
data$estimate
```
```output
data$estimate
   [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA 0.02 0.04 0.05
  [15] 0.12 0.08 0.05 0.01   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [29]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
...
[1709] 0.95 0.67   NA 0.53 0.24 0.63 0.67 0.57 0.81 0.39 0.39   NA   NA 0.10
[1723] 0.20 0.33 0.49 0.47 0.51 0.62
```

- Again, note that the boxed number on the left is the start index of that row

- What about single values?
  - Remember to offset the indices (count from zero, count from one)

```py
data.estimate[11]
```
```output
0.02
```
```r
data$estimate[12]
```
```output
[1] 0.02
```

- But remember that everything in R is a vector!

```py
len(data.estimate[11])
```
```error
TypeError: object of type 'numpy.float64' has no len()
```
```r
length(data$estimate[12])
```
```output
[1] 1
```

- And yes, ranges work

```py
data.estimate[5:15]
```
```output
5      NaN
6      NaN
7      NaN
8      NaN
9      NaN
10     NaN
11    0.02
12    0.04
13    0.05
14    0.12
Name: estimate, dtype: float64
```
```r
data$estimate[6:15]
```
```output
[1]   NA   NA   NA   NA   NA   NA 0.02 0.04 0.05 0.12
```

- Note that the upper bound is the same, because it's inclusive in R and exclusive in Python
- Note also that neither library prevents us from selecting a range of data that spans logical groups (such as countries)
  - Which is why selecting by row number is usually a sign of innocence, insouciance, or desperation

- Can select by column number as well
  - Pandas uses the rather clumsy `object.iloc[rows, columns]`, with the usual `:` shortcut for "entire range"

```py
data.iloc[:, 0]
```
```output
0       AFG
1       AFG
2       AFG
...     ...
1726    ZWE
1727    ZWE
Name: country, Length: 1728, dtype: object
```

- Since this is a column, it can be indexed

```py
data.iloc[:, 0][0]
```
```output
'AFG'
```

- In R, a single index is interpreted as the column index

```r
data[1]
```
```output
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
# ... with 1,718 more rows
```

- But notice that the output is not a vector, but another tibble (i.e., an N-row, 1-column structure)
- Which means that adding another index does column-wise indexing on that tibble

```r
data[1][1]
```
```output
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
# ... with 1,718 more rows
```

- How then to get the first mention of Afghanistan?
- Use double square brackets to strip away one level of structure

```r
data[[1]]
```
```output
   [1] "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AFG" "AGO" "AGO" "AGO"
  [13] "AGO" "AGO" "AGO" "AGO" "AGO" "AGO" "AIA" "AIA" "AIA" "AIA" "AIA" "AIA"
  ...  ...
[1717] "ZMB" "ZMB" "ZMB" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE" "ZWE"
```

- That is now a plain old vector, so it can be indexed with single square brackets

```r
data[[1]][1]
```
```output
[1] "AFG"
```

- Of course, that result is a vector and can be subscripted
  - For some value of "of course", of course...

```r
data[[1]][1][1]
```
```output
[1] "AFG"
```

- Note that `data[1][[1]]` produces a tibble, then selects the first column vector from it, so still gives us a vector
- *This is not madness* - it is merely...differently sane

## Basic Statistics

- What is the average estimate?
- Start by grabbing that column for convenience

```py
estimates = data.estimate
len(estimates)
```
```output
1728
```
```py
estimates.mean()
```
```output
0.3144200626959248
```

- In R:

```r
estimates <- data$estimate
length(estimates)
```
```output
[1] 1728
```
```r
mean(estimates)
```
```output
[1] NA
```

- All right, let's try that again
- In R first:

```r
mean(estimates, na.rm=TRUE)
```
```output
[1] 0.3144201
```

- And now with Pandas, trying to get the statistically correct behavior:

```py
estimates.mean(skipna=False)
```
```output
nan
```

- Many functions in R use `na.rm` to control whether `NA`s are removed or not
  - Remember, the `.` character is just another part of the name
- R's default behavior is to leave `NA`s in, and then to include them in aggregate computations
- Python's is to get rid of missing values early
- Other than that, the statistics works the same way in Python:

```py
estimates.min()
```
```output
0.0
```
```py
estimates.max()
```
```output
0.95
```
```py
estimates.std()
```
```output
0.2748172945892118
```

- And in R:

```r
min(estimates, na.rm=TRUE)
```
```output
[1] 0
```
```r
max(estimates, na.rm=TRUE)
```
```output
[1] 0.95
```
```r
sd(estimates, na.rm=TRUE)
```
```output
[1] 0.2748173
```

- A good use of aggregation is to check the quality of the data
- Are there any records where some of the estimate, the low value, or the high value are missing, but not all of them?

```py
(data.hi.isnull() != data.lo.isnull()).any()
```
```output
False
```

```r
any(is.na(data$hi) != is.na(data$lo))
```
```output
[1] FALSE
```

## Filtering

- By which we mean "selecting by value"
- As discussed in [an earlier section](simple_things.md), using a vector of logical values keeps only those values
- In Python:

```py
maximal = estimates[estimates >= 0.95]
len(maximal)
```
```output
24
```

- In R:

```r
maximal <- estimates[estimates >= 0.95]
length(maximal)
```
```output
[1] 1114
```

- That's unexpected
- Let's have a closer look at the result in Python:

```py
maximal
```
```output
181     0.95
182     0.95
184     0.95
185     0.95
363     0.95
381     0.95
382     0.95
383     0.95
385     0.95
386     0.95
447     0.95
793     0.95
794     0.95
795     0.95
796     0.95
797     0.95
956     0.95
958     0.95
960     0.95
961     0.95
962     0.95
1616    0.95
1618    0.95
1708    0.95
Name: estimate, dtype: float64
```

- And in R:

```r
maximal
```
```output
   [1]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  [15]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
  ...    ...
 [127]   NA   NA   NA   NA   NA   NA 0.95 0.95 0.95 0.95   NA   NA   NA   NA
  ...    ...
[1093]   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
[1107]   NA   NA   NA   NA 0.95   NA   NA   NA
```

- It appears that R has kept the unknown values
  - More precisely, wherever there was an `NA` in the original data...
  - ...there is an `NA` in the logical vector...
  - ...and hence an `NA` in the final vector
- Let us then turn to `which` to get a vector of indices at which a vector contains `TRUE`
  - This function does not return indices for `FALSE` or `NA`

```r
which(estimates >= 0.95)
```
```output
[1]  182  183  185  186  364  382  383  384  386  387  448  794  795  796  797
[16]  798  957  959  961  962  963 1617 1619 1709
```

- As a quick check:

```r
length(which(estimates >= 0.95))
```
```output
[1] 24
```

- So now we can index our vector with the result of the `which`

```r
maximal <- estimates[which(estimates >= 0.95)]
maximal
```
```output
 [1] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
[16] 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95
```

- But should we do this?
- Those `NA`s are important information, and discarding them in this way is something we should think about more carefully
- What we should *really* be doing is using the tools the tidyverse provides rather than clever indexing
  - Behave consistently across a wide scale of problems
  - Encourage use of patterns that make it easier for others to understand our programs

## Tidy Code

- The five basic data transformation operations in the tidyverse are:
  - `filter`: choose observations (rows) by value(s)
  - `arrange`: reorder rows
  - `select`: choose variables (columns) by name
  - `mutate`: derive new variables from existing ones
  - `summarize`: combine many values to create a single new value
- `filter(tibble, ...criteria...)` keeps rows that pass all of the specified criteria

```r
filter(data, lo > 0.5)
```
```output
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
# ... with 173 more rows
```

- Notice that the expression is `lo > 0.5` rather than `"lo" > 0.5`
  - The (incorrect) latter expression returns the entire table, because the string `"lo"` is greater than the number 0.5 everywhere
- But wait: how is it that `lo` can be used on its own?
  - Is is the name of a column, but there is no variable called `lo`.
- R uses *lazy evaluation* of arguments
  - Argument isn't evaluated until it's needed
  - So the function `filter` actually gets the expression `lo > 0.5`
  - Which allows it to check that there's a column called `lo` and then use it appropriately
  - Which is much nicer than `filter(data, data$lo > 0.5)` or `filter(data, "lo > 0.5")`
- But we can do even better by using the pipe operator `%>%`

```r
data %>% filter(lo > 0.5)
```
```output
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
# ... with 173 more rows
```

- Doesn't seem like much of an improvement, but neither does a Unix pipe consisting of `cat filename.txt | head`
- What about this?

```r
filter(data, (estimate != 0.95) & (lo > 0.5) & (hi <= (lo + 0.1)))
```
```output
# A tibble: 1 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 TTO      2017     0.94  0.95  0.86
```

- Note the use of `&` for vectorized "and" rather than `&&`
- Compare to:

```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.1))
```
```output
# A tibble: 1 x 5
  country  year estimate    hi    lo
  <chr>   <int>    <dbl> <dbl> <dbl>
1 TTO      2017     0.94  0.95  0.86
```

- Breaking the condition into stages may or may not make reading easier, but it sure helps development and testing
- Let's increase the band from 10% to 20%

```r
data %>% filter(estimate != 0.95) %>% filter(lo > 0.5) %>% filter(hi <= (lo + 0.2))
```
```output
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
# ... with 45 more rows
```

- Order by low value in descending order
  - Break the line the way the [tidyverse style guide](http://style.tidyverse.org/) recommends

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo))
```
```output
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
# ... with 45 more rows
```

- Only need the year, the low value, and the high value

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(year, lo, hi)
```
```output
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
# ... with 45 more rows
```

- Could just as easily select out the country and estimate, but that's probably more difficult to understand
  - And wouldn't rearrange the columns to put `lo` before `hi`
  - Which doesn't matter if we're selecting by name...
  - ...but *does* if we ever want to select by column index

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(-country, -esimate)
```

- Add a column containing the difference between low and high values
  - Use `mutate` to add to (the end of) an existing tibble
  - Use `transmute` to create a new table containing only the columns we explicitly ask for
  - We will want `low` and `high` later, so we'll use `mutate`

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  arrange(desc(lo)) %>%
  select(-country, -esimate) %>%
  mutate(difference = hi - lo)
```
```output
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
# ... with 45 more rows
```

- Does the difference between high and low estimates vary by year?
- Use `group_by` to put data into groups, and then `summarize` to summarize within groups
- Might as well get rid of the `arrange` and `select` at this point, since we're not using them
- And count how many records contributed to each aggregation using `n()`

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  mutate(difference = hi - lo) %>%
  group_by(year) %>%
  summarize(n(), mean(year))
```
```output
# A tibble: 9 x 3
   year `n()` `mean(difference)`
  <int> <int>              <dbl>
1  2009     3              0.170
2  2010     3              0.187
3  2011     5              0.168
4  2012     5              0.186
5  2013     6              0.183
6  2014    10              0.168
7  2015     6              0.162
8  2016    10              0.166
9  2017     7              0.153
```

- Let's try again with more meaningful names for the final table's columns
  - We can do this while summarizing, or add `rename` to our pipe

```r
data %>%
  filter(estimate != 0.95) %>%
  filter(lo > 0.5) %>%
  filter(hi <= (lo + 0.2)) %>%
  mutate(difference = hi - lo) %>%
  group_by(year) %>%
  summarize(count = n(), ave_diff = mean(year))
```
```output
# A tibble: 9 x 3
   year count ave_diff
  <int> <int>    <dbl>
1  2009     3    0.170
2  2010     3    0.187
3  2011     5    0.168
4  2012     5    0.186
5  2013     6    0.183
6  2014    10    0.168
7  2015     6    0.162
8  2016    10    0.166
9  2017     7    0.153
```

- How might we do this with Pandas?
  - Use a single multi-part `.query` to select data
  - Store into a variable because we now want to refer to its `hi` and `lo` columns without repeating the filtering expression
  - Group by year and aggregate, again using strings for column names

```py
data = pd.read_csv('tidy/infant_hiv.csv')
data = data.query('(estimate != 0.95) & (lo > 0.5) & (hi <= (lo + 0.2))')
data = data.assign(difference = (data.hi - data.lo))
grouped = data.groupby('year').agg({'difference' : {'ave_diff' : 'mean', 'count' : 'count'}})
print(grouped)
```
```output
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

- There are other ways, but the tidyverse approach produces code that I find more readable
