.PHONY: clean test haxelib default

default:
	@echo "Xinf top-level Makefile targets: "
	@echo " haxelib  - package haxelib"
	@echo " test     - package and test-run sample 0-test"
	@echo " clean    - remove temporary files"


PROJECT:=xinf
VERSION:=0.0.1
TAGLINE:=
TEST_SAMPLE:=samples/0-test

DATE:=$(shell date +"%Y-%m-%d %H:%M:%S")
REVISION:=$(shell svnversion)

# generate version file
FORCE:

VERSION_STUB:=xinf/Version.hx

$(VERSION_STUB):support/$(notdir $(VERSION_STUB)).in FORCE
	@sed -e "s/__VERSION__/$(VERSION)/" \
		-e "s/__REVISION__/$(REVISION)/" \
		-e "s/__TAGLINE__/$(TAGLINE)/" \
		-e "s/__DATE__/$(DATE)/" \
		$< > $@

# make docs
XINF_SOURCES:=$(wildcard $(PROJECT)/*.hx $(PROJECT)/*/*.hx $(PROJECT)/*/*/*.hx)
DOC_DIR:=doc

.PHONY: doc
$(DOC_DIR)/doc.n.xml : $(XINF_SOURCES)
	cd $(DOC_DIR); haxe --auto-xml \
		-lib opengl -lib cptr -lib fonttools -neko doc.n -cp ../ xinf.ImportAll \
#		--next -js doc.js -cp ../ xinf.ImportAll \
#		--next -swf-version 9 -swf doc.swf -cp ../ xinf.ImportAll
	
doc : $(DOC_DIR)/doc.n.xml
	cd $(DOC_DIR); haxedoc doc.n.xml -f xinf -f ony


# package resources

RESOURCE_DIR:=support/resources
RESOURCES:=$(wildcard $(RESOURCE_DIR)/*)
RESOURCE:=support/xinf-resources.n

RESOURCE_STUB:=support/Stub.hx

$(RESOURCE) : $(RESOURCES) $(RESOURCE_STUB)
	haxe -cp support/ -neko $(RESOURCE) $(foreach R,$(RESOURCES),-resource $(R)@$(notdir $(R))) Stub


# build haxelib package

HAXELIB_ROOT:=support/haxelib-build
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)

haxelib : $(HAXELIB_PROJECT).zip
	
$(HAXELIB_PROJECT).zip: $(RESOURCE) $(wildcard xinf/*/*.hx xinf/*/*/*.hx) $(VERSION_STUB)
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	sed -e s/__VERSION__/$(VERSION)/ support/haxelib.xml > $(HAXELIB_PROJECT)/haxelib.xml
	
	# copy haXe API and Samples
	svn export $(PROJECT) $(HAXELIB_PROJECT)/$(PROJECT)
	svn export samples $(HAXELIB_PROJECT)/samples
	cp $(VERSION_STUB) $(HAXELIB_PROJECT)/$(PROJECT)
	
	# build the "0-test" sample for haxelib run
	cd $(TEST_SAMPLE); haxe -cp ../../ -lib cptr -lib opengl -lib fonttools -main App -neko run.n;
	cp $(TEST_SAMPLE)/run.n $(HAXELIB_PROJECT)/
	
	# copy resource FIXME
	cp $(RESOURCE) $(HAXELIB_PROJECT)/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Linux/
	cp $(RESOURCE) $(HAXELIB_PROJECT)/ndll/Linux/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Mac/
	cp $(RESOURCE) $(HAXELIB_PROJECT)/ndll/Mac/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Windows/
	cp $(RESOURCE) $(HAXELIB_PROJECT)/ndll/Windows/
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	
test: haxelib
	haxelib test $(HAXELIB_PROJECT).zip
	haxelib run $(PROJECT)
	
clean:
	-rm -rf $(HAXELIB_ROOT)
