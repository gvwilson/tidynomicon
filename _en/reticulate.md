---
title: "Reticulate"
output: md_document
questions:
  - "How can I use Python and R together?"
objectives:
  - "Use `reticulate` to share data between R and Python."
  - "Use `reticulate` to call Python functions from R code and vice versa."
  - "Run Python scripts directly from R programs."
keypoints:
  - "The `reticulate` library allows R programs to access data in Python programs and vice versa."
  - "Use `py.whatever` to access a top-level Python variable from R."
  - "Use `r.whatever` to access a top-level R definition from Python."
  - "R is always indexed from 1 (even in Python) and Python is always indexed from 0 (even in R)."
  - "Numbers in R are floating point by default, so use a trailing 'L' to force a value to be an integer."
  - "A Python script run from an R session believes it is the main script, i.e., `__name__` is `'__main__'` inside the Python script."
---



As the previous lessons have shown,
you can do a lot with R,
but sometimes you might feel a cold, serpentine tug on your soul
pulling you back to Python.
You can put Python code in RMarkdown documents:


```python
print("Hello R")
#> Hello R
```

but how can those chunks interact with your R and vice versa?
The answer is a package called [reticulate][reticulate] that provides two-way communication between Python and R.
To use it,
run `install.packages("reticulate")`.
By default,
it uses the system-default Python:


```r
Sys.which("python")
#>                                 python 
#> "/Users/gvwilson/anaconda3/bin/python"
```

but you can configure it to use different versions,
or to use `virtualenv` or a Conda environment---see [the document][reticulate-configure] for details.

## How can I access data across languages?

The most common way to use reticulate is to do some calculations in Python and then use the results in R
or vice versa.
To show how this works,
let's read our infant HIV data into a Pandas data frame:


```python
import pandas
data = pandas.read_csv('tidy/infant_hiv.csv')
print(data.head())
#>   country  year  estimate  hi  lo
#> 0     AFG  2009       NaN NaN NaN
#> 1     AFG  2010       NaN NaN NaN
#> 2     AFG  2011       NaN NaN NaN
#> 3     AFG  2012       NaN NaN NaN
#> 4     AFG  2013       NaN NaN NaN
```

All of our Python variables are available in our R session as part of the `py` object,
so `py$data` is our data frame inside a chunk of R code:


```r
library(reticulate)
head(py$data)
#>   country year estimate  hi  lo
#> 1     AFG 2009      NaN NaN NaN
#> 2     AFG 2010      NaN NaN NaN
#> 3     AFG 2011      NaN NaN NaN
#> 4     AFG 2012      NaN NaN NaN
#> 5     AFG 2013      NaN NaN NaN
#> 6     AFG 2014      NaN NaN NaN
```

reticulate handles type conversions automatically,
though there are a few tricky cases:
for example,
the number `9` is a float in R,
so if you want an integer in Python,
you have to add the trailing `L` (for "long") and write it `9L`.

On the other hand,
reticulate translates between 0-based and 1-based indexing.
Suppose we create a character vector in R:


```r
elements = c('hydrogen', 'helium', 'lithium', 'beryllium')
```

Hydrogen is in position 1 in R:


```r
elements[1]
#> [1] "hydrogen"
```

but position 0 in Python:


```python
print(r.elements[0])
#> hydrogen
```

Note our use of the object `r` in our Python code:
just `py$whatever` gives us access to Python objects in R,
`r.whatever` gives us access to R objects in Python.

## How can I call functions across languages?

We don't have to run Python code,
store values in a variable,
and then access that variable from R:
we can call the Python directly (or vice versa).
For example,
we can use Python's random number generator in R as follows:


```r
pyrand <- import("random")
pyrand$gauss(0, 1)
#> [1] 0.1639939
```

(There's no reason to do this---R's random number generator is just as strong---but it illustrates the point.)

We can also source Python scripts.
For example,
suppose that `countries.py` contains this function:


```python
#!/usr/bin/env python
import pandas as pd
def get_countries(filename):
    data = pd.read_csv(filename)
    return data.country.unique()
```

We can run that script using `source_python`:


```r
source_python('countries.py')
```

There is no output because all the script did was define a function.
By default,
that function and all other top-level variables defined in the script are now available in R:


```r
get_countries('tidy/infant_hiv.csv')
#>   [1] "AFG" "AGO" "AIA" "ALB" "ARE" "ARG" "ARM" "ATG" "AUS" "AUT" "AZE"
#>  [12] "BDI" "BEL" "BEN" "BFA" "BGD" "BGR" "BHR" "BHS" "BIH" "BLR" "BLZ"
#>  [23] "BOL" "BRA" "BRB" "BRN" "BTN" "BWA" "CAF" "CAN" "CHE" "CHL" "CHN"
#>  [34] "CIV" "CMR" "COD" "COG" "COK" "COL" "COM" "CPV" "CRI" "CUB" "CYP"
#>  [45] "CZE" "DEU" "DJI" "DMA" "DNK" "DOM" "DZA" "ECU" "EGY" "ERI" "ESP"
#>  [56] "EST" "ETH" "FIN" "FJI" "FRA" "FSM" "GAB" "GBR" "GEO" "GHA" "GIN"
#>  [67] "GMB" "GNB" "GNQ" "GRC" "GRD" "GTM" "GUY" "HND" "HRV" "HTI" "HUN"
#>  [78] "IDN" "IND" "IRL" "IRN" "IRQ" "ISL" "ISR" "ITA" "JAM" "JOR" "JPN"
#>  [89] "KAZ" "KEN" "KGZ" "KHM" "KIR" "KNA" "KOR" "LAO" "LBN" "LBR" "LBY"
#> [100] "LCA" "LKA" "LSO" "LTU" "LUX" "LVA" "MAR" "MDA" "MDG" "MDV" "MEX"
#> [111] "MHL" "MKD" "MLI" "MLT" "MMR" "MNE" "MNG" "MOZ" "MRT" "MUS" "MWI"
#> [122] "MYS" "NAM" "NER" "NGA" "NIC" "NIU" "NLD" "NOR" "NPL" "NRU" "NZL"
#> [133] "OMN" "PAK" "PAN" "PER" "PHL" "PLW" "PNG" "POL" "PRK" "PRT" "PRY"
#> [144] "PSE" "ROU" "RUS" "RWA" "SAU" "SDN" "SEN" "SGP" "SLB" "SLE" "SLV"
#> [155] "SOM" "SRB" "SSD" "STP" "SUR" "SVK" "SVN" "SWE" "SWZ" "SYC" "SYR"
#> [166] "TCD" "TGO" "THA" "TJK" "TKM" "TLS" "TON" "TTO" "TUN" "TUR" "TUV"
#> [177] "TZA" "UGA" "UKR" "UNK" "URY" "USA" "UZB" "VCT" "VEN" "VNM" "VUT"
#> [188] "WSM" "YEM" "ZAF" "ZMB" "ZWE"
```

There is one small pothole in this.
When the script is run,
the special Python variable `__name__` is set to `'__main__'"'`,
i.e.,
the script thinks it is being called from the command line.
If it includes a conditional block to handle command-line arguments like this:


```python
if __name__ == '__main__':
    input_file, output_files = sys.argv[1], sys.argv[2:]
    main(input_file, output_files)
```

then that block will be executed,
but will fail because `sys.argv` won't include anything.

{% include links.md %}
