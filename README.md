<div align="center">
  <h1><em>The Tidynomicon</em></h1>
  <h2><em>A Brief Introduction to R for Python Programmers</em></h2>
  <img src="https://raw.githubusercontent.com/gvwilson/tidynomicon/master/files/cthulhu-400x355.png" />
  <p><em>"Speak not to me of madness, you who count from zero."</em></p>
</div>

## Setting Up

1.  [Install R][r-install].
2.  [Install RStudio][rstudio-install].
3.  In the RStudio console, run `install.packages("tidyverse")` to install the tidyverse libraries.
4.  Set the `RETICULATE_PYTHON` environment variable to point at the local Python you want to use.
5.  [Install Jekyll][jekyll-install] for local preview.

## Building

1.  `bin/gloss.R glossary.md` to check for missing and redundant glossary entries.
2.  `bin/build.R` to compile all `./*.Rmd` files to `_en/*.md`.
    (You can also `bin/build.R filename.Rmd` to build one file.)
3.  `jekyll serve` to create `_site/*.html` and run a local server
    (go to <http://localhost:4000> to view).

## Configuration

1.  Jeykll treats sets of files in `_name` directories as [collections][jekyll-collection]
    (provided the `collections` and `defaults` keys in `./_config.yml` are correctly configured).
    The collection is called `_en` to signal that its contents are in English;
    the more elaborate version of this template used in [Merely Useful][merely-useful]
    supports multiple languages with localization.
2.  The `lessons` key in `./_config.yml` lists the permalinks of the lessons in reading order,
    and is used to generate the table of contents,
    to order the summaries of learning objectives and key points,
    and so on.
3.  The `extras` key in `./_config.yml` lists the "extra" files' permalinks and titles.
    Extra files are handled this way so that the licence, code of conduct, and so on
    can go in the project's root directory (where they are expected).
    There is some redundancy here that should be refactored:
    extra files' titles are specified in `./_config.yml` and in the files themselves.

## Design

-   Lessons are written in [RMarkdown][rmarkdown] files in the root directory (`*.Rmd`).
-   Each lesson's YAML header must have the following:
    -   `title: "Lesson Title"`.
    -   `output: md_document` (so that [knitr][knitr] will produce Markdown output).
    -	`permalink: /something/` (so that Jekyll puts HTML files in `_site/something/index.html`).
    -	`questions:` a list of questions that learners will bring to the lesson.
    -	`objectives:` a list of lesson objectives (instructor-facing rather than learner-facing).
    -	`keypoints:` a list things learners should understand and be able to do after the lesson.
-   To knit lesson files (`./*.Rmd`) to Markdown files (`_en/*.md`):
    -   Run `bin/build.R` with no arguments to knit all `.Rmd` files.
    -   Run `bin/build.R filename.Rmd` to compile a specific `.Rmd` file.
-   When lessons are compiled:
    -   Questions are put in a block at the top of the generated HTML page.
    -   Objectives are collected into `/objectives/`.
    -   Key points are put in a block at the end of the generated HTML page and into `/keypoints`.
    -   See `_layouts/default.html` and `_includes/summary-block.html` for the implementation
    	of in-page blocks for questions and key points.
    -   See `./objectives.md`, `./keypoints.md`, and `_includes/summary-all.html` for the implementation
    	of summary pages for objectives and key points.
    -   Collecting objectives and key points into summary pages is why we use Jekyll:
        there is currently no facility in `knitr` and derived tools to gather metadata from many pages into one place.
-   Terms are defined in `glossary.md`.
    -   Each entry's definition has the form `*Term*{:#key}:` followed by a definition.
    -   The italicizing asterisks are needed to give the [Kramdown][kramdown] parser something to hang an element ID on.
    -	Terms are referenced in lesson pages using `../glossary/#key`
        (since all pages are in named sub-directories).

## Illustrations

We should have some.
They should be drawn in SVG and put in `./files`.

[jekyll-collection]: https://jekyllrb.com/docs/collections/
[jekyll-install]: https://jekyllrb.com/docs/installation/
[knitr]: https://yihui.name/knitr/
[kramdown]: https://kramdown.gettalong.org/
[merely-useful]: http://merely-useful.github.io/
[r-install]: https://cran.rstudio.com/
[rmarkdown]: https://rmarkdown.rstudio.com/
[rstudio-install]: https://www.rstudio.com/products/rstudio/download/
