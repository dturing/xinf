    XINFROOT=/home/dan/develop/xinf

NEKO=neko
NEKOPATH=/usr/neko/lib:$(XINFROOT)/libs
NEKO_SERVER=nekotools server

HAXE=haxe -cp ~/.haxe/lib/std -cp $(XINFROOT) -cp $(XINFROOT)/libs

XINF_SRC=$(shell find $(XINFROOT)/xinf -name \*.hx)

#
# no local modifications should be neccessary beyond here 
# (if still, i'd like to hear about it- dan_AT_xinf.org
#

RESOURCES=$(wildcard resources/*)
HAXE_RESOURCES=$(foreach RES, $(RESOURCES), -resource resources/$(notdir $(RES))@$(notdir $(RES)) )
LD_LIBRARY_PATH=$(XINFROOT)/libs

ASSETS=$(wildcard assets/* assets/*/*)
ifneq (,$(ASSETS))
	SWF_ASSETS=assets.swf
endif
    
XINF_RUNTIMES=n swf js
XINF_BINARIES=$(foreach MODULE,$(XINF_MODULES),$(foreach RUNTIME,$(XINF_RUNTIMES),$(MODULE).$(RUNTIME)))

NEKO_BINARIES=$(foreach MODULE,$(NEKO_MODULES),$(MODULE).n)
SWF_BINARIES=$(foreach MODULE,$(SWF_MODULES),$(MODULE).swf)
JS_BINARIES=$(foreach MODULE,$(JS_MODULES),$(MODULE).js)

BINARIES=$(XINF_BINARIES) $(NEKO_BINARIES) $(SWF_BINARIES) $(JS_BINARIES)
    
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
	echo "<movie><library>" $(foreach ASSET, $(ASSETS), "<clip id=\"$(ASSET)\" import=\"$(ASSET)\"/>") "</library><frame/></movie>" | swfmill simple stdin $@

compile: $(BINARIES)

clean:
	-@rm $(BINARIES) $(CLEAN_FILES) $(SWF_ASSETS) 2> /dev/null

#serve: $(MODULE).swf
#	firefox http://localhost:2000/
#	$(NEKO_SERVER)
 
#view: $(RUN).swf
#	firefox $(RUN).swf
   
run: $(RUN).n
	neko $(RUN).n $(RUN_ARGS)

foo:
	echo Testing: 
