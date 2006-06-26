
GEN_PATH=$(XINFROOT)/libs/gen
SWIG_XSL=$(GEN_PATH)/swig.xsl
GENERATOR_XSL=$(GEN_PATH)/generator.xsl

HAXEFLAGS=-cp ~/.haxe/lib/std -cp $(GEN_PATH)

TARGET_LIBS=$(foreach MOD,$(NEKOGEN_MODULES),$(MOD).ndll $(MOD)__.n)
TARGET_CLASSES=$(foreach MOD,$(NEKOGEN_MODULES),$(MOD).hx)
TARGETS=$(TARGET_LIBS) $(TARGET_CLASSES)

BINARIES+=$(TARGETS)
CLEAN_FILES+=$(foreach MOD,$(NEKOGEN_MODULES),$(MOD)__.hx)

include ../../project.make

# ------------------------------------------------------------
# building actual modules

# use swig to generate XML description of the library
%_wrap.xml : %.swg
	swig $($*_CFLAGS) -xml $<

# simplify swig's XML output
%_simple.xml : %_wrap.xml
	xsltproc $(SWIG_XSL) $< > $@

# generate a nekobind Generator class with a generate() function
%Generator.hx : %_simple.xml $(GENERATOR_XSL) $(wildcard exceptions*)
	xsltproc --stringparam module $* $(GENERATOR_XSL) $< > $@

# compile the generator
#%Generator.n : %Generator.hx
#	haxe $(HAXE_FLAGS) -neko $< -main $*Generator $*Generator
        
# generate C wrapper, and haxe "extern" and "impl" classes
%.hx %__.hx %_wrap.c : %Generator.n %.runtime
	neko $<
    
# compile C glue library
%.ndll : %_wrap.c
	gcc -shared -fPIC -o $@ $($*_CFLAGS) $(NEKO_CFLAGS) $(NEKO_LIBS) $($*_LIBS) $< 
        
# compile neko wrapper module
%.n : %.hx
	haxe $(HAXE_FLAGS) -neko $*.hx $*

libclean :
	-rm $(wildcard *.xml *_wrap.c *.n *__.hx *.hx *.ndll *.so)
