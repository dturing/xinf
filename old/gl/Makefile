# simple neko-gl makefile

NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko}

GL_LIBS=-lGL -lGLU

CPTR_LIBS=-L../bin -lcptr 

ALL_FLAGS=$(NEKO_LIBS) $(NEKO_CFLAGS) $(GL_LIBS) $(CPTR_LIBS)

MOD=../bin/GL.ndll
CC=gcc

default : $(MOD)

GL_wrap.c : GL.swg
	swig $(SDL_CFLAGS) -neko $<
    
$(MOD) : GL_wrap.c 
	$(CC) -shared -o $@ $(ALL_FLAGS) $<

clean :
	-rm GL_wrap.c GL.hx $(MOD)
