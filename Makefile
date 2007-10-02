
SRC=$(wildcard xinf/*/*.hx xinf/*/*/*.hx)

INITYLIBS=cptr opengl xinfinity-support
INITYCP=$(foreach LIB, $(INITYLIBS), -lib $(LIB) )
NEKOPATH:=$(NEKOPATH)

HAXEFLAGS=--override $(INITYCP) -cp .

default: test
	
# Example.hx test

test : $(SRC)
	haxe $(HAXEFLAGS) -neko test.n -main Example
	NEKOPATH=$(NEKOPATH) neko test.n
	
flash : $(SRC)
	haxe $(HAXEFLAGS) -swf test.swf -swf-header 640:480:25:ffffff -swf-version 9 -main Example
	
js : $(SRC)
	haxe $(HAXEFLAGS) -js test.js -main Example


#######################################################

PROJECT:=xinf
VERSION:=0.3.0
TAGLINE:=iteration 3

DATE:=$(shell date +"%Y-%m-%d %H:%M:%S")
REVISION:=$(shell svnversion)


#######################################################
# generate version file
FORCE:

VERSION_STUB:=xinf/Version.hx

$(VERSION_STUB):support/$(notdir $(VERSION_STUB)).in FORCE
	@sed -e "s/__VERSION__/$(VERSION)/" \
		-e "s/__REVISION__/$(REVISION)/" \
		-e "s/__TAGLINE__/$(TAGLINE)/" \
		-e "s/__DATE__/$(DATE)/" \
		$< > $@
	
######################
# xinf haxelib

HAXELIB_ROOT:=support/haxelib-build
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)

haxelib : $(HAXELIB_PROJECT).zip

$(HAXELIB_PROJECT).zip: $(wildcard xinf/*/*.hx xinf/*/*/*.hx) $(VERSION_STUB)
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	sed -e s/__VERSION__/$(VERSION)/ support/haxelib.xml > $(HAXELIB_PROJECT)/haxelib.xml
	
	# copy haXe API and Samples
	svn export $(PROJECT) $(HAXELIB_PROJECT)/$(PROJECT)
	cp Xinf.hx $(HAXELIB_PROJECT)/
#	svn export samples $(HAXELIB_PROJECT)/samples
	cp $(VERSION_STUB) $(HAXELIB_PROJECT)/$(PROJECT)
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
