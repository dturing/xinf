#######################################################

PROJECT:=xinf
VERSION:=0.4.1
TAGLINE:=traits

DATE:=$(shell date +"%Y-%m-%d %H:%M:%S")
REVISION:=$(shell svnversion)

#######################################################


SRC=$(wildcard xinf/*/*.hx xinf/*/*/*.hx)
VERSION_STUB:=xinf/Version.hx

INITYLIBS=cptr opengl xinfinity-support openvg
INITYCP=$(foreach LIB, $(INITYLIBS), -lib $(LIB) )
NEKOPATH:=$(NEKOPATH)

HAXEFLAGS=--override $(INITYCP) -cp .

default: test
	
# Example.hx test

test : $(VERSION_STUB) $(SRC) 
	haxe $(HAXEFLAGS) -resource test.svg@test.svg -neko test.n -main Example
	NEKOPATH=$(NEKOPATH) neko test.n  
	#xinf/test/static/SVG1.2/svg/struct-use-01-t.svg 

	
flash : $(SRC)
	haxe $(HAXEFLAGS) -resource test.svg@test.svg -swf test.swf -swf-header 640:480:25:ffffff -swf-version 9 -main Example
	
js : $(SRC)
	haxe $(HAXEFLAGS) -resource test.svg@test.svg -js test.js -main Example


# Benchmark

benchmark : $(VERSION_STUB) $(SRC) 
	haxe $(HAXEFLAGS) -D profile -neko bench.n -main Benchmark
	NEKOPATH=$(NEKOPATH) neko bench.n

memmark : $(VERSION_STUB) $(SRC) 
	haxe $(HAXEFLAGS) -neko mem.n -main Memmark
	NEKOPATH=$(NEKOPATH) neko mem.n

#######################################################
# generate version file
.PHONY: FORCE
FORCE:

$(VERSION_STUB): support/$(notdir $(VERSION_STUB)).in FORCE
	@sed -e "s/__VERSION__/$(VERSION)/" \
		-e "s/__REVISION__/$(REVISION)/" \
		-e "s/__TAGLINE__/$(TAGLINE)/" \
		-e "s/__DATE__/$(DATE)/" \
		$< > $@
	
	
######################
# xinf haxelib

HAXELIB_ROOT:=support/haxelib-build
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)

haxelib-test : haxelib
	haxelib test $(HAXELIB_PROJECT).zip

haxelib : $(HAXELIB_PROJECT).zip

$(HAXELIB_PROJECT).zip: $(wildcard xinf/*/*.hx xinf/*/*/*.hx) $(VERSION_STUB)
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	sed -e s/__VERSION__/$(VERSION)/ support/haxelib.xml > $(HAXELIB_PROJECT)/haxelib.xml
	
	# copy haXe API and Samples
	svn export $(PROJECT) $(HAXELIB_PROJECT)/$(PROJECT)

	cp Xinf.hx $(HAXELIB_PROJECT)/
	cp xinf/Version.hx $(HAXELIB_PROJECT)/xinf/
	svn export samples $(HAXELIB_PROJECT)/samples
	cp $(VERSION_STUB) $(HAXELIB_PROJECT)/$(PROJECT)
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
