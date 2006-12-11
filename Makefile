

default:
	@echo "Xinf top-level Makefile targets: "
	@echo " haxelib  - package haxelib"
	@echo " test     - package and test-run sample 0-test"
	@echo " clean    - remove temporary files"


PROJECT:=xinf
TEST_SAMPLE:=samples/0-test


# package bitstream vera

FONT_DIR:=support/font
FONT:=$(FONT_DIR)/vera.n

$(FONT_DIR)/%.n : $(FONT_DIR)/%.ttf $(FONT_DIR)/Stub.hx
	cd $(FONT_DIR); haxe -neko $*.n -resource $*.ttf@default-font Stub



# build haxelib package

HAXELIB_ROOT:=support/haxelib-build
HAXELIB_PROJECT:=$(HAXELIB_ROOT)/$(PROJECT)

haxelib : $(HAXELIB_PROJECT).zip
	
$(HAXELIB_PROJECT).zip: $(FONT) $(wildcard xinf/*/*.hx xinf/*/*/*.hx)
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
	
	# copy font FIXME
	cp $(FONT) $(HAXELIB_PROJECT)/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Linux/
	cp $(FONT) $(HAXELIB_PROJECT)/ndll/Linux/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Mac/
	cp $(FONT) $(HAXELIB_PROJECT)/ndll/Mac/
	mkdir -p $(HAXELIB_PROJECT)/ndll/Windows/
	cp $(FONT) $(HAXELIB_PROJECT)/ndll/Windows/
	
	# create the final .zip
	cd $(HAXELIB_ROOT); zip -r $(PROJECT).zip $(PROJECT)
	
test: haxelib
	haxelib test $(HAXELIB_PROJECT).zip
	haxelib run $(PROJECT)
	
clean:
	-rm -rf $(HAXELIB_ROOT)
