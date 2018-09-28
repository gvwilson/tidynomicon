This folder contains the raw data used in [The Tidynomicon: A Brief Introduction to R for Python Programmers](https://github.com/gvwilson/tidynomicon). This README is modelled on <https://github.com/the-pudding/data/blob/master/pockets/README.md>, which was created for an article in The Pudding titled [Women's Pockets Are Inferior](https://pudding.cool/2018/08/pockets/), and describes each of the data files. See the README in the `tidy/` directory for a description of the table format for each tidied dataset.

## Infants born to women with HIV receiving an HIV test within two months of birth, 2009-2017

- Infant_HIV_Testing_2017.xlsx
  - **What is this?**: Excel spreadsheet with summarized data.
  - **Source(s)**: UNICEF, <https://data.unicef.org/resources/dataset/hiv-aids-statistical-tables/>
  - **Last Modified**: July 2018 (according to website)
  - **Contact**: Greg Wilson <greg.wilson@rstudio.com>
  - **Spatial Applicability**: global
  - **Temporal Applicability**: 2009-2017
- infant_hiv.csv
  - **What is this?**: CSV export from Infant_HIV_Testing_2017.xlsx
- Notes
  - Data is not tidy: some rows are descriptive comments, others are blank separators between sections, and column headers are inconsistent.
  - Use `scripts/tidy-24.R` to convert to `tidy/infant_hiv.csv`.
  - See README in `tidy/` for format of tidy data.

## Maternal health indicators disaggregated by age

- maternal_health_adolescents_indicators_April-2016_250d599.xlsx
  - **What is this?**: Excel spreadsheet with summarized data.
  - **Source(s)**: UNICEF, <https://data.unicef.org/resources/dataset/maternal-health-data/>
  - **Last Modified**: July 2018 (according to website)
  - **Contact**: Greg Wilson <greg.wilson@rstudio.com>
  - **Spatial Applicability**: global
  - **Temporal Applicability**: 2000-2014
- at_health_facilities.csv
  - **What is this?**: percentage of births at health facilities by country, year, and mother's age
  - **Source(s)**: single sheet from maternal_health_adolescents_indicators_April-2016_250d599.xlsx
- c_sections.csv
  - **What is this?**: percentage of Caesarean sections by country, year, and mother's age
  - **Source(s)**: single sheet from maternal_health_adolescents_indicators_April-2016_250d599.xlsx
- skilled_attendant_at_birth.csv
  - **What is this?**: percentage of births with skilled attendant present by country, year, and mother's age
  - **Source(s)**: single sheet from maternal_health_adolescents_indicators_April-2016_250d599.xlsx
- Notes
  - Data is not tidy: some rows are descriptive comments, others are blank separators between sections, and column headers are inconsistent.
  - Use `scripts/mother-generic.R` to convert to `tidy/*.csv`
  - See README in `tidy/` for format of tidy data.
