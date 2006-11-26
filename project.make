XINFROOT:=/home/dan/develop/xinf

#
# no local modifications should be neccessary beyond here 
# (if still, i'd like to hear about it- dan_AT_xinf.org
#

LIB_PATHS:=$(foreach LIB, cptr GL GLU SDL GdkPixbuf X FT FontConfig gst opencv, $(XINFROOT)/libs/$(LIB)) $(XINFROOT)/libs

NEKOPATH:=$(NEKOPATH):$(subst : ,:,$(foreach PATH,$(LIB_PATHS),$(PATH):))
HAXE=haxe -D test -cp ~/.haxe/lib/std -cp $(XINFROOT) $(foreach PATH, $(LIB_PATHS), -cp $(PATH))

XINF_SRC=$(shell find $(XINFROOT)/xinf -name \*.hx) $(shell find $(XINFROOT)/demo -name \*.hx) 

LD_LIBRARY_PATH=$(XINFROOT)/libs/cptr

XINF_RUNTIMES=n swf js
XINF_BINARIES=$(foreach MODULE,$(XINF_MODULES),$(foreach RUNTIME,$(XINF_RUNTIMES),$(MODULE).$(RUNTIME)))

NEKO_BINARIES=$(foreach MODULE,$(NEKO_MODULES),$(MODULE).n)
SWF_BINARIES=$(foreach MODULE,$(SWF_MODULES),$(MODULE).swf)
JS_BINARIES=$(foreach MODULE,$(JS_MODULES),$(MODULE).js)

BINARIES+=$(XINF_BINARIES) $(NEKO_BINARIES) $(SWF_BINARIES) $(JS_BINARIES)

#
# patterns
#
%.n : %.hx $(XINF_SRC)
	$(HAXE) $(HAXEFLAGS) $(HAXE_RESOURCES) -cp $(dir $*) -neko $@ -main $(notdir $(subst /,.,$*))

%.js : %.hx $(XINF_SRC)
	$(HAXE) $(HAXEFLAGS) -cp $(dir $*) -js $@ -main $(subst /,., $*)

%.swf : %.hx $(XINF_SRC)
	$(HAXE) $(HAXEFLAGS) -cp $(dir $*) -swf-header 640:480:25:888888 --flash-strict -swf-lib font.swf -swf-version 9 -main $(subst /,., $*)

default: compile

#
# default targets
#
	
subdirs: 
	$(foreach SUBDIR, $(SUBDIRS), $(MAKE) -C $(SUBDIR);)

compile: subdirs $(BINARIES) 

clean:
	-@rm $(BINARIES) $(CLEAN_FILES) $(SWF_ASSETS) 2> /dev/null
	$(foreach SUBDIR, $(SUBDIRS), $(MAKE) -C $(SUBDIR) clean;)
   
run: $(RUN).n
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) NEKOPATH=$(NEKOPATH) neko $(RUN).n $(RUN_ARGS)
