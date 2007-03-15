

APP:=App
PLATFORMS:=n js swf
BINARIES:=$(foreach PLATFORM, $(PLATFORMS), $(APP).$(PLATFORM))

LIBS=cptr opengl xinfinity-support
NEKOPATH:=$(NEKOPATH):$(subst : ,:,$(foreach LIB,$(LIBS),../../libs/$(LIB)/bin/Linux:../../libs/$(LIB)/bin:))

HAXEFLAGS:=-cp ../../ $(foreach lib,$(LIBS),-cp ../../libs/$(lib)/api) -D htmltrace
SOURCES:=$(wildcard ../../*.hx ../../*/*.hx ../../*/*/*.hx)


test : $(APP).n
	NEKOPATH=$(NEKOPATH) neko $(APP).n

all : $(BINARIES)

%.swf : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) --flash-strict -debug -main $* -swf-version 9 -swf-header 320:240:25:000000 -swf $*.swf

%.js : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) -main $* -js $*.js

%.n : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) -main $* -neko $*.n

clean:
	-@rm $(BINARIES)
