BINARIES+=cptr.ndll
include ../libraries.make

%.ndll : %.c
	gcc $(NEKO_CFLAGS) $(NEKO_LIBS) -shared -o $@ $<
