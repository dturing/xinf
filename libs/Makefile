GEN_MODS=GL GLU SDL

cptr_LIBS=$(NEKO_LIBS)
cptr_CFLAGS=$(NEKO_CFLAGS)

GL_LIBS=$(NEKO_LIBS) -lGL -L. -lcptr
GL_CFLAGS=$(NEKO_CFLAGS)

GLU_LIBS=$(GL_LIBS) -lGLU -L. -lcptr
GLU_CFLAGS=$(GL_CFLAGS)

SDL_LIBS=$(NEKO_LIBS) ${shell sdl-config --libs} -L. -lcptr
SDL_CFLAGS=$(NEKO_CFLAGS) ${shell sdl-config --cflags}

# where to find GL/gl.h
SWIG_INCLUDE=-I/usr/include ${shell sdl-config --cflags}


# the rest should stay the same even if you add a module.

GEN_PATH=gen
SWIG_XSL=$(GEN_PATH)/swig.xsl
GENERATOR_XSL=$(GEN_PATH)/generator.xsl


HAXE_FLAGS=-cp ~/.haxe/lib/std -cp $(GEN_PATH)

NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko}

TARGET_LIBS=$(foreach MOD,$(GEN_MODS),$(MOD).ndll $(MOD)__.n)
TARGET_CLASSES=$(foreach MOD,$(GEN_MODS),$(MOD).hx)
TARGETS=$(TARGET_LIBS) $(TARGET_CLASSES) libcptr.so cptr.ndll

default : $(TARGETS)

# ------------------------------------------------------------
# building cptr helper lib

lib%.so : %.c
	gcc -shared -fPIC -o $@ $($*_CFLAGS) $($*_LIBS) $< 

%.ndll : lib%.so
	gcc -shared -fPIC -o $@ $($*_CFLAGS) $($*_LIBS) $< 

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
%.hx %__.hx %_wrap.c : %Generator.n
	neko $<
    
# compile C glue library
%.ndll : %_wrap.c libcptr.so
	gcc -shared -fPIC -o $@ $($*_CFLAGS) $($*_LIBS) $< 
        
# compile neko wrapper module
%.n : %.hx
	haxe $(HAXE_FLAGS) -neko $*.hx $*

clean :
	-rm $(wildcard *.xml *_wrap.c *.n *__.hx *.hx *.ndll *.so)
