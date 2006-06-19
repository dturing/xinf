DEPENDENCIES=$(shell find tests -name Test\*.hx)

CLEAN_FILES=index.n

RUN=TestShell

XINF_MODULES=TestShell
NEKO_MODULES=TestMain collect/Collector

include ../make.settings

foo:
	echo $(DEPENDENCIES)
        
index.n : TestMain.n
	cp $< $@
serve : index.n
	nekotools server
