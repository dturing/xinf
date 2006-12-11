

default:
	@echo "Xinf top-level Makefile targets: "
	@echo " haxelib  - package haxelib"
	@echo " test     - package and test-run sample 0-test"
	@echo " clean    - remove temporary files"


# build haxelib package
PROJECT:=xinf

HAXELIB_ROOT:=haxelib-build
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)
TEST_SAMPLE:=samples/0-test

haxelib : $(HAXELIB_PROJECT).zip
	
$(HAXELIB_PROJECT).zip: 
	-rm -rf $(HAXELIB_ROOT)
	mkdir -p $(HAXELIB_PROJECT)
	
	# copy haxelib.xml
	cp haxelib.xml $(HAXELIB_PROJECT)
	
	# copy haXe API and Samples
	svn export $(PROJECT) $(HAXELIB_PROJECT)/$(PROJECT)
	svn export samples $(HAXELIB_PROJECT)/samples
	
	# package and test-install the haxelib once (we need it to compile the test)
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	haxelib test $(HAXELIB_PROJECT).zip
	
	# build the "0-test" sample for haxelib run
	cd $(TEST_SAMPLE); haxe compile.hxml;
	cp $(TEST_SAMPLE)/run.n $(HAXELIB_PROJECT)/
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	
test: haxelib
	haxelib test $(HAXELIB_PROJECT).zip
	haxelib run $(PROJECT)
	
clean:
	-rm -rf $(HAXELIB_ROOT)
