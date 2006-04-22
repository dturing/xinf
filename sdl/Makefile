# simple neko-sdl makefile

NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko}

SDL_LIBS=${shell sdl-config --libs}
SDL_CFLAGS=${shell sdl-config --cflags}

ALL_FLAGS=$(NEKO_LIBS) $(NEKO_CFLAGS) $(SDL_LIBS) $(SDL_CFLAGS)

MOD=../bin/SDL.ndll
CC=gcc

default : $(MOD)

SDL_wrap.c : SDL.swg
	swig $(SDL_CFLAGS) -neko $<
    
$(MOD) : SDL_wrap.c 
	$(CC) -shared -o $@ $(ALL_FLAGS) $<

clean :
	-rm SDL_wrap.c SDL.hx $(MOD)
	
