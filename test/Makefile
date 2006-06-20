DEPENDENCIES=$(shell find tests -name \*.hx)

CLEAN_FILES=index.n

RUN=TestShell
RUN_ARGS=$(TEST)

XINF_MODULES=TestShell
NEKO_MODULES=collect/Collector

include ../make.settings

index.n : TestMain.n
	cp $< $@
serve : index.n
	nekotools server

