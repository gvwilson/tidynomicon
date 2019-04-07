# Projet-specific settings.

STEM=tidynomicon

# Build Markdown from R Markdown.
SITE_RMD=$(wildcard *.Rmd)
SITE_MD=$(patsubst %.Rmd,_${lang}/%.md,$(SITE_RMD))
_${lang}/%.md : %.Rmd
	@bin/build.R $< $@

## ----------------------------------------

## build          : rebuild Markdown source.
build : ${SITE_MD}
