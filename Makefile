.PHONY : all clean commands
STEM=tidynomicon
EPUB=_book/${STEM}.epub
HTML=_book/index.html
PDF=_book/${STEM}.pdf
SRC= \
index.Rmd \
basics.Rmd \
indexing.Rmd \
control.Rmd \
tidyverse.Rmd \
cleanup.Rmd \
nse.Rmd \
errors.Rmd \
oop.Rmd \
debt.Rmd \
projects.Rmd \
testing.Rmd \
shiny.Rmd \
python.Rmd \
references.Rmd \
appendix.Rmd \
LICENSE.md \
CONDUCT.md \
CITATION.md \
CONTRIBUTING.md \
gloss.md \
objectives.Rmd \
keypoints.Rmd

all : commands

#-------------------------------------------------------------------------------

## commands     : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g'

## everything   : rebuild all versions.
everything : ${HTML} ${PDF} ${EPUB}

## html         : build HTML version.
html : ${HTML}

## pdf          : build PDF version.
pdf : ${PDF}

## epub         : build epub version.
epub : ${EPUB}

## clean        : clean up generated files.
clean :
	@rm -rf _book
	@find . -name '*~' -exec rm {} \;

#-------------------------------------------------------------------------------

${HTML} : ${SRC}
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

${PDF} : ${SRC}
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

${EPUB} : ${SRC}
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
