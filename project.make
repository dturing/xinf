XINFROOT:=/home/dan/develop/xinf

LIB_PATHS:=$(foreach LIB, cptr GL GLU SDL GdkPixbuf X FT FontConfig gst, $(XINFROOT)/libs/$(LIB)) $(XINFROOT)/libs

NEKO:=neko
NEKOPATH:=$(NEKOPATH):$(subst : ,:,$(foreach PATH,$(LIB_PATHS),$(PATH):))
NEKO_SERVER:=nekotools server
NEKO_CFLAGS=-I/usr/local/include/neko -I$(XINFROOT)/libs/cptr -fPIC
NEKO_LIBS=-L/usr/lib -lneko -L$(XINFROOT)/libs/cptr

HAXE=haxe  -D test -cp ~/.haxe/lib/std -cp $(XINFROOT) $(foreach PATH, $(LIB_PATHS), -cp $(PATH))

XINF_SRC=$(shell find $(XINFROOT)/xinf -name \*.hx)

#
# no local modifications should be neccessary beyond here 
# (if still, i'd like to hear about it- dan_AT_xinf.org
#

RESOURCES=$(wildcard resources/*)
HAXE_RESOURCES=$(foreach RES, $(RESOURCES), -resource resources/$(notdir $(RES))@$(notdir $(RES)) )
LD_LIBRARY_PATH=$(XINFROOT)/libs/cptr

ASSETS=$(wildcard assets)
ifneq (,$(ASSETS))
	SWF_ASSETS=assets.swf
endif
    
XINF_RUNTIMES=n swf js
XINF_BINARIES=$(foreach MODULE,$(XINF_MODULES),$(foreach RUNTIME,$(XINF_RUNTIMES),$(MODULE).$(RUNTIME)))

NEKO_BINARIES=$(foreach MODULE,$(NEKO_MODULES),$(MODULE).n)
SWF_BINARIES=$(foreach MODULE,$(SWF_MODULES),$(MODULE).swf)
JS_BINARIES=$(foreach MODULE,$(JS_MODULES),$(MODULE).js)

BINARIES+=$(XINF_BINARIES) $(NEKO_BINARIES) $(SWF_BINARIES) $(JS_BINARIES)

#
# patterns
#
%.n : %.hx $(XINF_SRC) $(DEPENDENCIES)
	$(HAXE) $(HAXEFLAGS) $(HAXE_RESOURCES) -cp $(dir $*) -neko $@ -main $(notdir $(subst /,.,$*))

%.js : %.hx $(XINF_SRC) $(DEPENDENCIES)
	$(HAXE) $(HAXEFLAGS) -cp $(dir $*) -js $@ -main $(notdir $*)

%.swf : %.hx $(XINF_SRC) $(DEPENDENCIES) $(SWF_ASSETS)
	$(HAXE) $(HAXEFLAGS) -cp $(dir $*) -swf $@ $(foreach ASSET, $(SWF_ASSETS), -swf-lib $(ASSET)) -swf-header 320:240:25:ffffff --flash-strict -main $(notdir $*)

default: compile

#
# default targets
#
assets.swf : $(ASSETS)
#	echo "<movie>" $(foreach ASSET, $(ASSETS), "<library><clip id=\"$(ASSET)\" import=\"$(ASSET)\"/></library>") "<frame/></movie>" | swfmill simple stdin $@
	swfmill library $(ASSETS) $@
	
subdirs: 
	$(foreach SUBDIR, $(SUBDIRS), $(MAKE) -C $(SUBDIR);)

compile: subdirs $(BINARIES) 

clean:
	-@rm $(BINARIES) $(CLEAN_FILES) $(SWF_ASSETS) 2> /dev/null
	$(foreach SUBDIR, $(SUBDIRS), $(MAKE) -C $(SUBDIR) clean;)
   
run: $(RUN).n
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) NEKOPATH=$(NEKOPATH) neko $(RUN).n $(RUN_ARGS)
