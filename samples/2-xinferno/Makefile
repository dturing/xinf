
HAXEFLAGS:=-cp ../../ -D htmltrace
SOURCES:=$(wildcard ../../*.hx ../../*/*.hx ../../*/*/*.hx)

APP:=App
PLATFORMS:=n js swf
BINARIES:=$(foreach PLATFORM, $(PLATFORMS), $(APP).$(PLATFORM))

test : $(APP).n
	neko $(APP)

all : $(BINARIES)

%.swf : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) --flash-strict -debug -main $* -swf-version 9 -swf-header 320:240:25:aaaaaa -swf $*.swf

%.js : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) -main $* -js $*.js

%.n : %.hx $(SOURCES)
	haxe $(HAXEFLAGS) -lib opengl -lib cptr -lib xinfinity-support -main $* -neko $*.n

clean:
	-@rm $(BINARIES)
