HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp .

NEKO_LIBS=${shell pkg-config --libs neko}
NEKO_CFLAGS=${shell pkg-config --cflags neko}

GST_LIBS=${shell pkg-config --libs gstreamer-0.10}
GST_CFLAGS=${shell pkg-config --cflags gstreamer-0.10}

CPTR_LIBS=-L../bin -lcptr 

ALL_FLAGS=$(NEKO_LIBS) $(NEKO_CFLAGS) $(GST_LIBS) $(GST_CFLAGS) $(CPTR_LIBS)

MOD=../bin/GST.ndll
CC=gcc

default : $(MOD)

#GL_wrap.c : GL.swg
#	swig $(SDL_CFLAGS) -neko $<
    
$(MOD) : gst-neko.c 
	$(CC) -shared -o $@ $(ALL_FLAGS) $<

clean :
	-rm $(MOD)

test :
	haxe $(HAXEFLAGS) -neko g/Object.hx -main gst.Object gst.Object
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../bin neko g/Object.n
     
