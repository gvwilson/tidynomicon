ALL_MD=$(wildcard *.md)

.PHONY : clean commands settings spelling

all : commands

## commands    : show all commands.
commands :
	@grep -h -E '^##' Makefile | sed -e 's/## //g'

## spelling    : check spelling against words in 'spelling.txt'.
spelling :
	@cat ${ALL_MD} \
	| aspell list \
	| sort \
	| uniq \
	| comm -2 -3 - spelling.txt

## clean       : clean up.
clean :
	@find . -name '*~' -delete
	@find . -name .DS_Store -prune -delete

## settings    : display settings.
settings :
	@echo "ALL_MD:" ${ALL_MD}
