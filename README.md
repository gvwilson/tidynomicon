<div align="center">
  <h1><em>The Tidynomicon</em></h1>
  <h2><em>A Brief Introduction to R for Python Programmers</em></h2>
  <img src="https://raw.githubusercontent.com/gvwilson/tidynomicon/master/files/cthulhu.png" width="400" />
  <p><em>"Speak not to me of madness, you who count from zero."</em></p>
</div>

## Audience

**Padma**, 28, has been using Python and Pandas for the last four years to analyze agricultural production in southeast Asia.
She has just completed her PhD and accepted a job with a development bank whose staff use R instead.
Padma wants learn how do the things she has been doing in Python:
read data, clean it, explore it, model it, and present it.

**Dafydd**, 37, has been building performance dashboards for a logistics company using Django and D3.
The company has just hired some data scientists who use R,
and Dafydd would like to try building some dashboards in Shiny.
He doesn't need to know much about statistics---the analysts will take care of that---but
he wants to learn enough of the language to tidy up their packages.

Derived constraints:

- Learners understand loops, conditionals, writing and calling functions, lists, and dictionaries,
  can load and use libraries,
  and can use classes and objects,
  but do not know how to create new classes
  or how to use higher-order functions.
- Learners understand mean, variation, correlation, and other basic statistical concepts,
  but are not familiar with statistical tests.
- Learners are comfortable creating and interpreting plots of various kinds.
- Learners have experience with spreadsheets and with writing database queries that use filtering, aggregation, and joins,
  but have not designed database schemas.
- Learners have no experience building web applications
  and are not familiar with version control systems or unit testing.
- Learners know how to use a text editor
  but have never used an IDE.
- Learners are willing to spend half an hour on the basics of the language,
  both because they understand the utility and as a safety blanket,
  but will then be impatient to start tackling real tasks.

## Other Pages

- [Simple Things in Python and R](simple_things.md)

## Explorations

Here is a sample of data from `infant_hiv/raw/infant_hiv.csv`,
where `...` shows values elided to make the segment readable:

```
"Early Infant Diagnosis: Percentage of infants born to women living with HIV...",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,2009,,,2010,,,2011,,,2012,,,2013,,,2014,,,2015,,,2016,,,2017,,,
ISO3,Countries,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,...
AFG,Afghanistan,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
ALB,Albania,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
DZA,Algeria,-,-,-,-,-,-,38%,42%,35%,23%,25%,21%,55%,60%,50%,27%,30%,25%,23%,25%,21%,33%,37%,31%,61%,68%,57%,
AGO,Angola,-,-,-,3%,4%,2%,5%,7%,4%,6%,8%,5%,15%,20%,12%,10%,14%,8%,6%,8%,5%,1%,2%,1%,1%,2%,1%,
=-=-=-=-= many more rows =-=-=-=-=
YEM,Yemen,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
ZMB,Zambia,59%,70%,53%,27%,32%,24%,70%,84%,63%,74%,88%,67%,64%,76%,57%,91%,>95%,81%,43%,52%,39%,43%,51%,39%,46%,54%,41%,
ZWE,Zimbabwe,-,-,-,12%,15%,10%,23%,28%,20%,38%,47%,33%,57%,70%,49%,54%,67%,47%,59%,73%,51%,71%,88%,62%,65%,81%,57%,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,2009,,,2010,,,2011,,,2012,,,2013,,,2014,,,2015,,,2016,,,2017,,,
,,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,Estimate,hi,lo,...
Region,East Asia and the Pacific,25%,30%,22%,35%,42%,29%,30%,37%,26%,32%,38%,27%,28%,34%,24%,26%,31%,22%,31%,37%,27%,30%,35%,25%,28%,33%,24%,
,Eastern and Southern Africa,23%,29%,20%,44%,57%,37%,48%,62%,40%,54%,69%,46%,51%,65%,43%,62%,80%,53%,62%,79%,52%,54%,68%,45%,62%,80%,53%,
,Eastern Europe and Central Asia,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,
=-=-=-=-= several more rows =-=-=-=-=
,Sub-Saharan Africa,16%,22%,13%,34%,46%,28%,37%,50%,30%,43%,57%,35%,41%,54%,33%,50%,66%,41%,50%,66%,41%,45%,60%,37%,52%,69%,42%,
,Global,17%,23%,13%,33%,45%,27%,36%,49%,29%,41%,55%,34%,40%,53%,32%,48%,64%,39%,49%,64%,40%,44%,59%,36%,51%,67%,41%,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Indicator definition: Percentage of infants born to women living with HIV... ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Note: Data are not available if country did not submit data...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
Data source: Global AIDS Monitoring 2018 and UNAIDS 2018 estimates,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
"For more information on this indicator, please visit the guidance:...",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
"For more information on the data, visit data.unicef.org",,,,,,,,,,,,,,,,,,,,,,,,,,,,,
```

One of the exercises in this training will be to develop an R script to tidy up this data.
After reading [R4DS](http://r4ds.had.co.nz/) and doing about half of the exercises in it,
it took me about two and a half hours to create something that seems to work:

```r
# Libraries.
library(tidyverse)

# Settings.
raw_file <- 'infant_hiv/raw/infant_hiv.csv'
tidy_file <- 'infant_hiv/tidy/infant_hiv.csv'
left_padding <- 2
first_year <- 2009
last_year <- 2017
num_years <- 1 + last_year - first_year
header_height <- 2
num_rows <- 192
column_names <- c("estimate", "hi", "lo")
width <- 3

# Get the chunk of the CSV that's of interest.
raw_data <- read_csv(raw_file, skip = header_height, na = c("-"))
of_interest <- slice(raw_data, 1:num_rows)

# Fix and store ISO3 country names.
of_interest$ISO3[of_interest$Countries == "Kosovo"] = "XKX"
countries <- of_interest$ISO3

# Process each three-column chunk (holding values for one year).
chunks <- vector("list", num_years)
for (i in 1:num_years) {

  # Get the three-year chunk.
  start_loc = left_padding + (width * (i - 1))
  end_loc <- start_loc + width - 1
  chunk <- select(of_interest, start_loc:end_loc)
  
  # Convert textual percentages to fractions.
  # Reports of ">95%" are converted to 95%. This is probably sinful.
  chunk[chunk == ">95%"] <- "95%"
  chunk <- mutate_if(chunk, is_character, str_replace, pattern = "%", replacement = "")
  chunk <- as_tibble(map(map(chunk, as.numeric), function(x) x / 100.0))
  
  # Create and save a tibble with the right names and the years and countries.
  names(chunk) <- column_names
  chunk$year <- rep(first_year + i - 1, num_rows)
  chunk$country <- countries
  chunk <- select(chunk, country, year, everything())
  chunks[[i]] <- chunk
}

# Combine all the tibbles and sort by country and year.
tidy <- bind_rows(chunks)
tidy <- arrange(all_data, country, year)

# Save.
write_csv(tidy, tidy_file)
```

Here are some of the issues I encountered along the way that this training will need to cover
and questions I still have:

- Since the first few lines of the CSV aren't tidy, I ignore them, then select rows using row number based on inspection of the raw CSV.
  Is there a better way to get the data I want to tidy?
  For example, should I filter to get the row numbers of Afghanistan and Zimbabwe and pull out everything in between?
  Should I skip the first *three* lines when reading,
  accept X1, X2, and so on as column headers,
  and start from there?
- Once this script was working and I sorted by country and year,
  I discovered that Kosovo's ISO3 country code is empty,
  so I went back and patched it using the provisional "XKX" code used by NATO.
  - I should include some checks during development of this script on empty/missing fields.
    What's the preferred way to do this?
  - What's a better way to write the expression that fills in "XKX" where it's needed?
- In order to construct a tidy tibble,
  I pull out three-column chunks corresponding to particular years,
  clean them up,
  and attach the year and country code.
  Once the loop is done,
  I stitch the partial tibbles together.
  - Is `mutate_if` the right function to use to get rid of the % signs in my raw data?
  - Is there a cleaner way to replace the ">95%" text with "95%"?
  - Is there a better thing to do than make this replacement?
  - I shouldn't need to use two `map` calls to convert data to numeric and then divide by 100,
    but `map(chunk, as.numeric)/100` didn't work
    (presumably because arithmetic operations only work on vectors, not tables,
    but then why does the masked assignment that replaces ">95%" work?).
  - I also don't think I should have to `as_tibble` after `map`:
    is there a better way to apply a function to every column while leaving things as tibbles?
- The assignment to `chunk$year` feels like it ought to work without `rep`,
  i.e., that there ought to be a way to recycle the (scalar) value of year when creating a new column.
- Is there a clean way to make the country and year the first columns in the chunk
  rather than attaching them to the end and then rearranging with `select`?
- I constantly trip over `[...]` versus `[[...]]`,
  and am going to go back and review the differences between the two kinds of subscripting.
- I keep typing `select` when I should type `filter`.
- The IDE editor complains "no symbol named 'country' in scope" for the statement
  `chunk <- select(chunk, country, year, everything())`.
  This is fair (there actually *isn't* a variable called `country`),
  but it surprises me that the IDE would be upset by common tidyverse usage.
  (I get a similar complaint about uses of `year`.)
- I've committed the `tidynomicon.Rproj` file to my Git repository.
  Have I sinned?

Here are some answers:

- "Did you use the IDE data importer?  It's *really* helpful, especially when getting started."
  No: most people coming from Python will already be overwhelmed with detail,
  so my bet is that they will (a) not explore long enough to find it or
  (b) try to do everything by hand anyway (since they're not used to working with full-featured IDEs).
  Showing them the importer (and a breakpointing/single-stepping debugger) is now on the list of things to teach.

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

Read the CSV data set `infant_hiv/solution/infant_hiv.csv` into a tibble.
Use tidyverse functions to answer the following questions:

1. How many distinct countries are in the data?
1. Which countries reported an estimate for 2009?
1. Which countries reported an estimate for every year from 2009 to 2017?
1. What were the average estimates for 2014, 2015, and 2016?
1. How many countries didn't report estimates for one or more years?
1. Which countries never reported a low figure less than 50%?
1. Which countries reported a low figure greater than or equal to the estimate, and in which year(s)?

### Tidying Data

Look at the CSV file `infant_hiv/raw/infant_hiv.csv`
(which are taken from the Excel spreadsheet located in the same directory).
Write an R script that tidies this data and store the results in `infant_hiv/tidy/infant_hiv.csv`.
Compare your result to the file used in previous exercises.

### Using RStudio

Use RStudio's data importer to read `infant_hiv/raw/infant_hiv.csv`.
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
