---
title: "Cleaning Up Data"
output: md_document
permalink: /cleanup/
questions:
  - "How do I read tabular data into a program?"
  - "How do I control the way missing values are handled while I'm reading data?"
  - "What functions should I use to tidy up messy data?"
  - "How can I combine partial tables into a single large table?"
objectives:
  - "Describe and use the `read_csv` function."
  - "Describe and use the `str_replace` function."
  - "Describe and use the `is.numeric` and `as.numeric` functions."
  - "Describe and use the `map` function and its kin."
  - "Describe and use pre-allocation to capture the results of loops."
keypoints:
  - "Develop data-cleaning scripts one step at a time, checking intermediate results carefully."
  - "Use `read_csv` to read CSV-formatted tabular data into a tibble."
  - "Use the `skip` and `na` parameters of `read_csv` to skip rows and interpret certain values as `NA`."
  - "Use `str_replace` to replace portions of strings that match patterns with new strings."
  - "Use `is.numeric` to test if a value is a number and `as.numeric` to convert it to a number."
  - "Use `map` to apply a function to every element of a vector in turn."
  - "Use `map_dfc` and `map_dfr` to map functions across the columns and rows of a tibble."
  - "Pre-allocate storage in a list for each result from a loop and fill it in rather than repeatedly extending the list."
---


```
## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.0.0     ✔ readr   1.1.1
## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
## ✔ tidyr   0.8.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

Here is a sample of data from `raw/infant_hiv.csv`,
where `...` shows values elided to make the segment readable:

```
"Early Infant Diagnosis: Percentage of infants born to women living with HIV...",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,2009,,,2010,,,2011,,,2012,,,2013,,,2014,,,2015,,,2016,,,2017,,,
ISO3,Countries,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,...
AFG,Afghanistan,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
ALB,Albania,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
DZA,Algeria,-,-,-,-,-,-,38%,42%,35%,23%,25%,21%,55%,60%,50%,27%,30%,25%,23%,25%,21%,33%,37%,31%,61%,68%,57%,
AGO,Angola,-,-,-,3%,4%,2%,5%,7%,4%,6%,8%,5%,15%,20%,12%,10%,14%,8%,6%,8%,5%,1%,2%,1%,1%,2%,1%,
... many more rows ...
YEM,Yemen,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
ZMB,Zambia,59%,70%,53%,27%,32%,24%,70%,84%,63%,74%,88%,67%,64%,76%,57%,91%,>95%,81%,43%,52%,39%,43%,51%,39%,46%,54%,41%,
ZWE,Zimbabwe,-,-,-,12%,15%,10%,23%,28%,20%,38%,47%,33%,57%,70%,49%,54%,67%,47%,59%,73%,51%,71%,88%,62%,65%,81%,57%,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,2009,,,2010,,,2011,,,2012,,,2013,,,2014,,,2015,,,2016,,,2017,,,
,,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,...
Region,East Asia and the Pacific,25%,30%,22%,35%,42%,29%,30%,37%,26%,32%,38%,27%,28%,34%,24%,26%,31%,22%,31%,37%,27%,30%,35%,25%,28%,33%,24%,
,Eastern and Southern Africa,23%,29%,20%,44%,57%,37%,48%,62%,40%,54%,69%,46%,51%,65%,43%,62%,80%,53%,62%,79%,52%,54%,68%,45%,62%,80%,53%,
,Eastern Europe and Central Asia,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
... several more rows ...
,Sub-Saharan Africa,16%,22%,13%,34%,46%,28%,37%,50%,30%,43%,57%,35%,41%,54%,33%,50%,66%,41%,50%,66%,41%,45%,60%,37%,52%,69%,42%,
,Global,17%,23%,13%,33%,45%,27%,36%,49%,29%,41%,55%,34%,40%,53%,32%,48%,64%,39%,49%,64%,40%,44%,59%,36%,51%,67%,41%,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Indicator definition: Percentage of infants born to women living with HIV... ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Note: Data are not available if country did not submit data...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Data source: Global AIDS Monitoring 2018 and UNAIDS 2018 estimates,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
"For more information on this indicator, please visit the guidance:...",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
"For more information on the data, visit data.unicef.org",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
```

This is a mess---no, more than that, an affront to what little is left of our sanity.
There are comments mixed with data,
values' actual indices have to be synthesized by combining column headings from two rows
(two thirds of which have to be carried forward from previous columns),
and so on.
We want to create the tidy data found in `tidy/infant_hiv.csv`:

```
country,year,estimate,hi,lo
AFG,2009,NA,NA,NA
AFG,2010,NA,NA,NA
AFG,2011,NA,NA,NA
AFG,2012,NA,NA,NA
...
ZWE,2016,0.71,0.88,0.62
ZWE,2017,0.65,0.81,0.57
```

To bring this data to a state of grace will take some trial and effort,
which we shall do in stages.

## Show Me the Numbers

We will begin by reading the data into a tibble:


```r
raw <- read_csv("raw/infant_hiv.csv")
```

```
## Warning: Missing column names filled in: 'X2' [2], 'X3' [3], 'X4' [4],
## 'X5' [5], 'X6' [6], 'X7' [7], 'X8' [8], 'X9' [9], 'X10' [10], 'X11' [11],
## 'X12' [12], 'X13' [13], 'X14' [14], 'X15' [15], 'X16' [16], 'X17' [17],
## 'X18' [18], 'X19' [19], 'X20' [20], 'X21' [21], 'X22' [22], 'X23' [23],
## 'X24' [24], 'X25' [25], 'X26' [26], 'X27' [27], 'X28' [28], 'X29' [29],
## 'X30' [30]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
head(raw)
```

```
## # A tibble: 6 x 30
##   `Early Infant D… X2    X3    X4    X5    X6    X7    X8    X9    X10  
##   <chr>            <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
## 1 <NA>             <NA>  2009  <NA>  <NA>  2010  <NA>  <NA>  2011  <NA> 
## 2 ISO3             Coun… Esti… hi    lo    Esti… hi    lo    Esti… hi   
## 3 AFG              Afgh… -     -     -     -     -     -     -     -    
## 4 ALB              Alba… -     -     -     -     -     -     -     -    
## 5 DZA              Alge… -     -     -     -     -     -     38%   42%  
## 6 AGO              Ango… -     -     -     3%    4%    2%    5%    7%   
## # ... with 20 more variables: X11 <chr>, X12 <chr>, X13 <chr>, X14 <chr>,
## #   X15 <chr>, X16 <chr>, X17 <chr>, X18 <chr>, X19 <chr>, X20 <chr>,
## #   X21 <chr>, X22 <chr>, X23 <chr>, X24 <chr>, X25 <chr>, X26 <chr>,
## #   X27 <chr>, X28 <chr>, X29 <chr>, X30 <chr>
```

All right:
R isn't able to infer column names,
so it uses the entire first comment string as a very long column name
and then makes up names for the other columns.
Looking at the file,
the second row has years (spaced at three-column intervals)
and the column after that has the [ISO3 country code](../glossary/#iso3-country-code),
the country's name,
and then "Estimate", "hi", and "lo" repeated for every year.
We are going to have to combine what's in the second and third rows,
so we're going to have to do some work no matter which we skip or keep.
Since we want the ISO3 code and the country name,
let's skip the first two rows.


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2)
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
head(raw)
```

```
## # A tibble: 6 x 30
##   ISO3  Countries Estimate hi    lo    Estimate_1 hi_1  lo_1  Estimate_2
##   <chr> <chr>     <chr>    <chr> <chr> <chr>      <chr> <chr> <chr>     
## 1 AFG   Afghanis… -        -     -     -          -     -     -         
## 2 ALB   Albania   -        -     -     -          -     -     -         
## 3 DZA   Algeria   -        -     -     -          -     -     38%       
## 4 AGO   Angola    -        -     -     3%         4%    2%    5%        
## 5 AIA   Anguilla  -        -     -     -          -     -     -         
## 6 ATG   Antigua … -        -     -     -          -     -     -         
## # ... with 21 more variables: hi_2 <chr>, lo_2 <chr>, Estimate_3 <chr>,
## #   hi_3 <chr>, lo_3 <chr>, Estimate_4 <chr>, hi_4 <chr>, lo_4 <chr>,
## #   Estimate_5 <chr>, hi_5 <chr>, lo_5 <chr>, Estimate_6 <chr>,
## #   hi_6 <chr>, lo_6 <chr>, Estimate_7 <chr>, hi_7 <chr>, lo_7 <chr>,
## #   Estimate_8 <chr>, hi_8 <chr>, lo_8 <chr>, X30 <chr>
```

That's a bit of an improvement,
but why are all the columns `character` instead of numbers?
This happens because:

1.  our CSV file uses `-` (a single dash) to show missing data, and
2.  all of our numbers end with `%`, which means those values actually *are* character strings.

We will tackle the first problem by setting `na = c("-")` in our `read_csv` call
(since we should never do ourselves what a library function will do for us):


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
head(raw)
```

```
## # A tibble: 6 x 30
##   ISO3  Countries Estimate hi    lo    Estimate_1 hi_1  lo_1  Estimate_2
##   <chr> <chr>     <chr>    <chr> <chr> <chr>      <chr> <chr> <chr>     
## 1 AFG   Afghanis… <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>      
## 2 ALB   Albania   <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>      
## 3 DZA   Algeria   <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  38%       
## 4 AGO   Angola    <NA>     <NA>  <NA>  3%         4%    2%    5%        
## 5 AIA   Anguilla  <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>      
## 6 ATG   Antigua … <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>      
## # ... with 21 more variables: hi_2 <chr>, lo_2 <chr>, Estimate_3 <chr>,
## #   hi_3 <chr>, lo_3 <chr>, Estimate_4 <chr>, hi_4 <chr>, lo_4 <chr>,
## #   Estimate_5 <chr>, hi_5 <chr>, lo_5 <chr>, Estimate_6 <chr>,
## #   hi_6 <chr>, lo_6 <chr>, Estimate_7 <chr>, hi_7 <chr>, lo_7 <chr>,
## #   Estimate_8 <chr>, hi_8 <chr>, lo_8 <chr>, X30 <chr>
```

That's progress.
We now need to strip the percentage signs and convert what's left to numeric values.
To simplify our lives,
let's get the `ISO3` and `Countries` columns out of the way.
We will save the ISO3 values for later use
(and because it will illustrate a point about data hygiene that we want to make later,
but which we don't want to reveal just yet).


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
countries <- raw$ISO3
body <- raw %>%
  filter(-ISO3, -Countries)
```

```
## Error in filter_impl(.data, quo): Evaluation error: invalid argument to unary operator.
```

In the Hollywood version of this lesson,
we would sigh heavily at this point as we realize that we should have called `select`, not `filter`.
Once we make that change,
we can move forward once again:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
countries <- raw$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
head(body)
```

```
## # A tibble: 6 x 28
##   Estimate hi    lo    Estimate_1 hi_1  lo_1  Estimate_2 hi_2  lo_2 
##   <chr>    <chr> <chr> <chr>      <chr> <chr> <chr>      <chr> <chr>
## 1 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 2 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 3 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  38%        42%   35%  
## 4 <NA>     <NA>  <NA>  3%         4%    2%    5%         7%    4%   
## 5 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 6 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## # ... with 19 more variables: Estimate_3 <chr>, hi_3 <chr>, lo_3 <chr>,
## #   Estimate_4 <chr>, hi_4 <chr>, lo_4 <chr>, Estimate_5 <chr>,
## #   hi_5 <chr>, lo_5 <chr>, Estimate_6 <chr>, hi_6 <chr>, lo_6 <chr>,
## #   Estimate_7 <chr>, hi_7 <chr>, lo_7 <chr>, Estimate_8 <chr>,
## #   hi_8 <chr>, lo_8 <chr>, X30 <chr>
```

But wait.
Weren't there some aggregate lines of data at the end of our input?
What happened to them?


```r
tail(countries, n = 25)
```

```
##  [1] "YEM"                                                                                                                                                       
##  [2] "ZMB"                                                                                                                                                       
##  [3] "ZWE"                                                                                                                                                       
##  [4] ""                                                                                                                                                          
##  [5] ""                                                                                                                                                          
##  [6] ""                                                                                                                                                          
##  [7] "Region"                                                                                                                                                    
##  [8] ""                                                                                                                                                          
##  [9] ""                                                                                                                                                          
## [10] ""                                                                                                                                                          
## [11] ""                                                                                                                                                          
## [12] ""                                                                                                                                                          
## [13] ""                                                                                                                                                          
## [14] ""                                                                                                                                                          
## [15] ""                                                                                                                                                          
## [16] "Super-region"                                                                                                                                              
## [17] ""                                                                                                                                                          
## [18] ""                                                                                                                                                          
## [19] ""                                                                                                                                                          
## [20] ""                                                                                                                                                          
## [21] "Indicator definition: Percentage of infants born to women living with HIV receiving a virological test for HIV within two months of birth"                 
## [22] "Note: Data are not available if country did not submit data to Global AIDS Monitoring or if estimates of pregnant women living with HIV are not published."
## [23] "Data source: Global AIDS Monitoring 2018 and UNAIDS 2018 estimates"                                                                                        
## [24] "For more information on this indicator, please visit the guidance: http://www.unaids.org/sites/default/files/media_asset/global-aids-monitoring_en.pdf"    
## [25] "For more information on the data, visit data.unicef.org"
```

Once again the actor playing our part on screen sighs heavily.
How are we to trim this?
Since there is only one file,
we can manually count the number of rows we are interested in
(or rather, open the file with an editor or spreadsheet program, scroll down, and check the line number),
and then slice there.
This is a very bad idea if we're planning to use this script on other files---we should
instead look for the first blank line or the entry for Zimbabwe or something like that---but
let's revisit the problem once we have our data in place.


```r
num_rows <- 192
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:num_rows)
countries <- sliced$ISO3
tail(countries, n = 5)
```

```
## [1] "VEN" "VNM" "YEM" "ZMB" "ZWE"
```

Notice that we're counting rows *not including* the two we're skipping,
which means that the 192 in the call to `slice` above corresponds to row 195 of our original data:
195, not 194, because we're using the first row of unskipped data as headers and yes,
you are in fact making a faint whimpering sound.
We promise we will revisit the problem of slicing data without counting rows manually
so as to reduce the frequency with which that sound is heard.

And notice also that we are slicing, *then* extracting the column containing the countries.
We did, in a temporary version of this script,
peel off the countries, slice those, and then wonder why our main data table still had unwanted data at the end.
Vigilance, my friends---vigilance shall be our watchword,
and in light of that,
we shall first test our plan for converting our strings to numbers:


```r
fixture <- c(NA, "1%", "10%", "100%")
result <- as.numeric(str_replace(fixture, "%", "")) / 100
result
```

```
## [1]   NA 0.01 0.10 1.00
```

And as a further check:


```r
is.numeric(result)
```

```
## [1] TRUE
```

The function `is.numeric` is `TRUE` for both `NA` and actual numbers,
so it is doing the right thing here,
and so are we.
Our updated conversion script is now:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
numbers <- as.numeric(str_replace(body, "%", "")) / 100
```

```
## Warning in stri_replace_first_regex(string, pattern,
## fix_replacement(replacement), : argument is not an atomic vector; coercing
```

```
## Warning: NAs introduced by coercion
```

```r
is.numeric(numbers)
```

```
## [1] TRUE
```

Oh dear.
It appears that some function `str_replace` is calling is expecting an atomic vector,
not a tibble.
It worked for our test case because that was a character vector,
but tibbles have more structure than that.

The second complaint is that `NA`s were introduced,
which is troubling because we didn't get a complaint when we had actual `NA`s in our data.
However,
`is.numeric` tells us that all of our results are numbers.
Let's take a closer look:


```r
is.tibble(body)
```

```
## [1] TRUE
```

```r
is.tibble(numbers)
```

```
## [1] FALSE
```

Perdition.
After browsing the data,
we realize that some entries are `">95%"`,
i.e.,
there is a greater-than sign as well as a percentage in the text.
We will need to regularize those before we do any conversions.

Before that,
however,
let's see if we can get rid of the percent signs.
The obvious way is is to use `str_replace(body, "%", "")`,
but that doesn't work:
`str_replace` works on vectors,
but a tibble is a list of vectors.
Instead,
we can use `map` to apply the function `str_replace` to each column in turn to get rid of the percent signs:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map(body, str_replace, pattern = "%", replacement = "")
head(trimmed)
```

```
## $Estimate
##   [1] NA         NA         NA         NA         NA         NA        
##   [7] NA         NA         NA         NA         "26"       NA        
##  [13] NA         NA         NA         ">95"      NA         "77"      
##  [19] NA         NA         "7"        NA         NA         "25"      
##  [25] NA         NA         "3"        NA         ">95"      NA        
##  [31] "27"       NA         "1"        NA         NA         NA        
##  [37] "5"        NA         "8"        NA         "92"       NA        
##  [43] NA         "83"       NA         NA         NA         NA        
##  [49] NA         NA         NA         "28"       "1"        "4"       
##  [55] NA         NA         NA         NA         "4"        NA        
##  [61] NA         NA         NA         NA         "61"       NA        
##  [67] NA         NA         NA         NA         NA         NA        
##  [73] NA         NA         "61"       NA         NA         NA        
##  [79] NA         "2"        NA         NA         NA         NA        
##  [85] NA         NA         NA         ">95"      NA         NA        
##  [91] NA         NA         NA         NA         NA         "43"      
##  [97] "5"        NA         NA         NA         NA         NA        
## [103] "37"       NA         "8"        NA         NA         NA        
## [109] NA         NA         NA         NA         NA         "2"       
## [115] NA         NA         NA         NA         "2"        NA        
## [121] NA         "50"       NA         "4"        NA         NA        
## [127] NA         "1"        NA         NA         NA         NA        
## [133] NA         NA         "1"        NA         NA         NA        
## [139] ">95"      NA         NA         "58"       NA         NA        
## [145] NA         NA         NA         NA         "11"       NA        
## [151] NA         NA         NA         NA         NA         NA        
## [157] NA         NA         NA         NA         NA         NA        
## [163] "9"        NA         NA         NA         NA         "1"       
## [169] NA         NA         NA         "7"        NA         NA        
## [175] NA         NA         NA         NA         "8"        "78"      
## [181] NA         NA         "13"       NA         NA         "0"       
## [187] NA         NA         NA         NA         "59"       NA        
## [193] ""         "2009"     "Estimate" "25"       "23"       NA        
## [199] "24"       "2"        NA         "1"        "8"        NA        
## [205] "7"        "72"       "16"       "17"       ""         ""        
## [211] ""         ""         ""         ""        
## 
## $hi
##   [1] NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    "35" 
##  [12] NA    NA    NA    NA    ">95" NA    "89"  NA    NA    "10"  NA   
##  [23] NA    "35"  NA    NA    "5"   NA    ">95" NA    "36"  NA    "1"  
##  [34] NA    NA    NA    "6"   NA    "12"  NA    ">95" NA    NA    ">95"
##  [45] NA    NA    NA    NA    NA    NA    NA    "36"  "1"   "4"   NA   
##  [56] NA    NA    NA    "6"   NA    NA    NA    NA    NA    "77"  NA   
##  [67] NA    NA    NA    NA    NA    NA    NA    NA    "74"  NA    NA   
##  [78] NA    NA    "2"   NA    NA    NA    NA    NA    NA    NA    ">95"
##  [89] NA    NA    NA    NA    NA    NA    NA    "53"  "7"   NA    NA   
## [100] NA    NA    NA    "44"  NA    "9"   NA    NA    NA    NA    NA   
## [111] NA    NA    NA    "2"   NA    NA    NA    NA    "2"   NA    NA   
## [122] "69"  NA    "7"   NA    NA    NA    "1"   NA    NA    NA    NA   
## [133] NA    NA    "1"   NA    NA    NA    ">95" NA    NA    "75"  NA   
## [144] NA    NA    NA    NA    NA    "13"  NA    NA    NA    NA    NA   
## [155] NA    NA    NA    NA    NA    NA    NA    NA    "11"  NA    NA   
## [166] NA    NA    "1"   NA    NA    NA    "12"  NA    NA    NA    NA   
## [177] NA    NA    "9"   "95"  NA    NA    "16"  NA    NA    "1"   NA   
## [188] NA    NA    NA    "70"  NA    ""    ""    "hi"  "30"  "29"  NA   
## [199] "32"  "2"   NA    "2"   "12"  NA    "9"   "89"  "22"  "23"  ""   
## [210] ""    ""    ""    ""    ""   
## 
## $lo
##   [1] NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    "18" 
##  [12] NA    NA    NA    NA    ">95" NA    "3"   NA    NA    "5"   NA   
##  [23] NA    "19"  NA    NA    "3"   NA    "85"  NA    "23"  NA    "1"  
##  [34] NA    NA    NA    "4"   NA    "6"   NA    "81"  NA    NA    "75" 
##  [45] NA    NA    NA    NA    NA    NA    NA    "21"  "0"   "3"   NA   
##  [56] NA    NA    NA    "3"   NA    NA    NA    NA    NA    "49"  NA   
##  [67] NA    NA    NA    NA    NA    NA    NA    NA    "51"  NA    NA   
##  [78] NA    NA    "1"   NA    NA    NA    NA    NA    NA    NA    ">95"
##  [89] NA    NA    NA    NA    NA    NA    NA    "38"  "4"   NA    NA   
## [100] NA    NA    NA    "32"  NA    "6"   NA    NA    NA    NA    NA   
## [111] NA    NA    NA    "1"   NA    NA    NA    NA    "1"   NA    NA   
## [122] "33"  NA    "3"   NA    NA    NA    "1"   NA    NA    NA    NA   
## [133] NA    NA    "1"   NA    NA    NA    "89"  NA    NA    "49"  NA   
## [144] NA    NA    NA    NA    NA    "9"   NA    NA    NA    NA    NA   
## [155] NA    NA    NA    NA    NA    NA    NA    NA    "7"   NA    NA   
## [166] NA    NA    "0"   NA    NA    NA    "5"   NA    NA    NA    NA   
## [177] NA    NA    "7"   "65"  NA    NA    "11"  NA    NA    "0"   NA   
## [188] NA    NA    NA    "53"  NA    ""    ""    "lo"  "22"  "20"  NA   
## [199] "16"  "1"   NA    "1"   "6"   NA    "6"   "59"  "13"  "13"  ""   
## [210] ""    ""    ""    ""    ""   
## 
## $Estimate_1
##   [1] NA         NA         NA         "3"        NA         NA        
##   [7] NA         NA         NA         NA         "24"       NA        
##  [13] NA         "2"        NA         ">95"      NA         "75"      
##  [19] NA         NA         "46"       NA         "53"       "25"      
##  [25] NA         NA         "9"        "10"       ">95"      "45"      
##  [31] "20"       NA         "1"        "3"        NA         NA        
##  [37] "10"       NA         "7"        NA         "69"       "22"      
##  [43] NA         ">95"      NA         NA         NA         "3"       
##  [49] NA         NA         NA         "10"       "1"        "5"       
##  [55] "28"       NA         NA         NA         "40"       NA        
##  [61] NA         NA         "6"        NA         "82"       NA        
##  [67] "1"        NA         NA         NA         "5"        NA        
##  [73] "27"       NA         "69"       NA         NA         "6"       
##  [79] NA         "13"       NA         NA         NA         NA        
##  [85] NA         NA         NA         ">95"      "75"       NA        
##  [91] NA         NA         "1"        NA         NA         ">95"     
##  [97] "5"        NA         NA         NA         NA         NA        
## [103] "61"       NA         "8"        NA         NA         NA        
## [109] NA         NA         NA         NA         NA         "21"      
## [115] "31"       "1"        "57"       NA         "3"        NA        
## [121] NA         "38"       NA         "6"        NA         NA        
## [127] NA         "1"        NA         NA         "30"       NA        
## [133] "27"       NA         "3"        NA         NA         NA        
## [139] ">95"      NA         NA         "73"       NA         NA        
## [145] NA         NA         NA         NA         "11"       NA        
## [151] NA         "1"        NA         NA         NA         NA        
## [157] NA         "66"       NA         NA         NA         NA        
## [163] "9"        "50"       NA         NA         NA         "4"       
## [169] "54"       NA         NA         "14"       NA         NA        
## [175] NA         NA         NA         NA         "13"       ">95"     
## [181] NA         NA         "24"       NA         "62"       "12"      
## [187] NA         NA         NA         NA         "27"       "12"      
## [193] ""         "2010"     "Estimate" "35"       "44"       NA        
## [199] "18"       "11"       NA         "6"        "8"        NA        
## [205] "15"       "90"       "34"       "33"       ""         ""        
## [211] ""         ""         ""         ""        
## 
## $hi_1
##   [1] NA    NA    NA    "4"   NA    NA    NA    NA    NA    NA    "31" 
##  [12] NA    NA    "3"   NA    ">95" NA    "88"  NA    NA    "67"  NA   
##  [23] "62"  "35"  NA    NA    "14"  "15"  ">95" "54"  "26"  NA    "1"  
##  [34] "4"   NA    NA    "12"  NA    "10"  NA    "78"  "34"  NA    ">95"
##  [45] NA    NA    NA    "4"   NA    NA    NA    "13"  "1"   "5"   "32" 
##  [56] NA    NA    NA    "61"  NA    NA    NA    "8"   NA    ">95" NA   
##  [67] "1"   NA    NA    NA    "6"   NA    "30"  NA    "86"  NA    NA   
##  [78] "9"   NA    "18"  NA    NA    NA    NA    NA    NA    NA    ">95"
##  [89] ">95" NA    NA    NA    "1"   NA    NA    ">95" "7"   NA    NA   
## [100] NA    NA    NA    "72"  NA    "9"   NA    NA    NA    NA    NA   
## [111] NA    NA    NA    "28"  "42"  "2"   "72"  NA    "4"   NA    NA   
## [122] "51"  NA    "10"  NA    NA    NA    "2"   NA    NA    "35"  NA   
## [133] "40"  NA    "4"   NA    NA    NA    ">95" NA    NA    ">95" NA   
## [144] NA    NA    NA    NA    NA    "12"  NA    NA    "1"   NA    NA   
## [155] NA    NA    NA    "88"  NA    NA    NA    NA    "11"  "59"  NA   
## [166] NA    NA    "5"   "66"  NA    NA    "23"  NA    NA    NA    NA   
## [177] NA    NA    "16"  ">95" NA    NA    "30"  NA    "73"  "16"  NA   
## [188] NA    NA    NA    "32"  "15"  ""    ""    "hi"  "42"  "57"  NA   
## [199] "23"  "15"  NA    "8"   "12"  NA    "20"  ">95" "46"  "45"  ""   
## [210] ""    ""    ""    ""    ""   
## 
## $lo_1
##   [1] NA    NA    NA    "2"   NA    NA    NA    NA    NA    NA    "17" 
##  [12] NA    NA    "2"   NA    ">95" NA    "3"   NA    NA    "34"  NA   
##  [23] "47"  "19"  NA    NA    "7"   "8"   "87"  "39"  "16"  NA    "1"  
##  [34] "3"   NA    NA    "8"   NA    "5"   NA    "61"  "15"  NA    "85" 
##  [45] NA    NA    NA    "2"   NA    NA    NA    "8"   "0"   "4"   "25" 
##  [56] NA    NA    NA    "30"  NA    NA    NA    "5"   NA    "66"  NA   
##  [67] "1"   NA    NA    NA    "4"   NA    "24"  NA    "59"  NA    NA   
##  [78] "4"   NA    "9"   NA    NA    NA    NA    NA    NA    NA    ">95"
##  [89] "63"  NA    NA    NA    "1"   NA    NA    "88"  "4"   NA    NA   
## [100] NA    NA    NA    "52"  NA    "7"   NA    NA    NA    NA    NA   
## [111] NA    NA    NA    "17"  "25"  "1"   "50"  NA    "3"   NA    NA   
## [122] "25"  NA    "4"   NA    NA    NA    "1"   NA    NA    "27"  NA   
## [133] "17"  NA    "3"   NA    NA    NA    ">95" NA    NA    "63"  NA   
## [144] NA    NA    NA    NA    NA    "9"   NA    NA    "0"   NA    NA   
## [155] NA    NA    NA    "56"  NA    NA    NA    NA    "7"   "45"  NA   
## [166] NA    NA    "3"   "46"  NA    NA    "10"  NA    NA    NA    NA   
## [177] NA    NA    "11"  "86"  NA    NA    "20"  NA    "54"  "9"   NA   
## [188] NA    NA    NA    "24"  "10"  ""    ""    "lo"  "29"  "37"  NA   
## [199] "13"  "8"   NA    "4"   "6"   NA    "11"  "73"  "28"  "27"  ""   
## [210] ""    ""    ""    ""    ""
```

Perdition once again.
The problem now is that `map` produces a raw list as output.
The function we want is `map_dfc`,
which maps a function across the columns of a tibble and returns a tibble as a result.
(There is a corresponding function `map_dfr` that maps a function across rows.)


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = "%", replacement = "")
head(trimmed)
```

```
## # A tibble: 6 x 28
##   Estimate hi    lo    Estimate_1 hi_1  lo_1  Estimate_2 hi_2  lo_2 
##   <chr>    <chr> <chr> <chr>      <chr> <chr> <chr>      <chr> <chr>
## 1 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 2 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 3 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  38         42    35   
## 4 <NA>     <NA>  <NA>  3          4     2     5          7     4    
## 5 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## 6 <NA>     <NA>  <NA>  <NA>       <NA>  <NA>  <NA>       <NA>  <NA> 
## # ... with 19 more variables: Estimate_3 <chr>, hi_3 <chr>, lo_3 <chr>,
## #   Estimate_4 <chr>, hi_4 <chr>, lo_4 <chr>, Estimate_5 <chr>,
## #   hi_5 <chr>, lo_5 <chr>, Estimate_6 <chr>, hi_6 <chr>, lo_6 <chr>,
## #   Estimate_7 <chr>, hi_7 <chr>, lo_7 <chr>, Estimate_8 <chr>,
## #   hi_8 <chr>, lo_8 <chr>, X30 <chr>
```

Now to tackle those `">95%"` values.
It turns out that `str_replace` uses [regular expressions](../glossary/#regular-expression),
not just direct string matches,
so we can get rid of the `>` at the same time as we get rid of the `%`.
We will check by looking at the first `Estimate` column,
which earlier inspection informed us had at least one `">95%"` in it:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
trimmed$Estimate
```

```
##   [1] NA         NA         NA         NA         NA         NA        
##   [7] NA         NA         NA         NA         "26"       NA        
##  [13] NA         NA         NA         "95"       NA         "77"      
##  [19] NA         NA         "7"        NA         NA         "25"      
##  [25] NA         NA         "3"        NA         "95"       NA        
##  [31] "27"       NA         "1"        NA         NA         NA        
##  [37] "5"        NA         "8"        NA         "92"       NA        
##  [43] NA         "83"       NA         NA         NA         NA        
##  [49] NA         NA         NA         "28"       "1"        "4"       
##  [55] NA         NA         NA         NA         "4"        NA        
##  [61] NA         NA         NA         NA         "61"       NA        
##  [67] NA         NA         NA         NA         NA         NA        
##  [73] NA         NA         "61"       NA         NA         NA        
##  [79] NA         "2"        NA         NA         NA         NA        
##  [85] NA         NA         NA         "95"       NA         NA        
##  [91] NA         NA         NA         NA         NA         "43"      
##  [97] "5"        NA         NA         NA         NA         NA        
## [103] "37"       NA         "8"        NA         NA         NA        
## [109] NA         NA         NA         NA         NA         "2"       
## [115] NA         NA         NA         NA         "2"        NA        
## [121] NA         "50"       NA         "4"        NA         NA        
## [127] NA         "1"        NA         NA         NA         NA        
## [133] NA         NA         "1"        NA         NA         NA        
## [139] "95"       NA         NA         "58"       NA         NA        
## [145] NA         NA         NA         NA         "11"       NA        
## [151] NA         NA         NA         NA         NA         NA        
## [157] NA         NA         NA         NA         NA         NA        
## [163] "9"        NA         NA         NA         NA         "1"       
## [169] NA         NA         NA         "7"        NA         NA        
## [175] NA         NA         NA         NA         "8"        "78"      
## [181] NA         NA         "13"       NA         NA         "0"       
## [187] NA         NA         NA         NA         "59"       NA        
## [193] ""         "2009"     "Estimate" "25"       "23"       NA        
## [199] "24"       "2"        NA         "1"        "8"        NA        
## [205] "7"        "72"       "16"       "17"       ""         ""        
## [211] ""         ""         ""         ""
```

Excellent.
We can now use `map_dfc` to convert the columns to numeric percentages
using an anonymous function that we define inside the `map_dfr` call itself:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
percents <- map_dfr(trimmed, function(col) as.numeric(col) / 100)
```

```
## Warning in .f(.x[[i]], ...): NAs introduced by coercion
```

```
## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion
```

```r
head(percents)
```

```
## # A tibble: 6 x 28
##   Estimate    hi    lo Estimate_1  hi_1  lo_1 Estimate_2  hi_2  lo_2
##      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
## 1       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 2       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 3       NA    NA    NA      NA    NA    NA          0.38  0.42  0.35
## 4       NA    NA    NA       0.03  0.04  0.02       0.05  0.07  0.04
## 5       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 6       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## # ... with 19 more variables: Estimate_3 <dbl>, hi_3 <dbl>, lo_3 <dbl>,
## #   Estimate_4 <dbl>, hi_4 <dbl>, lo_4 <dbl>, Estimate_5 <dbl>,
## #   hi_5 <dbl>, lo_5 <dbl>, Estimate_6 <dbl>, hi_6 <dbl>, lo_6 <dbl>,
## #   Estimate_7 <dbl>, hi_7 <dbl>, lo_7 <dbl>, Estimate_8 <dbl>,
## #   hi_8 <dbl>, lo_8 <dbl>, X30 <dbl>
```

27 warnings is rather a lot,
so let's see what running `warnings()` produces right after the `as.numeric` call:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- raw %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
percents <- map_dfr(trimmed, function(col) as.numeric(col) / 100)
```

```
## Warning in .f(.x[[i]], ...): NAs introduced by coercion
```

```
## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion

## Warning in .f(.x[[i]], ...): NAs introduced by coercion
```

```r
warnings()
```

Something is still not right.
The first `Estimates` column looks all right,
so let's have a look at the second column:


```r
trimmed$hi
```

```
##   [1] NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   "35" NA   NA   NA  
##  [15] NA   "95" NA   "89" NA   NA   "10" NA   NA   "35" NA   NA   "5"  NA  
##  [29] "95" NA   "36" NA   "1"  NA   NA   NA   "6"  NA   "12" NA   "95" NA  
##  [43] NA   "95" NA   NA   NA   NA   NA   NA   NA   "36" "1"  "4"  NA   NA  
##  [57] NA   NA   "6"  NA   NA   NA   NA   NA   "77" NA   NA   NA   NA   NA  
##  [71] NA   NA   NA   NA   "74" NA   NA   NA   NA   "2"  NA   NA   NA   NA  
##  [85] NA   NA   NA   "95" NA   NA   NA   NA   NA   NA   NA   "53" "7"  NA  
##  [99] NA   NA   NA   NA   "44" NA   "9"  NA   NA   NA   NA   NA   NA   NA  
## [113] NA   "2"  NA   NA   NA   NA   "2"  NA   NA   "69" NA   "7"  NA   NA  
## [127] NA   "1"  NA   NA   NA   NA   NA   NA   "1"  NA   NA   NA   "95" NA  
## [141] NA   "75" NA   NA   NA   NA   NA   NA   "13" NA   NA   NA   NA   NA  
## [155] NA   NA   NA   NA   NA   NA   NA   NA   "11" NA   NA   NA   NA   "1" 
## [169] NA   NA   NA   "12" NA   NA   NA   NA   NA   NA   "9"  "95" NA   NA  
## [183] "16" NA   NA   "1"  NA   NA   NA   NA   "70" NA   ""   ""   "hi" "30"
## [197] "29" NA   "32" "2"  NA   "2"  "12" NA   "9"  "89" "22" "23" ""   ""  
## [211] ""   ""   ""   ""
```

Empty strings.
Why'd it have to be empty strings?
More importantly,
where are they coming from?
Let's backtrack by displaying the `hi` column of each of our [intermediate variables](../glossary/#intermediate-variable)...

...and there's our bug.
We are creating a variable called `sliced` that has only the rows we care about,
but then using the full table in `raw` to create `body`.
It's a simple mistake,
and one that could easily have slipped by us.
Here is our revised script,
in which we check *both* the head and the tail:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
sliced <- slice(raw, 1:192)
countries <- sliced$ISO3
body <- sliced %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
percents <- map_dfr(trimmed, function(col) as.numeric(col) / 100)
head(percents)
```

```
## # A tibble: 6 x 28
##   Estimate    hi    lo Estimate_1  hi_1  lo_1 Estimate_2  hi_2  lo_2
##      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
## 1       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 2       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 3       NA    NA    NA      NA    NA    NA          0.38  0.42  0.35
## 4       NA    NA    NA       0.03  0.04  0.02       0.05  0.07  0.04
## 5       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## 6       NA    NA    NA      NA    NA    NA         NA    NA    NA   
## # ... with 19 more variables: Estimate_3 <dbl>, hi_3 <dbl>, lo_3 <dbl>,
## #   Estimate_4 <dbl>, hi_4 <dbl>, lo_4 <dbl>, Estimate_5 <dbl>,
## #   hi_5 <dbl>, lo_5 <dbl>, Estimate_6 <dbl>, hi_6 <dbl>, lo_6 <dbl>,
## #   Estimate_7 <dbl>, hi_7 <dbl>, lo_7 <dbl>, Estimate_8 <dbl>,
## #   hi_8 <dbl>, lo_8 <dbl>, X30 <dbl>
```

```r
tail(percents)
```

```
## # A tibble: 6 x 28
##   Estimate    hi    lo Estimate_1  hi_1  lo_1 Estimate_2  hi_2  lo_2
##      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>      <dbl> <dbl> <dbl>
## 1    NA     NA   NA         NA    NA    NA         NA    NA    NA   
## 2    NA     NA   NA         NA    NA    NA         NA    NA    NA   
## 3    NA     NA   NA         NA    NA    NA          0.31  0.37  0.26
## 4    NA     NA   NA         NA    NA    NA         NA    NA    NA   
## 5     0.59   0.7  0.53       0.27  0.32  0.24       0.7   0.84  0.63
## 6    NA     NA   NA          0.12  0.15  0.1        0.23  0.28  0.2 
## # ... with 19 more variables: Estimate_3 <dbl>, hi_3 <dbl>, lo_3 <dbl>,
## #   Estimate_4 <dbl>, hi_4 <dbl>, lo_4 <dbl>, Estimate_5 <dbl>,
## #   hi_5 <dbl>, lo_5 <dbl>, Estimate_6 <dbl>, hi_6 <dbl>, lo_6 <dbl>,
## #   Estimate_7 <dbl>, hi_7 <dbl>, lo_7 <dbl>, Estimate_8 <dbl>,
## #   hi_8 <dbl>, lo_8 <dbl>, X30 <dbl>
```

Comparing this to the raw data file convinces us that yes,
we are now converting the percentages properly,
which means we are halfway home.

## Cut, Pad, and Stitch

We now have numeric values in `percents` and corresponding ISO3 codes in `countries`.
What we do *not* have is tidy data:
countries are not associated with records,
years are not recorded at all,
and the column headers for `percents` have mostly been manufactured for us by R.
We must now sew these parts together like Dr. Frankenstein's trusty assistant Igor
(who, like all in his trade, did most of the actual work but was given only crumbs of credit).

Our starting point is this:

1.  Each row in `percents` corresponds positionally to an ISO3 code in `countries`.
2.  Each group of three consecutive columns in `percents` has the estimate, high, and low values
    for a single year.
3.  The years themselves are not stored in `percents`,
    but we know from inspection that they start at 2009 and run without interruption to 2017.

Our strategy is to make a list of temporary tables:

1.  Take three columns at a time from `percents` to create a temporary tibble.
2.  Join `countries` to it.
3.  Create a column holding the year in each row and join that as well.

and then join those temporary tables row-wise to create our final tidy table.
(We might,
through clever use of `scatter` and `gather`,
be able to do this without a loop,
but at this point on our journey,
a loop is probably simpler.)
Here is the addition to our script:


```r
first_year <- 2009
last_year <- 2017
num_years <- (last_year - first_year) + 1
chunks <- vector("list", num_years)
for (year in 1:num_years) {
  end <- year + 2
  temp <- select(percents, year:end)
  names(temp) <- c("estimate", "hi", "lo")
  temp$country <- countries
  temp$year <- rep((first_year + year) - 1, num_rows)
  temp <- select(temp, country, year, everything())
  chunks[[year]] <- temp
}
chunks
```

```
## [[1]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2009       NA    NA    NA
##  2 ALB      2009       NA    NA    NA
##  3 DZA      2009       NA    NA    NA
##  4 AGO      2009       NA    NA    NA
##  5 AIA      2009       NA    NA    NA
##  6 ATG      2009       NA    NA    NA
##  7 ARG      2009       NA    NA    NA
##  8 ARM      2009       NA    NA    NA
##  9 AUS      2009       NA    NA    NA
## 10 AUT      2009       NA    NA    NA
## # ... with 182 more rows
## 
## [[2]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2010       NA    NA NA   
##  2 ALB      2010       NA    NA NA   
##  3 DZA      2010       NA    NA NA   
##  4 AGO      2010       NA    NA  0.03
##  5 AIA      2010       NA    NA NA   
##  6 ATG      2010       NA    NA NA   
##  7 ARG      2010       NA    NA NA   
##  8 ARM      2010       NA    NA NA   
##  9 AUS      2010       NA    NA NA   
## 10 AUT      2010       NA    NA NA   
## # ... with 182 more rows
## 
## [[3]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2011       NA NA    NA   
##  2 ALB      2011       NA NA    NA   
##  3 DZA      2011       NA NA    NA   
##  4 AGO      2011       NA  0.03  0.04
##  5 AIA      2011       NA NA    NA   
##  6 ATG      2011       NA NA    NA   
##  7 ARG      2011       NA NA    NA   
##  8 ARM      2011       NA NA    NA   
##  9 AUS      2011       NA NA    NA   
## 10 AUT      2011       NA NA    NA   
## # ... with 182 more rows
## 
## [[4]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2012    NA    NA    NA   
##  2 ALB      2012    NA    NA    NA   
##  3 DZA      2012    NA    NA    NA   
##  4 AGO      2012     0.03  0.04  0.02
##  5 AIA      2012    NA    NA    NA   
##  6 ATG      2012    NA    NA    NA   
##  7 ARG      2012    NA    NA    NA   
##  8 ARM      2012    NA    NA    NA   
##  9 AUS      2012    NA    NA    NA   
## 10 AUT      2012    NA    NA    NA   
## # ... with 182 more rows
## 
## [[5]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2013    NA    NA    NA   
##  2 ALB      2013    NA    NA    NA   
##  3 DZA      2013    NA    NA     0.38
##  4 AGO      2013     0.04  0.02  0.05
##  5 AIA      2013    NA    NA    NA   
##  6 ATG      2013    NA    NA    NA   
##  7 ARG      2013    NA    NA     0.13
##  8 ARM      2013    NA    NA    NA   
##  9 AUS      2013    NA    NA    NA   
## 10 AUT      2013    NA    NA    NA   
## # ... with 182 more rows
## 
## [[6]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2014    NA    NA    NA   
##  2 ALB      2014    NA    NA    NA   
##  3 DZA      2014    NA     0.38  0.42
##  4 AGO      2014     0.02  0.05  0.07
##  5 AIA      2014    NA    NA    NA   
##  6 ATG      2014    NA    NA    NA   
##  7 ARG      2014    NA     0.13  0.14
##  8 ARM      2014    NA    NA    NA   
##  9 AUS      2014    NA    NA    NA   
## 10 AUT      2014    NA    NA    NA   
## # ... with 182 more rows
## 
## [[7]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2015    NA    NA    NA   
##  2 ALB      2015    NA    NA    NA   
##  3 DZA      2015     0.38  0.42  0.35
##  4 AGO      2015     0.05  0.07  0.04
##  5 AIA      2015    NA    NA    NA   
##  6 ATG      2015    NA    NA    NA   
##  7 ARG      2015     0.13  0.14  0.11
##  8 ARM      2015    NA    NA    NA   
##  9 AUS      2015    NA    NA    NA   
## 10 AUT      2015    NA    NA    NA   
## # ... with 182 more rows
## 
## [[8]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2016    NA    NA    NA   
##  2 ALB      2016    NA    NA    NA   
##  3 DZA      2016     0.42  0.35  0.23
##  4 AGO      2016     0.07  0.04  0.06
##  5 AIA      2016    NA    NA    NA   
##  6 ATG      2016    NA    NA    NA   
##  7 ARG      2016     0.14  0.11  0.12
##  8 ARM      2016    NA    NA    NA   
##  9 AUS      2016    NA    NA    NA   
## 10 AUT      2016    NA    NA    NA   
## # ... with 182 more rows
## 
## [[9]]
## # A tibble: 192 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 AFG      2017    NA    NA    NA   
##  2 ALB      2017    NA    NA    NA   
##  3 DZA      2017     0.35  0.23  0.25
##  4 AGO      2017     0.04  0.06  0.08
##  5 AIA      2017    NA    NA    NA   
##  6 ATG      2017    NA    NA    NA   
##  7 ARG      2017     0.11  0.12  0.14
##  8 ARM      2017    NA    NA    NA   
##  9 AUS      2017    NA    NA    NA   
## 10 AUT      2017    NA    NA    NA   
## # ... with 182 more rows
```

We start by giving names to our years;
if or when we decide to use this script for other data files,
we should extract the years from the data itself.
We then use `vector` to create the storage we are going to need to hold our temporary tables.
We could grow the list one item at a time,
but [allocating storage in advance](../glossary/#storage-allocation) is more efficient
and serves as a check on our logic:
if our loop doesn't run for the right number of iterations,
we will either overflow our list or have empty entries,
either of which should draw our attention.

Within the loop we figure out the bounds on the next three-column stripe,
select that,
and then give those three columns meaningful names.
This ensures that when we join all the sub-tables together,
the columns of the result will also be sensibly named.
Attaching the ISO3 country codes is as easy as assigning to `temp$country`,
and replicating the year for each row is easily done using the `rep` function.
We then reorder the columns to put country and year first
(the call to `everything` inside `select` selects all columns that aren't specifically selected),
and then we assign the temporary table to the appropriate slot in `chunks` using `[[..]]`.

As its name suggests,
`bind_rows` takes a list of tables and concatenates their rows in order.
Since we have taken care to give all of those tables the same column names,
no subsequent renaming is necessary.
We do,
however,
use `arrange` to order entries by country and year.

Now comes the payoff for all that hard work:


```r
tidy <- bind_rows(chunks)
tidy <- arrange(tidy, country, year)
tidy
```

```
## # A tibble: 1,728 x 5
##    country  year estimate    hi    lo
##    <chr>   <dbl>    <dbl> <dbl> <dbl>
##  1 ""       2009       NA    NA    NA
##  2 ""       2010       NA    NA    NA
##  3 ""       2011       NA    NA    NA
##  4 ""       2012       NA    NA    NA
##  5 ""       2013       NA    NA    NA
##  6 ""       2014       NA    NA    NA
##  7 ""       2015       NA    NA    NA
##  8 ""       2016       NA    NA    NA
##  9 ""       2017       NA    NA    NA
## 10 AFG      2009       NA    NA    NA
## # ... with 1,718 more rows
```

What fresh hell is this?
Why do some rows have empty strings where country codes should be
and `NA`s for the three percentages?
Is our indexing off?
Have we somehow created one extra row for each year with nonsense values?

No.
It is not our tools that have failed us, or our reason, but our data.
("These parts are not fresh, Igor---I must have *fresh* parts to work with!")
Let us do this:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
missing <- raw %>%
  filter(is.na(Countries) | (Countries == "") | is.na(ISO3) | (ISO3 == "")) %>%
  select(Countries, ISO3)
missing
```

```
## # A tibble: 21 x 2
##    Countries                       ISO3 
##    <chr>                           <chr>
##  1 Kosovo                          ""   
##  2 ""                              ""   
##  3 ""                              ""   
##  4 ""                              ""   
##  5 Eastern and Southern Africa     ""   
##  6 Eastern Europe and Central Asia ""   
##  7 Latin America and the Caribbean ""   
##  8 Middle East and North Africa    ""   
##  9 North America                   ""   
## 10 South Asia                      ""   
## # ... with 11 more rows
```

The lack of ISO3 country code for the region names doesn't bother us,
but Kosovo is definitely a problem.
[According to Wikipedia][wikipedia-iso3],
UNK is used for Kosovo residents whose travel documents were issued by the United Nations,
so we will fill that in with an ugly hack immediately after loading the data:


```r
raw <- read_csv("raw/infant_hiv.csv", skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
missing <- raw %>%
  filter(is.na(Countries) | (Countries == "") | is.na(ISO3) | (ISO3 == "")) %>%
  select(Countries, ISO3)
missing
```

```
## # A tibble: 20 x 2
##    Countries               ISO3                                           
##    <chr>                   <chr>                                          
##  1 ""                      ""                                             
##  2 ""                      ""                                             
##  3 ""                      ""                                             
##  4 Eastern and Southern A… ""                                             
##  5 Eastern Europe and Cen… ""                                             
##  6 Latin America and the … ""                                             
##  7 Middle East and North … ""                                             
##  8 North America           ""                                             
##  9 South Asia              ""                                             
## 10 West and Central Africa ""                                             
## 11 Western Europe          ""                                             
## 12 Europe and Central Asia ""                                             
## 13 Sub-Saharan Africa      ""                                             
## 14 Global                  ""                                             
## 15 ""                      ""                                             
## 16 ""                      Indicator definition: Percentage of infants bo…
## 17 ""                      Note: Data are not available if country did no…
## 18 ""                      Data source: Global AIDS Monitoring 2018 and U…
## 19 ""                      For more information on this indicator, please…
## 20 ""                      For more information on the data, visit data.u…
```

All right.
Let's add that hack to our script,
then save the result to a file.
The whole thing is now 38 lines long:


```r
# Constants.
raw_filename <- "raw/infant_hiv.csv"
tidy_filename <- "tidy/infant_hiv.csv"
num_rows <- 192
first_year <- 2009
last_year <- 2017

# Get and clean percentages.
raw <- read_csv(raw_filename, skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
sliced <- slice(raw, 1:num_rows)
countries <- sliced$ISO3
body <- sliced %>%
  select(-ISO3, -Countries)
trimmed <- map_dfr(body, str_replace, pattern = ">?(\\d+)%", replacement = "\\1")
percents <- map_dfr(trimmed, function(col) as.numeric(col) / 100)

# Separate three-column chunks and add countries and years.
num_years <- (last_year - first_year) + 1
chunks <- vector("list", num_years)
for (year in 1:num_years) {
  end <- year + 2
  temp <- select(percents, year:end)
  names(temp) <- c("estimate", "hi", "lo")
  temp$country <- countries
  temp$year <- rep((first_year + year) - 1, num_rows)
  temp <- select(temp, country, year, everything())
  chunks[[year]] <- temp
}

# Combine chunks and order by country and year.
tidy <- bind_rows(chunks)
tidy <- arrange(tidy, country, year)

# Save.
write_csv(tidy, tidy_filename)
```

"It's alive!",
we exclaim,
but we can do better.
Let's start by using a pipeline for the code that extracts and formats the percentages:


```r
# Constants...

# Get and clean percentages.
raw <- read_csv(raw_filename, skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
sliced <- slice(raw, 1:num_rows)
countries <- sliced$ISO3
percents <- sliced %>%
  select(-ISO3, -Countries) %>%
  map_dfr(str_replace, pattern = ">?(\\d+)%", replacement = "\\1") %>%
  map_dfr(function(col) as.numeric(col) / 100)

# Separate three-column chunks and add countries and years...

# Combine chunks and order by country and year...

# Check...
```

The two changes are:

1.  We use a `%>%` pipe for the various transformations involved in creating percentages.
2.  We write the result to `temp.csv` so that we can compare it to the file created by our previous script.
    We should always do this sort of comparison when refactoring code in ways that isn't meant to change output;
    if the file is small enough to store in version control,
    we could overwrite it and use `git diff` or something similar to check whether it has changed.
    However,
    we would then have to trust ourselves to be careful enough not to accidentally commit changes,
    and frankly,
    we are no longer sure how trustworthy we are...

After checking that this has not changed the output,
we pipeline the computation in the loop:


```r
# Constans...

# Get and clean percentages...

# Separate three-column chunks and add countries and years.
num_years <- (last_year - first_year) + 1
chunks <- vector("list", num_years)
for (year in 1:num_years) {
  chunks[[year]] <- select(percents, year:(year + 2)) %>%
    rename(estimate = 1, hi = 2, lo = 3) %>%
    mutate(country = countries,
           year = rep((first_year + year) - 1, num_rows)) %>%
    select(country, year, everything())
}

# Combine chunks and order by country and year.
tidy <- bind_rows(chunks) %>%
  arrange(country, year)
```

We have introduced a call to `rename` here to give the columns of each sub-table the right names,
and used `mutate` instead of assigning to named columns one by one.
The lack of intermediate variables may make the code harder to debug using print statements,
but certainly makes this incantation easier to read aloud.

So we run it and inspect the output and it's the same as what we had
and we're about to commit to version control
when we decide to double check against the original data and guess what?
The values for Argentina are wrong.
In fact,
the values for most countries and years are wrong:
only the ones in the first three columns are right.
The problem,
it turns out,
is that our loop index `year` is going up in ones,
while each year's data is three columns wide.
Here's the final, *final*, __*final*__ version:


```r
library(tidyverse)

# Constants.
raw_filename <- "raw/infant_hiv.csv"
tidy_filename <- "tidy/infant_hiv.csv"
first_year <- 2009
last_year <- 2017
num_rows <- 192

# Get and clean percentages.
raw <- read_csv(raw_filename, skip = 2, na = c("-"))
```

```
## Warning: Missing column names filled in: 'X30' [30]
```

```
## Warning: Duplicated column names deduplicated: 'Estimate' =>
## 'Estimate_1' [6], 'hi' => 'hi_1' [7], 'lo' => 'lo_1' [8], 'Estimate' =>
## 'Estimate_2' [9], 'hi' => 'hi_2' [10], 'lo' => 'lo_2' [11], 'Estimate' =>
## 'Estimate_3' [12], 'hi' => 'hi_3' [13], 'lo' => 'lo_3' [14], 'Estimate' =>
## 'Estimate_4' [15], 'hi' => 'hi_4' [16], 'lo' => 'lo_4' [17], 'Estimate' =>
## 'Estimate_5' [18], 'hi' => 'hi_5' [19], 'lo' => 'lo_5' [20], 'Estimate' =>
## 'Estimate_6' [21], 'hi' => 'hi_6' [22], 'lo' => 'lo_6' [23], 'Estimate' =>
## 'Estimate_7' [24], 'hi' => 'hi_7' [25], 'lo' => 'lo_7' [26], 'Estimate' =>
## 'Estimate_8' [27], 'hi' => 'hi_8' [28], 'lo' => 'lo_8' [29]
```

```
## Parsed with column specification:
## cols(
##   .default = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
raw$ISO3[raw$Countries == "Kosovo"] <- "UNK"
sliced <- slice(raw, 1:num_rows)
countries <- sliced$ISO3
percents <- sliced %>%
  select(-ISO3, -Countries) %>%
  map_dfr(str_replace, pattern = ">?(\\d+)%", replacement = "\\1") %>%
  map_dfr(function(col) as.numeric(col) / 100)

# Separate three-column chunks and add countries and years.
num_years <- (last_year - first_year) + 1
chunks <- vector("list", num_years)
for (year in 1:num_years) {
  start = 3 * (year - 1) + 1
  chunks[[year]] <- select(percents, start:(start + 2)) %>%
    rename(estimate = 1, hi = 2, lo = 3) %>%
    mutate(country = countries,
           year = rep((first_year + year) - 1, num_rows)) %>%
    select(country, year, everything())
}

# Combine chunks and order by country and year.
tidy <- bind_rows(chunks) %>%
  arrange(country, year)

# Check.
write_csv(tidy, tidy_filename)
```

We're done,
and we have learned a lot of R,
but what we have also learned is that we make mistakes,
and that those mistakes can easily slip past us.
If people are going to use our cleaned-up data in their analyses,
we need a better way to develop and check our scripts.

## Exercises

1. Rewrite the code that converts numbers to use
   the [parse_number package][parse-number-package].

{% include links.md %}
