include ../libraries.make

HAXEFLAGS=-cp /home/dan/.haxe/lib/std -cp . -cp ..

GST_ELEMENTS=gstnekobus

GST_LIBS=${shell pkg-config --libs gstreamer-0.10} -lgstvideo-0.10 -lGL -lGLU 
GST_CFLAGS=${shell pkg-config --cflags gstreamer-0.10}

CPTR_LIBS=-L../libs 
CPTR_FLAGS=-I../libs

ALL_FLAGS=$(NEKO_LIBS) $(NEKO_CFLAGS) $(GST_LIBS) $(GST_CFLAGS) $(CPTR_FLAGS) $(CPTR_LIBS)

MOD=GST.ndll
CC=gcc

default : $(MOD)

$(MOD) : gst-neko.c $(addsuffix .c, $(GST_ELEMENTS))
	$(CC) -shared -o $@ $(ALL_FLAGS) $^

clean: 
	-rm $(MOD)

test :
	haxe $(HAXEFLAGS) -neko Pipeline.hx -main gst.Pipeline 
	neko Pipeline.n

run: test

