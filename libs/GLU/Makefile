GEN_MODS=GLU

NEKO_LIBS=${shell pkg-config --libs neko} -L../
NEKO_CFLAGS=${shell pkg-config --cflags neko} -fPIC -I../

GLU_LIBS=$(NEKO_LIBS) -lGL -lGLU -L. -lcptr
GLU_CFLAGS=$(NEKO_CFLAGS)

# where to find GL/gl.h
SWIG_INCLUDE=-I/usr/include

# the rest should stay the same even if you add a module.
GEN_PATH=../gen
SWIG_XSL=$(GEN_PATH)/swig.xsl
GENERATOR_XSL=$(GEN_PATH)/generator.xsl

HAXE_FLAGS=-cp ~/.haxe/lib/std -cp $(GEN_PATH)

TARGET_LIBS=$(foreach MOD,$(GEN_MODS),$(MOD).ndll $(MOD)__.n)
TARGET_CLASSES=$(foreach MOD,$(GEN_MODS),$(MOD).hx)
TARGETS=$(TARGET_LIBS) $(TARGET_CLASSES)

default : $(TARGETS)

done : $(TARGETS)
	touch done

# ------------------------------------------------------------
# building cptr helper lib

lib%.so : %.c
	gcc -shared -o $@ $($*_CFLAGS) $($*_LIBS) $< 

%.ndll : lib%.so
	gcc -shared -o $@ $($*_CFLAGS) $($*_LIBS) $< 

# ------------------------------------------------------------
# building actual modules

# use swig to generate XML description of the library
%_wrap.xml : %.swg
	swig $(SWIG_INCLUDE) -xml $<

# simplify swig's XML output
%_simple.xml : %_wrap.xml
	xsltproc $(SWIG_XSL) $< > $@

# generate a nekobind Generator class with a generate() function
%Generator.hx : %_simple.xml $(GENERATOR_XSL)
	xsltproc --stringparam module $* $(GENERATOR_XSL) $< > $@

# compile the generator
%Generator.n : %Generator.hx
	haxe $(HAXE_FLAGS) -neko $< -main $*Generator $*Generator
        
# generate C wrapper, and haxe "extern" and "impl" classes
%.hx %__.hx %_wrap.c : %Generator.n %.runtime
	neko $<
    
# compile C glue library
%.ndll : %_wrap.c
	gcc -shared -o $@ $($*_CFLAGS) $($*_LIBS) $< 
        
# compile neko wrapper module
%.n : %.hx
	haxe $(HAXE_FLAGS) -neko $*.hx $*

# just copy
%.hx : %.hx.in
	cp $< $@

clean :
	-rm $(wildcard *.xml *_wrap.c *.n *__.hx *.hx *.ndll *.so)
