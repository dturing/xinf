DEPENDENCIES=$(shell find tests -name \*.hx)

RUN=TestShell
RUN_ARGS=$(TEST)

XINF_MODULES=TestShell
NEKO_MODULES=collect/Collector

include ../make.settings

serve : 
	nekotools server

