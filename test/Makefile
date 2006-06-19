#TEST_MODULES=$(foreach TEST, $(shell find tests -name Test\*.hx), $(basename $(TEST)) )
#TEST_SHELLS=$(foreach MOD, $(MODULES), tests/$(MOD)Shell)

CLEAN_FILES=index.n

RUN=TestShell

XINF_MODULES=TestShell
NEKO_MODULES=TestMain collect/Collector

include ../make.settings


index.n : TestMain.n
	cp $< $@
serve : index.n
	nekotools server
